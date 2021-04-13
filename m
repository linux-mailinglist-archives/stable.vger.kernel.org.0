Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1841C35E1F1
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 16:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhDMOyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 10:54:47 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:43235 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231378AbhDMOyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 10:54:46 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 10:54:45 EDT
Received: from iota-build.ysoft.local (unknown [10.1.5.151])
        by uho.ysoft.cz (Postfix) with ESMTP id 25F8BA0955;
        Tue, 13 Apr 2021 16:46:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1618325177;
        bh=wwzfajTFuzGrwTVqLjvmY4IObt01LM6Qma789rJ6+z0=;
        h=From:To:Cc:Subject:Date:From;
        b=K4PeXCgoASZwFKLuKYj73GmMq8WZxhTtE+O/B17VLvV9d1kKUoosu6C+pwOuTiLWD
         Td+J9Ado69q4XacHCkrrrQ2qjBVn6Slm8XkOpz6YQuvOTJlV86S86wLkwV4e8CpaTY
         Yexm6ioOAeT9ZkjqGkWpFN2ht31c51Hyd5U5XfT0=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>
Cc:     Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334 switch
Date:   Tue, 13 Apr 2021 16:45:57 +0200
Message-Id: <1618325157-5774-1-git-send-email-michal.vokac@ysoft.com>
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

