Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CC140DF6F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhIPQJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230422AbhIPQIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:08:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EB1F61263;
        Thu, 16 Sep 2021 16:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808439;
        bh=2nfsBoyBHbMhXNVy4BnkUM8w6dgoh57z7E6GDF9opyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEVCoaSrAM6K7ZM0bsfdaRzofIRpDHLq8v0ebclfeJZxw5Flazm1isnm2xk2q2obI
         M/u2l88onzKbGjR1CSu0ZhhJ8vhZEvhBrrjUtQ/mMByOpHEZ/ptLzzV2M3IGzszXVH
         FWl7nKTKTvnXUq+HmzqCJddE25sGuIIgLjcQF9Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Abel Vesa <abel.vesa@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/306] clk: imx8m: fix clock tree update of TF-A managed clocks
Date:   Thu, 16 Sep 2021 17:57:16 +0200
Message-Id: <20210916155757.168379877@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit d36207b848a6490e14664e2197a1c8ab51d8148e ]

On the i.MX8M*, the TF-A exposes a SiP (Silicon Provider) service
for DDR frequency scaling. The imx8m-ddrc-devfreq driver calls the
SiP and then does clk_set_parent on the DDR muxes to synchronize
the clock tree.

Since 936c383673b9 ("clk: imx: fix composite peripheral flags"),
these TF-A managed muxes have SET_PARENT_GATE set, which results
in imx8m-ddrc-devfreq's clk_set_parent after SiP failing with -EBUSY:

	echo 25000000 > userspace/set_freq
	imx8m-ddrc-devfreq 3d400000.memory-controller: failed to set
		dram_apb parent: -16

Fix this by adding a new i.MX composite flag for firmware managed
clocks, which clears SET_PARENT_GATE.

This is safe to do, because updating the Linux clock tree to reflect
reality will always be glitch-free.

Fixes: 936c383673b9 ("clk: imx: fix composite peripheral flags")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20210810151432.9228-1-a.fatoum@pengutronix.de
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-composite-8m.c |  3 ++-
 drivers/clk/imx/clk-imx8mm.c       |  7 ++++---
 drivers/clk/imx/clk-imx8mn.c       |  7 ++++---
 drivers/clk/imx/clk-imx8mq.c       |  7 ++++---
 drivers/clk/imx/clk.h              | 16 ++++++++++++++--
 5 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/imx/clk-composite-8m.c b/drivers/clk/imx/clk-composite-8m.c
index 2c309e3dc8e3..04e728538cef 100644
--- a/drivers/clk/imx/clk-composite-8m.c
+++ b/drivers/clk/imx/clk-composite-8m.c
@@ -216,7 +216,8 @@ struct clk_hw *imx8m_clk_hw_composite_flags(const char *name,
 		div->width = PCG_PREDIV_WIDTH;
 		divider_ops = &imx8m_clk_composite_divider_ops;
 		mux_ops = &clk_mux_ops;
-		flags |= CLK_SET_PARENT_GATE;
+		if (!(composite_flags & IMX_COMPOSITE_FW_MANAGED))
+			flags |= CLK_SET_PARENT_GATE;
 	}
 
 	div->lock = &imx_ccm_lock;
diff --git a/drivers/clk/imx/clk-imx8mm.c b/drivers/clk/imx/clk-imx8mm.c
index 4cbf86ab2eac..711bd2294c70 100644
--- a/drivers/clk/imx/clk-imx8mm.c
+++ b/drivers/clk/imx/clk-imx8mm.c
@@ -458,10 +458,11 @@ static int imx8mm_clocks_probe(struct platform_device *pdev)
 
 	/*
 	 * DRAM clocks are manipulated from TF-A outside clock framework.
-	 * Mark with GET_RATE_NOCACHE to always read div value from hardware
+	 * The fw_managed helper sets GET_RATE_NOCACHE and clears SET_PARENT_GATE
+	 * as div value should always be read from hardware
 	 */
-	hws[IMX8MM_CLK_DRAM_ALT] = __imx8m_clk_hw_composite("dram_alt", imx8mm_dram_alt_sels, base + 0xa000, CLK_GET_RATE_NOCACHE);
-	hws[IMX8MM_CLK_DRAM_APB] = __imx8m_clk_hw_composite("dram_apb", imx8mm_dram_apb_sels, base + 0xa080, CLK_IS_CRITICAL | CLK_GET_RATE_NOCACHE);
+	hws[IMX8MM_CLK_DRAM_ALT] = imx8m_clk_hw_fw_managed_composite("dram_alt", imx8mm_dram_alt_sels, base + 0xa000);
+	hws[IMX8MM_CLK_DRAM_APB] = imx8m_clk_hw_fw_managed_composite_critical("dram_apb", imx8mm_dram_apb_sels, base + 0xa080);
 
 	/* IP */
 	hws[IMX8MM_CLK_VPU_G1] = imx8m_clk_hw_composite("vpu_g1", imx8mm_vpu_g1_sels, base + 0xa100);
diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index f98f25279539..33a7ddc23cd2 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -441,10 +441,11 @@ static int imx8mn_clocks_probe(struct platform_device *pdev)
 
 	/*
 	 * DRAM clocks are manipulated from TF-A outside clock framework.
-	 * Mark with GET_RATE_NOCACHE to always read div value from hardware
+	 * The fw_managed helper sets GET_RATE_NOCACHE and clears SET_PARENT_GATE
+	 * as div value should always be read from hardware
 	 */
