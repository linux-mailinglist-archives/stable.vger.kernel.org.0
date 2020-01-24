Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC11814811F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390278AbgAXLRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733082AbgAXLRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:17:11 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DFB420708;
        Fri, 24 Jan 2020 11:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864631;
        bh=RJeEkwX1T8qdvdAUEK3an+nSjFvQlKmlFzM5QPGXXgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKD6D1DfUr1FfYQSnQ1hG7osBle+0jKrTPEKmXa12Xw3egm2y16Y2WudGTRjOK6/m
         9vdXKCVyMd6NNCaDmvSgBbLc2aNR6JvE0oBmqGN4VvidEeHV+RdTPiiGIrfZXHlJ4C
         IGTunVidtDbzrUJiZXDgNM71Gmnu5XNz3Heg81Ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 320/639] ARM: dts: ls1021: Fix SGMII PCS link remaining down after PHY disconnect
Date:   Fri, 24 Jan 2020 10:28:10 +0100
Message-Id: <20200124093127.122646308@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f0c949d748331..ec5afad3efd8e 100644
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
index f18490548c785..7e22309bccac7 100644
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



