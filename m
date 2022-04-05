Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0944F308B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241713AbiDEIfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239392AbiDEIUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216FBC4E03;
        Tue,  5 Apr 2022 01:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09A760B0E;
        Tue,  5 Apr 2022 08:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD124C385A0;
        Tue,  5 Apr 2022 08:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146336;
        bh=mmZ2Jvn5IljWceAQxbq/am6ExJcO/DLxJptcZiszCck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b77YDsQRImN3TueRKprczzLFxQHTRS6oJR5rk5vxa9b7nZ4zUDm68FVT+iLZKJ6w5
         HDLAOHRegqf404kxM1GEse7VddlGnRQA2skcpCwl1EHlIWh/ojtsN92c0EloW+6a9a
         qb6zTVNTUNOCpaw7/UDNRPKi9ZW0kvzs9yttKYrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0728/1126] clk: renesas: r8a779f0: Fix RSW2 clock divider
Date:   Tue,  5 Apr 2022 09:24:35 +0200
Message-Id: <20220405070428.960190253@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 691419f90f7fb8a6f247b477cb539644e11431da ]

According to Section 8.1.2 Figure 8.1.1 ("Block Diagram of CPG"), Note
22 ("RSW2 divider"), and Table 8.1.4d ("Lists of CPG clocks generated
from CPGMA1"), the RSwitch2 and PCI Express clock is generated from PLL5
by dividing by two, followed by the RSW2 divider.  As PLL5 runs at 3200
MHz, and RSW2 is fixed to 320 MHz, the RSW2 divider must be 5.

Correct the parent and the fixed divider.

Fixes: 24aaff6a6ce4c4de ("clk: renesas: cpg-mssr: Add support for R-Car S4-8")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/d6a406f31e6f02f892e0253f4e8a9a2f68fd652e.1641566003.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779f0-cpg-mssr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/r8a779f0-cpg-mssr.c b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
index e6ec02c2c2a8..344957d533d8 100644
--- a/drivers/clk/renesas/r8a779f0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
@@ -103,7 +103,7 @@ static const struct cpg_core_clk r8a779f0_core_clks[] __initconst = {
 	DEF_FIXED("s0d12_hsc",	R8A779F0_CLK_S0D12_HSC,	CLK_S0,		12, 1),
 	DEF_FIXED("cl16m_hsc",	R8A779F0_CLK_CL16M_HSC,	CLK_S0,		48, 1),
 	DEF_FIXED("s0d2_cc",	R8A779F0_CLK_S0D2_CC,	CLK_S0,		2, 1),
-	DEF_FIXED("rsw2",	R8A779F0_CLK_RSW2,	CLK_PLL5,	2, 1),
+	DEF_FIXED("rsw2",	R8A779F0_CLK_RSW2,	CLK_PLL5_DIV2,	5, 1),
 	DEF_FIXED("cbfusa",	R8A779F0_CLK_CBFUSA,	CLK_EXTAL,	2, 1),
 	DEF_FIXED("cpex",	R8A779F0_CLK_CPEX,	CLK_EXTAL,	2, 1),
 
-- 
2.34.1



