Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C82B594B6C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244975AbiHPARk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353079AbiHPAQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:16:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85175A1D21;
        Mon, 15 Aug 2022 13:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B91061057;
        Mon, 15 Aug 2022 20:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F964C433D6;
        Mon, 15 Aug 2022 20:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595439;
        bh=S/IeTTpq9OkUlxtTdQuqOhWlh09dKfkjc/hnIhRR/+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snyl39aD7dHZEAYfz+3TyaT3FlYWLc9fl5PurcG3NVOuRLG1PVyNGU0zbfyqTvZ7E
         mdlCnSPqia7mGs/S260LEcPqDrV6q8epLTbmwLOew94+tcloCpz14d00ZvmKERGiO1
         Pdv5fwOPpeIMEl2bm6kWYOEHsZrcmYRanSXzxGNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0722/1157] clk: imx93: correct nic_media parent
Date:   Mon, 15 Aug 2022 20:01:18 +0200
Message-Id: <20220815180508.366052615@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 1e3c837a663e9a12c4afabb3279d18cb5110a8f4 ]

NIC_MEDIA sources from media_axi_root, not media_apb_root.

Fixes: 24defbe194b6 ("clk: imx: add i.MX93 clk")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20220609132902.3504651-3-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index 172cd56c9610..26885bd3971c 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -219,7 +219,7 @@ static const struct imx93_clk_ccgr {
 	{ IMX93_CLK_LCDIF_GATE,		"lcdif",	"media_apb_root",	0x9640, },
 	{ IMX93_CLK_PXP_GATE,		"pxp",		"media_apb_root",	0x9680, },
 	{ IMX93_CLK_ISI_GATE,		"isi",		"media_apb_root",	0x96c0, },
-	{ IMX93_CLK_NIC_MEDIA_GATE,	"nic_media",	"media_apb_root",	0x9700, },
+	{ IMX93_CLK_NIC_MEDIA_GATE,	"nic_media",	"media_axi_root",	0x9700, },
 	{ IMX93_CLK_USB_CONTROLLER_GATE, "usb_controller", "hsio_root",		0x9a00, },
 	{ IMX93_CLK_USB_TEST_60M_GATE,	"usb_test_60m",	"hsio_usb_test_60m_root", 0x9a40, },
 	{ IMX93_CLK_HSIO_TROUT_24M_GATE, "hsio_trout_24m", "osc_24m",		0x9a80, },
-- 
2.35.1



