Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE376AEDC7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbjCGSH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjCGSHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:07:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EF485379
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:00:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CFE46150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1F9C4339E;
        Tue,  7 Mar 2023 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212005;
        bh=K0PjAwaLIhioEy3O2E8Eo/dUpsnarRb9VXrWAQjoRZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+mQzxN6Sfb2+NYmlUTSiGaIOnqDtFNqGgDzUgMs6TVhBRpbt9PgJcm2kPT0bvwDA
         JhID9WNFPJBgIPQDfr2tpw7krnWNgCkfPTijmLsqrdMFCDWsP77JDQk/1Y6yPScd07
         8mEG1dgk1UREDMQAtbZjCrSNpBiRzBFTEUleSdCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/885] arm64: dts: mediatek: mt8192: Fix systimer 13 MHz clock description
Date:   Tue,  7 Mar 2023 17:49:10 +0100
Message-Id: <20230307170002.354085005@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit f19f68e56b0c6631984a9f5023035d4bd09612bb ]

The systimer block derives its 13 MHz clock by dividing the main 26 MHz
oscillator clock by 2 internally, not through the TOPCKGEN clock
controller.

On the MT8192 this divider is fixed to /2 and is not configurable.

Making the systimer block take the 26 MHz clock directly requires
changing the implementations. As an ABI compatible fix, change the
input clock of the systimer block a fixed factor divide-by-2 clock
that takes the 26 MHz oscillator as its input.

Fixes: 48489980e27e ("arm64: dts: Add Mediatek SoC MT8192 and evaluation board dts and Makefile")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221201084229.3464449-3-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index 6b20376191a75..8163684a23f6e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -29,6 +29,15 @@ aliases {
 		rdma4 = &rdma4;
 	};
 
+	clk13m: fixed-factor-clock-13m {
+		compatible = "fixed-factor-clock";
+		#clock-cells = <0>;
+		clocks = <&clk26m>;
+		clock-div = <2>;
+		clock-mult = <1>;
+		clock-output-names = "clk13m";
+	};
+
 	clk26m: oscillator0 {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
@@ -531,8 +540,7 @@ systimer: timer@10017000 {
 				     "mediatek,mt6765-timer";
 			reg = <0 0x10017000 0 0x1000>;
 			interrupts = <GIC_SPI 233 IRQ_TYPE_LEVEL_HIGH 0>;
-			clocks = <&topckgen CLK_TOP_CSW_F26M_D2>;
-			clock-names = "clk13m";
+			clocks = <&clk13m>;
 		};
 
 		pwrap: pwrap@10026000 {
-- 
2.39.2



