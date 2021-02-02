Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF4830CC77
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhBBT50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232764AbhBBNuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:50:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F5B264FB1;
        Tue,  2 Feb 2021 13:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273378;
        bh=cyYxp5wJ/tarTNqT8sbm3bDvNzAKxN3rFcebUfwjwX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMkpCj1sVMkI3UogHnItfVIOKAaiCo9KTzKfIs+52Dc21KO/m1YSK5kXTz3wOSX3w
         F/oj6sNMUOEsHgPGS4lEW1IYmsepDC3wG60ztXzZQH1RWV2/WqEQbLw2ZvCrsjZelf
         qwP+DTuXbvxTib6BHBHkj42ZpjyXdNsQf41xlChk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Mattheis <christoph.mattheis@arcor.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/142] ARM: dts: imx6qdl-sr-som: fix some cubox-i platforms
Date:   Tue,  2 Feb 2021 14:37:28 +0100
Message-Id: <20210202133001.222464537@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 2cc0bfc9c12784188482a8f3d751d44af45b0d97 ]

The PHY address bit 2 is configured by the LED pin. Attaching a LED
to this pin is not sufficient to guarantee this configuration pin is
correctly read. This leads to some platforms having their PHY at
address 0 and others at address 4.

If there is no phy-handle specified, the FEC driver will scan the PHY
bus for a PHY and use that. Consequently, adding the DT configuration
of the PHY and the phy properties to the FEC driver broke some boards.

Fix this by removing the phy-handle property, and listing two PHY
entries for both possible PHY addresses, so that the DT configuration
for the PHY can be found by the PHY driver.

Fixes: 86b08bd5b994 ("ARM: dts: imx6-sr-som: add ethernet PHY configuration")
Reported-by: Christoph Mattheis <christoph.mattheis@arcor.de>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
index b06577808ff4e..7e4e5fd0143a1 100644
--- a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
@@ -53,7 +53,6 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_microsom_enet_ar8035>;
-	phy-handle = <&phy>;
 	phy-mode = "rgmii-id";
 	phy-reset-duration = <2>;
 	phy-reset-gpios = <&gpio4 15 GPIO_ACTIVE_LOW>;
@@ -63,10 +62,19 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		phy: ethernet-phy@0 {
+		/*
+		 * The PHY can appear at either address 0 or 4 due to the
+		 * configuration (LED) pin not being pulled sufficiently.
+		 */
+		ethernet-phy@0 {
 			reg = <0>;
 			qca,clk-out-frequency = <125000000>;
 		};
+
+		ethernet-phy@4 {
+			reg = <4>;
+			qca,clk-out-frequency = <125000000>;
+		};
 	};
 };
 
-- 
2.27.0



