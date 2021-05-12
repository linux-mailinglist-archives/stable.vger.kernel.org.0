Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8136537C934
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbhELQPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234926AbhELQIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4185361C63;
        Wed, 12 May 2021 15:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833962;
        bh=caOxPsbfonQftADl/7vtEo8tGVXxxbcHE7qdHZYQ6yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=We17Mm3fZ0Fpy6fNpNhHLWruOyJSDzvJ5zUfWnkk3sTidOIiUdeAyg6dJzxSeu6iS
         WcOgXxl5GFnz3WzlVn+Pro8efgVi9imF3lPjVASP1Sc6EKM/M/dbRJLTJEVUWA57m7
         FV+xMGpR4nu68bCaNxP5qoxYp7sJkaey7ZAgAb0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 356/601] clk: zynqmp: move zynqmp_pll_set_mode out of round_rate callback
Date:   Wed, 12 May 2021 16:47:13 +0200
Message-Id: <20210512144839.521039450@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit d7fd3f9f53df8bb2212dff70f66f12cae0e1a653 ]

The round_rate callback should only perform rate calculation and not
involve calling zynqmp_pll_set_mode to change the pll mode. So let's
move zynqmp_pll_set_mode out of round_rate and to set_rate callback.

Fixes: 3fde0e16d016 ("drivers: clk: Add ZynqMP clock driver")
Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Link: https://lore.kernel.org/r/20210406154015.602779-1-quanyang.wang@windriver.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/pll.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/zynqmp/pll.c b/drivers/clk/zynqmp/pll.c
index 92f449ed38e5..03bfe62c1e62 100644
--- a/drivers/clk/zynqmp/pll.c
+++ b/drivers/clk/zynqmp/pll.c
@@ -100,9 +100,7 @@ static long zynqmp_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 	/* Enable the fractional mode if needed */
 	rate_div = (rate * FRAC_DIV) / *prate;
 	f = rate_div % FRAC_DIV;
-	zynqmp_pll_set_mode(hw, !!f);
-
-	if (zynqmp_pll_get_mode(hw) == PLL_MODE_FRAC) {
+	if (f) {
 		if (rate > PS_PLL_VCO_MAX) {
 			fbdiv = rate / PS_PLL_VCO_MAX;
 			rate = rate / (fbdiv + 1);
@@ -173,10 +171,12 @@ static int zynqmp_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	long rate_div, frac, m, f;
 	int ret;
 
-	if (zynqmp_pll_get_mode(hw) == PLL_MODE_FRAC) {
-		rate_div = (rate * FRAC_DIV) / parent_rate;
+	rate_div = (rate * FRAC_DIV) / parent_rate;
+	f = rate_div % FRAC_DIV;
+	zynqmp_pll_set_mode(hw, !!f);
+
+	if (f) {
 		m = rate_div / FRAC_DIV;
-		f = rate_div % FRAC_DIV;
 		m = clamp_t(u32, m, (PLL_FBDIV_MIN), (PLL_FBDIV_MAX));
 		rate = parent_rate * m;
 		frac = (parent_rate * f) / FRAC_DIV;
-- 
2.30.2



