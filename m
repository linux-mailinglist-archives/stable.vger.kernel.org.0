Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172C04029BD
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 15:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243642AbhIGNde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 09:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbhIGNdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 09:33:33 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79673C061757
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 06:32:27 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id f6so12865520iox.0
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 06:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8hWJO4fyW9aLGtkPoc8sXRTVfW/EL7Nik2BlBvPuUkI=;
        b=R2q8x9XDefDu5UWfpSUmH50jCRo+OhxUj/EiqsumUYcPBP5Xi40AkIVpf6WunU4D/D
         uDKi5jR81VrF3m+rjxcSXOAKNfGMiNN8rX6X7Zk+TCGa4vIATwnqdgq4gXJi47J5NNGI
         AZIIadJYd8j+vmQlFeMPpHb7PWS2zHzhAnvpVFi7GBmUb9cZNL4DimtrJGdvV9Qt3Olc
         QMJqCN0X/sTRuBMdBBpWtUslv35+EjJI3h0YNzj/K5BcV3llScuZpZYTucyXzrZAB1Zy
         EgXuFUgGku5Ym4RfJMJLDirJXhNzHRACaP9mUcsLiDJFSUpI8ufT0/dLKvgcw1052kV2
         OWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8hWJO4fyW9aLGtkPoc8sXRTVfW/EL7Nik2BlBvPuUkI=;
        b=gmnhSJO0wBztqwhhLmq9PVpyXriw6/k1Iiy4BcxC4qnUtitAwfizUj7U4ZrgOQGx1o
         bKXgPfn0YMtj7wMBqHOLlv4AYmWESi9nB6tKlHxNCzZz0/7G2jkkhDevFcx49icJFzAY
         UHbN9v1QApjbKIB2PR5uqhdLUWCGq1bKpMp0iAILPrZi2/+5MEEPM7liPktjNN2BqGe/
         cNVvG7N3Jp1ZLaWk5OpvRonV4ysPRelH6waz7zZnrWInH5HL+mZ3ZLOsprwpKV6a8cbu
         xAZLaxRdNHIlC4YvB/WoNrNUCUbYF9PPrqur/PCd9fkKLh7+9FZvubSmCPwrmfp7qsUm
         isWw==
X-Gm-Message-State: AOAM532+7hjrsLVcvgNCI0sHClpSxyDlIkgfkr0D36b0chWzS4h3WxmO
        r2ar4mrYdDflMZSa8KtxtEEdN6Oedrb1bIE7
X-Google-Smtp-Source: ABdhPJxOGsbe9d7UwBHXXp0rLPZCxZzuEBkSU+w11jNE9vdE7dBUGols/GtjaLzHS4QGoX3X0pRAdw==
X-Received: by 2002:a5d:8a05:: with SMTP id w5mr13268622iod.155.1631021546498;
        Tue, 07 Sep 2021 06:32:26 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id g23sm6486392ioc.8.2021.09.07.06.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 06:32:26 -0700 (PDT)
Subject: Re: [greybus-dev] [PATCH] staging: greybus: uart: fix tty use after
 free
To:     Johan Hovold <johan@kernel.org>, David Lin <dtwlin@gmail.com>,
        Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     greybus-dev@lists.linaro.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210906124538.22358-1-johan@kernel.org>
From:   Alex Elder <elder@linaro.org>
Message-ID: <56782caa-bd9d-b049-7ca6-c64e3fbe109a@linaro.org>
Date:   Tue, 7 Sep 2021 08:32:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210906124538.22358-1-johan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/6/21 7:45 AM, Johan Hovold wrote:
> User space can hold a tty open indefinitely and tty drivers must not
> release the underlying structures until the last user is gone.
> 
> Switch to using the tty-port reference counter to manage the life time
> of the greybus tty state to avoid use after free after a disconnect.
> 
> Fixes: a18e15175708 ("greybus: more uart work")
> Cc: stable@vger.kernel.org      # 4.9
> Signed-off-by: Johan Hovold <johan@kernel.org>

I have a couple of minor comments.  I assume the
tty model matches normal patterns for get/put and
reference counted objects, and based on that I'm
ready to give a Reviewed-by, but I'd like to hear
your responses first.

					-Alex

