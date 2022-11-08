Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19EFE621589
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbiKHONC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiKHOMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B855257B4E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:12:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2E24615B2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BF4C433C1;
        Tue,  8 Nov 2022 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916758;
        bh=Ibt0SZ8FFXftkZUueDEBBfZ4Gc5X+0ePSCcr3bV5Ft0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sC9UjFFiIKbRYXkRtA4IuiMFlQaAngwVtilO3FhQOuLkiz/QY8tj5DwFm59VSqoNP
         pEs3hf39+7hGjVkA/qUFezhMsrxnvPYhkZrVCQ2MVofIZ/WVSB1+wPpMQJwJ67cHxZ
         RqHZNM+UpiuCbQ7efzai5dMIE3yyQ+6FT1lKDltY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 095/197] clk: renesas: r8a779g0: Fix HSCIF parent clocks
Date:   Tue,  8 Nov 2022 14:38:53 +0100
Message-Id: <20221108133359.176536804@linuxfoundation.org>
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

[ Upstream commit a9003f74f5a2f487e101f3aa1dd5c3d3a78c6999 ]

As serial communication requires a clean clock signal, the High Speed
Serial Communication Interfaces with FIFO (HSCIF) is clocked by a clock
that is not affected by Spread Spectrum or Fractional Multiplication.

Hence change the parent clocks for the HSCIF modules from the S0D3_PER
clock to the SASYNCPERD1 clock (which has the same clock rate), cfr.
R-Car V4H Hardware User's Manual rev. 0.54.

Fixes: 0ab55cf1834177a2 ("clk: renesas: cpg-mssr: Add support for R-Car V4H")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/b7928abc8b9f53d5b06ec8624342f449de3d24ec.1665147497.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779g0-cpg-mssr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/renesas/r8a779g0-cpg-mssr.c b/drivers/clk/renesas/r8a779g0-cpg-mssr.c
index 3fc4233b1ead..c9c59c6f7139 100644
--- a/drivers/clk/renesas/r8a779g0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779g0-cpg-mssr.c
@@ -150,10 +150,10 @@ static const struct cpg_core_clk r8a779g0_core_clks[] __initconst = {
 };
 
 static const struct mssr_mod_clk r8a779g0_mod_clks[] __initconst = {
-	DEF_MOD("hscif0",	514,	R8A779G0_CLK_S0D3_PER),
-	DEF_MOD("hscif1",	515,	R8A779G0_CLK_S0D3_PER),
-	DEF_MOD("hscif2",	516,	R8A779G0_CLK_S0D3_PER),
-	DEF_MOD("hscif3",	517,	R8A779G0_CLK_S0D3_PER),
+	DEF_MOD("hscif0",	514,	R8A779G0_CLK_SASYNCPERD1),
+	DEF_MOD("hscif1",	515,	R8A779G0_CLK_SASYNCPERD1),
+	DEF_MOD("hscif2",	516,	R8A779G0_CLK_SASYNCPERD1),
+	DEF_MOD("hscif3",	517,	R8A779G0_CLK_SASYNCPERD1),
 };
 
 /*
-- 
2.35.1



