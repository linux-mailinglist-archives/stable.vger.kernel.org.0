Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE094D9826
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346861AbiCOJyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346858AbiCOJyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:54:18 -0400
Received: from smtp-out.xnet.cz (smtp-out.xnet.cz [178.217.244.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8476DE50;
        Tue, 15 Mar 2022 02:52:59 -0700 (PDT)
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id E924F18B18;
        Tue, 15 Mar 2022 10:52:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=true.cz; s=xnet;
        t=1647337978; bh=ox4zNWlTMk+MPz4ulEDu2t2rrdbC7u1dcQZJDhylnO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Jry+YG9VZUmcJHATFEgEDp8HsMPcaeL+R0IjXE7f4GDJc2yuFmMSD4kmRV8kwlOzL
         tcS+4G9/E95X3nzmyJZ/GKK2Zf5KrMRTAe4CYfZt4l4IdbVZRVic3aTqPq0fjD74lm
         DqRzxz2fNAONPTmwEHU17mtTTq7b3BdMtreCgi/o=
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 61b1a915;
        Tue, 15 Mar 2022 10:52:34 +0100 (CET)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev
Subject: [PATCH v2 2/3] ARM: dts: sun7i: add support for A20-olinuxino-lime2 Revisions G/G1/G2
Date:   Tue, 15 Mar 2022 10:52:43 +0100
Message-Id: <20220315095244.29718-3-ynezz@true.cz>
In-Reply-To: <20220315095244.29718-1-ynezz@true.cz>
References: <20220315095244.29718-1-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lime2 HW first public revisions G/G1/G2 used RTL8211E PHYs. Later public
revision K and newest are using KSZ9031 PHYs. Up to commit bbc4d71d6354
("net: phy: realtek: fix rtl8211e rx/tx delay config") it was possible
to use same DTS for A20-olinuxino-lime2 with either KSZ9031 or RTL8211E
PHYs, thus on all HW revisions.

Having commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay
config") applied, Bastien found out, that his board using RTL8211E PHY
doesn't work anymore and tried to fix it by providing proper `phy-mode`
in commit 55dd7e059098 ("ARM: dts: sun7i: A20-olinuxino-lime2: Fix
ethernet phy-mode") with following reasoning:

 Commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay
 config") sets the RX/TX delay according to the phy-mode property in the
 device tree. For the A20-olinuxino-lime2 board this is "rgmii", which is
 the wrong setting.

Indeed, the settings were likely wrong, but only for boards with G/G1/G2
revisions using RTL8211E PHY. Those settings were still correct on
boards with HW revisions K and later with KSZ9031 PHY, so this fix was
incorrect.

So fix it properly by introducing separate DTS for boards with G/G1/G2
revisions using proper PHY mode for RTL8211E PHY.

Cc: stable@vger.kernel.org
Cc: Bastien Roucariès <rouca@debian.org>
References: https://github.com/OLIMEX/OLINUXINO/blob/master/HARDWARE/A20-OLinuXino-LIME2/hardware_revision_changes_log.txt
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 arch/arm/boot/dts/Makefile                            |  2 ++
 .../boot/dts/sun7i-a20-olinuxino-lime2-emmc-revG.dts  | 11 +++++++++++
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-revG.dts  | 11 +++++++++++
 3 files changed, 24 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc-revG.dts
 create mode 100644 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-revG.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index e41eca79c950..241a1a229f0f 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -1244,7 +1244,9 @@ dtb-$(CONFIG_MACH_SUN7I) += \
 	sun7i-a20-olinuxino-lime.dtb \
 	sun7i-a20-olinuxino-lime-emmc.dtb \
 	sun7i-a20-olinuxino-lime2.dtb \
+	sun7i-a20-olinuxino-lime2-revG.dtb \
 	sun7i-a20-olinuxino-lime2-emmc.dtb \
+	sun7i-a20-olinuxino-lime2-emmc-revG.dtb \
 	sun7i-a20-olinuxino-micro.dtb \
 	sun7i-a20-olinuxino-micro-emmc.dtb \
 	sun7i-a20-orangepi.dtb \
diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc-revG.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc-revG.dts
new file mode 100644
index 000000000000..1e29f973614d
--- /dev/null
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc-revG.dts
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include "sun7i-a20-olinuxino-lime2-emmc.dts"
+
+/ {
+	model = "Olimex A20-OLinuXino-LIME2-eMMC (Rev G/G1/G2)";
+	compatible = "olimex,a20-olinuxino-lime2-emmc-revG", "allwinner,sun7i-a20";
+};
+
+&gmac {
+	phy-mode = "rgmii-id";
+};
diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-revG.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-revG.dts
new file mode 100644
index 000000000000..7122dc99810a
--- /dev/null
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-revG.dts
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include "sun7i-a20-olinuxino-lime2.dts"
+
+/ {
+	model = "Olimex A20-OLinuXino-LIME2 (Rev G/G1/G2)";
+	compatible = "olimex,a20-olinuxino-lime2-revG", "allwinner,sun7i-a20";
+};
+
+&gmac {
+	phy-mode = "rgmii-id";
+};
