Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D5C15EE5B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389888AbgBNQER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389885AbgBNQER (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF68624676;
        Fri, 14 Feb 2020 16:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696256;
        bh=JDVA4kPHn3/WHslHxrVCCMC6R0vLzrDqSzqYuvBaUyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCFrBV7Kv2Frw2YVmk/hYHUMKOMj5oOunGk4eo7kdyTP+omIv+WVoPGS5i1Ck1kPP
         HtbbjJN2pm7E17G2dMD0qX6yyTQn8bZ+lHXv4yx0YZBcf9yqVaM0y1m58aEITV8HdY
         KKxlU+/jlTsSS34PtWEfqWbNY9r9G66euhOdTYWk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <sboyd@kernel.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 111/459] clk: qcom: Don't overwrite 'cfg' in clk_rcg2_dfs_populate_freq()
Date:   Fri, 14 Feb 2020 10:56:01 -0500
Message-Id: <20200214160149.11681-111-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 21e157c62eeded8b1558a991b4820b761d48a730 ]

The DFS frequency table logic overwrites 'cfg' while detecting the
parent clk and then later on in clk_rcg2_dfs_populate_freq() we use that
same variable to figure out the mode of the clk, either MND or not. Add
a new variable to hold the parent clk bit so that 'cfg' is left
untouched for use later.

This fixes problems in detecting the supported frequencies for any clks
in DFS mode.

Fixes: cc4f6944d0e3 ("clk: qcom: Add support for RCG to register for DFS")
Reported-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20200128193329.45635-1-sboyd@kernel.org
Tested-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 5a89ed88cc27a..5174222cbfab2 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -952,7 +952,7 @@ static void clk_rcg2_dfs_populate_freq(struct clk_hw *hw, unsigned int l,
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 	struct clk_hw *p;
 	unsigned long prate = 0;
-	u32 val, mask, cfg, mode;
+	u32 val, mask, cfg, mode, src;
 	int i, num_parents;
 
 	regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + SE_PERF_DFSR(l), &cfg);
@@ -962,12 +962,12 @@ static void clk_rcg2_dfs_populate_freq(struct clk_hw *hw, unsigned int l,
 	if (cfg & mask)
 		f->pre_div = cfg & mask;
 
-	cfg &= CFG_SRC_SEL_MASK;
-	cfg >>= CFG_SRC_SEL_SHIFT;
+	src = cfg & CFG_SRC_SEL_MASK;
+	src >>= CFG_SRC_SEL_SHIFT;
 
 	num_parents = clk_hw_get_num_parents(hw);
 	for (i = 0; i < num_parents; i++) {
-		if (cfg == rcg->parent_map[i].cfg) {
+		if (src == rcg->parent_map[i].cfg) {
 			f->src = rcg->parent_map[i].src;
 			p = clk_hw_get_parent_by_index(&rcg->clkr.hw, i);
 			prate = clk_hw_get_rate(p);
-- 
2.20.1

