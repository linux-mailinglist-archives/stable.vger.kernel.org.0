Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3116406391
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240929AbhIJAsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234797AbhIJAYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E26860FDA;
        Fri, 10 Sep 2021 00:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233391;
        bh=W1W9y/9p0SOx2kGkEmxow82SYjxCXKtIlDxwA6pa9Hs=;
        h=From:To:Cc:Subject:Date:From;
        b=STzDfhRjK0HqTf0EdmT6kQKFB2eVthBtTJNdG7h1x47J1j8CHrNg1blpj3GGybz8e
         ziIFOYDEioEAuwUQkiWwdsFFRvLnTg+25FDAS1j0/vralP8y4vBbaahqSygomQT/bw
         GTLFo/KBF2H2uHqS/1rl5+GvVkPjCvNs8ZPhNby/Fos4jK+GT9R2zPH5tU6P+zSmBx
         SUdTg6Fdlx3lPexkr28qdN30IzHSyUR5Y8rSz29bML8a/aT7UrYZK75UF0bgEgJotU
         SbgmBGtMqRUIOCZckK23oaEBf0FOTxrRTgIS7R9bhhRZWaiNEHTkFfDCmf+Y2hscrF
         9E/dyfRzTtjXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Lin <jon.lin@rock-chips.com>,
        Elaine Zhang <zhangqing@rock-chips.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 01/19] clk: rockchip: rk3036: fix up the sclk_sfc parent error
Date:   Thu,  9 Sep 2021 20:22:51 -0400
Message-Id: <20210910002309.176412-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Lin <jon.lin@rock-chips.com>

[ Upstream commit 0be3df186f870cbde56b223c1ad7892109c9c440 ]

Choose the correct pll

Signed-off-by: Elaine Zhang <zhangqing@rock-chips.com>
Signed-off-by: Jon Lin <jon.lin@rock-chips.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20210713094456.23288-5-jon.lin@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3036.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3036.c b/drivers/clk/rockchip/clk-rk3036.c
index c3001980dbdc..ee3f6462620f 100644
--- a/drivers/clk/rockchip/clk-rk3036.c
+++ b/drivers/clk/rockchip/clk-rk3036.c
@@ -128,6 +128,7 @@ PNAME(mux_pll_src_3plls_p)	= { "apll", "dpll", "gpll" };
 PNAME(mux_timer_p)		= { "xin24m", "pclk_peri_src" };
 
 PNAME(mux_pll_src_apll_dpll_gpll_usb480m_p)	= { "apll", "dpll", "gpll", "usb480m" };
+PNAME(mux_pll_src_dmyapll_dpll_gpll_xin24_p)   = { "dummy_apll", "dpll", "gpll", "xin24m" };
 
 PNAME(mux_mmc_src_p)	= { "apll", "dpll", "gpll", "xin24m" };
 PNAME(mux_i2s_pre_p)	= { "i2s_src", "i2s_frac", "ext_i2s", "xin12m" };
@@ -347,7 +348,7 @@ static struct rockchip_clk_branch rk3036_clk_branches[] __initdata = {
 			RK2928_CLKSEL_CON(16), 8, 2, MFLAGS, 10, 5, DFLAGS,
 			RK2928_CLKGATE_CON(10), 4, GFLAGS),
 
-	COMPOSITE(SCLK_SFC, "sclk_sfc", mux_pll_src_apll_dpll_gpll_usb480m_p, 0,
+	COMPOSITE(SCLK_SFC, "sclk_sfc", mux_pll_src_dmyapll_dpll_gpll_xin24_p, 0,
 			RK2928_CLKSEL_CON(16), 0, 2, MFLAGS, 2, 5, DFLAGS,
 			RK2928_CLKGATE_CON(10), 5, GFLAGS),
 
-- 
2.30.2

