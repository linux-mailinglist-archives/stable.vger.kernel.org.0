Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7362D10BCD4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732056AbfK0VDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:03:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732052AbfK0VDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:03:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A6B21569;
        Wed, 27 Nov 2019 21:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888616;
        bh=+Tu81s/jZSdhO5WGgtrMGG8ucgrcGU+ah1WI414OjVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkObS85IDBVI+6/38wSoLyDrBAJTeFKgJrAexqnTlVH4G6Y+5ymztdGF5kpMx2oJY
         4pja/3dBAMMik2zN5aqSioJSnOi8yOHkHNb54apZzx6azGwll2POOQ9C+i7c7bzHdK
         QaCcqgPzQueD8cpJqj9ORmWc1Dh9AJMql1cYgZWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 204/306] ARM: dts: imx6sx-sdb: Fix enet phy regulator
Date:   Wed, 27 Nov 2019 21:30:54 +0100
Message-Id: <20191127203130.052624751@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