-	hws[IMX8MN_CLK_DRAM_ALT] = __imx8m_clk_hw_composite("dram_alt", imx8mn_dram_alt_sels, base + 0xa000, CLK_GET_RATE_NOCACHE);
-	hws[IMX8MN_CLK_DRAM_APB] = __imx8m_clk_hw_composite("dram_apb", imx8mn_dram_apb_sels, base + 0xa080, CLK_IS_CRITICAL | CLK_GET_RATE_NOCACHE);
+	hws[IMX8MN_CLK_DRAM_ALT] = imx8m_clk_hw_fw_managed_composite("dram_alt", imx8mn_dram_alt_sels, base + 0xa000);
+	hws[IMX8MN_CLK_DRAM_APB] = imx8m_clk_hw_fw_managed_composite_critical("dram_apb", imx8mn_dram_apb_sels, base + 0xa080);
 
 	hws[IMX8MN_CLK_DISP_PIXEL] = imx8m_clk_hw_composite("disp_pixel", imx8mn_disp_pixel_sels, base + 0xa500);
 	hws[IMX8MN_CLK_SAI2] = imx8m_clk_hw_composite("sai2", imx8mn_sai2_sels, base + 0xa600);
diff --git a/drivers/clk/imx/clk-imx8mq.c b/drivers/clk/imx/clk-imx8mq.c
index aac6bcc65c20..f679e5cc320b 100644
--- a/drivers/clk/imx/clk-imx8mq.c
+++ b/drivers/clk/imx/clk-imx8mq.c
@@ -427,11 +427,12 @@ static int imx8mq_clocks_probe(struct platform_device *pdev)
 
 	/*
 	 * DRAM clocks are manipulated from TF-A outside clock framework.
-	 * Mark with GET_RATE_NOCACHE to always read div value from hardware
+	 * The fw_managed helper sets GET_RATE_NOCACHE and clears SET_PARENT_GATE
+	 * as div value should always be read from hardware
 	 */
 	hws[IMX8MQ_CLK_DRAM_CORE] = imx_clk_hw_mux2_flags("dram_core_clk", base + 0x9800, 24, 1, imx8mq_dram_core_sels, ARRAY_SIZE(imx8mq_dram_core_sels), CLK_IS_CRITICAL);
-	hws[IMX8MQ_CLK_DRAM_ALT] = __imx8m_clk_hw_composite("dram_alt", imx8mq_dram_alt_sels, base + 0xa000, CLK_GET_RATE_NOCACHE);
-	hws[IMX8MQ_CLK_DRAM_APB] = __imx8m_clk_hw_composite("dram_apb", imx8mq_dram_apb_sels, base + 0xa080, CLK_IS_CRITICAL | CLK_GET_RATE_NOCACHE);
+	hws[IMX8MQ_CLK_DRAM_ALT] = imx8m_clk_hw_fw_managed_composite("dram_alt", imx8mq_dram_alt_sels, base + 0xa000);
+	hws[IMX8MQ_CLK_DRAM_APB] = imx8m_clk_hw_fw_managed_composite_critical("dram_apb", imx8mq_dram_apb_sels, base + 0xa080);
 
 	/* IP */
 	hws[IMX8MQ_CLK_VPU_G1] = imx8m_clk_hw_composite("vpu_g1", imx8mq_vpu_g1_sels, base + 0xa100);
diff --git a/drivers/clk/imx/clk.h b/drivers/clk/imx/clk.h
index f04cbbab9fcc..c66e00e87711 100644
--- a/drivers/clk/imx/clk.h
+++ b/drivers/clk/imx/clk.h
@@ -533,8 +533,9 @@ struct clk_hw *imx_clk_hw_cpu(const char *name, const char *parent_name,
 		struct clk *div, struct clk *mux, struct clk *pll,
 		struct clk *step);
 
-#define IMX_COMPOSITE_CORE	BIT(0)
-#define IMX_COMPOSITE_BUS	BIT(1)
+#define IMX_COMPOSITE_CORE		BIT(0)
+#define IMX_COMPOSITE_BUS		BIT(1)
+#define IMX_COMPOSITE_FW_MANAGED	BIT(2)
 
 struct clk_hw *imx8m_clk_hw_composite_flags(const char *name,
 					    const char * const *parent_names,
@@ -570,6 +571,17 @@ struct clk_hw *imx8m_clk_hw_composite_flags(const char *name,
 		ARRAY_SIZE(parent_names), reg, 0, \
 		flags | CLK_SET_RATE_NO_REPARENT | CLK_OPS_PARENT_ENABLE)
 
+#define __imx8m_clk_hw_fw_managed_composite(name, parent_names, reg, flags) \
+	imx8m_clk_hw_composite_flags(name, parent_names, \
+		ARRAY_SIZE(parent_names), reg, IMX_COMPOSITE_FW_MANAGED, \
+		flags | CLK_GET_RATE_NOCACHE | CLK_SET_RATE_NO_REPARENT | CLK_OPS_PARENT_ENABLE)
+
+#define imx8m_clk_hw_fw_managed_composite(name, parent_names, reg) \
+	__imx8m_clk_hw_fw_managed_composite(name, parent_names, reg, 0)
+
+#define imx8m_clk_hw_fw_managed_composite_critical(name, parent_names, reg) \
+	__imx8m_clk_hw_fw_managed_composite(name, parent_names, reg, CLK_IS_CRITICAL)
+
 #define __imx8m_clk_composite(name, parent_names, reg, flags) \
 	to_clk(__imx8m_clk_hw_composite(name, parent_names, reg, flags))
 
-- 
2.30.2



