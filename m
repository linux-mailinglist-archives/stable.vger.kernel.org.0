Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEBB5941FD
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348883AbiHOVmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349628AbiHOVle (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:41:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5D95C364;
        Mon, 15 Aug 2022 12:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A7E6102C;
        Mon, 15 Aug 2022 19:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA05FC433C1;
        Mon, 15 Aug 2022 19:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591759;
        bh=S/IeTTpq9OkUlxtTdQuqOhWlh09dKfkjc/hnIhRR/+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpkRZukCgiZjmRSYgy2EApCLxedWdtyKX836L7h9nrHawv1okm1W4tDAaC/18Enh8
         V+S8piW9RXKFH35mVrpW3WvNVSaqv3STo29X02kqpH8Biq9N0FpEmHcGxP51rZoa+r
         ZRWKeEy525w+jWf2B0tLuIiut0UJFUMIGmzIKYDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0677/1095] clk: imx93: correct nic_media parent
Date:   Mon, 15 Aug 2022 20:01:16 +0200
Message-Id: <20220815180457.380104104@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



