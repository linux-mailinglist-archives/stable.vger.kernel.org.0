Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15ED54F27BB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbiDEIIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235572AbiDEH7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F46A40E7B;
        Tue,  5 Apr 2022 00:55:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52999B81B90;
        Tue,  5 Apr 2022 07:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DEDC3410F;
        Tue,  5 Apr 2022 07:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145342;
        bh=3lJ3J/Hn5KmINnLVJmAiRUoqx4L93qq6dyLbb8I1oE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afjn+/O7YrBHlvPNrGb25wZz48olqEbzzpwdzS/8PuXsST4sL8YIfCYLrdsF8gZ3L
         TzNjW9LoPkf5VRTezh+KFTDAu9ua++KgtXKk+gNi7TegKFXEZ5jogh2N8gEVNzPYkh
         1FiX+SIbqIFZJlnswLIIjRmIoRebd1xSqKlo9ztg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0343/1126] ARM: dts: sun8i: v3s: Move the csi1 block to follow address order
Date:   Tue,  5 Apr 2022 09:18:10 +0200
Message-Id: <20220405070417.683974050@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit c4af51698c4fb4fc683f2ac67f482cdf9ba2cd13 ]

The csi1 block node was mistakenly added before the gic node, although
its address comes after the gic's. Move the node to its correct
position.

Fixes: 90e048101fa1 ("ARM: dts: sun8i: V3/V3s/S3/S3L: add CSI1 device node")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220205185429.2278860-2-paul.kocialkowski@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-v3s.dtsi | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-v3s.dtsi b/arch/arm/boot/dts/sun8i-v3s.dtsi
index b30bc1a25ebb..084323d5c61c 100644
--- a/arch/arm/boot/dts/sun8i-v3s.dtsi
+++ b/arch/arm/boot/dts/sun8i-v3s.dtsi
@@ -593,6 +593,17 @@
 			#size-cells = <0>;
 		};
 
+		gic: interrupt-controller@1c81000 {
+			compatible = "arm,gic-400";
+			reg = <0x01c81000 0x1000>,
+			      <0x01c82000 0x2000>,
+			      <0x01c84000 0x2000>,
+			      <0x01c86000 0x2000>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
+		};
+
 		csi1: camera@1cb4000 {
 			compatible = "allwinner,sun8i-v3s-csi";
 			reg = <0x01cb4000 0x3000>;
@@ -604,16 +615,5 @@
 			resets = <&ccu RST_BUS_CSI>;
 			status = "disabled";
 		};
-
-		gic: interrupt-controller@1c81000 {
-			compatible = "arm,gic-400";
-			reg = <0x01c81000 0x1000>,
-			      <0x01c82000 0x2000>,
-			      <0x01c84000 0x2000>,
-			      <0x01c86000 0x2000>;
-			interrupt-controller;
-			#interrupt-cells = <3>;
-			interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
-		};
 	};
 };
-- 
2.34.1



