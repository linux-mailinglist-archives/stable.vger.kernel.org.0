Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA777657D09
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiL1Pin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbiL1Pim (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:38:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26620165AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:38:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B631E61553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8853C433EF;
        Wed, 28 Dec 2022 15:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241921;
        bh=1yS5ZiO4I4cvZ+6wIElHWtR1ssr18Zd8PCaPJOAdhHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvD8+LAvb+NkFwQdoq528oCmH88JUlRlPCYgfV9R5uUlZH6IqcL1DXHOisyMrZ/WJ
         x494DolQjSE/xeqWPYjadMCK6x0qF9WgXw26Puju/sl4xMrEmOKbZTOOQ9X5gA5WTf
         3ytl4uO8YwC5VRLVMd8inFhsi9biQMd/4DFGITKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0305/1146] clk: renesas: r8a779f0: Fix SCIF parent clocks
Date:   Wed, 28 Dec 2022 15:30:44 +0100
Message-Id: <20221228144338.438355345@linuxfoundation.org>
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

[ Upstream commit 2e0d7d3eabce3babae1fd66d7650e00c848a3b45 ]

As serial communication requires a clean clock signal, the Serial
Communication Interfaces with FIFO (SCIF) are clocked by a clock that is
not affected by Spread Spectrum or Fractional Multiplication.

Hence change the parent clocks for the SCIF modules from the S0D12_PER
clock to the SASYNCPERD4 clock (which has the same clock rate), cfr.
R-Car S4-8 Hardware User's Manual rev. 0.81.

Fixes: 24aaff6a6ce4 ("clk: renesas: cpg-mssr: Add support for R-Car S4-8")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20221103143440.46449-3-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779f0-cpg-mssr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/renesas/r8a779f0-cpg-mssr.c b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
index f293a8a54fb2..27b668def357 100644
--- a/drivers/clk/renesas/r8a779f0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
@@ -142,10 +142,10 @@ static const struct mssr_mod_clk r8a779f0_mod_clks[] __initconst = {
 	DEF_MOD("msiof3",	621,	R8A779F0_CLK_MSO),
 	DEF_MOD("pcie0",	624,	R8A779F0_CLK_S0D2),
 	DEF_MOD("pcie1",	625,	R8A779F0_CLK_S0D2),
-	DEF_MOD("scif0",	702,	R8A779F0_CLK_S0D12_PER),
-	DEF_MOD("scif1",	703,	R8A779F0_CLK_S0D12_PER),
-	DEF_MOD("scif3",	704,	R8A779F0_CLK_S0D12_PER),
-	DEF_MOD("scif4",	705,	R8A779F0_CLK_S0D12_PER),
+	DEF_MOD("scif0",	702,	R8A779F0_CLK_SASYNCPERD4),
+	DEF_MOD("scif1",	703,	R8A779F0_CLK_SASYNCPERD4),
+	DEF_MOD("scif3",	704,	R8A779F0_CLK_SASYNCPERD4),
+	DEF_MOD("scif4",	705,	R8A779F0_CLK_SASYNCPERD4),
 	DEF_MOD("sdhi0",        706,    R8A779F0_CLK_SD0),
 	DEF_MOD("sys-dmac0",	709,	R8A779F0_CLK_S0D3_PER),
 	DEF_MOD("sys-dmac1",	710,	R8A779F0_CLK_S0D3_PER),
-- 
2.35.1



