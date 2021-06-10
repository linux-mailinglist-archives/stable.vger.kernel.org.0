Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA763A32A8
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 20:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhFJSEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 14:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbhFJSEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 14:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB304613F1;
        Thu, 10 Jun 2021 18:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623348154;
        bh=amib4PGevbgjiEIp2raeUzTI9UUnkvqa1yT1lTBW3l8=;
        h=Subject:To:From:Date:From;
        b=X8WvL2RV3e8jBVio/clnPZzlN6SU3ciKXI11sm3NNE/SnRLH6gwb0WnE1mV3BoJ4o
         TepILT4FArnia0NGoIfNnH0LXOf2ikm1orsodz1oFtQcC2kb+UjIT6/0HNEDi5pJyO
         /vqmH/7GowK/MNXsfJ3i+K4M/wrFDs+wCjkaAR5A=
Subject: patch "usb: gadget: fsl: Re-enable driver for ARM SoCs" added to usb-linus
To:     joel@jms.id.au, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Jun 2021 20:02:23 +0200
Message-ID: <162334814333203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: fsl: Re-enable driver for ARM SoCs

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e0e8b6abe8c862229ba00cdd806e8598cdef00bb Mon Sep 17 00:00:00 2001
From: Joel Stanley <joel@jms.id.au>
Date: Thu, 10 Jun 2021 13:19:57 +0930
Subject: usb: gadget: fsl: Re-enable driver for ARM SoCs

The commit a390bef7db1f ("usb: gadget: fsl_mxc_udc: Remove the driver")
dropped the ARCH_MXC dependency from USB_FSL_USB2, leaving it depending
solely on FSL_SOC.

FSL_SOC is powerpc only; it was briefly available on ARM in 2014 but was
removed by commit cfd074ad8600 ("ARM: imx: temporarily remove
CONFIG_SOC_FSL from LS1021A"). Therefore the driver can no longer be
enabled on ARM platforms.

This appears to be a mistake as arm64's ARCH_LAYERSCAPE and arm32
SOC_LS1021A SoCs use this symbol. It's enabled in these defconfigs:

arch/arm/configs/imx_v6_v7_defconfig:CONFIG_USB_FSL_USB2=y
arch/arm/configs/multi_v7_defconfig:CONFIG_USB_FSL_USB2=y
arch/powerpc/configs/mgcoge_defconfig:CONFIG_USB_FSL_USB2=y
arch/powerpc/configs/mpc512x_defconfig:CONFIG_USB_FSL_USB2=y

To fix, expand the dependencies so USB_FSL_USB2 can be enabled on the
ARM platforms, and with COMPILE_TEST.

Fixes: a390bef7db1f ("usb: gadget: fsl_mxc_udc: Remove the driver")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20210610034957.93376-1-joel@jms.id.au
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 8c614bb86c66..7348acbdc560 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -90,7 +90,7 @@ config USB_BCM63XX_UDC
 
 config USB_FSL_USB2
 	tristate "Freescale Highspeed USB DR Peripheral Controller"
-	depends on FSL_SOC
+	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A || COMPILE_TEST
 	help
 	   Some of Freescale PowerPC and i.MX processors have a High Speed
 	   Dual-Role(DR) USB controller, which supports device mode.
-- 
2.32.0


