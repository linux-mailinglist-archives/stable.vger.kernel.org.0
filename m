Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7CC37B9C7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhELJ54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:57:56 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:44770 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbhELJ5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 05:57:52 -0400
Received: from iota-build.ysoft.local (unknown [10.1.5.151])
        by uho.ysoft.cz (Postfix) with ESMTP id 79B1CA02C2;
        Wed, 12 May 2021 11:56:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1620813403;
        bh=SG2y18C7JNfTDUdkAYTD8f+Wpft0cnGU4jaSxzMgYBs=;
        h=From:To:Cc:Subject:Date:From;
        b=SLG6Qg+DJ3GzlTGeJV5O/TAGbWajSJHZA2UDlj1BauYIPr/TZYYwq1dQkqQq/ewg/
         hmeuX44ONiwt4v4KOnTKGoyZ/BkZ4aVXA0EqpoOKJ6pMniALPv7JOTVBGzYDvaQwux
         JEg7TRCTb7UyzbYfWFZqEBxqBQXHjlp5/e5gOcqc=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        stable@vger.kernel.org
Subject: [PATCH RESEND] ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334 switch
Date:   Wed, 12 May 2021 11:56:32 +0200
Message-Id: <1620813392-30933-1-git-send-email-michal.vokac@ysoft.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The FEC does not have a PHY so it should not have a phy-handle. It is
connected to the switch at RGMII level so we need a fixed-link sub-node
on both ends.

This was not a problem until the qca8k.c driver was converted to PHYLINK
by commit b3591c2a3661 ("net: dsa: qca8k: Switch to PHYLINK instead of
PHYLIB"). That commit revealed the FEC configuration was not correct.

Fixes: 87489ec3a77f ("ARM: dts: imx: Add Y Soft IOTA Draco, Hydra and Ursa boards")
Cc: stable@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
index 111d4d331f98..686dab57a1e4 100644
--- a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
+++ b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
@@ -121,9 +121,13 @@
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
 	phy-reset-duration = <20>;
 	phy-supply = <&sw2_reg>;
-	phy-handle = <&ethphy0>;
 	status = "okay";
 
+	fixed-link {
+		speed = <1000>;
+		full-duplex;
+	};
+
 	mdio {
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.1.4

