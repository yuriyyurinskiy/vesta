server {
    listen      %ip%:%web_port%;
    server_name %domain_idn% %alias_idn%;
    root        %docroot%;
    index       index.php index.html index.htm;
    access_log  /var/log/nginx/domains/%domain%.log combined;
    access_log  /var/log/nginx/domains/%domain%.bytes bytes;
    error_log   /var/log/nginx/domains/%domain%.error.log error;

    location / {
        proxy_read_timeout 300;
        proxy_pass_header  X-Transmission-Session-Id;
        proxy_set_header   X-Forwarded-Host   $host;
        proxy_set_header   X-Forwarded-Server $host;
        proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;       
        proxy_pass         http://127.0.0.1:9091/transmission/web/;
    }
       
    location /rpc {
        proxy_pass         http://127.0.0.1:9091/transmission/rpc;
    }
       
    location /upload {
        proxy_pass         http://127.0.0.1:9091/transmission/upload;
    }

    error_page  403 /error/404.html;
    error_page  404 /error/404.html;
    error_page  500 502 503 504 /error/50x.html;

    location /error/ {
        alias   %home%/%user%/web/%domain%/document_errors/;
    }

    location ~* "/\.(htaccess|htpasswd)$" {
        deny    all;
        return  404;
    }

    include     %home%/%user%/conf/web/nginx.%domain%.conf*;
}
