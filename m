Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8341462156F
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbiKHOMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiKHOL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:11:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC8056575
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDDB5615BF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1E7C433D7;
        Tue,  8 Nov 2022 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916690;
        bh=Dl2C7KGHu0hglCWFLVaeKmkhI5oTULAkVMFHqAcx4vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g3jR2XPlyd+8HlGlYzAZZAXTIEdPiJeU2OB7191cnQv/jlB4plc9IPx+NiFGKO7ay
         xXbg6WtXfreI3QSJ+vKfKE1xuzKRGtFGiDi3KntxyPtVs2GG2LaUbsS/S7HFg6OTDM
         14G0fftDbu/PpBMH8OvgXBAWceLNpjDX069KnCcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 103/197] arm64: dts: imx8: correct clock order
Date:   Tue,  8 Nov 2022 14:39:01 +0100
Message-Id: <20221108133359.544705409@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 06acb824d7d00a30e9400f67eee481b218371b5a ]

Per bindings/mmc/fsl-imx-esdhc.yaml, the clock order is ipg, ahb, per,
otherwise warning: "
mmc@5b020000: clock-names:1: 'ahb' was expected
mmc@5b020000: clock-names:2: 'per' was expected "

Fixes: 16c4ea7501b1 ("arm64: dts: imx8: switch to new lpcg clock binding")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/freescale/imx8-ss-conn.dtsi | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
index 82a1c4488378..10370d1a6c6d 100644
--- a/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
@@ -38,9 +38,9 @@ usdhc1: mmc@5b010000 {
 		interrupts = <GIC_SPI 232 IRQ_TYPE_LEVEL_HIGH>;
 		reg = <0x5b010000 0x10000>;
 		clocks = <&sdhc0_lpcg IMX_LPCG_CLK_4>,
-			 <&sdhc0_lpcg IMX_LPCG_CLK_5>,
-			 <&sdhc0_lpcg IMX_LPCG_CLK_0>;
-		clock-names = "ipg", "per", "ahb";
+			 <&sdhc0_lpcg IMX_LPCG_CLK_0>,
+			 <&sdhc0_lpcg IMX_LPCG_CLK_5>;
+		clock-names = "ipg", "ahb", "per";
 		power-domains = <&pd IMX_SC_R_SDHC_0>;
 		status = "disabled";
 	};
@@ -49,9 +49,9 @@ usdhc2: mmc@5b020000 {
 		interrupts = <GIC_SPI 233 IRQ_TYPE_LEVEL_HIGH>;
 		reg = <0x5b020000 0x10000>;
 		clocks = <&sdhc1_lpcg IMX_LPCG_CLK_4>,
-			 <&sdhc1_lpcg IMX_LPCG_CLK_5>,
-			 <&sdhc1_lpcg IMX_LPCG_CLK_0>;
-		clock-names = "ipg", "per", "ahb";
+			 <&sdhc1_lpcg IMX_LPCG_CLK_0>,
+			 <&sdhc1_lpcg IMX_LPCG_CLK_5>;
+		clock-names = "ipg", "ahb", "per";
 		power-domains = <&pd IMX_SC_R_SDHC_1>;
 		fsl,tuning-start-tap = <20>;
 		fsl,tuning-step = <2>;
@@ -62,9 +62,9 @@ usdhc3: mmc@5b030000 {
 		interrupts = <GIC_SPI 234 IRQ_TYPE_LEVEL_HIGH>;
 		reg = <0x5b030000 0x10000>;
 		clocks = <&sdhc2_lpcg IMX_LPCG_CLK_4>,
-			 <&sdhc2_lpcg IMX_LPCG_CLK_5>,
-			 <&sdhc2_lpcg IMX_LPCG_CLK_0>;
-		clock-names = "ipg", "per", "ahb";
+			 <&sdhc2_lpcg IMX_LPCG_CLK_0>,
+			 <&sdhc2_lpcg IMX_LPCG_CLK_5>;
+		clock-names = "ipg", "ahb", "per";
 		power-domains = <&pd IMX_SC_R_SDHC_2>;
 		status = "disabled";
 	};
-- 
2.35.1



