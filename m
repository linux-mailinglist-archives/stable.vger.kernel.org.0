Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0973A3CEF
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 09:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhFKHYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 03:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231287AbhFKHYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 03:24:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32E84613AE;
        Fri, 11 Jun 2021 07:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623396131;
        bh=Y7AV02B/ChGXTid1fZaGIbFNfr8ps4qj/G8E00xnJ2o=;
        h=Subject:To:From:Date:From;
        b=ZVfXViG0VI7U6t75wV3GgXDZP2UhcQixTlvFKTcRVqosfHP7HI1L7lXH1+C/vRMN3
         ZYHfmNDmtcjHG88/Jrq/SNvCgHIgFjRHTvvyDn+4XQlCbRWKQEwGfOT3cefrArdvLp
         1zQxNntip63I7MPba6+s/yxReGDSLGQU9QWHvAm8=
Subject: patch "Revert "usb: gadget: fsl: Re-enable driver for ARM SoCs"" added to usb-linus
To:     gregkh@linuxfoundation.org, arnd@arndb.de, balbi@kernel.org,
        joel@jms.id.au, leoyang.li@nxp.com, lkp@intel.com,
        peter.chen@nxp.com, ran.wang_1@nxp.com, sfr@canb.auug.org.au,
        shawnguo@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Jun 2021 09:22:09 +0200
Message-ID: <1623396129105150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "usb: gadget: fsl: Re-enable driver for ARM SoCs"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From abd062886cd103196b4f26cf735c3a3619dec76b Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 11 Jun 2021 09:18:47 +0200
Subject: Revert "usb: gadget: fsl: Re-enable driver for ARM SoCs"

This reverts commit e0e8b6abe8c862229ba00cdd806e8598cdef00bb.

Turns out this breaks the build.  We had numerous reports of problems
from linux-next and 0-day about this not working properly, so revert it
for now until it can be figured out properly.

The build errors are:
	arm-linux-gnueabi-ld: fsl_udc_core.c:(.text+0x29d4): undefined reference to `fsl_udc_clk_finalize'
	arm-linux-gnueabi-ld: fsl_udc_core.c:(.text+0x2ba8): undefined reference to `fsl_udc_clk_release'
	fsl_udc_core.c:(.text+0x2848): undefined reference to `fsl_udc_clk_init'
	fsl_udc_core.c:(.text+0xe88): undefined reference to `fsl_udc_clk_release'

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: e0e8b6abe8c8 ("usb: gadget: fsl: Re-enable driver for ARM SoCs")
Cc: stable <stable@vger.kernel.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Leo Li <leoyang.li@nxp.com>
Cc: Peter Chen <peter.chen@nxp.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Ran Wang <ran.wang_1@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 7348acbdc560..8c614bb86c66 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -90,7 +90,7 @@ config USB_BCM63XX_UDC
 
 config USB_FSL_USB2
 	tristate "Freescale Highspeed USB DR Peripheral Controller"
-	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A || COMPILE_TEST
+	depends on FSL_SOC
 	help
 	   Some of Freescale PowerPC and i.MX processors have a High Speed
 	   Dual-Role(DR) USB controller, which supports device mode.
-- 
2.32.0


