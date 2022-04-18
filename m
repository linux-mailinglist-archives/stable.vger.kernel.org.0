Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5B2505096
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238835AbiDRM0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbiDRM0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:12 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A60766A;
        Mon, 18 Apr 2022 05:19:56 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r13so26554340ejd.5;
        Mon, 18 Apr 2022 05:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bPi1M4TpdIF35hZ6pGwoTFeZJUCgotNcWVS0tlq5Gy0=;
        b=mWBRchCaMLmzqclRE3NU5WjLz7A7l7uKIZbpLiuae6iFeHIgrmuXM7rl1R3GlpYFEM
         ///hkpMzhtANLw7rxbrSgN08RvqMYAZ3sjLUZInh/y0drfYcYI/Bs9zjbTHtMxa5X+aN
         1WxXLWR0nhwUayIePh+RunzOtBllTHgbA1IkRq9ME8fQjdqNwte3L8LMCGaPVGwVoMNq
         +4bxQfbHNz/YyGJ2FZ6c1olp+ainFaMRcC0M2coEUONZJIoujnwZX4jBr2RfWGLt0vrA
         9gq2+vC+FjaEdsBcUO8VJKz30bX8hU5crDBJ8OjlXg5h4Ko8y3/+MiGFYgL6V6HZuI9c
         rzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bPi1M4TpdIF35hZ6pGwoTFeZJUCgotNcWVS0tlq5Gy0=;
        b=uYUOw6SKlR62m5VDEk5pWyGasyzO+uC8gibSSWVarCujDjpXlyBKciiV/JpPD6MYdN
         0DUHRH9g1w1dO2BzkhsiZFrK/GYa0KYtGyVb/7cCKFPk70bDJt5jeEF8pYrMvolGgUxY
         0MOYVHgz5Ae5UQsMTty3n5Mg+bVlPqfPacH6O7EgOtUUMtj93rU+i/Egycpf0HfqA99N
         uv+9XCSsFy09N/mdABZrKc9Vvi2ABm6S4DVFSXKYx8ufWOZSDfcZbrs9kvRQEE+qS920
         zOyzjQ7laTANOOcI8ZbgS941p0sDcAl9JStbcM/vis2gb+TFs9EjC89k3CjOC39gBEF9
         Ny3Q==
X-Gm-Message-State: AOAM532v4VCKifsuVZhG5WmwQC7ynI0TIECAWWdTQ+ohX52RV4xEU6v5
        sgz/OItfCd+7hGRbA87bZadezwdhgZVKWsdLIjeo0I5Dc1WH6w==
X-Google-Smtp-Source: ABdhPJyPD6AIcVEj5ia6EDgEOLP4lzMXX7ielqUjla1STAukjxOqTZDEkgeuUuCFmmwrz2TlQNzd6QJLK/SqD3RDRTQ=
X-Received: by 2002:a17:906:1cd1:b0:6ec:c59:6a1d with SMTP id
 i17-20020a1709061cd100b006ec0c596a1dmr8086964ejh.77.1650284395249; Mon, 18
 Apr 2022 05:19:55 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.21.2204161848030.9383@angie.orcam.me.uk> <alpine.DEB.2.21.2204162156340.9383@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2204162156340.9383@angie.orcam.me.uk>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 18 Apr 2022 15:19:19 +0300
Message-ID: <CAHp75VccGqH-peGQHnM+guu8KfkGo6-R3wwGUPKRWKqQZid7AA@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] serial: 8250: Also set sticky MCR bits in console restoration
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 2:02 AM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>
> Sticky MCR bits are lost in console restoration if console suspending
> has been disabled.  This currently affects the AFE bit, which works in
> combination with RTS which we set, so we want to make sure the UART
> retains control of its FIFO where previously requested.  Also specific
> drivers may need other bits in the future.

Since it's a fix it should be moved to the beginning of the series.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: 4516d50aabed ("serial: 8250: Use canary to restart console after suspend")
> Cc: stable@vger.kernel.org # v4.0+
> ---
> New change in v4, factored out from 5/5.
> ---
>  drivers/tty/serial/8250/8250_port.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> linux-serial-8250-mcr-restore.diff
> Index: linux-macro/drivers/tty/serial/8250/8250_port.c
> ===================================================================
> --- linux-macro.orig/drivers/tty/serial/8250/8250_port.c
> +++ linux-macro/drivers/tty/serial/8250/8250_port.c
> @@ -3308,7 +3308,7 @@ static void serial8250_console_restore(s
>
>         serial8250_set_divisor(port, baud, quot, frac);
>         serial_port_out(port, UART_LCR, up->lcr);
> -       serial8250_out_MCR(up, UART_MCR_DTR | UART_MCR_RTS);
> +       serial8250_out_MCR(up, up->mcr | UART_MCR_DTR | UART_MCR_RTS);
>  }
>
>  /*



-- 
With Best Regards,
Andy Shevchenko
