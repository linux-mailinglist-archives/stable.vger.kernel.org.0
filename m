Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E868821FECA
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 22:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgGNUpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 16:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgGNUpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 16:45:14 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B789C061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 13:45:14 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p20so24358355ejd.13
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 13:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kqh1NBVBlHrZFE286BUwAHdoh8ntAaaIXSLlXQ7Bm6s=;
        b=dsDrvsXKwnz4Ec5AoGC7UzNnGr6HGFuQx0fMIrzZdpvzT8V+sMBjSseqibtKkUleNp
         YAQBi76uicXluskJd+hTeTsyWAg05jNYM0frcHY4PBAtEKlADxwqvaJdPcxxHuR6fSg4
         Z8Av9Xw3kWBU7AcvAiZLJvP0ANAQYQY/1HRVk5m0U6KRDc+OtwfbXN0N1c0AAmeVdh96
         7p0jLgi5ACnL+H0e8teJtGjWlj+U1ay7gVzmHsVYk1zN8dRbuaztcrZ66pzJ2Ok7zto2
         EGMDow93S9QTHHgzoSZB16/uOQk9fIg12WPTEmg38d7cg2Gx2p4CpzISSSFIUXkbDAsr
         HC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kqh1NBVBlHrZFE286BUwAHdoh8ntAaaIXSLlXQ7Bm6s=;
        b=Ve15MeEnmFj5pWQfDVkvFm0yN7SNClfXiojulmy/lPe9RvJfvGf3JseCfixAlKMdZR
         15LcP9boVOY1IjjCylqIk8OOvUszCyGMi9bUU6luV5PZSs/IHlwwNmYjRts4DVc/VrIA
         uBYnwQrzRmA/b+NSszUEQMUskDJSCPec44dRfbO8Hr73iGHXeL6iWz6nvj1S/KrJ2Bus
         6Diui3U/QJ2nwLHMZRvhuItnMm4fzJN8tJlEXPoZY7QVPz4rh1Tew1hMZt4+x8Q4FWj5
         jlSZSkh+B137nCKpXn1Ck43X5NtOd37XxN355xrBO2Z7fjcorhJrVbPme5/U02c8UQui
         rzug==
X-Gm-Message-State: AOAM530nzfaV947JB8uoA7LBgqFzbuh0AkUMuo0hmPK2+IVh91ZKacK5
        Zt2gYkrsrio0uD/ntZmi7i7PPnXuTTRXwxnQhDQWsw==
X-Google-Smtp-Source: ABdhPJysUSBHVOa53sWJQjIcFkn4l3OgSNQEcR9y15L+mAV25fgE46PISgPYdobloPCBMeTthBtC00kZdSRclXpMQu0=
X-Received: by 2002:a17:906:fa9b:: with SMTP id lt27mr6000034ejb.513.1594759512692;
 Tue, 14 Jul 2020 13:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200714124113.20918-1-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20200714124113.20918-1-Sergey.Semin@baikalelectronics.ru>
From:   Daniel Winkler <danielwinkler@google.com>
Date:   Tue, 14 Jul 2020 13:45:01 -0700
Message-ID: <CAP2xMbvwxYaGPPCDWY2LWUc2te8kS9t-+A0zieYp3RiGMJR6ng@mail.gmail.com>
Subject: Re: [PATCH] serial: 8250_mtk: Fix high-speed baud rates clamping
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Claire Chang <tientzu@google.com>,
        Nicolas Boichat <drinkcat@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Aaron Sierra <asierra@xes-inc.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-serial@vger.kernel.org, linux-mediatek@lists.infradead.org,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        abhishekpandit@chromium.org, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thank you Sergey for looking into this. Adding folks working on this
platform to perform validation of the proposed patch.

Best,
Daniel

