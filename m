Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE56954913B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376704AbiFMN0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376422AbiFMNYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:24:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337F06C0DC;
        Mon, 13 Jun 2022 04:24:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E2B961034;
        Mon, 13 Jun 2022 11:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7105C341C6;
        Mon, 13 Jun 2022 11:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119460;
        bh=kASKjZT5YezjwioLLpLa2+thzfwlw4qcZGDgQHwSUk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoitIuHWT+4AeS7PEkybxozEFZOnAfhAmSw/KFy4/CpdE7SaTbmWTqoLRDKKJ4Zs0
         RqgoqP8ghbllVcy0VNZof6fZcecSGUjoeQLWtcSslAHpbNFCtSHXFNjRelUVfXhIPG
         3J62+c62n8Abc4CSoOL+OzBPAIKRSwVNEhWej3y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tinghan Shen <tinghan.shen@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 005/339] remoteproc: mediatek: Fix side effect of mt8195 sram power on
Date:   Mon, 13 Jun 2022 12:07:10 +0200
Message-Id: <20220613094926.669006623@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tinghan Shen <tinghan.shen@mediatek.com>

[ Upstream commit f20e232d74ee0ace386be0b7db1ff993ea69b4c4 ]

The definition of L1TCM_SRAM_PDN bits on mt8195 is different to mt8192.

L1TCM_SRAM_PDN bits[3:0] control the power of mt8195 L1TCM SRAM.

L1TCM_SRAM_PDN bits[7:4] control the access path to EMI for SCP.
These bits have to be powered on to allow EMI access for SCP.

Bits[7:4] also affect audio DSP because audio DSP and SCP are
placed on the same hardware bus. If SCP cannot access EMI, audio DSP is
blocked too.

L1TCM_SRAM_PDN bits[31:8] are not used.

This fix removes modification of bits[7:4] when power on/off mt8195 SCP
L1TCM. It's because the modification introduces a short period of time
blocking audio DSP to access EMI. This was not a problem until we have
to load both SCP module and audio DSP module. audio DSP needs to access
EMI because it has source/data on DRAM. Audio DSP will have unexpected
behavior when it accesses EMI and the SCP driver blocks the EMI path at
the same time.

Fixes: 79111df414fc ("remoteproc: mediatek: Support mt8195 scp")
Signed-off-by: Tinghan Shen <tinghan.shen@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20220321060340.10975-1-tinghan.shen@mediatek.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_common.h |  2 +
 drivers/remoteproc/mtk_scp.c    | 69 +++++++++++++++++++++++++--------
 2 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/drivers/remoteproc/mtk_common.h b/drivers/remoteproc/mtk_common.h
index 71ce4977cb0b..ea6fa1100a00 100644
--- a/drivers/remoteproc/mtk_common.h
+++ b/drivers/remoteproc/mtk_common.h
@@ -54,6 +54,8 @@
 #define MT8192_CORE0_WDT_IRQ		0x10030
 #define MT8192_CORE0_WDT_CFG		0x10034
 
+#define MT8195_L1TCM_SRAM_PDN_RESERVED_RSI_BITS		GENMASK(7, 4)
+
 #define SCP_FW_VER_LEN			32
 #define SCP_SHARE_BUFFER_SIZE		288
 
diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index 38609153bf64..ee6c4009586e 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -365,22 +365,22 @@ static int mt8183_scp_before_load(struct mtk_scp *scp)
 	return 0;
 }
 
-static void mt8192_power_on_sram(void __iomem *addr)
+static void scp_sram_power_on(void __iomem *addr, u32 reserved_mask)
 {
 	int i;
 
 	for (i = 31; i >= 0; i--)
-		writel(GENMASK(i, 0), addr);
+		writel(GENMASK(i, 0) & ~reserved_mask, addr);
 	writel(0, addr);
 }
 
-static void mt8192_power_off_sram(void __iomem *addr)
+static void scp_sram_power_off(void __iomem *addr, u32 reserved_mask)
 {
 	int i;
 
 	writel(0, addr);
 	for (i = 0; i < 32; i++)
-		writel(GENMASK(i, 0), addr);
+		writel(GENMASK(i, 0) & ~reserved_mask, addr);
 }
 
 static int mt8186_scp_before_load(struct mtk_scp *scp)
@@ -393,7 +393,7 @@ static int mt8186_scp_before_load(struct mtk_scp *scp)
 	writel(0x0, scp->reg_base + MT8183_SCP_CLK_DIV_SEL);
 
 	/* Turn on the power of SCP's SRAM before using it. Enable 1 block per time*/
-	mt8192_power_on_sram(scp->reg_base + MT8183_SCP_SRAM_PDN);
+	scp_sram_power_on(scp->reg_base + MT8183_SCP_SRAM_PDN, 0);
 
 	/* Initialize TCM before loading FW. */
 	writel(0x0, scp->reg_base + MT8183_SCP_L1_SRAM_PD);
@@ -412,11 +412,32 @@ static int mt8192_scp_before_load(struct mtk_scp *scp)
 	writel(1, scp->reg_base + MT8192_CORE0_SW_RSTN_SET);
 
 	/* enable SRAM clock */
