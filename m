Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF62657923
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbiL1O6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbiL1O55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:57:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140FB10054
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:57:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D651B81716
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A72C433EF;
        Wed, 28 Dec 2022 14:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239469;
        bh=zdjZSvUlQos4Eexk/hd0ENgOFCCKp8WpgkAhKYnYH8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvQpdRqUZiqVapHWpweRN+HoEUDOrBFDHJH97PLTVTvgxuzBl/IXLOUBHRkGFY4+q
         0WTH4vNve25wii3QI0WxbdvKvYQzB0p4qbto8PaRTLdUGRIxV3WpmX4eWCz9x/eSRV
         ehVW0ONWZIy6CzVjdw4z14yfLQLKKBVsYlfRe0hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0008/1073] arm64: dts: renesas: r8a779g0: Fix HSCIF0 "brg_int" clock
Date:   Wed, 28 Dec 2022 15:26:36 +0100
Message-Id: <20221228144328.394527728@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a4290d407aa9fd174d8053878783d466d3124e38 ]

As serial communication requires a clock signal, the High Speed Serial
Communication Interfaces with FIFO (HSCIF) are clocked by a clock that
is not affected by Spread Spectrum or Fractional Multiplication.

Hence change the clock input for the HSCIF0 Baud Rate Generator internal
clock from the S0D3_PER clock to the SASYNCPERD1 clock (which has the
same clock rate), cfr. R-Car V4H Hardware User's Manual rev. 0.54.

Fixes: 987da486d84a5643 ("arm64: dts: renesas: Add Renesas R8A779G0 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/a5bd4148f92806f7c8e577d383370f810315f586.1665155947.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
index 1c15726cff8b..4bd3cb107b38 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
@@ -87,7 +87,7 @@ hscif0: serial@e6540000 {
 			reg = <0 0xe6540000 0 96>;
 			interrupts = <GIC_SPI 246 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 514>,
-				 <&cpg CPG_CORE R8A779G0_CLK_S0D3_PER>,
+				 <&cpg CPG_CORE R8A779G0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			power-domains = <&sysc R8A779G0_PD_ALWAYS_ON>;
-- 
2.35.1



