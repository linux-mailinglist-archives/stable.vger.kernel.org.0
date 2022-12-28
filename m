Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4728C657C70
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiL1Pc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbiL1Pcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:32:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDDB15F0A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:32:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A9D5B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856AEC433D2;
        Wed, 28 Dec 2022 15:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241543;
        bh=vq/GNhPCQ1t1QBGROyBX1JQNozTtv/RuPQIlVEsUJWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/3iOxAcP6vklwOrVCW9/fCHX0IrnKSl8KWgzbcaQ4Ln4n7eo7gUFHNi81BcxrDDQ
         yk2PcjXd9GRLbqMaGfrd7b+/5gNc43Dy/FkfuF5wvBxrCWjx+iBrvd/POwTVXrH6eS
         1nTywcWrkL+ogeoVjk5ELsiRkifAXfsinIo2nTwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0296/1073] clk: renesas: r8a779f0: Fix HSCIF parent clocks
Date:   Wed, 28 Dec 2022 15:31:24 +0100
Message-Id: <20221228144336.053780100@linuxfoundation.org>
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

[ Upstream commit c258e3ab639112d8f5ae9df9a873750ae2623ce2 ]

As serial communication requires a clean clock signal, the High Speed
Serial Communication Interfaces with FIFO (HSCIF) are clocked by a clock
that is not affected by Spread Spectrum or Fractional Multiplication.

Hence change the parent clocks for the HSCIF modules from the S0D3_PER
clock to the SASYNCPERD1 clock (which has the same clock rate), cfr.
R-Car S4-8 Hardware User's Manual rev. 0.81.

Fixes: 080bcd8d5997 ("clk: renesas: r8a779f0: Add HSCIF clocks")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20221103143440.46449-2-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779f0-cpg-mssr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/renesas/r8a779f0-cpg-mssr.c b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
index cd80b6084ece..90cac3f8b2ed 100644
--- a/drivers/clk/renesas/r8a779f0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
@@ -120,10 +120,10 @@ static const struct cpg_core_clk r8a779f0_core_clks[] __initconst = {
 };
 
 static const struct mssr_mod_clk r8a779f0_mod_clks[] __initconst = {
-	DEF_MOD("hscif0",	514,	R8A779F0_CLK_S0D3),
-	DEF_MOD("hscif1",	515,	R8A779F0_CLK_S0D3),
-	DEF_MOD("hscif2",	516,	R8A779F0_CLK_S0D3),
-	DEF_MOD("hscif3",	517,	R8A779F0_CLK_S0D3),
+	DEF_MOD("hscif0",	514,	R8A779F0_CLK_SASYNCPERD1),
+	DEF_MOD("hscif1",	515,	R8A779F0_CLK_SASYNCPERD1),
+	DEF_MOD("hscif2",	516,	R8A779F0_CLK_SASYNCPERD1),
+	DEF_MOD("hscif3",	517,	R8A779F0_CLK_SASYNCPERD1),
 	DEF_MOD("i2c0",		518,	R8A779F0_CLK_S0D6_PER),
 	DEF_MOD("i2c1",		519,	R8A779F0_CLK_S0D6_PER),
 	DEF_MOD("i2c2",		520,	R8A779F0_CLK_S0D6_PER),
-- 
2.35.1



