Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDE03C4EF2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241368AbhGLHW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343504AbhGLHTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A242061153;
        Mon, 12 Jul 2021 07:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074223;
        bh=YSYhO3cbDVWWb4FnD286mmEmTDJhapXmpJucvyPgi3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=do4ijMDwGAdjNkuUn1m26Nv1QmUqAjCY1jR7iVEK1rPyS1B8qXtYbM+nFd0wrYIev
         5LTe1RYZ/ue6W4xq5V/XivLpwaZRfBuRSXkbQB+HOczScdiwF0Z6LKW/bxCulI1lvV
         fYsZT9qWxz2YlLAc0T+KJc9Cxpw3AQfezGftYKkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 506/700] clk: qcom: clk-alpha-pll: fix CAL_L write in alpha_pll_fabia_prepare
Date:   Mon, 12 Jul 2021 08:09:49 +0200
Message-Id: <20210712061030.340905581@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 7f54bf2640e877c8a9b4cc7e2b29f82e3ca1a284 ]

Caught this when looking at alpha-pll code. Untested but it is clear that
this was intended to write to PLL_CAL_L_VAL and not PLL_ALPHA_VAL.

Fixes: 691865bad627 ("clk: qcom: clk-alpha-pll: Add support for Fabia PLL calibration")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Link: https://lore.kernel.org/r/20210609022852.4151-1-jonathan@marek.ca
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index c6eb99169ddc..6f8f0bbc5ab5 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1234,7 +1234,7 @@ static int alpha_pll_fabia_prepare(struct clk_hw *hw)
 		return ret;
 
 	/* Setup PLL for calibration frequency */
-	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), cal_l);
+	regmap_write(pll->clkr.regmap, PLL_CAL_L_VAL(pll), cal_l);
 
 	/* Bringup the PLL at calibration frequency */
 	ret = clk_alpha_pll_enable(hw);
-- 
2.30.2



