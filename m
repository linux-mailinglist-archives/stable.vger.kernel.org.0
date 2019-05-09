Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0642D19171
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbfEISyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726888AbfEISyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:54:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88C70217F9;
        Thu,  9 May 2019 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428075;
        bh=SUlprhcR9idfkpVHxBTp9Vgr2oLGsU0myBp4XAzMICk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guKGGXIwQevpdXXF3omkIM+dbr5RX0bGWuaH2QjkZzUtB15P7s41jEDRJbkSS8EAP
         /stWY16N23PFYEYswXwv9vFKFD1RbcWb9WyQJWWKP0YfvUtQFbhCKnFESUTDsByogJ
         Tmi7gfWBJ9vt7+7+oy/mhB9TMIMmLbT6GGX1lELY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Bin Liu <b-liu@ti.com>
Subject: [PATCH 5.1 17/30] soc: sunxi: Fix missing dependency on REGMAP_MMIO
Date:   Thu,  9 May 2019 20:42:49 +0200
Message-Id: <20190509181254.569413784@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

commit a84014e1db35d8e7af09878d0b4bf30804fb17d5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/sunxi/Kconfig |    1 +
 drivers/usb/musb/Kconfig  |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

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


