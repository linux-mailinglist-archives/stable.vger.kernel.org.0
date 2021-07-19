Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD33CD99B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244033AbhGSOa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244450AbhGSO3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE8B360249;
        Mon, 19 Jul 2021 15:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707371;
        bh=5i7m6YX8SA5KT6nhg8VE7TWcYW8SL3Nb60FoMy3MKc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXI6ddpKVKOydztGmw/5zmZDFsFTdPWepFzRaxY0ji6r7mlgCc4c4Rz32s9Yt6CMU
         2XW7YfZNwhHOtkJqo5+1UDXLNYh85sZIJun9+/RNksRaTo81jtAmPvTGOj9gSlOFEK
         NMNTzgGv7iUflemyYCD5HqAqEb/ZXeGONRj/xDeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 134/245] clk: tegra: Ensure that PLLU configuration is applied properly
Date:   Mon, 19 Jul 2021 16:51:16 +0200
Message-Id: <20210719144944.740824590@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
 drivers/clk/tegra/clk-pll.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 1ab36a355daf..789efad791a3 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1085,7 +1085,8 @@ static int clk_pllu_enable(struct clk_hw *hw)
 	if (pll->lock)
 		spin_lock_irqsave(pll->lock, flags);
 
-	_clk_pll_enable(hw);
+	if (!clk_pll_is_enabled(hw))
+		_clk_pll_enable(hw);
 
 	ret = clk_pll_wait_for_lock(pll);
 	if (ret < 0)
@@ -1702,7 +1703,8 @@ static int clk_pllu_tegra114_enable(struct clk_hw *hw)
 	if (pll->lock)
 		spin_lock_irqsave(pll->lock, flags);
 
-	_clk_pll_enable(hw);
+	if (!clk_pll_is_enabled(hw))
+		_clk_pll_enable(hw);
 
 	ret = clk_pll_wait_for_lock(pll);
 	if (ret < 0)
-- 
2.30.2



