Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBC624BBAB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHTMc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729693AbgHTJtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:49:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6AA122B43;
        Thu, 20 Aug 2020 09:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916989;
        bh=IC5OrnGLEQIkbg7gmZ9Y+tk1B80FEjYjLyV8ASjFDcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJ4i4P3j/2Bg47OZ34LyoFapLQ5Bx3ZK3iMAkS9CNeWtJvkX/quA6qT5v0qBrOa0G
         jbeNOU4dHxqLQ22pXPGVALvdjlEGMTjK5Nk0dJFKDGFqxiPk/AK7ODSWppoTZ6sLUl
         TqTUCDy4gjIwUDm2Q3twHzQX6o+nY39sNhL8ThAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/152] clk: bcm2835: Do not use prediv with bcm2711s PLLs
Date:   Thu, 20 Aug 2020 11:21:24 +0200
Message-Id: <20200820091559.758175658@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit f34e4651ce66a754f41203284acf09b28b9dd955 ]

Contrary to previous SoCs, bcm2711 doesn't have a prescaler in the PLL
feedback loop. Bypass it by zeroing fb_prediv_mask when running on
bcm2711.

Note that, since the prediv configuration bits were re-purposed, this
was triggering miscalculations on all clocks hanging from the VPU clock,
notably the aux UART, making its output unintelligible.

Fixes: 42de9ad400af ("clk: bcm2835: Add BCM2711_CLOCK_EMMC2 support")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20200730182619.23246-1-nsaenzjulienne@suse.de
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm2835.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index 6e5d635f030f4..45420b514149f 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -314,6 +314,7 @@ struct bcm2835_cprman {
 	struct device *dev;
 	void __iomem *regs;
 	spinlock_t regs_lock; /* spinlock for all clocks */
+	unsigned int soc;
 
 	/*
 	 * Real names of cprman clock parents looked up through
@@ -525,6 +526,20 @@ static int bcm2835_pll_is_on(struct clk_hw *hw)
 		A2W_PLL_CTRL_PRST_DISABLE;
 }
 
+static u32 bcm2835_pll_get_prediv_mask(struct bcm2835_cprman *cprman,
+				       const struct bcm2835_pll_data *data)
+{
+	/*
+	 * On BCM2711 there isn't a pre-divisor available in the PLL feedback
+	 * loop. Bits 13:14 of ANA1 (PLLA,PLLB,PLLC,PLLD) have been re-purposed
+	 * for to for VCO RANGE bits.
+	 */
+	if (cprman->soc & SOC_BCM2711)
+		return 0;
+
+	return data->ana->fb_prediv_mask;
+}
+
 static void bcm2835_pll_choose_ndiv_and_fdiv(unsigned long rate,
 					     unsigned long parent_rate,
 					     u32 *ndiv, u32 *fdiv)
@@ -582,7 +597,7 @@ static unsigned long bcm2835_pll_get_rate(struct clk_hw *hw,
 	ndiv = (a2wctrl & A2W_PLL_CTRL_NDIV_MASK) >> A2W_PLL_CTRL_NDIV_SHIFT;
 	pdiv = (a2wctrl & A2W_PLL_CTRL_PDIV_MASK) >> A2W_PLL_CTRL_PDIV_SHIFT;
 	using_prediv = cprman_read(cprman, data->ana_reg_base + 4) &
-		data->ana->fb_prediv_mask;
+		       bcm2835_pll_get_prediv_mask(cprman, data);
 
 	if (using_prediv) {
 		ndiv *= 2;
@@ -665,6 +680,7 @@ static int bcm2835_pll_set_rate(struct clk_hw *hw,
 	struct bcm2835_pll *pll = container_of(hw, struct bcm2835_pll, hw);
 	struct bcm2835_cprman *cprman = pll->cprman;
 	const struct bcm2835_pll_data *data = pll->data;
+	u32 prediv_mask = bcm2835_pll_get_prediv_mask(cprman, data);
 	bool was_using_prediv, use_fb_prediv, do_ana_setup_first;
 	u32 ndiv, fdiv, a2w_ctl;
 	u32 ana[4];
@@ -682,7 +698,7 @@ static int bcm2835_pll_set_rate(struct clk_hw *hw,
 	for (i = 3; i >= 0; i--)
 		ana[i] = cprman_read(cprman, data->ana_reg_base + i * 4);
 
-	was_using_prediv = ana[1] & data->ana->fb_prediv_mask;
+	was_using_prediv = ana[1] & prediv_mask;
 
 	ana[0] &= ~data->ana->mask0;
 	ana[0] |= data->ana->set0;
@@ -692,10 +708,10 @@ static int bcm2835_pll_set_rate(struct clk_hw *hw,
 	ana[3] |= data->ana->set3;
 
 	if (was_using_prediv && !use_fb_prediv) {
-		ana[1] &= ~data->ana->fb_prediv_mask;
+		ana[1] &= ~prediv_mask;
 		do_ana_setup_first = true;
 	} else if (!was_using_prediv && use_fb_prediv) {
-		ana[1] |= data->ana->fb_prediv_mask;
+		ana[1] |= prediv_mask;
 		do_ana_setup_first = false;
 	} else {
 		do_ana_setup_first = true;
@@ -2234,6 +2250,7 @@ static int bcm2835_clk_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, cprman);
 
 	cprman->onecell.num = asize;
+	cprman->soc = pdata->soc;
 	hws = cprman->onecell.hws;
 
 	for (i = 0; i < asize; i++) {
-- 
2.25.1



