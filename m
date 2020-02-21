Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AB1167849
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgBUHs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:48:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbgBUHs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:48:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE31524656;
        Fri, 21 Feb 2020 07:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271337;
        bh=P69UTbhozxeT3KFIKlTK55qTnkoIRQAh1+kQfAY8bnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1nfepH0hIAClj1fBeyBSD0Lq4+zCZ38uzgTGKianJBOK/J7g7g2QK4QE7Lj0kNaW
         diAEE4Vv4nDHBTHZNrc6mnQ969+ssmPchKObDcVXH3CoHI+vz1Su3x1hBMXIqwL2jS
         EVhdCKxCSTIX6azRqLPPS+E47j6xWGl+4lEzM0rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abel Vesa <abel.vesa@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 128/399] clk: imx: Add correct failure handling for clk based helpers
Date:   Fri, 21 Feb 2020 08:37:33 +0100
Message-Id: <20200221072414.922072206@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abel Vesa <abel.vesa@nxp.com>

[ Upstream commit f60f1c62c3188fcca945581e35e3440ee3fdcc95 ]

If the clk_hw based API returns an error, trying to return the clk from
hw will end up in a NULL pointer dereference. So adding the to_clk
checker and using it inside every clk based macro helper we handle that
case correctly.

This to_clk is also temporary and will go away along with the clk based
macro helpers once there is no user that need them anymore.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk.h | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/imx/clk.h b/drivers/clk/imx/clk.h
index bc5bb6ac86364..30ddbc1ced2ee 100644
--- a/drivers/clk/imx/clk.h
+++ b/drivers/clk/imx/clk.h
@@ -54,48 +54,48 @@ extern struct imx_pll14xx_clk imx_1416x_pll;
 extern struct imx_pll14xx_clk imx_1443x_pll;
 
 #define imx_clk_cpu(name, parent_name, div, mux, pll, step) \
-	imx_clk_hw_cpu(name, parent_name, div, mux, pll, step)->clk
+	to_clk(imx_clk_hw_cpu(name, parent_name, div, mux, pll, step))
 
 #define clk_register_gate2(dev, name, parent_name, flags, reg, bit_idx, \
 				cgr_val, clk_gate_flags, lock, share_count) \
-	clk_hw_register_gate2(dev, name, parent_name, flags, reg, bit_idx, \
-				cgr_val, clk_gate_flags, lock, share_count)->clk
+	to_clk(clk_hw_register_gate2(dev, name, parent_name, flags, reg, bit_idx, \
+				cgr_val, clk_gate_flags, lock, share_count))
 
 #define imx_clk_pllv3(type, name, parent_name, base, div_mask) \
-	imx_clk_hw_pllv3(type, name, parent_name, base, div_mask)->clk
+	to_clk(imx_clk_hw_pllv3(type, name, parent_name, base, div_mask))
 
 #define imx_clk_pfd(name, parent_name, reg, idx) \
-	imx_clk_hw_pfd(name, parent_name, reg, idx)->clk
+	to_clk(imx_clk_hw_pfd(name, parent_name, reg, idx))
 
 #define imx_clk_gate_exclusive(name, parent, reg, shift, exclusive_mask) \
-	imx_clk_hw_gate_exclusive(name, parent, reg, shift, exclusive_mask)->clk
+	to_clk(imx_clk_hw_gate_exclusive(name, parent, reg, shift, exclusive_mask))
 
 #define imx_clk_fixed_factor(name, parent, mult, div) \
-	imx_clk_hw_fixed_factor(name, parent, mult, div)->clk
+	to_clk(imx_clk_hw_fixed_factor(name, parent, mult, div))
 
 #define imx_clk_divider2(name, parent, reg, shift, width) \
-	imx_clk_hw_divider2(name, parent, reg, shift, width)->clk
+	to_clk(imx_clk_hw_divider2(name, parent, reg, shift, width))
 
 #define imx_clk_gate_dis(name, parent, reg, shift) \
-	imx_clk_hw_gate_dis(name, parent, reg, shift)->clk
+	to_clk(imx_clk_hw_gate_dis(name, parent, reg, shift))
 
 #define imx_clk_gate2(name, parent, reg, shift) \
-	imx_clk_hw_gate2(name, parent, reg, shift)->clk
+	to_clk(imx_clk_hw_gate2(name, parent, reg, shift))
 
 #define imx_clk_gate2_flags(name, parent, reg, shift, flags) \
-	imx_clk_hw_gate2_flags(name, parent, reg, shift, flags)->clk
+	to_clk(imx_clk_hw_gate2_flags(name, parent, reg, shift, flags))
 
 #define imx_clk_gate2_shared2(name, parent, reg, shift, share_count) \
-	imx_clk_hw_gate2_shared2(name, parent, reg, shift, share_count)->clk
+	to_clk(imx_clk_hw_gate2_shared2(name, parent, reg, shift, share_count))
 
 #define imx_clk_gate3(name, parent, reg, shift) \
-	imx_clk_hw_gate3(name, parent, reg, shift)->clk
+	to_clk(imx_clk_hw_gate3(name, parent, reg, shift))
 
 #define imx_clk_gate4(name, parent, reg, shift) \
-	imx_clk_hw_gate4(name, parent, reg, shift)->clk
+	to_clk(imx_clk_hw_gate4(name, parent, reg, shift))
 
 #define imx_clk_mux(name, reg, shift, width, parents, num_parents) \
-	imx_clk_hw_mux(name, reg, shift, width, parents, num_parents)->clk
+	to_clk(imx_clk_hw_mux(name, reg, shift, width, parents, num_parents))
 
 struct clk *imx_clk_pll14xx(const char *name, const char *parent_name,
 		 void __iomem *base, const struct imx_pll14xx_clk *pll_clk);
@@ -198,6 +198,13 @@ struct clk_hw *imx_clk_hw_fixup_mux(const char *name, void __iomem *reg,
 			      u8 shift, u8 width, const char * const *parents,
 			      int num_parents, void (*fixup)(u32 *val));
 
+static inline struct clk *to_clk(struct clk_hw *hw)
+{
+	if (IS_ERR_OR_NULL(hw))
+		return ERR_CAST(hw);
+	return hw->clk;
+}
+
 static inline struct clk *imx_clk_fixed(const char *name, int rate)
 {
 	return clk_register_fixed_rate(NULL, name, NULL, 0, rate);
-- 
2.20.1



