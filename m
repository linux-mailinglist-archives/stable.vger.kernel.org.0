Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BCE4F327D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350377AbiDEJ5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343980AbiDEJQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD79C7B;
        Tue,  5 Apr 2022 02:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62D71B818F3;
        Tue,  5 Apr 2022 09:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A9DC385A1;
        Tue,  5 Apr 2022 09:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149382;
        bh=HJdEqjir6i4ZoPfHna7exWzCgYiLB24dyPugU8scUp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cY05PNdQ3VNlhMz8MLEP2pFRU6Mdi2vtKS5QQ1MSZ/zeIbRmlFOIKRdla7Ak03A7g
         iX06Ok3soOXLc4tRvCLbotyCipkS+PqpkQ6BAJZzOld9/YEKOwZyw6UeelwDt/rS5T
         RltH9rcSxZBFTl1cXB7Xi7ZhGe8r2WMt9K8eVinM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0694/1017] staging: mt7621-dts: fix pinctrl properties for ethernet
Date:   Tue,  5 Apr 2022 09:26:47 +0200
Message-Id: <20220405070414.873195068@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 6fe603c7711d..03d6bb6735ac 100644
--- a/drivers/staging/mt7621-dts/gbpc2.dts
+++ b/drivers/staging/mt7621-dts/gbpc2.dts
@@ -13,10 +13,16 @@
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
index 25687f4fa671..7b75e4a92b2a 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -363,6 +363,9 @@
 
 		mediatek,ethsys = <&sysc>;
 
+		pinctrl-names = "default";
+		pinctrl-0 = <&rgmii1_pins &rgmii2_pins &mdio_pins>;
+
 		gmac0: mac@0 {
 			compatible = "mediatek,eth-mac";
 			reg = <0>;
@@ -380,22 +383,12 @@
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