On Tue, Jul 14, 2020 at 5:41 AM Serge Semin
<Sergey.Semin@baikalelectronics.ru> wrote:
>
> Commit 7b668c064ec3 ("serial: 8250: Fix max baud limit in generic 8250
> port") fixed limits of a baud rate setting for a generic 8250 port.
> In other words since that commit the baud rate has been permitted to be
> within [uartclk / 16 / UART_DIV_MAX; uartclk / 16], which is absolutely
> normal for a standard 8250 UART port. But there are custom 8250 ports,
> which provide extended baud rate limits. In particular the Mediatek 8250
> port can work with baud rates up to "uartclk" speed.
>
> Normally that and any other peculiarity is supposed to be handled in a
> custom set_termios() callback implemented in the vendor-specific
> 8250-port glue-driver. Currently that is how it's done for the most of
> the vendor-specific 8250 ports, but for some reason for Mediatek a
> solution has been spread out to both the glue-driver and to the generic
> 8250-port code. Due to that a bug has been introduced, which permitted the
> extended baud rate limit for all even for standard 8250-ports. The bug
> has been fixed by the commit 7b668c064ec3 ("serial: 8250: Fix max baud
> limit in generic 8250 port") by narrowing the baud rates limit back down to
> the normal bounds. Unfortunately by doing so we also broke the
> Mediatek-specific extended bauds feature.
>
> A fix of the problem described above is twofold. First since we can't get
> back the extended baud rate limits feature to the generic set_termios()
> function and that method supports only a standard baud rates range, the
> requested baud rate must be locally stored before calling it and then
> restored back to the new termios structure after the generic set_termios()
> finished its magic business. By doing so we still use the
> serial8250_do_set_termios() method to set the LCR/MCR/FCR/etc. registers,
> while the extended baud rate setting procedure will be performed later in
> the custom Mediatek-specific set_termios() callback. Second since a true
> baud rate is now fully calculated in the custom set_termios() method we
> need to locally update the port timeout by calling the
> uart_update_timeout() function. After the fixes described above are
> implemented in the 8250_mtk.c driver, the Mediatek 8250-port should
> get back to normally working with extended baud rates.
>
> Link: https://lore.kernel.org/linux-serial/20200701211337.3027448-1-danielwinkler@google.com
>
> Fixes: 7b668c064ec3 ("serial: 8250: Fix max baud limit in generic 8250 port")
> Reported-by: Daniel Winkler <danielwinkler@google.com>
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
>
> ---
>
> Folks, sorry for a delay with the problem fix. A solution is turned out to
> be a bit more complicated than I originally thought in my comment to the
> Daniel revert-patch.
>
> Please also note, that I don't have a Mediatek hardware to test the
> solution suggested in the patch. The code is written as on so called
> the tip of the pen after digging into the 8250_mtk.c and 8250_port.c
> drivers code. So please Daniel or someone with Mediatek 8250-port
> available on a board test this patch first and report about the results in
> reply to this emailing thread. After that, if your conclusion is positive
> and there is no objection against the solution design the patch can be
> merged in.
>
> Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
> Cc: Daniel Winkler <danielwinkler@google.com>
> Cc: Aaron Sierra <asierra@xes-inc.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Vignesh Raghavendra <vigneshr@ti.com>
> Cc: linux-serial@vger.kernel.org
> Cc: linux-mediatek@lists.infradead.org
> Cc: BlueZ <linux-bluetooth@vger.kernel.org>
> Cc: chromeos-bluetooth-upstreaming <chromeos-bluetooth-upstreaming@chromium.org>
> Cc: abhishekpandit@chromium.org
> Cc: stable@vger.kernel.org
> ---
>  drivers/tty/serial/8250/8250_mtk.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
> index f839380c2f4c..98b8a3e30733 100644
> --- a/drivers/tty/serial/8250/8250_mtk.c
> +++ b/drivers/tty/serial/8250/8250_mtk.c
> @@ -306,8 +306,21 @@ mtk8250_set_termios(struct uart_port *port, struct ktermios *termios,
>         }
>  #endif
>
> +       /*
> +        * Store the requested baud rate before calling the generic 8250
> +        * set_termios method. Standard 8250 port expects bauds to be
> +        * no higher than (uartclk / 16) so the baud will be clamped if it
> +        * gets out of that bound. Mediatek 8250 port supports speed
> +        * higher than that, therefore we'll get original baud rate back
> +        * after calling the generic set_termios method and recalculate
> +        * the speed later in this method.
> +        */
> +       baud = tty_termios_baud_rate(termios);
> +
>         serial8250_do_set_termios(port, termios, old);
>
> +       tty_termios_encode_baud_rate(termios, baud, baud);
> +
>         /*
>          * Mediatek UARTs use an extra highspeed register (MTK_UART_HIGHS)
>          *
> @@ -339,6 +352,11 @@ mtk8250_set_termios(struct uart_port *port, struct ktermios *termios,
>          */
>         spin_lock_irqsave(&port->lock, flags);
>
> +       /*
> +        * Update the per-port timeout.
> +        */
> +       uart_update_timeout(port, termios->c_cflag, baud);
> +
>         /* set DLAB we have cval saved in up->lcr from the call to the core */
>         serial_port_out(port, UART_LCR, up->lcr | UART_LCR_DLAB);
>         serial_dl_write(up, quot);
> --
> 2.26.2
>