> ---
>   drivers/staging/greybus/uart.c | 62 ++++++++++++++++++----------------
>   1 file changed, 32 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
> index 73f01ed1e5b7..a943fce322be 100644
> --- a/drivers/staging/greybus/uart.c
> +++ b/drivers/staging/greybus/uart.c
> @@ -761,6 +761,17 @@ static void gb_tty_port_shutdown(struct tty_port *port)
>   	gbphy_runtime_put_autosuspend(gb_tty->gbphy_dev);
>   }
>   
> +static void gb_tty_port_destruct(struct tty_port *port)
> +{
> +	struct gb_tty *gb_tty = container_of(port, struct gb_tty, port);
> +

So the minor number is GB_NUM_MINORS until after both the buffer
and the kfifo have been allocated.  And kfifo_free() (similar to
kfree()) handles being provided a non-initialized kfifo, correct?

> +	if (gb_tty->minor != GB_NUM_MINORS)
> +		release_minor(gb_tty);
> +	kfifo_free(&gb_tty->write_fifo);
> +	kfree(gb_tty->buffer);
> +	kfree(gb_tty);
> +}
> +
>   static const struct tty_operations gb_ops = {
>   	.install =		gb_tty_install,
>   	.open =			gb_tty_open,
> @@ -786,6 +797,7 @@ static const struct tty_port_operations gb_port_ops = {
>   	.dtr_rts =		gb_tty_dtr_rts,
>   	.activate =		gb_tty_port_activate,
>   	.shutdown =		gb_tty_port_shutdown,
> +	.destruct =		gb_tty_port_destruct,
>   };
>   
>   static int gb_uart_probe(struct gbphy_device *gbphy_dev,
> @@ -798,17 +810,11 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
>   	int retval;
>   	int minor;
>   
> -	gb_tty = kzalloc(sizeof(*gb_tty), GFP_KERNEL);
> -	if (!gb_tty)
> -		return -ENOMEM;
> -

Why do you reorder when you allocate the gb_tty structure?
I don't have a problem with it, but it seems like the order
doesn't matter.  Is it just so you can initialize it right
after it's allocated?  (If so, I like that reason.)

>   	connection = gb_connection_create(gbphy_dev->bundle,
>   					  le16_to_cpu(gbphy_dev->cport_desc->id),
>   					  gb_uart_request_handler);
> -	if (IS_ERR(connection)) {
> -		retval = PTR_ERR(connection);
> -		goto exit_tty_free;
> -	}
> +	if (IS_ERR(connection))
> +		return PTR_ERR(connection);
>   
>   	max_payload = gb_operation_get_payload_size_max(connection);
>   	if (max_payload < sizeof(struct gb_uart_send_data_request)) {
> @@ -816,13 +822,23 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
>   		goto exit_connection_destroy;
>   	}
>   
> +	gb_tty = kzalloc(sizeof(*gb_tty), GFP_KERNEL);
> +	if (!gb_tty) {
> +		retval = -ENOMEM;
> +		goto exit_connection_destroy;
> +	}
> +
> +	tty_port_init(&gb_tty->port);
> +	gb_tty->port.ops = &gb_port_ops;
> +	gb_tty->minor = GB_NUM_MINORS;
> +
>   	gb_tty->buffer_payload_max = max_payload -
>   			sizeof(struct gb_uart_send_data_request);
>   
>   	gb_tty->buffer = kzalloc(gb_tty->buffer_payload_max, GFP_KERNEL);
>   	if (!gb_tty->buffer) {
>   		retval = -ENOMEM;
> -		goto exit_connection_destroy;
> +		goto exit_put_port;
>   	}
>   
>   	INIT_WORK(&gb_tty->tx_work, gb_uart_tx_write_work);
> @@ -830,7 +846,7 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
>   	retval = kfifo_alloc(&gb_tty->write_fifo, GB_UART_WRITE_FIFO_SIZE,
>   			     GFP_KERNEL);
>   	if (retval)
> -		goto exit_buf_free;
> +		goto exit_put_port;
>   
>   	gb_tty->credits = GB_UART_FIRMWARE_CREDITS;
>   	init_completion(&gb_tty->credits_complete);
> @@ -844,7 +860,7 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
>   		} else {
>   			retval = minor;
>   		}
> -		goto exit_kfifo_free;
> +		goto exit_put_port;
>   	}
>   
>   	gb_tty->minor = minor;
> @@ -853,9 +869,6 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
>   	init_waitqueue_head(&gb_tty->wioctl);
>   	mutex_init(&gb_tty->mutex);
>   
> -	tty_port_init(&gb_tty->port);
> -	gb_tty->port.ops = &gb_port_ops;
> -
>   	gb_tty->connection = connection;
>   	gb_tty->gbphy_dev = gbphy_dev;
>   	gb_connection_set_data(connection, gb_tty);
> @@ -863,7 +876,7 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
>   
>   	retval = gb_connection_enable_tx(connection);
>   	if (retval)
> -		goto exit_release_minor;
> +		goto exit_put_port;
>   
>   	send_control(gb_tty, gb_tty->ctrlout);
>   
> @@ -890,16 +903,10 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
>   
>   exit_connection_disable:
>   	gb_connection_disable(connection);
> -exit_release_minor:
> -	release_minor(gb_tty);
> -exit_kfifo_free:
> -	kfifo_free(&gb_tty->write_fifo);
> -exit_buf_free:
> -	kfree(gb_tty->buffer);
> +exit_put_port:
> +	tty_port_put(&gb_tty->port);
>   exit_connection_destroy:
>   	gb_connection_destroy(connection);
> -exit_tty_free:
> -	kfree(gb_tty);
>   
>   	return retval;
>   }
> @@ -930,15 +937,10 @@ static void gb_uart_remove(struct gbphy_device *gbphy_dev)
>   	gb_connection_disable_rx(connection);
>   	tty_unregister_device(gb_tty_driver, gb_tty->minor);
>   
> -	/* FIXME - free transmit / receive buffers */
> -
>   	gb_connection_disable(connection);
> -	tty_port_destroy(&gb_tty->port);
>   	gb_connection_destroy(connection);
> -	release_minor(gb_tty);
> -	kfifo_free(&gb_tty->write_fifo);
> -	kfree(gb_tty->buffer);
> -	kfree(gb_tty);
> +
> +	tty_port_put(&gb_tty->port);

In the error path above, you call tty_port_put()
before calling gb_connection_destroy(), which matches
(in reverse) the order in which they're created. I'm
accustomed to having the order of the calls here match
the error path.  Is this difference intentional?  (It
shouldn't really matter.)

					-Alex

>   }
>   
>   static int gb_tty_init(void)
> 

