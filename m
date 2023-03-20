Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0C86C2134
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 20:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjCTTUT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Mar 2023 15:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjCTTTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 15:19:42 -0400
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06F84EF9;
        Mon, 20 Mar 2023 12:11:57 -0700 (PDT)
Received: by mail-qt1-f170.google.com with SMTP id t19so354498qta.12;
        Mon, 20 Mar 2023 12:11:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679339516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32XMWaYeoPpvuSP4SJ2y+jdAZEcgNNcwFIl8GOW4Yfc=;
        b=o3qIN2/LnO4ED23wjTMEUrjH699iEJ//+/jSREdD7Cuv9fQeXnRaexFGeDm8cF/PqI
         cxI+ZhpZCnAtcscmFCVRyCUbCzAStPyR69Dvfop4uwN9DezgV84bKLB2G8R0DEJXDt7a
         lhKKahXjSGkhaIQJF/thSal0clOE1u226furEQijuGKvoyxfw64sekiglP2JLlYTqk0l
         kNWiNjNot4P8VOWPylzlPMRRbsvW2FUbr31O3R927O0XOdkabv1zt3hsdgbVTllFv4QX
         dPwOrujKrDnLHmpnnErMnuPjnlpx8v/zY4oE67flQdM+jZx4Dcnivz95C7BiUTdE3tHI
         vp1g==
X-Gm-Message-State: AO0yUKUWSl6xVYsQbh1il4e4NC/bc4StrS0WzXhIW9VWiEcuWACJIdAa
        8t7X1m9vRQbQqMwBV6qysiQHB4PRQTTD5g==
X-Google-Smtp-Source: AK7set/lzaN1t3KTUVZkEumSDbdmOHX5pEo8NAJQP1oIh0/XbnlYc0mKuLl4/fvcWAm42fACvEG+lQ==
X-Received: by 2002:a05:622a:54e:b0:3bf:d9f3:debe with SMTP id m14-20020a05622a054e00b003bfd9f3debemr289534qtx.59.1679339516454;
        Mon, 20 Mar 2023 12:11:56 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id c7-20020ac86e87000000b003e1ff058350sm2007985qtv.63.2023.03.20.12.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 12:11:55 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id e71so14500150ybc.0;
        Mon, 20 Mar 2023 12:11:55 -0700 (PDT)
X-Received: by 2002:a25:5b84:0:b0:b67:d295:d614 with SMTP id
 p126-20020a255b84000000b00b67d295d614mr201995ybb.12.1679339514703; Mon, 20
 Mar 2023 12:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230320105339.236279-1-biju.das.jz@bp.renesas.com> <20230320105339.236279-3-biju.das.jz@bp.renesas.com>
In-Reply-To: <20230320105339.236279-3-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 20 Mar 2023 20:11:43 +0100
X-Gmail-Original-Message-ID: <CAMuHMdW2gxDzYbP_0Z90o8mHdUm_BV6e+gMHpELJx_g=ezAbdw@mail.gmail.com>
Message-ID: <CAMuHMdW2gxDzYbP_0Z90o8mHdUm_BV6e+gMHpELJx_g=ezAbdw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
> SCI IP on RZ/G2L alike SoCs do not need regshift compared to other SCI
> IPs on the SH platform. Currently, it does regshift and configuring Rx
> wrongly. Drop adding regshift for RZ/G2L alike SoCs.
>
> Fixes: f9a2adcc9e90 ("arm64: dts: renesas: r9a07g044: Add SCI[0-1] nodes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v3:
>  * New patch.

Thanks for your patch!

> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c
> @@ -158,6 +158,7 @@ struct sci_port {
>
>         bool has_rtscts;
>         bool autorts;
> +       bool is_rz_sci;
>  };
>
>  #define SCI_NPORTS CONFIG_SERIAL_SH_SCI_NR_UARTS
> @@ -2937,7 +2938,7 @@ static int sci_init_single(struct platform_device *dev,
>         port->flags             = UPF_FIXED_PORT | UPF_BOOT_AUTOCONF | p->flags;
>         port->fifosize          = sci_port->params->fifosize;
>
> -       if (port->type == PORT_SCI) {
> +       if (port->type == PORT_SCI && !sci_port->is_rz_sci) {

Perhaps check for !dev->dev.of_node instead? Values of 1 or 2 for
regshift are only needed for sh770x/sh7750/sh7760, which don't use
DT yet.  When they are converted to DT, we can extend the driver to
support the more-or-less standard "reg-shift" DT property.

>                 if (sci_port->reg_size >= 0x20)
>                         port->regshift = 2;
>                 else
> @@ -3353,6 +3354,11 @@ static int sci_probe(struct platform_device *dev)
>         sp = &sci_ports[dev_id];
>         platform_set_drvdata(dev, sp);
>
> +       if (of_device_is_compatible(dev->dev.of_node, "renesas,r9a07g043-sci") ||
> +           of_device_is_compatible(dev->dev.of_node, "renesas,r9a07g044-sci") ||
> +           of_device_is_compatible(dev->dev.of_node, "renesas,r9a07g054-sci"))

Please, no of_device_is_compatible() checks in a driver that uses
proper DT matching.

> +               sp->is_rz_sci = 1;
> +
>         ret = sci_probe_single(dev, dev_id, p, sp);
>         if (ret)
>                 return ret;

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
