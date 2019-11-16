Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7004AFF260
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbfKPPqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729337AbfKPPqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:18 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8E12083B;
        Sat, 16 Nov 2019 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919178;
        bh=+Tu81s/jZSdhO5WGgtrMGG8ucgrcGU+ah1WI414OjVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tTi3lM4+ifw8TrAvx+imKniBJf8q5JjPHEBH3Mn2JFslXmo7HpYbUdH2348N0hdK
         oCW0rH1QNVE7J3OSiellNwXyiAVTIpoUncjB8hDFeNkDt2j4tge3U8C0XMzVXcKRn+
         4zc0fXE8ZnLS/tNzLKmPQ7UIe8QDIXyYWZWxan/o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 187/237] ARM: dts: imx6sx-sdb: Fix enet phy regulator
Date:   Sat, 16 Nov 2019 10:40:22 -0500
Message-Id: <20191116154113.7417-187-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit 1ad9fb750a104f51851c092edd7b3553f0218428 ]

Bindings for "fixed-regulator" only explicitly support "gpio" property,
not "gpios". Fix by correcting the property name.

The enet PHYs on imx6sx-sdb needs to be explicitly reset after a power
cycle, this can be handled by the phy-reset-gpios property. Sadly this
is not handled on suspend: the fec driver turns phy-supply off but
doesn't assert phy-reset-gpios again on resume.

Since additional phy-level work is required to support powering off the
phy in suspend fix the problem by just marking the regulator as
"boot-on" "always-on" so that it's never turned off. This behavior is
equivalent to older releases.

Keep the phy-reset-gpios property on fec anyway because it is a correct
description of board design.

This issue was exposed by commit efdfeb079cc3 ("regulator: fixed:
Convert to use GPIO descriptor only") which causes the "gpios" property
to also be parsed. Before that commit the "gpios" property had no
effect, PHY reset was only handled in the the bootloader.

This fixes linux-next boot failures previously reported here:
 https://lore.kernel.org/patchwork/patch/982437/#1177900
 https://lore.kernel.org/patchwork/patch/994091/#1178304

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sx-sdb.dtsi | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6sx-sdb.dtsi b/arch/arm/boot/dts/imx6sx-sdb.dtsi
index f8f31872fa144..d6d517e4922ff 100644
--- a/arch/arm/boot/dts/imx6sx-sdb.dtsi
+++ b/arch/arm/boot/dts/imx6sx-sdb.dtsi
@@ -115,7 +115,9 @@
 		regulator-name = "enet_3v3";
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
-		gpios = <&gpio2 6 GPIO_ACTIVE_LOW>;
+		gpio = <&gpio2 6 GPIO_ACTIVE_LOW>;
+		regulator-boot-on;
+		regulator-always-on;
 	};
 
 	reg_pcie_gpio: regulator-pcie-gpio {
@@ -178,6 +180,7 @@
 	phy-supply = <&reg_enet_3v3>;
 	phy-mode = "rgmii";
 	phy-handle = <&ethphy1>;
+	phy-reset-gpios = <&gpio2 7 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
 	mdio {
@@ -371,6 +374,8 @@
 				MX6SX_PAD_RGMII1_RD3__ENET1_RX_DATA_3	0x3081
 				MX6SX_PAD_RGMII1_RX_CTL__ENET1_RX_EN	0x3081
 				MX6SX_PAD_ENET2_RX_CLK__ENET2_REF_CLK_25M	0x91
+				/* phy reset */
+				MX6SX_PAD_ENET2_CRS__GPIO2_IO_7		0x10b0
 			>;
 		};
 
-- 
2.20.1

