Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382454F4032
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382776AbiDEMQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237628AbiDEKdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:33:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FB1DEB97;
        Tue,  5 Apr 2022 03:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDADEB81C8A;
        Tue,  5 Apr 2022 10:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC3BC385A1;
        Tue,  5 Apr 2022 10:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153937;
        bh=nHOg9kX+MbvlIgN8jRKrk4EKwtzKb7SaZy1WfCamDGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbUe8Mgn4Pwnb2UIzepeDf4/pyG/jDFjG9QtzovAOliiWDw2gYUqR1hGOLNyvdPPy
         ELA3UYITxRBJgfLakHM1BZuYfuITZXpZwvnKShdNEDSRgKwdQT5jFdgqveJNHtOsd3
         7CbCNNlGa1s9dG7wUGfGzBGewM5fmmkNtarncLt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wolfe <david.wolfe@nxp.com>,
        Abel Vesa <abel.vesa@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 400/599] clk: imx7d: Remove audio_mclk_root_clk
Date:   Tue,  5 Apr 2022 09:31:34 +0200
Message-Id: <20220405070310.733879929@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abel Vesa <abel.vesa@nxp.com>

[ Upstream commit eccac77ede3946c90143447cdc785dc16aec4b24 ]

The audio_mclk_root_clk was added as a gate with the CCGR121 (0x4790),
but according to the reference manual, there is no such gate. The
CCGR121 belongs to ECSPI2 and it is not shared.

Fixes: 8f6d8094b215b57 ("ARM: imx: add imx7d clk tree support")
Reported-by: David Wolfe <david.wolfe@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20220127141052.1900174-2-abel.vesa@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx7d.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx7d.c b/drivers/clk/imx/clk-imx7d.c
index c4e0f1c07192..3f6fd7ef2a68 100644
--- a/drivers/clk/imx/clk-imx7d.c
+++ b/drivers/clk/imx/clk-imx7d.c
@@ -849,7 +849,6 @@ static void __init imx7d_clocks_init(struct device_node *ccm_node)
 	hws[IMX7D_WDOG4_ROOT_CLK] = imx_clk_hw_gate4("wdog4_root_clk", "wdog_post_div", base + 0x49f0, 0);
 	hws[IMX7D_KPP_ROOT_CLK] = imx_clk_hw_gate4("kpp_root_clk", "ipg_root_clk", base + 0x4aa0, 0);
 	hws[IMX7D_CSI_MCLK_ROOT_CLK] = imx_clk_hw_gate4("csi_mclk_root_clk", "csi_mclk_post_div", base + 0x4490, 0);
-	hws[IMX7D_AUDIO_MCLK_ROOT_CLK] = imx_clk_hw_gate4("audio_mclk_root_clk", "audio_mclk_post_div", base + 0x4790, 0);
 	hws[IMX7D_WRCLK_ROOT_CLK] = imx_clk_hw_gate4("wrclk_root_clk", "wrclk_post_div", base + 0x47a0, 0);
 	hws[IMX7D_USB_CTRL_CLK] = imx_clk_hw_gate4("usb_ctrl_clk", "ahb_root_clk", base + 0x4680, 0);
 	hws[IMX7D_USB_PHY1_CLK] = imx_clk_hw_gate4("usb_phy1_clk", "pll_usb1_main_clk", base + 0x46a0, 0);
-- 
2.34.1



