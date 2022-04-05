Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D3A4F3F9B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383527AbiDEMZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358773AbiDELRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 07:17:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F83DDFD52;
        Tue,  5 Apr 2022 03:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A61961562;
        Tue,  5 Apr 2022 10:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1692AC385A0;
        Tue,  5 Apr 2022 10:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153982;
        bh=ZfobBtkv0dNRmNXjqAgvo8TFqgxLcLeOrAxHVbstjGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIa4BU0/YVBgYATTyjtpGF/FWcodlJTH+LVSpRoJ/QrM4wbGuvkvsKoB2ucnbWf4u
         Nrd0VIRStkK6C1fyj/80y0GVPtS+Rq/aro/kVzt2Sm4OT/ykyZ1HYd3QvIXNYMPiAR
         I0uoxq1/0uWHk6af6CASmqkISICRWGTFB5P55Ms0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/599] staging: mt7621-dts: fix pinctrl properties for ethernet
Date:   Tue,  5 Apr 2022 09:31:50 +0200
Message-Id: <20220405070311.211992749@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit 0a93c0d75809582893e82039143591b9265b520e ]

Add pinctrl properties with rgmii1 & mdio pins under ethernet node which
was wrongfully put under an external phy node.
GMAC1 will start working with this fix.

Link: https://lore.kernel.org/netdev/02ecce91-7aad-4392-c9d7-f45ca1b31e0b@arinc9.com/T/

Move GB-PC2 specific phy_external node to its own device tree.

Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20220125153903.1469-5-arinc.unal@arinc9.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-dts/gbpc2.dts   | 16 +++++++++++-----
 drivers/staging/mt7621-dts/mt7621.dtsi | 13 +++----------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/mt7621-dts/gbpc2.dts b/drivers/staging/mt7621-dts/gbpc2.dts
index 52760e7351f6..f9b69091bfc0 100644
--- a/drivers/staging/mt7621-dts/gbpc2.dts
+++ b/drivers/staging/mt7621-dts/gbpc2.dts
@@ -12,10 +12,16 @@
 	function = "gpio";
 };
 
-&gmac1 {
-	status = "ok";
-};
+&ethernet {
+	gmac1: mac@1 {
+		status = "ok";
+		phy-handle = <&phy_external>;
+	};
 
-&phy_external {
-	status = "ok";
+	mdio-bus {
+		phy_external: ethernet-phy@5 {
+			reg = <5>;
+			phy-mode = "rgmii-rxid";
+		};
+	};
 };
diff --git a/drivers/staging/mt7621-dts/mt7621.dtsi b/drivers/staging/mt7621-dts/mt7621.dtsi
index 50f6d89f4673..51c0061daa37 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -412,6 +412,9 @@
 
 		mediatek,ethsys = <&ethsys>;
 
+		pinctrl-names = "default";
+		pinctrl-0 = <&rgmii1_pins &rgmii2_pins &mdio_pins>;
+
 		gmac0: mac@0 {
 			compatible = "mediatek,eth-mac";
 			reg = <0>;
@@ -429,22 +432,12 @@
 			reg = <1>;
 			status = "off";
 			phy-mode = "rgmii-rxid";
-			phy-handle = <&phy_external>;
 		};
 
 		mdio-bus {
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			phy_external: ethernet-phy@5 {
-				status = "off";
-				reg = <5>;
-				phy-mode = "rgmii-rxid";
-
-				pinctrl-names = "default";
-				pinctrl-0 = <&rgmii2_pins>;
-			};
-
 			switch0: switch0@0 {
 				compatible = "mediatek,mt7621";
 				#address-cells = <1>;
-- 
2.34.1



