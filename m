Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B654D6215B5
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbiKHOO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiKHOOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:14:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4615FAB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:14:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03AE6615B2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B40C433C1;
        Tue,  8 Nov 2022 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916857;
        bh=iPwgpQId2kMAahd0kA5A2kxOKhjE7gZJwnxKIkVTc04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBBGLCOYEq3FYdUn1tlur5Hdsc77xCROem8gD2LUrrraWMCOAEWBOeCRH7VLV3QPF
         qnBVk4rI53pFFB9EJdcJenQIJ1aRbA5b5rkM/s1AXumtz5zXg/2F3t6Rya2jZ3XlhG
         t4NHbWnO2Tf+2VPQT0JfXb0pJfsmKDdmgCUzTxU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 126/197] clk: renesas: r8a779g0: Add SASYNCPER clocks
Date:   Tue,  8 Nov 2022 14:39:24 +0100
Message-Id: <20221108133400.701156799@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ba5284ebe497044f37c9bb9c7b1564932f4b6610 ]

On R-Car V4H, all PLLs except PLL5 support Spread Spectrum and/or
Fractional Multiplication to reduce electromagnetic interference.

Add the SASYNCPER and SASYNCPERD[124] clocks, which are used as clock
sources for modules that must not be affected by Spread Spectrum and/or
Fractional Multiplication.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/d0f35c35e1f96c5a649ab477e7ba5d8025957cd0.1665147497.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779g0-cpg-mssr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/renesas/r8a779g0-cpg-mssr.c b/drivers/clk/renesas/r8a779g0-cpg-mssr.c
index c9c59c6f7139..7beb0e3b1872 100644
--- a/drivers/clk/renesas/r8a779g0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779g0-cpg-mssr.c
@@ -47,6 +47,7 @@ enum clk_ids {
 	CLK_S0_VIO,
 	CLK_S0_VC,
 	CLK_S0_HSC,
+	CLK_SASYNCPER,
 	CLK_SV_VIP,
 	CLK_SV_IR,
 	CLK_SDSRC,
@@ -84,6 +85,7 @@ static const struct cpg_core_clk r8a779g0_core_clks[] __initconst = {
 	DEF_FIXED(".s0_vio",	CLK_S0_VIO,	CLK_PLL1_DIV2,	2, 1),
 	DEF_FIXED(".s0_vc",	CLK_S0_VC,	CLK_PLL1_DIV2,	2, 1),
 	DEF_FIXED(".s0_hsc",	CLK_S0_HSC,	CLK_PLL1_DIV2,	2, 1),
+	DEF_FIXED(".sasyncper",	CLK_SASYNCPER,	CLK_PLL5_DIV4,	3, 1),
 	DEF_FIXED(".sv_vip",	CLK_SV_VIP,	CLK_PLL1,	5, 1),
 	DEF_FIXED(".sv_ir",	CLK_SV_IR,	CLK_PLL1,	5, 1),
 	DEF_BASE(".sdsrc",	CLK_SDSRC,	CLK_TYPE_GEN4_SDSRC, CLK_PLL5),
@@ -128,6 +130,9 @@ static const struct cpg_core_clk r8a779g0_core_clks[] __initconst = {
 	DEF_FIXED("s0d4_hsc",	R8A779G0_CLK_S0D4_HSC,	CLK_S0_HSC,	4, 1),
 	DEF_FIXED("cl16m_hsc",	R8A779G0_CLK_CL16M_HSC,	CLK_S0_HSC,	48, 1),
 	DEF_FIXED("s0d2_cc",	R8A779G0_CLK_S0D2_CC,	CLK_S0,		2, 1),
+	DEF_FIXED("sasyncperd1",R8A779G0_CLK_SASYNCPERD1, CLK_SASYNCPER,1, 1),
+	DEF_FIXED("sasyncperd2",R8A779G0_CLK_SASYNCPERD2, CLK_SASYNCPER,2, 1),
+	DEF_FIXED("sasyncperd4",R8A779G0_CLK_SASYNCPERD4, CLK_SASYNCPER,4, 1),
 	DEF_FIXED("svd1_ir",	R8A779G0_CLK_SVD1_IR,	CLK_SV_IR,	1, 1),
 	DEF_FIXED("svd2_ir",	R8A779G0_CLK_SVD2_IR,	CLK_SV_IR,	2, 1),
 	DEF_FIXED("svd1_vip",	R8A779G0_CLK_SVD1_VIP,	CLK_SV_VIP,	1, 1),
-- 
2.35.1



