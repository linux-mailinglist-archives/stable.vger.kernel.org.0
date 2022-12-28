Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CA657998
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiL1PDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiL1PCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9737C12AD0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:02:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46F9DB8171A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8E6C433D2;
        Wed, 28 Dec 2022 15:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239762;
        bh=QKQhX1psIxlBPogiPxu1D8wYuaKcSXNfACdGTVtWaj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeI+XCJgYryYkpmcWQE9xj1qPAGA2jxKZeBs5YzGavAtC/z51vGWzIHw/qIJBzF7m
         MiMsakJkrE+G3o27MaUM8aRKXvZABRvd0klZuIyG4s3tGnuikXg+1Oc+dRstlwk3ZY
         DIW8JcRNVW/ElSZRbNOzIN8ejQA50ByKDTDB1szM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0040/1146] arm64: dts: renesas: r8a779f0: Fix HSCIF "brg_int" clock
Date:   Wed, 28 Dec 2022 15:26:19 +0100
Message-Id: <20221228144331.253240084@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit a5101ef18b4d0751588f61d939694bad183cc240 ]

As serial communication requires a clean clock signal, the High Speed
Serial Communication Interfaces with FIFO (HSCIF) are clocked by a clock
that is not affected by Spread Spectrum or Fractional Multiplication.

Hence change the clock input for the HSCIF Baud Rate Generator internal
clock from the S0D3_PER clock to the SASYNCPERD1 clock (which has the
same clock rate), cfr. R-Car S4-8 Hardware User's Manual rev. 0.81.

Fixes: 01a787f78bfd ("arm64: dts: renesas: r8a779f0: Add HSCIF nodes")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20221103143440.46449-4-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
index c2f152bcf10e..3be577dc9a93 100644
--- a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
@@ -577,7 +577,7 @@ hscif0: serial@e6540000 {
 			reg = <0 0xe6540000 0 0x60>;
 			interrupts = <GIC_SPI 245 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 514>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x31>, <&dmac0 0x30>,
@@ -594,7 +594,7 @@ hscif1: serial@e6550000 {
 			reg = <0 0xe6550000 0 0x60>;
 			interrupts = <GIC_SPI 246 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 515>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x33>, <&dmac0 0x32>,
@@ -611,7 +611,7 @@ hscif2: serial@e6560000 {
 			reg = <0 0xe6560000 0 0x60>;
 			interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 516>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x35>, <&dmac0 0x34>,
@@ -628,7 +628,7 @@ hscif3: serial@e66a0000 {
 			reg = <0 0xe66a0000 0 0x60>;
 			interrupts = <GIC_SPI 248 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 517>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x37>, <&dmac0 0x36>,
-- 
2.35.1



