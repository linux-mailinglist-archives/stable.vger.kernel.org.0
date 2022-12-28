Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1852657933
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiL1O66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiL1O6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:58:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C7D12AB6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:58:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F4826154E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34ED9C433D2;
        Wed, 28 Dec 2022 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239511;
        bh=uDdfqx5O5Q5TfBacudoEGk/8mff/sFtmbsh8WePEOic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KoMnNO75SKT78zKnxVV92EFSLiV4Ov6S7oiMPuwBNdtNcyDb15Ut1V6ZS1G/uQ+O6
         M0GyK6UC4hbk3a2p8X1cOzCIkabfSj9Yg+/mk5MMQrTC6T06XVGbAI1WPy2uf287mD
         GP47GwRMA7u+kbJ3GMdXGbBKV7HDbjksnx2nL9vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0044/1073] arm64: dts: renesas: r8a779f0: Fix SCIF "brg_int" clock
Date:   Wed, 28 Dec 2022 15:27:12 +0100
Message-Id: <20221228144329.320903346@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 64416ef0b0c4d73349035d1b3206eed3d2047ee0 ]

As serial communication requires a clean clock signal, the Serial
Communication Interfaces with FIFO (SCIF) are clocked by a clock that is
not affected by Spread Spectrum or Fractional Multiplication.

Hence change the clock input for the SCIF Baud Rate Generator internal
clock from the S0D3_PER clock to the SASYNCPERD1 clock (which has the
same clock rate), cfr. R-Car S4-8 Hardware User's Manual rev. 0.81.

Fixes: c62331e8222f ("arm64: dts: renesas: Add Renesas R8A779F0 SoC support")
Fixes: 40753144256b ("arm64: dts: renesas: r8a779f0: Add SCIF nodes")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20221103143440.46449-5-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
index 6ee5f0a54b13..d4f3ebfe841a 100644
--- a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
@@ -522,7 +522,7 @@ scif0: serial@e6e60000 {
 			reg = <0 0xe6e60000 0 64>;
 			interrupts = <GIC_SPI 249 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 702>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3_PER>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x51>, <&dmac0 0x50>,
@@ -539,7 +539,7 @@ scif1: serial@e6e68000 {
 			reg = <0 0xe6e68000 0 64>;
 			interrupts = <GIC_SPI 250 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 703>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3_PER>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x53>, <&dmac0 0x52>,
@@ -556,7 +556,7 @@ scif3: serial@e6c50000 {
 			reg = <0 0xe6c50000 0 64>;
 			interrupts = <GIC_SPI 252 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 704>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3_PER>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x57>, <&dmac0 0x56>,
@@ -573,7 +573,7 @@ scif4: serial@e6c40000 {
 			reg = <0 0xe6c40000 0 64>;
 			interrupts = <GIC_SPI 253 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 705>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3_PER>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x59>, <&dmac0 0x58>,
-- 
2.35.1



