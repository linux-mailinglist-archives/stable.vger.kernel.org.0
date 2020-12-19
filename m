Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFFA2DEF07
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgLSM6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbgLSM6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:05 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 14/49] net: stmmac: dwmac-meson8b: fix mask definition of the m250_sel mux
Date:   Sat, 19 Dec 2020 13:58:18 +0100
Message-Id: <20201219125345.376925474@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 82ca4c922b8992013a238d65cf4e60cc33e12f36 ]

The m250_sel mux clock uses bit 4 in the PRG_ETH0 register. Fix this by
shifting the PRG_ETH0_CLK_M250_SEL_MASK accordingly as the "mask" in
struct clk_mux expects the mask relative to the "shift" field in the
same struct.

While here, get rid of the PRG_ETH0_CLK_M250_SEL_SHIFT macro and use
__ffs() to determine it from the existing PRG_ETH0_CLK_M250_SEL_MASK
macro.

Fixes: 566e8251625304 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20201205213207.519341-1-martin.blumenstingl@googlemail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -30,7 +30,6 @@
 #define PRG_ETH0_EXT_RMII_MODE		4
 
 /* mux to choose between fclk_div2 (bit unset) and mpll2 (bit set) */
-#define PRG_ETH0_CLK_M250_SEL_SHIFT	4
 #define PRG_ETH0_CLK_M250_SEL_MASK	GENMASK(4, 4)
 
 /* TX clock delay in ns = "8ns / 4 * tx_dly_val" (where 8ns are exactly one
@@ -155,8 +154,9 @@ static int meson8b_init_rgmii_tx_clk(str
 		return -ENOMEM;
 
 	clk_configs->m250_mux.reg = dwmac->regs + PRG_ETH0;
-	clk_configs->m250_mux.shift = PRG_ETH0_CLK_M250_SEL_SHIFT;
-	clk_configs->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK;
+	clk_configs->m250_mux.shift = __ffs(PRG_ETH0_CLK_M250_SEL_MASK);
+	clk_configs->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK >>
+				     clk_configs->m250_mux.shift;
 	clk = meson8b_dwmac_register_clk(dwmac, "m250_sel", mux_parents,
 					 ARRAY_SIZE(mux_parents), &clk_mux_ops,
 					 &clk_configs->m250_mux.hw);


