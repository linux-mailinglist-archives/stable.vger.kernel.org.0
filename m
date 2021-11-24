Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D77845C1EB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345685AbhKXNYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:24:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349265AbhKXNS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:18:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9416161AED;
        Wed, 24 Nov 2021 12:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757969;
        bh=7xoY8n8uQOFMeGwlpGixZjniBDpaU8T0lcYuoX6KMzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qO1oMOVQAG9wW01ZsNRKUx2tJlDiI7misLtRfkTcFiOqsQts0zHMA9thPbn7g3/e7
         WaAnjDKtn6shWFTRbra3O4je51bv8e1rjQLsZIuLdpFVnTXka/pWOokuB6CFr9Cvep
         qyVvgIF58D3TmlcMP+yJrNn8Na23K+e5f6O0XMv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Abel Vesa <abel.vesa@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/100] clk: imx: imx6ul: Move csi_sel mux to correct base register
Date:   Wed, 24 Nov 2021 12:57:29 +0100
Message-Id: <20211124115655.283163718@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Riedmueller <s.riedmueller@phytec.de>

[ Upstream commit 2f9d61869640f732599ec36b984c2b5c46067519 ]

The csi_sel mux register is located in the CCM register base and not the
CCM_ANALOG register base. So move it to the correct position in code.

Otherwise changing the parent of the csi clock can lead to a complete
system failure due to the CCM_ANALOG_PLL_SYS_TOG register being falsely
modified.

Also remove the SET_RATE_PARENT flag since one possible supply for the
csi_sel mux is the system PLL which we don't want to modify.

Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20210927072857.3940880-1-s.riedmueller@phytec.de
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6ul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx6ul.c b/drivers/clk/imx/clk-imx6ul.c
index bc931988fe7b2..f3ac5a524f4ed 100644
--- a/drivers/clk/imx/clk-imx6ul.c
+++ b/drivers/clk/imx/clk-imx6ul.c
@@ -161,7 +161,6 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 	hws[IMX6UL_PLL5_BYPASS] = imx_clk_hw_mux_flags("pll5_bypass", base + 0xa0, 16, 1, pll5_bypass_sels, ARRAY_SIZE(pll5_bypass_sels), CLK_SET_RATE_PARENT);
 	hws[IMX6UL_PLL6_BYPASS] = imx_clk_hw_mux_flags("pll6_bypass", base + 0xe0, 16, 1, pll6_bypass_sels, ARRAY_SIZE(pll6_bypass_sels), CLK_SET_RATE_PARENT);
 	hws[IMX6UL_PLL7_BYPASS] = imx_clk_hw_mux_flags("pll7_bypass", base + 0x20, 16, 1, pll7_bypass_sels, ARRAY_SIZE(pll7_bypass_sels), CLK_SET_RATE_PARENT);
-	hws[IMX6UL_CLK_CSI_SEL] = imx_clk_hw_mux_flags("csi_sel", base + 0x3c, 9, 2, csi_sels, ARRAY_SIZE(csi_sels), CLK_SET_RATE_PARENT);
 
 	/* Do not bypass PLLs initially */
 	clk_set_parent(hws[IMX6UL_PLL1_BYPASS]->clk, hws[IMX6UL_CLK_PLL1]->clk);
@@ -270,6 +269,7 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 	hws[IMX6UL_CLK_ECSPI_SEL]	  = imx_clk_hw_mux("ecspi_sel",	base + 0x38, 18, 1, ecspi_sels, ARRAY_SIZE(ecspi_sels));
 	hws[IMX6UL_CLK_LCDIF_PRE_SEL]	  = imx_clk_hw_mux_flags("lcdif_pre_sel", base + 0x38, 15, 3, lcdif_pre_sels, ARRAY_SIZE(lcdif_pre_sels), CLK_SET_RATE_PARENT);
 	hws[IMX6UL_CLK_LCDIF_SEL]	  = imx_clk_hw_mux("lcdif_sel",	base + 0x38, 9, 3, lcdif_sels, ARRAY_SIZE(lcdif_sels));
+	hws[IMX6UL_CLK_CSI_SEL]		  = imx_clk_hw_mux("csi_sel", base + 0x3c, 9, 2, csi_sels, ARRAY_SIZE(csi_sels));
 
 	hws[IMX6UL_CLK_LDB_DI0_DIV_SEL]  = imx_clk_hw_mux("ldb_di0", base + 0x20, 10, 1, ldb_di0_div_sels, ARRAY_SIZE(ldb_di0_div_sels));
 	hws[IMX6UL_CLK_LDB_DI1_DIV_SEL]  = imx_clk_hw_mux("ldb_di1", base + 0x20, 11, 1, ldb_di1_div_sels, ARRAY_SIZE(ldb_di1_div_sels));
-- 
2.33.0



