Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E99406284
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhIJAp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233831AbhIJAVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D6E610A3;
        Fri, 10 Sep 2021 00:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233241;
        bh=UeNb57tKzwWRAwXejt0MpMewHQPDGOuLS/1eXFaB9G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsX+qOKPynB4VpqK+8lJpwyUc7EDDgutRshu1AjE3COPg6tv3ftejwXipQBA+x2vE
         6j/qsGG/m5ILTnhGgBwe8E5g7KtPbNejaWXF5R8C5a4b4W+mYjkcbCR1m0GWyi0TlO
         ciNIfdL2oD59YTSNoqbvznECKCA3AK8DzHHG5RtEYFhPw9/wMnKJsxdf9c53uF8126
         MrXfDFN82E58Az3Lsu5fUMznTZAAIryPeBN9rDI/UBMV6My5viFrldD9cvL246iVqD
         uN8cpQDgTbXAbXhEdWjPh4h7yVPjsQENp0b50v5cPRkHzprk3eSNdLKsGyv6osQJd4
         U5cTd+Qaj1zIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chun-Jie Chen <chun-jie.chen@mediatek.com>,
        Ikjoon Jang <ikjn@chromium.org>,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 09/53] clk: mediatek: Fix asymmetrical PLL enable and disable control
Date:   Thu,  9 Sep 2021 20:19:44 -0400
Message-Id: <20210910002028.175174-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chun-Jie Chen <chun-jie.chen@mediatek.com>

[ Upstream commit 7cc4e1bbe300c5cf610ece8eca6c6751b8bc74db ]

In fact, the en_mask is a combination of divider enable mask
and pll enable bit(bit0).
Before this patch, we enabled both divider mask and bit0 in prepare(),
but only cleared the bit0 in unprepare().
In the future, we hope en_mask will only be used as divider enable mask.
The enable register(CON0) will be set in 2 steps:
first is divider mask, and then bit0 during prepare(), and vice versa.
But considering backward compatibility, at this stage we allow en_mask
to be a combination or a pure divider enable mask.
And then we will make en_mask a pure divider enable mask in another
following patch series.

Reviewed-by: Ikjoon Jang <ikjn@chromium.org>
Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
Signed-off-by: Chun-Jie Chen <chun-jie.chen@mediatek.com>
Link: https://lore.kernel.org/r/20210726105719.15793-7-chun-jie.chen@mediatek.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-pll.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/mediatek/clk-pll.c b/drivers/clk/mediatek/clk-pll.c
index f440f2cd0b69..11ed5d1d1c36 100644
--- a/drivers/clk/mediatek/clk-pll.c
+++ b/drivers/clk/mediatek/clk-pll.c
@@ -238,6 +238,7 @@ static int mtk_pll_prepare(struct clk_hw *hw)
 {
 	struct mtk_clk_pll *pll = to_mtk_clk_pll(hw);
 	u32 r;
+	u32 div_en_mask;
 
 	r = readl(pll->pwr_addr) | CON0_PWR_ON;
 	writel(r, pll->pwr_addr);
@@ -247,10 +248,15 @@ static int mtk_pll_prepare(struct clk_hw *hw)
 	writel(r, pll->pwr_addr);
 	udelay(1);
 
-	r = readl(pll->base_addr + REG_CON0);
-	r |= pll->data->en_mask;
+	r = readl(pll->base_addr + REG_CON0) | CON0_BASE_EN;
 	writel(r, pll->base_addr + REG_CON0);
 
+	div_en_mask = pll->data->en_mask & ~CON0_BASE_EN;
+	if (div_en_mask) {
+		r = readl(pll->base_addr + REG_CON0) | div_en_mask;
+		writel(r, pll->base_addr + REG_CON0);
+	}
+
 	__mtk_pll_tuner_enable(pll);
 
 	udelay(20);
@@ -268,6 +274,7 @@ static void mtk_pll_unprepare(struct clk_hw *hw)
 {
 	struct mtk_clk_pll *pll = to_mtk_clk_pll(hw);
 	u32 r;
+	u32 div_en_mask;
 
 	if (pll->data->flags & HAVE_RST_BAR) {
 		r = readl(pll->base_addr + REG_CON0);
@@ -277,8 +284,13 @@ static void mtk_pll_unprepare(struct clk_hw *hw)
 
 	__mtk_pll_tuner_disable(pll);
 
-	r = readl(pll->base_addr + REG_CON0);
-	r &= ~CON0_BASE_EN;
+	div_en_mask = pll->data->en_mask & ~CON0_BASE_EN;
+	if (div_en_mask) {
+		r = readl(pll->base_addr + REG_CON0) & ~div_en_mask;
+		writel(r, pll->base_addr + REG_CON0);
+	}
+
+	r = readl(pll->base_addr + REG_CON0) & ~CON0_BASE_EN;
 	writel(r, pll->base_addr + REG_CON0);
 
 	r = readl(pll->pwr_addr) | CON0_ISO_EN;
-- 
2.30.2

