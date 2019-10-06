Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372BECD44C
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfJFRYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbfJFRYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:24:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F36A2217F9;
        Sun,  6 Oct 2019 17:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382659;
        bh=TkRXmpHdZvwNp4jqEj1dbBI2v217kXfJTlu2W7Axhqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7MN9z9cNIiXqwYMPvY3kPNKhwDc7l+F8U5phMeSYFTXLX7F1Xw/Lu12Bt2FMvfDc
         gS1YjIPu2wZ1wgNf9C2aUg5DMT/SrlO2kgKxOHdF+QhkBcDQ8pGTxcJYZ5rcgpbslr
         DTR/qLB77YipVixghTofypEIpLwHlhUtrqeQ1NIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Zeng <Guo.Zeng@csr.com>,
        Barry Song <Baohua.Song@csr.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/47] clk: sirf: Dont reference clk_init_data after registration
Date:   Sun,  6 Oct 2019 19:20:54 +0200
Message-Id: <20191006172017.276004519@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006172016.873463083@linuxfoundation.org>
References: <20191006172016.873463083@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit af55dadfbce35b4f4c6247244ce3e44b2e242b84 ]

A future patch is going to change semantics of clk_register() so that
clk_hw::init is guaranteed to be NULL after a clk is registered. Avoid
referencing this member here so that we don't run into NULL pointer
exceptions.

Cc: Guo Zeng <Guo.Zeng@csr.com>
Cc: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20190731193517.237136-6-sboyd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sirf/clk-common.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/sirf/clk-common.c b/drivers/clk/sirf/clk-common.c
index 77e1e2491689b..edb7197cc4b4d 100644
--- a/drivers/clk/sirf/clk-common.c
+++ b/drivers/clk/sirf/clk-common.c
@@ -298,9 +298,10 @@ static u8 dmn_clk_get_parent(struct clk_hw *hw)
 {
 	struct clk_dmn *clk = to_dmnclk(hw);
 	u32 cfg = clkc_readl(clk->regofs);
+	const char *name = clk_hw_get_name(hw);
 
 	/* parent of io domain can only be pll3 */
-	if (strcmp(hw->init->name, "io") == 0)
+	if (strcmp(name, "io") == 0)
 		return 4;
 
 	WARN_ON((cfg & (BIT(3) - 1)) > 4);
@@ -312,9 +313,10 @@ static int dmn_clk_set_parent(struct clk_hw *hw, u8 parent)
 {
 	struct clk_dmn *clk = to_dmnclk(hw);
 	u32 cfg = clkc_readl(clk->regofs);
+	const char *name = clk_hw_get_name(hw);
 
 	/* parent of io domain can only be pll3 */
-	if (strcmp(hw->init->name, "io") == 0)
+	if (strcmp(name, "io") == 0)
 		return -EINVAL;
 
 	cfg &= ~(BIT(3) - 1);
@@ -354,7 +356,8 @@ static long dmn_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 {
 	unsigned long fin;
 	unsigned ratio, wait, hold;
-	unsigned bits = (strcmp(hw->init->name, "mem") == 0) ? 3 : 4;
+	const char *name = clk_hw_get_name(hw);
+	unsigned bits = (strcmp(name, "mem") == 0) ? 3 : 4;
 
 	fin = *parent_rate;
 	ratio = fin / rate;
@@ -376,7 +379,8 @@ static int dmn_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_dmn *clk = to_dmnclk(hw);
 	unsigned long fin;
 	unsigned ratio, wait, hold, reg;
-	unsigned bits = (strcmp(hw->init->name, "mem") == 0) ? 3 : 4;
+	const char *name = clk_hw_get_name(hw);
+	unsigned bits = (strcmp(name, "mem") == 0) ? 3 : 4;
 
 	fin = parent_rate;
 	ratio = fin / rate;
-- 
2.20.1



