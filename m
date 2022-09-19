Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6567A5BC24F
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 06:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiISEoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 00:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiISEoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 00:44:16 -0400
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DF1193D0;
        Sun, 18 Sep 2022 21:44:15 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id m3so19713688eda.12;
        Sun, 18 Sep 2022 21:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Q0cD5qNEPRxZfsNmq0to2KwlndvtkRC9pRuN4rCumnA=;
        b=yKCNl3ug3jcdI8E2sEGqwWLGjqSWF+KXTa5cVAquKvhyYFJRHalOCZJgF6mENGSBq2
         Wz7Js8kYWOrELdrbIZa3SY1d5X/JGYrQGKaENx7dyJfc9lG2C25MaDNNMcvS4Fc2+cAY
         F4HULeoDKZHb9JCGLKkGtcaLhLehSE74TA/NEWySRhOjBfnQ6CrEN31Fpfj29+kMqXsM
         vr+JODEM76bvc6MoZsLTCRnbl9j50XtqnrC9EsjxWfJd6yEIVghxYgCS3B/7ezpfLFEg
         dDTPOtvTnJcyBMYreS9weEipf+rrkFbHlMjcGy5fRecGiRtl3iWrUyzzXKitHdWCafz0
         gfaA==
X-Gm-Message-State: ACrzQf2ao6c7mA3XoN4BwGqhMOctO5N5zGpI5TV77TOQP9RMJo/fzzZY
        bX62FoIQ5hGePCv8zkq5DMM=
X-Google-Smtp-Source: AMsMyM7gUcDGMQDHqY2SgrgLcj0o1Nw/C3cdjTxZJvd4LormirRE5NAsQnRpgCZoydE7kKTL+KJhwA==
X-Received: by 2002:a05:6402:240d:b0:442:b0c4:9e02 with SMTP id t13-20020a056402240d00b00442b0c49e02mr14118903eda.210.1663562653719;
        Sun, 18 Sep 2022 21:44:13 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id a2-20020a170906468200b0073d71792c8dsm14715213ejr.180.2022.09.18.21.44.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 21:44:13 -0700 (PDT)
Message-ID: <7785ca40-2f4d-a0a8-2ada-ca5fb941b6a2@kernel.org>
Date:   Mon, 19 Sep 2022 06:44:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 2/2] serial: 8250: Request full 16550A feature probing for
 OxSemi PCIe devices
Content-Language: en-US
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk>
 <alpine.DEB.2.21.2209171020390.31781@angie.orcam.me.uk>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <alpine.DEB.2.21.2209171020390.31781@angie.orcam.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17. 09. 22, 12:07, Maciej W. Rozycki wrote:
> Oxford Semiconductor PCIe (Tornado) 950 serial port devices need to
> operate in the enhanced mode via the EFR register for the Divide-by-M
> N/8 baud rate generator prescaler to be used in their native UART mode.
> Otherwise the prescaler is fixed at 1 causing grossly incorrect baud
> rates to be programmed.
> 
> Accessing the EFR register requires 16550A features to have been probed
> for, so request this to happen regardless of SERIAL_8250_16550A_VARIANTS
> by setting UPF_FULL_PROBE in port flags.
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
> Fixes: 366f6c955d4d ("serial: 8250: Add proper clock handling for OxSemi PCIe devices")
> Cc: stable@vger.kernel.org # v5.19+
> ---
>   drivers/tty/serial/8250/8250_pci.c |    5 +++++
>   1 file changed, 5 insertions(+)
> 
> linux-serial-8250-oxsemi-efr.diff
> Index: linux-macro/drivers/tty/serial/8250/8250_pci.c
> ===================================================================
> --- linux-macro.orig/drivers/tty/serial/8250/8250_pci.c
> +++ linux-macro/drivers/tty/serial/8250/8250_pci.c
> @@ -1232,6 +1232,10 @@ static void pci_oxsemi_tornado_set_mctrl
>   	serial8250_do_set_mctrl(port, mctrl);
>   }
>   
> +/*
> + * We require EFR features for clock programming, so set UPF_FULL_PROBE
> + * for full probing regardless of CONFIG_SERIAL_8250_16550A_VARIANTS setting.
> + */

It'd make more sense to me to move this comment right before the line 
you add below.

>   static int pci_oxsemi_tornado_setup(struct serial_private *priv,
>   				    const struct pciserial_board *board,
>   				    struct uart_8250_port *up, int idx)
> @@ -1239,6 +1243,7 @@ static int pci_oxsemi_tornado_setup(stru
>   	struct pci_dev *dev = priv->dev;
>   
>   	if (pci_oxsemi_tornado_p(dev)) {
> +		up->port.flags |= UPF_FULL_PROBE;
>   		up->port.get_divisor = pci_oxsemi_tornado_get_divisor;
>   		up->port.set_divisor = pci_oxsemi_tornado_set_divisor;
>   		up->port.set_mctrl = pci_oxsemi_tornado_set_mctrl;

thanks,
-- 
js
suse labs

