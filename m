Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30A1657C73
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiL1Pc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbiL1Pce (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:32:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13B915F1D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:32:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C5F361553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D69CC433EF;
        Wed, 28 Dec 2022 15:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241551;
        bh=qTmgKyPShOgg+gT/dnV3qY/Twr1ZaxTcWID7DRnbNOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgDxBYbiIilD4dLTw3OGb0RbIXfZWbZTlpR61ekY+ZywnmbIEmo4DFRJsvPmNrtXu
         9SAll1R0Y1a54m3zB4rQxYbvyJq5L3smC35o0WoatpVhokz6jyVlWj9hNx89KNdQkx
         UMzNEcll93y7duqIfmMzUWz2+BoloXCGCUxJ+Xhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0297/1073] clk: renesas: r8a779f0: Fix SCIF parent clocks
Date:   Wed, 28 Dec 2022 15:31:25 +0100
Message-Id: <20221228144336.080239886@linuxfoundation.org>
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
index 90cac3f8b2ed..b7936f422c27 100644
--- a/drivers/clk/renesas/r8a779f0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
@@ -132,10 +132,10 @@ static const struct mssr_mod_clk r8a779f0_mod_clks[] __initconst = {
 	DEF_MOD("i2c5",		523,	R8A779F0_CLK_S0D6_PER),
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



