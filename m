Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641B42176CB
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 20:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgGGSdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 14:33:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39731 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbgGGSdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 14:33:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id w3so119937wmi.4;
        Tue, 07 Jul 2020 11:33:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VmP8szPEkxiHeyf+0eBKORKozprQKxCy4pGc7rULiWQ=;
        b=b8mtu9sLNkHRTiQzsxhuPsSUeyd24FNhN/SroqfIS3GuGO+fuDNGTO9b+8LL1XS4z0
         2Lvg+/zZzMgrCBRbjs96r4IA/JCohu/lHxSvvoj1npOXsGO9zpDkipROrB4tQ94sKjs5
         ictxBnLPd2WHEo0xrL8tm1/HuP2GJj3+A3EO1RuSSt0bcbDrGM6BdCv3MPktTENPSapN
         6BcXerr1F1xRgxKNpnXdhnneA81fZA1CR1YQwn9BgqBdq74hmmIBXm7jDwRFPAPW675q
         FvsJVW7GJ9hvexa3XnO10Fe9KnY0W2dXQb5fo6TnwtYZzMqIgb8gDLfzZMXoxX8wmNov
         EerQ==
X-Gm-Message-State: AOAM532y+EFsoxonJQSWiK+hlEKH697Rjgys9vdoPsCixQEWYXfq3r5I
        5onhNBO4onrMgWLyP65QineVDh0p
X-Google-Smtp-Source: ABdhPJxXmNpEE7ZSzC7CoOjODE0Pk58NtoKpx9ZPZXgTFFRyRnbU2aTENsnxHI0ccD9fXLv6r6a0yQ==
X-Received: by 2002:a1c:6289:: with SMTP id w131mr5221362wmb.64.1594146803436;
        Tue, 07 Jul 2020 11:33:23 -0700 (PDT)
Received: from kozik-lap ([194.230.155.195])
        by smtp.googlemail.com with ESMTPSA id q7sm2359182wrs.27.2020.07.07.11.33.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jul 2020 11:33:22 -0700 (PDT)
Date:   Tue, 7 Jul 2020 20:33:20 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] i2c: imx: Fix external abort on interrupt in exit
 paths
Message-ID: <20200707183320.GA3442@kozik-lap>
References: <1592130544-19759-1-git-send-email-krzk@kernel.org>
 <1592130544-19759-2-git-send-email-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1592130544-19759-2-git-send-email-krzk@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 14, 2020 at 12:29:04PM +0200, Krzysztof Kozlowski wrote:
> If interrupt comes late, during probe error path or device remove (could
> be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
> i2c_imx_isr() will access registers with the clock being disabled.  This
> leads to external abort on non-linefetch on Toradex Colibri VF50 module
> (with Vybrid VF5xx):
> 
> Unhandled fault: external abort on non-linefetch (0x1008) at 0x8882d003
> Internal error: : 1008 [#1] ARM
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper Not tainted 5.7.0 #607
> Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
>   (i2c_imx_isr) from [<8017009c>] (free_irq+0x25c/0x3b0)
>   (free_irq) from [<805844ec>] (release_nodes+0x178/0x284)
>   (release_nodes) from [<80580030>] (really_probe+0x10c/0x348)
>   (really_probe) from [<80580380>] (driver_probe_device+0x60/0x170)
>   (driver_probe_device) from [<80580630>] (device_driver_attach+0x58/0x60)
>   (device_driver_attach) from [<805806bc>] (__driver_attach+0x84/0xc0)
>   (__driver_attach) from [<8057e228>] (bus_for_each_dev+0x68/0xb4)
>   (bus_for_each_dev) from [<8057f3ec>] (bus_add_driver+0x144/0x1ec)
>   (bus_add_driver) from [<80581320>] (driver_register+0x78/0x110)
>   (driver_register) from [<8010213c>] (do_one_initcall+0xa8/0x2f4)
>   (do_one_initcall) from [<80c0100c>] (kernel_init_freeable+0x178/0x1dc)
>   (kernel_init_freeable) from [<80807048>] (kernel_init+0x8/0x110)
>   (kernel_init) from [<80100114>] (ret_from_fork+0x14/0x20)
> 
> Additionally, the i2c_imx_isr() could wake up the wait queue
> (imx_i2c_struct->queue) before its initialization happens.
> 
> The resource-managed framework should not be used for interrupt handling,
> because the resource will be released too late - after disabling clocks.
> The interrupt handler is not prepared for such case.
> 
> Fixes: 1c4b6c3bcf30 ("i2c: imx: implement bus recovery")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> Changes since v1:
> 1. Remove the devm- and use regular methods.

Hi everyone,

Similar patch for SPI driver was already merged [1]. Any comments here?

Best regards,
Krzysztof


[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=3d87b613d6a3c6f0980e877ab0895785a2dde581

> ---
>  drivers/i2c/busses/i2c-imx.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
