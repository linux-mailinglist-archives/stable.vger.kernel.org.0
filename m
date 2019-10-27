Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EC9E6720
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731245AbfJ0VSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731224AbfJ0VSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:18:14 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F26DD20717;
        Sun, 27 Oct 2019 21:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211094;
        bh=KfIBcyEnuRceF3vKSjN16F7+m+qFJm3bdbFB9alfQcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3I9Q4NpD0grjadVLmYkKMlx/5RXW8eUA4E0Fw1S2Owjw6inF+FN0qLmjo3QKLZe5
         5UupRs3XmSHEL39pEOUf+WuA5Hf4mjqh6JpjPPl3dDkwaf3LvdQn5C01w8BKLdFxrH
         SS1iFBYIC6i8bdMVkVc1Xi1kl6xAHEgmk+6nSOjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-clk@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Suman Anna <s-anna@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 003/197] clk: ti: dra7: Fix mcasp8 clock bits
Date:   Sun, 27 Oct 2019 21:58:41 +0100
Message-Id: <20191027203351.876536314@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit dd8882a255388ba66175098b1560d4f81c100d30 ]

There's a typo for dra7 mcasp clkctrl bit, it should be 22 like the other
macasp instances, and not 24. And in dra7xx_clks[] we have the bits wrong
way around.

Fixes: dffa9051d546 ("clk: ti: dra7: add new clkctrl data")
Cc: linux-clk@vger.kernel.org
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Suman Anna <s-anna@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-7xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
index b57fe09b428be..9dd6185a4b4e2 100644
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -683,7 +683,7 @@ static const struct omap_clkctrl_reg_data dra7_l4per2_clkctrl_regs[] __initconst
 	{ DRA7_L4PER2_MCASP2_CLKCTRL, dra7_mcasp2_bit_data, CLKF_SW_SUP, "l4per2-clkctrl:0154:22" },
 	{ DRA7_L4PER2_MCASP3_CLKCTRL, dra7_mcasp3_bit_data, CLKF_SW_SUP, "l4per2-clkctrl:015c:22" },
 	{ DRA7_L4PER2_MCASP5_CLKCTRL, dra7_mcasp5_bit_data, CLKF_SW_SUP, "l4per2-clkctrl:016c:22" },
-	{ DRA7_L4PER2_MCASP8_CLKCTRL, dra7_mcasp8_bit_data, CLKF_SW_SUP, "l4per2-clkctrl:0184:24" },
+	{ DRA7_L4PER2_MCASP8_CLKCTRL, dra7_mcasp8_bit_data, CLKF_SW_SUP, "l4per2-clkctrl:0184:22" },
 	{ DRA7_L4PER2_MCASP4_CLKCTRL, dra7_mcasp4_bit_data, CLKF_SW_SUP, "l4per2-clkctrl:018c:22" },
 	{ DRA7_L4PER2_UART7_CLKCTRL, dra7_uart7_bit_data, CLKF_SW_SUP, "l4per2-clkctrl:01c4:24" },
 	{ DRA7_L4PER2_UART8_CLKCTRL, dra7_uart8_bit_data, CLKF_SW_SUP, "l4per2-clkctrl:01d4:24" },
@@ -828,8 +828,8 @@ static struct ti_dt_clk dra7xx_clks[] = {
 	DT_CLK(NULL, "mcasp6_aux_gfclk_mux", "l4per2-clkctrl:01f8:22"),
 	DT_CLK(NULL, "mcasp7_ahclkx_mux", "l4per2-clkctrl:01fc:24"),
 	DT_CLK(NULL, "mcasp7_aux_gfclk_mux", "l4per2-clkctrl:01fc:22"),
-	DT_CLK(NULL, "mcasp8_ahclkx_mux", "l4per2-clkctrl:0184:22"),
-	DT_CLK(NULL, "mcasp8_aux_gfclk_mux", "l4per2-clkctrl:0184:24"),
+	DT_CLK(NULL, "mcasp8_ahclkx_mux", "l4per2-clkctrl:0184:24"),
+	DT_CLK(NULL, "mcasp8_aux_gfclk_mux", "l4per2-clkctrl:0184:22"),
 	DT_CLK(NULL, "mmc1_clk32k", "l3init-clkctrl:0008:8"),
 	DT_CLK(NULL, "mmc1_fclk_div", "l3init-clkctrl:0008:25"),
 	DT_CLK(NULL, "mmc1_fclk_mux", "l3init-clkctrl:0008:24"),
-- 
2.20.1



