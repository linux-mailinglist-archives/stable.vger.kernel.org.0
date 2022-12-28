Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB44657DC6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbiL1Pqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiL1Pqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:46:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934A315811
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:46:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 265A66155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387C6C433EF;
        Wed, 28 Dec 2022 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242389;
        bh=QfUaT42pzPMS2vKzNr+C9o1BvtAlEyXwVjTQ+USMG7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QugZ2FJMFib+Ao63xi3yWUfRwbrssBdDoz6ilQnHAAh1ZkeEtdL/8P82CUISkzhGB
         a+pNQec5DuEPY2eK+bsHQdaor0ULfUEZdBSf3/isDCVS0yn8jWcgHmRAw2tYMsy3h+
         VqqCrMvHZtuGsebc23F7+xsk2acU/URZST/JzE9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0364/1146] clk: imx93: correct the flexspi1 clock setting
Date:   Wed, 28 Dec 2022 15:31:43 +0100
Message-Id: <20221228144340.053897616@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 62dfdbcc16e767b91ed35d4fc0428c86d4688505 ]

Correct IMX93_CLK_FLEXSPI1_GATE CCGR setting. Otherwise the flexspi
always can't be assigned to a parent clock when dump the clock tree.

Fixes: 24defbe194b6 ("clk: imx: add i.MX93 clk")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/1666589199-1199-1-git-send-email-haibo.chen@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index 99cff1fd108b..40ecee3b5e78 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -170,7 +170,7 @@ static const struct imx93_clk_ccgr {
 	{ IMX93_CLK_MU2_B_GATE,		"mu2_b",	"bus_wakeup_root",	0x8500, 0, &share_count_mub },
 	{ IMX93_CLK_EDMA1_GATE,		"edma1",	"m33_root",		0x8540, },
 	{ IMX93_CLK_EDMA2_GATE,		"edma2",	"wakeup_axi_root",	0x8580, },
-	{ IMX93_CLK_FLEXSPI1_GATE,	"flexspi",	"flexspi_root",		0x8640, },
+	{ IMX93_CLK_FLEXSPI1_GATE,	"flexspi1",	"flexspi1_root",	0x8640, },
 	{ IMX93_CLK_GPIO1_GATE,		"gpio1",	"m33_root",		0x8880, },
 	{ IMX93_CLK_GPIO2_GATE,		"gpio2",	"bus_wakeup_root",	0x88c0, },
 	{ IMX93_CLK_GPIO3_GATE,		"gpio3",	"bus_wakeup_root",	0x8900, },
-- 
2.35.1



