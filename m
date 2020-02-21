Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AB81676AB
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbgBUIFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731261AbgBUIFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:05:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22EF824676;
        Fri, 21 Feb 2020 08:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272301;
        bh=JDVA4kPHn3/WHslHxrVCCMC6R0vLzrDqSzqYuvBaUyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+90EoNRAMY3YAFDYeVUO5UFsmR+pwB+B33+L/VgB1wOKKmS+yAgycJ1nuYRghM2i
         QJlpxYT60N5Ke3KbIwqKOmXeNapwwU7l9fr2+R1ddkycybyIkzLhJsdC9CgmvCXg/u
         wapWqw7biNqFCMOHkZddmJ9Ouwd9moARLitQhVi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/344] clk: qcom: Dont overwrite cfg in clk_rcg2_dfs_populate_freq()
Date:   Fri, 21 Feb 2020 08:38:10 +0100
Message-Id: <20200221072357.231206580@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



