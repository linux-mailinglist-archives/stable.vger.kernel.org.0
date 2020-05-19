Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7951D9610
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 14:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgESMSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 08:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbgESMSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 08:18:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01832C08C5C0
        for <stable@vger.kernel.org>; Tue, 19 May 2020 05:18:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1jb1Cb-0006RS-ED; Tue, 19 May 2020 14:18:33 +0200
Subject: Re: FAILED: patch "[PATCH] ARM: imx: provide v7_cpu_resume() only on
 ARM_CPU_SUSPEND=y" failed to apply to 5.6-stable tree
To:     gregkh@linuxfoundation.org, clemens.gruber@pqgruber.com,
        shawnguo@kernel.org, stable@vger.kernel.org
References: <158980862996131@kroah.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <00037464-ad28-3a1c-8308-cfc16dcfc213@pengutronix.de>
Date:   Tue, 19 May 2020 14:18:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <158980862996131@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/18/20 3:30 PM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.6-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

For the record, the patch was picked up by both Arnd and Shawn.
Arnd's pull made it into v5.7-rc3 and Shawn's into v5.7-rc6.

The patch in v5.7-rc3 is already in the stable trees, so nothing
further to do here.

Cheers
Ahmad

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 3100423dc133c25679dbaa1099404651b8ae3af9 Mon Sep 17 00:00:00 2001
> From: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Date: Mon, 23 Mar 2020 09:19:33 +0100
> Subject: [PATCH] ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y
> 
> 512a928affd5 ("ARM: imx: build v7_cpu_resume() unconditionally")
> introduced an unintended linker error for i.MX6 configurations that have
> ARM_CPU_SUSPEND=n which can happen if neither CONFIG_PM, CONFIG_CPU_IDLE,
> nor ARM_PSCI_FW are selected.
> 
> Fix this by having v7_cpu_resume() compiled only when cpu_resume() it
> calls is available as well.
> 
> The C declaration for the function remains unguarded to avoid future code
> inadvertently using a stub and introducing a regression to the bug the
> original commit fixed.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 512a928affd5 ("ARM: imx: build v7_cpu_resume() unconditionally")
> Reported-by: Clemens Gruber <clemens.gruber@pqgruber.com>
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> 
> diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
> index 03506ce46149..e7364e6c8c6b 100644
> --- a/arch/arm/mach-imx/Makefile
> +++ b/arch/arm/mach-imx/Makefile
> @@ -91,8 +91,10 @@ AFLAGS_suspend-imx6.o :=-Wa,-march=armv7-a
>  obj-$(CONFIG_SOC_IMX6) += suspend-imx6.o
>  obj-$(CONFIG_SOC_IMX53) += suspend-imx53.o
>  endif
> +ifeq ($(CONFIG_ARM_CPU_SUSPEND),y)
>  AFLAGS_resume-imx6.o :=-Wa,-march=armv7-a
>  obj-$(CONFIG_SOC_IMX6) += resume-imx6.o
> +endif
>  obj-$(CONFIG_SOC_IMX6) += pm-imx6.o
>  
>  obj-$(CONFIG_SOC_IMX1) += mach-imx1.o
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
