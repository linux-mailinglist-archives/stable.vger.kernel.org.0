Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E623C66E91
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfGLMjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727546AbfGLM0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:26:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E8A62084B;
        Fri, 12 Jul 2019 12:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934385;
        bh=KeNf6QfzbHhC0UdjC81omhs6P0360g1qsMqo+/TFbD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wt6CqTcnHkNmV6FfG+kkMs7NpGcC0622dV/AN47HIP244oqhHUbhdVt+HL+ysDnJ3
         LD0AJ4iZ6QEUZ6qqPQDuO2HLcors4sI0akSXuLuvdd2nthpKlAkUF2R7vAnN1//3Oj
         fHkvTyO0QVodDP90vToPMmEuN17ZXR8ZSuywV81o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 039/138] net: phy: rename Asix Electronics PHY driver
Date:   Fri, 12 Jul 2019 14:18:23 +0200
Message-Id: <20190712121630.179102388@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a9520543b123bbd7275a0ab8d0375a5412683b41 ]

[Resent to net instead of net-next - may clash with Anders Roxell's patch
series addressing duplicate module names]

Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
introduced a new PHY driver drivers/net/phy/asix.c that causes a module
name conflict with a pre-existiting driver (drivers/net/usb/asix.c).

The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
by that driver via its PHY ID. A rename of the driver looks unproblematic.

Rename PHY driver to ax88796b.c in order to resolve name conflict.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/8390/Kconfig      | 2 +-
 drivers/net/phy/Kconfig                | 2 +-
 drivers/net/phy/Makefile               | 2 +-
 drivers/net/phy/{asix.c => ax88796b.c} | 0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename drivers/net/phy/{asix.c => ax88796b.c} (100%)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index f2f0264c58ba..443b34e2725f 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -49,7 +49,7 @@ config XSURF100
 	tristate "Amiga XSurf 100 AX88796/NE2000 clone support"
 	depends on ZORRO
 	select AX88796
-	select ASIX_PHY
+	select AX88796B_PHY
 	help
 	  This driver is for the Individual Computers X-Surf 100 Ethernet
 	  card (based on the Asix AX88796 chip). If you have such a card,
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 520657945b82..b0c13f8c2b62 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -242,7 +242,7 @@ config AQUANTIA_PHY
 	---help---
 	  Currently supports the Aquantia AQ1202, AQ2104, AQR105, AQR405
 
-config ASIX_PHY
+config AX88796B_PHY
 	tristate "Asix PHYs"
 	help
 	  Currently supports the Asix Electronics PHY found in the X-Surf 100
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index ece5dae67174..6d44ab91fbf6 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -51,7 +51,7 @@ ifdef CONFIG_HWMON
 aquantia-objs			+= aquantia_hwmon.o
 endif
 obj-$(CONFIG_AQUANTIA_PHY)	+= aquantia.o
-obj-$(CONFIG_ASIX_PHY)		+= asix.o
+obj-$(CONFIG_AX88796B_PHY)	+= ax88796b.o
 obj-$(CONFIG_AT803X_PHY)	+= at803x.o
 obj-$(CONFIG_BCM63XX_PHY)	+= bcm63xx.o
 obj-$(CONFIG_BCM7XXX_PHY)	+= bcm7xxx.o
diff --git a/drivers/net/phy/asix.c b/drivers/net/phy/ax88796b.c
similarity index 100%
rename from drivers/net/phy/asix.c
rename to drivers/net/phy/ax88796b.c
-- 
2.20.1



