Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9493CA6BE
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240536AbhGOSuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239708AbhGOSt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE996613DF;
        Thu, 15 Jul 2021 18:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374824;
        bh=J9jzMF9UE8azGOzNI1ZPfuhQllO46jyFP0pJ2whawEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnJJJLS+bJYOf9gezOwukFz9Qok6ziHcBmNJgTrWTt5nbHSaqxj2Eon4rgwYnhWSy
         /8AStiwJeYZsVxUqxP212/Tdkbs7JPeKYfm9ZH5sOJFepSPu7dWFvC4uyMUfx8qIMl
         dKWZMfWdvIT1gDMe7gu2wrOaHrUMwrtuidTtY+ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/215] clk: tegra: Ensure that PLLU configuration is applied properly
Date:   Thu, 15 Jul 2021 20:36:53 +0200
Message-Id: <20210715182606.551249060@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit a7196048cd5168096c2c4f44a3939d7a6dcd06b9 ]

The PLLU (USB) consists of the PLL configuration itself and configuration
of the PLLU outputs. The PLLU programming is inconsistent on T30 vs T114,
where T114 immediately bails out if PLLU is enabled and T30 re-enables
a potentially already enabled PLL (left after bootloader) and then fully
reprograms it, which could be unsafe to do. The correct way should be to
skip enabling of the PLL if it's already enabled and then apply
configuration to the outputs. This patch doesn't fix any known problems,
it's a minor improvement.

Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-pll.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index c5cc0a2dac6f..d709ecb7d8d7 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1131,7 +1131,8 @@ static int clk_pllu_enable(struct clk_hw *hw)
 	if (pll->lock)
 		spin_lock_irqsave(pll->lock, flags);
 
-	_clk_pll_enable(hw);
+	if (!clk_pll_is_enabled(hw))
+		_clk_pll_enable(hw);
 
 	ret = clk_pll_wait_for_lock(pll);
 	if (ret < 0)
@@ -1748,15 +1749,13 @@ static int clk_pllu_tegra114_enable(struct clk_hw *hw)
 		return -EINVAL;
 	}
 
-	if (clk_pll_is_enabled(hw))
-		return 0;
-
 	input_rate = clk_hw_get_rate(__clk_get_hw(osc));
 
 	if (pll->lock)
 		spin_lock_irqsave(pll->lock, flags);
 
-	_clk_pll_enable(hw);
+	if (!clk_pll_is_enabled(hw))
+		_clk_pll_enable(hw);
 
 	ret = clk_pll_wait_for_lock(pll);
 	if (ret < 0)
-- 
2.30.2



