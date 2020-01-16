Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A9C13F5FF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388873AbgAPRGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:06:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388866AbgAPRGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B66A22522;
        Thu, 16 Jan 2020 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194372;
        bh=ytr1jqxcGQfSHeYVEAxStVB/R5aVTSPwptwvqK57Oqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLoBr0/dv7JFKrmGrIYgQfiUF+O1+jxamFGwZjnWfQd3QIc/5Q22KDqZGaFdBxieV
         MgkQwSaCe0Z5FP2xjuXIpvFpL8K4JwDOl0kmWKMNE5d3GJ9+9I+sFy+1zPc/J0R6j1
         T+gFFLEFOdcmUZNiUerBuoJIDQgSmh43C4oTNOJc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 305/671] ARM: dts: ls1021: Fix SGMII PCS link remaining down after PHY disconnect
Date:   Thu, 16 Jan 2020 11:59:03 -0500
Message-Id: <20200116170509.12787-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit c7861adbe37f576931650ad8ef805e0c47564b9a ]

Each eTSEC MAC has its own TBI (SGMII) PCS and private MDIO bus.
But due to a DTS oversight, both SGMII-compatible MACs of the LS1021 SoC
are pointing towards the same internal PCS. Therefore nobody is
controlling the internal PCS of eTSEC0.

Upon initial ndo_open, the SGMII link is ok by virtue of U-boot
initialization. But upon an ifdown/ifup sequence, the code path from
ndo_open -> init_phy -> gfar_configure_serdes does not get executed for
the PCS of eTSEC0 (and is executed twice for MAC eTSEC1). So the SGMII
link remains down for eTSEC0. On the LS1021A-TWR board, to signal this
failure condition, the PHY driver keeps printing
'803x_aneg_done: SGMII link is not ok'.

Also, it changes compatible of mdio0 to "fsl,etsec2-mdio" to match
mdio1 device.

Fixes: 055223d4d22d ("ARM: dts: ls1021a: Enable the eTSEC ports on QDS and TWR")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Acked-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ls1021a-twr.dts |  9 ++++++++-
 arch/arm/boot/dts/ls1021a.dtsi    | 11 ++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ls1021a-twr.dts b/arch/arm/boot/dts/ls1021a-twr.dts
index f0c949d74833..ec5afad3efd8 100644
--- a/arch/arm/boot/dts/ls1021a-twr.dts
+++ b/arch/arm/boot/dts/ls1021a-twr.dts
@@ -143,7 +143,7 @@
 };
 
 &enet0 {
-	tbi-handle = <&tbi1>;
+	tbi-handle = <&tbi0>;
 	phy-handle = <&sgmii_phy2>;
 	phy-connection-type = "sgmii";
 	status = "okay";
@@ -222,6 +222,13 @@
 	sgmii_phy2: ethernet-phy@2 {
 		reg = <0x2>;
 	};
+	tbi0: tbi-phy@1f {
+		reg = <0x1f>;
+		device_type = "tbi-phy";
+	};
+};
+
+&mdio1 {
 	tbi1: tbi-phy@1f {
 		reg = <0x1f>;
 		device_type = "tbi-phy";
diff --git a/arch/arm/boot/dts/ls1021a.dtsi b/arch/arm/boot/dts/ls1021a.dtsi
index f18490548c78..7e22309bccac 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -584,7 +584,7 @@
 		};
 
 		mdio0: mdio@2d24000 {
-			compatible = "gianfar";
+			compatible = "fsl,etsec2-mdio";
 			device_type = "mdio";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -592,6 +592,15 @@
 			      <0x0 0x2d10030 0x0 0x4>;
 		};
 
+		mdio1: mdio@2d64000 {
+			compatible = "fsl,etsec2-mdio";
+			device_type = "mdio";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x0 0x2d64000 0x0 0x4000>,
+			      <0x0 0x2d50030 0x0 0x4>;
+		};
+
 		ptp_clock@2d10e00 {
 			compatible = "fsl,etsec-ptp";
 			reg = <0x0 0x2d10e00 0x0 0xb0>;
-- 
2.20.1

