Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51187329027
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242694AbhCAUDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242344AbhCATxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EFBF650E8;
        Mon,  1 Mar 2021 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621194;
        bh=K3xNrXhUVqjnSx3rUO3T5Zh1wsZLbB70mPBkArxwv/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1TN5Kc/fi8dRt3iYyLZOCDfB5e0cpVBpCPB99FCDZAPJskOVYAraXt3+AhSikuU6
         6K0m7AkCoMiAZ4g7+uQEBofgXhedKYRtxcWtxozBSjR/eqOGBNQGV6C9JdSTI0Twbd
         1dj7NKRBpo2YFGL2sYCsWLXMFPY31AcDPqwsx1ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 426/775] clk: qcom: gfm-mux: fix clk mask
Date:   Mon,  1 Mar 2021 17:09:54 +0100
Message-Id: <20210301161222.621653129@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 78ddb79cab178534b2c1d9ab95823f2af882ee8e ]

For some reason global GFM_MASK ended up with bit 1 instead of bit 0.
Remove the global GFM_MASK and reuse mux_mask field.

Fixes: a2d8f507803e ("clk: qcom: Add support to LPASS AUDIO_CC Glitch Free Mux clocks")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210119113851.18946-1-srinivas.kandagatla@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/lpass-gfm-sm8250.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/lpass-gfm-sm8250.c b/drivers/clk/qcom/lpass-gfm-sm8250.c
index d366c7c2abc77..f5e31e692b9b4 100644
--- a/drivers/clk/qcom/lpass-gfm-sm8250.c
+++ b/drivers/clk/qcom/lpass-gfm-sm8250.c
@@ -33,14 +33,13 @@ struct clk_gfm {
 	void __iomem *gfm_mux;
 };
 
-#define GFM_MASK	BIT(1)
 #define to_clk_gfm(_hw) container_of(_hw, struct clk_gfm, hw)
 
 static u8 clk_gfm_get_parent(struct clk_hw *hw)
 {
 	struct clk_gfm *clk = to_clk_gfm(hw);
 
-	return readl(clk->gfm_mux) & GFM_MASK;
+	return readl(clk->gfm_mux) & clk->mux_mask;
 }
 
 static int clk_gfm_set_parent(struct clk_hw *hw, u8 index)
@@ -51,9 +50,10 @@ static int clk_gfm_set_parent(struct clk_hw *hw, u8 index)
 	val = readl(clk->gfm_mux);
 
 	if (index)
-		val |= GFM_MASK;
+		val |= clk->mux_mask;
 	else
-		val &= ~GFM_MASK;
+		val &= ~clk->mux_mask;
+
 
 	writel(val, clk->gfm_mux);
 
-- 
2.27.0



