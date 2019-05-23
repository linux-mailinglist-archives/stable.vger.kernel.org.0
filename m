Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D5E2882A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390148AbfEWTWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:32886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390563AbfEWTWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:22:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D697C2054F;
        Thu, 23 May 2019 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639371;
        bh=sn+dZ/PchoWhDRxZdzF7nRF8NliCSnp7Ebv9+XJ/kfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQoqxs2X+ZAanOV+TjxKpJbAf0jcr/fGCVRt8H5eoZk0zNLsMKZRuXeePIEto3qca
         BQaI/IitSac3pOU3mdsl/XwUrLcYpoAI63XGtCB6mr1FVcObfxOOHmZKXm6d20T3oi
         LXC95tK5DUDdlevtlmVE9qPvTckAR/ao/0tZmuPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Owen Chen <owen.chen@mediatek.com>,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        James Liao <jamesjj.liao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.0 053/139] clk: mediatek: Disable tuner_en before change PLL rate
Date:   Thu, 23 May 2019 21:05:41 +0200
Message-Id: <20190523181727.557852703@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Owen Chen <owen.chen@mediatek.com>

commit be17ca6ac76a5cfd07cc3a0397dd05d6929fcbbb upstream.

PLLs with tuner_en bit, such as APLL1, need to disable
tuner_en before apply new frequency settings, or the new frequency
settings (pcw) will not be applied.
The tuner_en bit will be disabled during changing PLL rate
and be restored after new settings applied.

Fixes: e2f744a82d725 (clk: mediatek: Add MT2712 clock support)
Cc: <stable@vger.kernel.org>
Signed-off-by: Owen Chen <owen.chen@mediatek.com>
Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
Reviewed-by: James Liao <jamesjj.liao@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/mediatek/clk-pll.c |   48 +++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 14 deletions(-)

--- a/drivers/clk/mediatek/clk-pll.c
+++ b/drivers/clk/mediatek/clk-pll.c
@@ -88,6 +88,32 @@ static unsigned long __mtk_pll_recalc_ra
 	return ((unsigned long)vco + postdiv - 1) / postdiv;
 }
 
+static void __mtk_pll_tuner_enable(struct mtk_clk_pll *pll)
+{
+	u32 r;
+
+	if (pll->tuner_en_addr) {
+		r = readl(pll->tuner_en_addr) | BIT(pll->data->tuner_en_bit);
+		writel(r, pll->tuner_en_addr);
+	} else if (pll->tuner_addr) {
+		r = readl(pll->tuner_addr) | AUDPLL_TUNER_EN;
+		writel(r, pll->tuner_addr);
+	}
+}
+
+static void __mtk_pll_tuner_disable(struct mtk_clk_pll *pll)
+{
+	u32 r;
+
+	if (pll->tuner_en_addr) {
+		r = readl(pll->tuner_en_addr) & ~BIT(pll->data->tuner_en_bit);
+		writel(r, pll->tuner_en_addr);
+	} else if (pll->tuner_addr) {
+		r = readl(pll->tuner_addr) & ~AUDPLL_TUNER_EN;
+		writel(r, pll->tuner_addr);
+	}
+}
+
 static void mtk_pll_set_rate_regs(struct mtk_clk_pll *pll, u32 pcw,
 		int postdiv)
 {
@@ -96,6 +122,9 @@ static void mtk_pll_set_rate_regs(struct
 
 	pll_en = readl(pll->base_addr + REG_CON0) & CON0_BASE_EN;
 
+	/* disable tuner */
+	__mtk_pll_tuner_disable(pll);
+
 	/* set postdiv */
 	val = readl(pll->pd_addr);
 	val &= ~(POSTDIV_MASK << pll->data->pd_shift);
@@ -122,6 +151,9 @@ static void mtk_pll_set_rate_regs(struct
 	if (pll->tuner_addr)
 		writel(con1 + 1, pll->tuner_addr);
 
+	/* restore tuner_en */
+	__mtk_pll_tuner_enable(pll);
+
 	if (pll_en)
 		udelay(20);
 }
@@ -228,13 +260,7 @@ static int mtk_pll_prepare(struct clk_hw
 	r |= pll->data->en_mask;
 	writel(r, pll->base_addr + REG_CON0);
 
-	if (pll->tuner_en_addr) {
-		r = readl(pll->tuner_en_addr) | BIT(pll->data->tuner_en_bit);
-		writel(r, pll->tuner_en_addr);
-	} else if (pll->tuner_addr) {
-		r = readl(pll->tuner_addr) | AUDPLL_TUNER_EN;
-		writel(r, pll->tuner_addr);
-	}
+	__mtk_pll_tuner_enable(pll);
 
 	udelay(20);
 
@@ -258,13 +284,7 @@ static void mtk_pll_unprepare(struct clk
 		writel(r, pll->base_addr + REG_CON0);
 	}
 
-	if (pll->tuner_en_addr) {
-		r = readl(pll->tuner_en_addr) & ~BIT(pll->data->tuner_en_bit);
-		writel(r, pll->tuner_en_addr);
-	} else if (pll->tuner_addr) {
-		r = readl(pll->tuner_addr) & ~AUDPLL_TUNER_EN;
-		writel(r, pll->tuner_addr);
-	}
+	__mtk_pll_tuner_disable(pll);
 
 	r = readl(pll->base_addr + REG_CON0);
 	r &= ~CON0_BASE_EN;


