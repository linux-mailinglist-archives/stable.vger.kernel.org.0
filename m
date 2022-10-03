Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80065F2993
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiJCHV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiJCHVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:21:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9C148C87;
        Mon,  3 Oct 2022 00:15:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 405F960FA5;
        Mon,  3 Oct 2022 07:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E68C433C1;
        Mon,  3 Oct 2022 07:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781351;
        bh=88y6V89ZhIC2mAYvMvB8/89AVze1JwN4vvrzk+RVBGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsoG1nYBudrUAtc3X2PGMxzMUM4siOtgyvU2QZVqGqPHQChAE5i5K3HeFASt8I6KG
         xg34XtRmOWhNApv0NupgkHD+gVJN+4yz7uc6iG0HQqDwb3IV23kBsgjYCNmkP50M3o
         aJMVaLlSmYpl+2qJSQWtnr6dTCDtFq6/d0rpRJEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Han Xu <han.xu@nxp.com>,
        Fabio Estevam <festevam@denx.de>,
        Abel Vesa <abel.vesa@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 090/101] clk: imx: imx6sx: remove the SET_RATE_PARENT flag for QSPI clocks
Date:   Mon,  3 Oct 2022 09:11:26 +0200
Message-Id: <20221003070726.681219152@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Han Xu <han.xu@nxp.com>

[ Upstream commit b1ff1bfe81e763420afd5f3f25f0b3cbfd97055c ]

There is no dedicate parent clock for QSPI so SET_RATE_PARENT flag
should not be used. For instance, the default parent clock for QSPI is
pll2_bus, which is also the parent clock for quite a few modules, such
as MMDC, once GPMI NAND set clock rate for EDO5 mode can cause system
hang due to pll2_bus rate changed.

Fixes: f1541e15e38e ("clk: imx6sx: Switch to clk_hw based API")
Signed-off-by: Han Xu <han.xu@nxp.com>
Link: https://lore.kernel.org/r/20220915150959.3646702-1-han.xu@nxp.com
Tested-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6sx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx6sx.c b/drivers/clk/imx/clk-imx6sx.c
index fc1bd23d4583..598f3cf4eba4 100644
--- a/drivers/clk/imx/clk-imx6sx.c
+++ b/drivers/clk/imx/clk-imx6sx.c
@@ -280,13 +280,13 @@ static void __init imx6sx_clocks_init(struct device_node *ccm_node)
 	hws[IMX6SX_CLK_SSI3_SEL]           = imx_clk_hw_mux("ssi3_sel",         base + 0x1c,  14,     2,      ssi_sels,          ARRAY_SIZE(ssi_sels));
 	hws[IMX6SX_CLK_SSI2_SEL]           = imx_clk_hw_mux("ssi2_sel",         base + 0x1c,  12,     2,      ssi_sels,          ARRAY_SIZE(ssi_sels));
 	hws[IMX6SX_CLK_SSI1_SEL]           = imx_clk_hw_mux("ssi1_sel",         base + 0x1c,  10,     2,      ssi_sels,          ARRAY_SIZE(ssi_sels));
-	hws[IMX6SX_CLK_QSPI1_SEL]          = imx_clk_hw_mux_flags("qspi1_sel", base + 0x1c,  7, 3, qspi1_sels, ARRAY_SIZE(qspi1_sels), CLK_SET_RATE_PARENT);
+	hws[IMX6SX_CLK_QSPI1_SEL]          = imx_clk_hw_mux("qspi1_sel",        base + 0x1c,  7,      3,      qspi1_sels,        ARRAY_SIZE(qspi1_sels));
 	hws[IMX6SX_CLK_PERCLK_SEL]         = imx_clk_hw_mux("perclk_sel",       base + 0x1c,  6,      1,      perclk_sels,       ARRAY_SIZE(perclk_sels));
 	hws[IMX6SX_CLK_VID_SEL]            = imx_clk_hw_mux("vid_sel",          base + 0x20,  21,     3,      vid_sels,          ARRAY_SIZE(vid_sels));
 	hws[IMX6SX_CLK_ESAI_SEL]           = imx_clk_hw_mux("esai_sel",         base + 0x20,  19,     2,      audio_sels,        ARRAY_SIZE(audio_sels));
 	hws[IMX6SX_CLK_CAN_SEL]            = imx_clk_hw_mux("can_sel",          base + 0x20,  8,      2,      can_sels,          ARRAY_SIZE(can_sels));
 	hws[IMX6SX_CLK_UART_SEL]           = imx_clk_hw_mux("uart_sel",         base + 0x24,  6,      1,      uart_sels,         ARRAY_SIZE(uart_sels));
-	hws[IMX6SX_CLK_QSPI2_SEL]          = imx_clk_hw_mux_flags("qspi2_sel", base + 0x2c, 15, 3, qspi2_sels, ARRAY_SIZE(qspi2_sels), CLK_SET_RATE_PARENT);
+	hws[IMX6SX_CLK_QSPI2_SEL]          = imx_clk_hw_mux("qspi2_sel",        base + 0x2c,  15,     3,      qspi2_sels,        ARRAY_SIZE(qspi2_sels));
 	hws[IMX6SX_CLK_SPDIF_SEL]          = imx_clk_hw_mux("spdif_sel",        base + 0x30,  20,     2,      audio_sels,        ARRAY_SIZE(audio_sels));
 	hws[IMX6SX_CLK_AUDIO_SEL]          = imx_clk_hw_mux("audio_sel",        base + 0x30,  7,      2,      audio_sels,        ARRAY_SIZE(audio_sels));
 	hws[IMX6SX_CLK_ENET_PRE_SEL]       = imx_clk_hw_mux("enet_pre_sel",     base + 0x34,  15,     3,      enet_pre_sels,     ARRAY_SIZE(enet_pre_sels));
-- 
2.35.1



