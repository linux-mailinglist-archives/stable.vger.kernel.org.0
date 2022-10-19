Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25B1604405
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiJSL4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiJSLzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:55:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950B3BC5;
        Wed, 19 Oct 2022 04:34:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 39B5BCE2169;
        Wed, 19 Oct 2022 09:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B123C433D6;
        Wed, 19 Oct 2022 09:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170288;
        bh=hKTO3ckIBTXb4I4DS2/kQuJdu1VH4R9jTa0t7jwGJUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTpXhf5qBbJ3oogIfgLmC9yDqWtn4G0G6MWCJPfn+sNcom1C2ZjTTw5H6YyWy5w4s
         ZNO7bWZcPpI74v+3qeYp1oLkHDLjs8yLL/1CmlzPMN199GaWRlbEVlz+RV2MnX6qmo
         3Pu5OqdaUyyjtAQXFQS2crB7lmhgjjSyPwh+WPPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Li <ye.li@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 597/862] clk: imx8mp: tune the order of enet_qos_root_clk
Date:   Wed, 19 Oct 2022 10:31:24 +0200
Message-Id: <20221019083316.351549397@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit c68cd258a67730c24566b9688d7c134e67459ac6 ]

The enet_qos_root_clk takes sim_enet_root_clk as parent. When
registering enet_qos_root_clk, it will be put into clk orphan list,
because sim_enet_root_clk is not ready.

When sim_enet_root_clk is ready, clk_core_reparent_orphans_nolock will
set enet_qos_root_clk parent to sim_enet_root_clk.

Because CLK_OPS_PARENT_ENABLE is set, sim_enet_root_clk will be
enabled and disabled during the enet_qos_root_clk reparent phase.

All the above are correct. But with M7 booted early and using
enet, M7 enet feature will be broken, because clk driver probe phase
disable the needed clks, in case M7 firmware not configure
sim_enet_root_clk.

And tune the order would also save cpu cycles.

Reviewed-by: Ye Li <ye.li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20220815013428.476015-1-peng.fan@oss.nxp.com
Stable-dep-of: 855ae87a2073 ("clk: imx: scu: fix memleak on platform_device_add() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index e89db568f5a8..652ae58c2735 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -665,8 +665,8 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_CLK_CAN1_ROOT] = imx_clk_hw_gate2("can1_root_clk", "can1", ccm_base + 0x4350, 0);
 	hws[IMX8MP_CLK_CAN2_ROOT] = imx_clk_hw_gate2("can2_root_clk", "can2", ccm_base + 0x4360, 0);
 	hws[IMX8MP_CLK_SDMA1_ROOT] = imx_clk_hw_gate4("sdma1_root_clk", "ipg_root", ccm_base + 0x43a0, 0);
-	hws[IMX8MP_CLK_ENET_QOS_ROOT] = imx_clk_hw_gate4("enet_qos_root_clk", "sim_enet_root_clk", ccm_base + 0x43b0, 0);
 	hws[IMX8MP_CLK_SIM_ENET_ROOT] = imx_clk_hw_gate4("sim_enet_root_clk", "enet_axi", ccm_base + 0x4400, 0);
+	hws[IMX8MP_CLK_ENET_QOS_ROOT] = imx_clk_hw_gate4("enet_qos_root_clk", "sim_enet_root_clk", ccm_base + 0x43b0, 0);
 	hws[IMX8MP_CLK_GPU2D_ROOT] = imx_clk_hw_gate4("gpu2d_root_clk", "gpu2d_core", ccm_base + 0x4450, 0);
 	hws[IMX8MP_CLK_GPU3D_ROOT] = imx_clk_hw_gate4("gpu3d_root_clk", "gpu3d_core", ccm_base + 0x4460, 0);
 	hws[IMX8MP_CLK_UART1_ROOT] = imx_clk_hw_gate4("uart1_root_clk", "uart1", ccm_base + 0x4490, 0);
-- 
2.35.1



