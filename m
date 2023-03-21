Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822FA6C2C04
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 09:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjCUILO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Mar 2023 04:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjCUIK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 04:10:56 -0400
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055AE457D1;
        Tue, 21 Mar 2023 01:10:13 -0700 (PDT)
Received: by mail-qt1-f169.google.com with SMTP id s12so16878635qtq.11;
        Tue, 21 Mar 2023 01:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679386202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+MNEtT7l4tO1AQyNTgAvqQykRAVkyT7PJMiutdPsDLo=;
        b=eQkJny0/I0lJMfEPzOHWE2FhOGkMS2COgO7/P/2AlUp4zQijE6mFy437AbZL8WK7oQ
         Yu77dDSYCa3Q8FRK5gNJZJ+16SJ7YDUBFtxJUqZZ3JAKSi56UeU8Z2eSwfneA8/3lM9E
         jhKHQ3Eqfx5eez1xGHyNzMqnhBrdJqhv68d3HkaBwBqVYYSikBJPcfhQwH/QUBm97BZ0
         x5kG3NHA+ALdEIWlmd20vCtgYg8RmJnWrUb6W6WlsfbPMSKom2IO6vIpyzB0Bv6HlqHo
         TOPyft97Wi5XSX2i/05scVFPhxeXSrqTIbViQzrvNa8LvlrjPPiUUTZ1b/UCzrFaYukV
         0Img==
X-Gm-Message-State: AO0yUKV8KfCSMNnV4qTUw17TB8NwQUo/dpudDG9SMf63Pk6EWaINpDW3
        2/kREUdtuvzRd5Xjn8H8xFGbd/q2hXKIwQ==
X-Google-Smtp-Source: AK7set+G8nU2uWrcAA0ae6hNArZBIUSOa7wJC8sAVyvu8ZPdL/s76Y2CraJGJ1tICr6UzmmRKETWog==
X-Received: by 2002:ac8:5ad4:0:b0:3bf:d13f:2094 with SMTP id d20-20020ac85ad4000000b003bfd13f2094mr3383418qtd.33.1679386202396;
        Tue, 21 Mar 2023 01:10:02 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id jr28-20020a05622a801c00b003bd0f0b26b0sm7785445qtb.77.2023.03.21.01.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 01:10:02 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id j7so16044637ybg.4;
        Tue, 21 Mar 2023 01:10:01 -0700 (PDT)
X-Received: by 2002:a05:6902:1023:b0:b6b:841a:aae4 with SMTP id
 x3-20020a056902102300b00b6b841aaae4mr652141ybt.12.1679386201641; Tue, 21 Mar
 2023 01:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230320105339.236279-1-biju.das.jz@bp.renesas.com> <20230320105339.236279-4-biju.das.jz@bp.renesas.com>
In-Reply-To: <20230320105339.236279-4-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Mar 2023 09:09:50 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUqd=cwefG-AK-RqtN_aWKAqy6Rg65imHGgGKXvn5q-Bw@mail.gmail.com>
Message-ID: <CAMuHMdUqd=cwefG-AK-RqtN_aWKAqy6Rg65imHGgGKXvn5q-Bw@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] tty: serial: sh-sci: Fix Tx on SCI IP
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-serial@vger.kernel.org,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Biju,

On Mon, Mar 20, 2023 at 11:53 AM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> For SCI, the TE (transmit enable) must be set after setting TIE (transmit
> interrupt enable) or in the same instruction to start the transmission.
> Set TE bit in sci_start_tx() instead of set_termios() for SCI and clear
> TE bit, if circular buffer is empty in sci_transmit_chars().
>
> Fixes: f9a2adcc9e90 ("arm64: dts: renesas: r9a07g044: Add SCI[0-1] nodes")

That's a DTS patch?

I'm wondering if this got broken accidentally by commit 93bcefd4c6bad4c6
("serial: sh-sci: Fix setting SCSCR_TIE while transferring data"),
which was probably never tested on SCI.

> Cc: stable@vger.kernel.org
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v3:
>  * New patch
> ---
>  drivers/tty/serial/sh-sci.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> index b9cd27451f90..9079a8ea9132 100644
> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c
> @@ -597,6 +597,15 @@ static void sci_start_tx(struct uart_port *port)
>         if (!s->chan_tx || port->type == PORT_SCIFA || port->type == PORT_SCIFB) {
>                 /* Set TIE (Transmit Interrupt Enable) bit in SCSCR */
>                 ctrl = serial_port_in(port, SCSCR);
> +
> +               /*
> +                * For SCI, TE (transmit enable) must be set after setting TIE
> +                * (transmit interrupt enable) or in the same instruction to start
> +                * the transmit process.
> +                */
> +               if (port->type == PORT_SCI)
> +                       ctrl |= SCSCR_TE;
> +
>                 serial_port_out(port, SCSCR, ctrl | SCSCR_TIE);
>         }
>  }
> @@ -835,6 +844,12 @@ static void sci_transmit_chars(struct uart_port *port)
>                         c = xmit->buf[xmit->tail];
>                         xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
>                 } else {
> +                       if (port->type == PORT_SCI) {
> +                               ctrl = serial_port_in(port, SCSCR);
> +                               ctrl &= ~SCSCR_TE;
> +                               serial_port_out(port, SCSCR, ctrl);
> +                               return;
> +                       }
>                         break;
>                 }
>
> @@ -2581,8 +2596,14 @@ static void sci_set_termios(struct uart_port *port, struct ktermios *termios,
>                 sci_set_mctrl(port, port->mctrl);
>         }
>
> -       scr_val |= SCSCR_RE | SCSCR_TE |
> -                  (s->cfg->scscr & ~(SCSCR_CKE1 | SCSCR_CKE0));
> +       /*
> +        * For SCI, TE (transmit enable) must be set after setting TIE
> +        * (transmit interrupt enable) or in the same instruction to
> +        * start the transmitting process. So skip setting TE here for SCI.
> +        */
> +       if (port->type != PORT_SCI)
> +               scr_val |= SCSCR_TE;
> +       scr_val |= SCSCR_RE | (s->cfg->scscr & ~(SCSCR_CKE1 | SCSCR_CKE0));
>         serial_port_out(port, SCSCR, scr_val | s->hscif_tot);
>         if ((srr + 1 == 5) &&
>             (port->type == PORT_SCIFA || port->type == PORT_SCIFB)) {

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
