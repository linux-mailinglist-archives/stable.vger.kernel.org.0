Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5873E1057F
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 08:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfEAGlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 02:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfEAGlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 May 2019 02:41:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D41C021743;
        Wed,  1 May 2019 06:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556692867;
        bh=0rRmRrDW8+WCJ0igGV9Z0524E1SbyXBOzg7WPdtj/SM=;
        h=Subject:To:From:Date:From;
        b=eOt2AXwEPjNhypwSOC1oukuUTtExLg+4TWZk2OpbuKHjeQBr5kDAVHKxMFR+aAwkS
         LZw3lJ92UseQyrfggHDXZOgUkd/2ep20twElAlj0vdzGgCwanxrsnMaMjFkBZFftHI
         3n6LNJ42yFakJsLY2NDrGPe6MHOjIvgU0AwBK0xs=
Subject: patch "soc: sunxi: Fix missing dependency on REGMAP_MMIO" added to usb-next
To:     samuel@sholland.org, b-liu@ti.com, gregkh@linuxfoundation.org,
        maxime.ripard@bootlin.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 01 May 2019 08:40:33 +0200
Message-ID: <155669283375209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    soc: sunxi: Fix missing dependency on REGMAP_MMIO

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From a84014e1db35d8e7af09878d0b4bf30804fb17d5 Mon Sep 17 00:00:00 2001
From: Samuel Holland <samuel@sholland.org>
Date: Tue, 30 Apr 2019 09:59:37 -0500
Subject: soc: sunxi: Fix missing dependency on REGMAP_MMIO

When enabling ARCH_SUNXI from allnoconfig, SUNXI_SRAM is enabled, but
not REGMAP_MMIO, so the kernel fails to link with an undefined reference
to __devm_regmap_init_mmio_clk. Select REGMAP_MMIO, as suggested in
drivers/base/regmap/Kconfig.

This creates the following dependency loop:

  drivers/of/Kconfig:68:                symbol OF_IRQ depends on IRQ_DOMAIN
  kernel/irq/Kconfig:63:                symbol IRQ_DOMAIN is selected by REGMAP
  drivers/base/regmap/Kconfig:7:        symbol REGMAP default is visible depending on REGMAP_MMIO
  drivers/base/regmap/Kconfig:39:       symbol REGMAP_MMIO is selected by SUNXI_SRAM
  drivers/soc/sunxi/Kconfig:4:          symbol SUNXI_SRAM is selected by USB_MUSB_SUNXI
  drivers/usb/musb/Kconfig:63:          symbol USB_MUSB_SUNXI depends on GENERIC_PHY
  drivers/phy/Kconfig:7:                symbol GENERIC_PHY is selected by PHY_BCM_NS_USB3
  drivers/phy/broadcom/Kconfig:29:      symbol PHY_BCM_NS_USB3 depends on MDIO_BUS
  drivers/net/phy/Kconfig:12:           symbol MDIO_BUS default is visible depending on PHYLIB
  drivers/net/phy/Kconfig:181:          symbol PHYLIB is selected by ARC_EMAC_CORE
  drivers/net/ethernet/arc/Kconfig:18:  symbol ARC_EMAC_CORE is selected by ARC_EMAC
  drivers/net/ethernet/arc/Kconfig:24:  symbol ARC_EMAC depends on OF_IRQ

To fix the circular dependency, make USB_MUSB_SUNXI select GENERIC_PHY
instead of depending on it. This matches the use of GENERIC_PHY by all
but two other drivers.

Cc: <stable@vger.kernel.org> # 4.19
Fixes: 5828729bebbb ("soc: sunxi: export a regmap for EMAC clock reg on A64")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/sunxi/Kconfig | 1 +
 drivers/usb/musb/Kconfig  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/sunxi/Kconfig b/drivers/soc/sunxi/Kconfig
index 353b07e40176..e84eb4e59f58 100644
--- a/drivers/soc/sunxi/Kconfig
+++ b/drivers/soc/sunxi/Kconfig
@@ -4,6 +4,7 @@
 config SUNXI_SRAM
 	bool
 	default ARCH_SUNXI
+	select REGMAP_MMIO
 	help
 	  Say y here to enable the SRAM controller support. This
 	  device is responsible on mapping the SRAM in the sunXi SoCs
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index f742fddc5e2c..52f8e2b57ad5 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -67,7 +67,7 @@ config USB_MUSB_SUNXI
 	depends on NOP_USB_XCEIV
 	depends on PHY_SUN4I_USB
 	depends on EXTCON
-	depends on GENERIC_PHY
+	select GENERIC_PHY
 	select SUNXI_SRAM
 
 config USB_MUSB_DAVINCI
-- 
2.21.0


