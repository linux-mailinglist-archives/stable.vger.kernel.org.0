Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029F66041B4
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiJSKrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiJSKqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:46:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A44CDD887;
        Wed, 19 Oct 2022 03:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9F3BB8244D;
        Wed, 19 Oct 2022 09:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F58C433D6;
        Wed, 19 Oct 2022 09:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170035;
        bh=K97j+I7L9AaRvIOBnMiDgOiubOBBSINEGKUsqgcayO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6ePb1g2+4lEMC8gQt5NON75X8E7AJO7DpIVeUff/TOuRF2f9lg7GM7LKI0KjtT7E
         beM2pUaer7aCW0E+t0SqucA/4mwsGpmMYHAViV8o86lyE8e0FSH0S9C1ucI8acd1+5
         U0aGbcek5xwS2I08unJZRsPdemuVZurFMnZwUXbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 502/862] clk: mediatek: mt8195-infra_ao: Set pwrmcu clocks as critical
Date:   Wed, 19 Oct 2022 10:29:49 +0200
Message-Id: <20221019083312.178174715@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 3f10f49cd9f8ab6471639d4ca2c6db9451121779 ]

The pwrmcu is responsible for power management and idle states in SSPM:
on older SoCs this was managed in Linux drivers like sspm/mcupm/eemgpu
but, at least on MT8195, this functionality was transferred to the ATF
firmware.
For this reason, turning off the pwrmcu related clocks from the kernel
will lead to unability to resume the platform after suspend and other
currently unknown PM related side-effects.

Set the PWRMCU and PWRMCU_BUS_H clocks as critical to prevent the
kernel from turning them off, fixing the aforementioned issue.

Fixes: e2edf59dec0b ("clk: mediatek: Add MT8195 infrastructure clock support")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220719093316.37253-1-angelogioacchino.delregno@collabora.com
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8195-infra_ao.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mt8195-infra_ao.c b/drivers/clk/mediatek/clk-mt8195-infra_ao.c
index 97657f255618..832160c92996 100644
--- a/drivers/clk/mediatek/clk-mt8195-infra_ao.c
+++ b/drivers/clk/mediatek/clk-mt8195-infra_ao.c
@@ -55,8 +55,12 @@ static const struct mtk_gate_regs infra_ao4_cg_regs = {
 #define GATE_INFRA_AO1(_id, _name, _parent, _shift)	\
 	GATE_INFRA_AO1_FLAGS(_id, _name, _parent, _shift, 0)
 
+#define GATE_INFRA_AO2_FLAGS(_id, _name, _parent, _shift, _flag)	\
+	GATE_MTK_FLAGS(_id, _name, _parent, &infra_ao2_cg_regs, _shift,	\
+		       &mtk_clk_gate_ops_setclr, _flag)
+
 #define GATE_INFRA_AO2(_id, _name, _parent, _shift)			\
-	GATE_MTK(_id, _name, _parent, &infra_ao2_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
+	GATE_INFRA_AO2_FLAGS(_id, _name, _parent, _shift, 0)
 
 #define GATE_INFRA_AO3_FLAGS(_id, _name, _parent, _shift, _flag)		\
 	GATE_MTK_FLAGS(_id, _name, _parent, &infra_ao3_cg_regs, _shift,	\
@@ -136,8 +140,11 @@ static const struct mtk_gate infra_ao_clks[] = {
 	GATE_INFRA_AO2(CLK_INFRA_AO_UNIPRO_SYS, "infra_ao_unipro_sys", "top_ufs", 11),
 	GATE_INFRA_AO2(CLK_INFRA_AO_UNIPRO_TICK, "infra_ao_unipro_tick", "top_ufs_tick1us", 12),
 	GATE_INFRA_AO2(CLK_INFRA_AO_UFS_MP_SAP_B, "infra_ao_ufs_mp_sap_b", "top_ufs_mp_sap_cfg", 13),
-	GATE_INFRA_AO2(CLK_INFRA_AO_PWRMCU, "infra_ao_pwrmcu", "top_pwrmcu", 15),
-	GATE_INFRA_AO2(CLK_INFRA_AO_PWRMCU_BUS_H, "infra_ao_pwrmcu_bus_h", "top_axi", 17),
+	/* pwrmcu is used by ATF for platform PM: clocks must never be disabled by the kernel */
+	GATE_INFRA_AO2_FLAGS(CLK_INFRA_AO_PWRMCU, "infra_ao_pwrmcu", "top_pwrmcu", 15,
+			     CLK_IS_CRITICAL),
+	GATE_INFRA_AO2_FLAGS(CLK_INFRA_AO_PWRMCU_BUS_H, "infra_ao_pwrmcu_bus_h", "top_axi", 17,
+			     CLK_IS_CRITICAL),
 	GATE_INFRA_AO2(CLK_INFRA_AO_APDMA_B, "infra_ao_apdma_b", "top_axi", 18),
 	GATE_INFRA_AO2(CLK_INFRA_AO_SPI4, "infra_ao_spi4", "top_spi", 25),
 	GATE_INFRA_AO2(CLK_INFRA_AO_SPI5, "infra_ao_spi5", "top_spi", 26),
-- 
2.35.1



