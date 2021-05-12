Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9138137C524
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhELPiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235465AbhELP3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:29:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F4FE61940;
        Wed, 12 May 2021 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832537;
        bh=caOxPsbfonQftADl/7vtEo8tGVXxxbcHE7qdHZYQ6yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhCJC4GOF00p0pfh2SaI9N5N69wuPyDeB8bU1qmCD0aDy5SGzagcRqD8iU+JCsiaS
         TnSuR7yjNykE+hVN0YINU5jU4S3aAgACiV5dsNrvKKexATBfcKsoqhNYqemJ3dVg4M
         mSSGC156JvTNYElbxnCCg87qlfqVz0UY7yKpK+5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/530] clk: zynqmp: move zynqmp_pll_set_mode out of round_rate callback
Date:   Wed, 12 May 2021 16:47:10 +0200
Message-Id: <20210512144830.326467678@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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



