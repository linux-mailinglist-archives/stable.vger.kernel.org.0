Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C06CD5F8
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730937AbfJFRmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730875AbfJFRmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:42:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B246C2080F;
        Sun,  6 Oct 2019 17:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383730;
        bh=vNJVuAcZSGd4JfMJeT1HcCWqm+jXlfUf9xrhXZuLZQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qm0GdRRIC/cTkdWZzFHKvMCNb3Q6IS1hqkjXo79IXXChjQnib9/f5T2eFfcaPet8a
         j1tOBFnMnVsDD7xn6n13kjUuth+Ys6o2QkhkaktjMl0mcdYJLCnfOt5KIa/nlpBb6j
         tRvJlEWQMdHY1SvpTDCQ1QYFKVRj2e8sX7z05ed0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 073/166] clk: imx: clk-pll14xx: unbypass PLL by default
Date:   Sun,  6 Oct 2019 19:20:39 +0200
Message-Id: <20191006171219.574571166@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit a9aa8306074d9519dd6e5fdf07240b01bac72e04 ]

When registering the PLL, unbypass the PLL.
The PLL has two bypass control bit, BYPASS and EXT_BYPASS.
we will expose EXT_BYPASS to clk driver for mux usage, and keep
BYPASS inside pll14xx usage. The PLL has a restriction that
when M/P change, need to RESET/BYPASS pll to avoid glitch, so
we could not expose BYPASS.

To make it easy for clk driver usage, unbypass PLL which does
not hurt current function.

Fixes: 8646d4dcc7fb ("clk: imx: Add PLLs driver for imx8mm soc")
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lkml.kernel.org/r/1568043491-20680-3-git-send-email-peng.fan@nxp.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-pll14xx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/imx/clk-pll14xx.c b/drivers/clk/imx/clk-pll14xx.c
index 656f48b002dd3..7a815ec76aa5c 100644
--- a/drivers/clk/imx/clk-pll14xx.c
+++ b/drivers/clk/imx/clk-pll14xx.c
@@ -368,6 +368,7 @@ struct clk *imx_clk_pll14xx(const char *name, const char *parent_name,
 	struct clk_pll14xx *pll;
 	struct clk *clk;
 	struct clk_init_data init;
+	u32 val;
 
 	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
 	if (!pll)
@@ -399,6 +400,10 @@ struct clk *imx_clk_pll14xx(const char *name, const char *parent_name,
 	pll->rate_table = pll_clk->rate_table;
 	pll->rate_count = pll_clk->rate_count;
 
+	val = readl_relaxed(pll->base + GNRL_CTL);
+	val &= ~BYPASS_MASK;
+	writel_relaxed(val, pll->base + GNRL_CTL);
+
 	clk = clk_register(NULL, &pll->hw);
 	if (IS_ERR(clk)) {
 		pr_err("%s: failed to register pll %s %lu\n",
-- 
2.20.1