-	mt8192_power_on_sram(scp->reg_base + MT8192_L2TCM_SRAM_PD_0);
-	mt8192_power_on_sram(scp->reg_base + MT8192_L2TCM_SRAM_PD_1);
-	mt8192_power_on_sram(scp->reg_base + MT8192_L2TCM_SRAM_PD_2);
-	mt8192_power_on_sram(scp->reg_base + MT8192_L1TCM_SRAM_PDN);
-	mt8192_power_on_sram(scp->reg_base + MT8192_CPU0_SRAM_PD);
+	scp_sram_power_on(scp->reg_base + MT8192_L2TCM_SRAM_PD_0, 0);
+	scp_sram_power_on(scp->reg_base + MT8192_L2TCM_SRAM_PD_1, 0);
+	scp_sram_power_on(scp->reg_base + MT8192_L2TCM_SRAM_PD_2, 0);
+	scp_sram_power_on(scp->reg_base + MT8192_L1TCM_SRAM_PDN, 0);
+	scp_sram_power_on(scp->reg_base + MT8192_CPU0_SRAM_PD, 0);
+
+	/* enable MPU for all memory regions */
+	writel(0xff, scp->reg_base + MT8192_CORE0_MEM_ATT_PREDEF);
+
+	return 0;
+}
+
+static int mt8195_scp_before_load(struct mtk_scp *scp)
+{
+	/* clear SPM interrupt, SCP2SPM_IPC_CLR */
+	writel(0xff, scp->reg_base + MT8192_SCP2SPM_IPC_CLR);
+
+	writel(1, scp->reg_base + MT8192_CORE0_SW_RSTN_SET);
+
+	/* enable SRAM clock */
+	scp_sram_power_on(scp->reg_base + MT8192_L2TCM_SRAM_PD_0, 0);
+	scp_sram_power_on(scp->reg_base + MT8192_L2TCM_SRAM_PD_1, 0);
+	scp_sram_power_on(scp->reg_base + MT8192_L2TCM_SRAM_PD_2, 0);
+	scp_sram_power_on(scp->reg_base + MT8192_L1TCM_SRAM_PDN,
+			  MT8195_L1TCM_SRAM_PDN_RESERVED_RSI_BITS);
+	scp_sram_power_on(scp->reg_base + MT8192_CPU0_SRAM_PD, 0);
 
 	/* enable MPU for all memory regions */
 	writel(0xff, scp->reg_base + MT8192_CORE0_MEM_ATT_PREDEF);
@@ -572,11 +593,25 @@ static void mt8183_scp_stop(struct mtk_scp *scp)
 static void mt8192_scp_stop(struct mtk_scp *scp)
 {
 	/* Disable SRAM clock */
-	mt8192_power_off_sram(scp->reg_base + MT8192_L2TCM_SRAM_PD_0);
-	mt8192_power_off_sram(scp->reg_base + MT8192_L2TCM_SRAM_PD_1);
-	mt8192_power_off_sram(scp->reg_base + MT8192_L2TCM_SRAM_PD_2);
-	mt8192_power_off_sram(scp->reg_base + MT8192_L1TCM_SRAM_PDN);
-	mt8192_power_off_sram(scp->reg_base + MT8192_CPU0_SRAM_PD);
+	scp_sram_power_off(scp->reg_base + MT8192_L2TCM_SRAM_PD_0, 0);
+	scp_sram_power_off(scp->reg_base + MT8192_L2TCM_SRAM_PD_1, 0);
+	scp_sram_power_off(scp->reg_base + MT8192_L2TCM_SRAM_PD_2, 0);
+	scp_sram_power_off(scp->reg_base + MT8192_L1TCM_SRAM_PDN, 0);
+	scp_sram_power_off(scp->reg_base + MT8192_CPU0_SRAM_PD, 0);
+
+	/* Disable SCP watchdog */
+	writel(0, scp->reg_base + MT8192_CORE0_WDT_CFG);
+}
+
+static void mt8195_scp_stop(struct mtk_scp *scp)
+{
+	/* Disable SRAM clock */
+	scp_sram_power_off(scp->reg_base + MT8192_L2TCM_SRAM_PD_0, 0);
+	scp_sram_power_off(scp->reg_base + MT8192_L2TCM_SRAM_PD_1, 0);
+	scp_sram_power_off(scp->reg_base + MT8192_L2TCM_SRAM_PD_2, 0);
+	scp_sram_power_off(scp->reg_base + MT8192_L1TCM_SRAM_PDN,
+			   MT8195_L1TCM_SRAM_PDN_RESERVED_RSI_BITS);
+	scp_sram_power_off(scp->reg_base + MT8192_CPU0_SRAM_PD, 0);
 
 	/* Disable SCP watchdog */
 	writel(0, scp->reg_base + MT8192_CORE0_WDT_CFG);
@@ -922,11 +957,11 @@ static const struct mtk_scp_of_data mt8192_of_data = {
 
 static const struct mtk_scp_of_data mt8195_of_data = {
 	.scp_clk_get = mt8195_scp_clk_get,
-	.scp_before_load = mt8192_scp_before_load,
+	.scp_before_load = mt8195_scp_before_load,
 	.scp_irq_handler = mt8192_scp_irq_handler,
 	.scp_reset_assert = mt8192_scp_reset_assert,
 	.scp_reset_deassert = mt8192_scp_reset_deassert,
-	.scp_stop = mt8192_scp_stop,
+	.scp_stop = mt8195_scp_stop,
 	.scp_da_to_va = mt8192_scp_da_to_va,
 	.host_to_scp_reg = MT8192_GIPC_IN_SET,
 	.host_to_scp_int_bit = MT8192_HOST_IPC_INT_BIT,
-- 
2.35.1



