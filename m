Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2288366C700
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjAPQ1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjAPQ04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:26:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35BC241E4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D465B80E93
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF79DC433F0;
        Mon, 16 Jan 2023 16:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885704;
        bh=7hj+My+ZmdmllQE/aQurLvg1UTWjEsw60JBnmJ4fdzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuXnOHQB+50BpdI82tXTjULac7bOg8KJ1wTteUBNESB07RJRRHo0s6sHdhCjDT70F
         A8kL0AVhNuReDB2ZS5+hf/LWS0UE48Oe+8iwEkOQzucyFYIOL73vCx5hbTWlkGu0aq
         dDD2lnM3Tcz53wJnG8xA7pFZxuSuPoH+SFmOJ0mI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Jun <jun.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 151/658] clk: imx8mn: correct the usb1_ctrl parent to be usb_bus
Date:   Mon, 16 Jan 2023 16:43:59 +0100
Message-Id: <20230116154916.355339437@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Li Jun <jun.li@nxp.com>

[ Upstream commit 134d43bb1ff09a696996f16ed8b28d404b770c8a ]

Per latest imx8mn datasheet of CCM, the parent of usb1_ctrl_root_clk
should be usb_bus.

Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index 882b42efd258..d520a8c5eabb 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -582,7 +582,7 @@ static int imx8mn_clocks_probe(struct platform_device *pdev)
 	clks[IMX8MN_CLK_UART2_ROOT] = imx_clk_gate4("uart2_root_clk", "uart2", base + 0x44a0, 0);
 	clks[IMX8MN_CLK_UART3_ROOT] = imx_clk_gate4("uart3_root_clk", "uart3", base + 0x44b0, 0);
 	clks[IMX8MN_CLK_UART4_ROOT] = imx_clk_gate4("uart4_root_clk", "uart4", base + 0x44c0, 0);
-	clks[IMX8MN_CLK_USB1_CTRL_ROOT] = imx_clk_gate4("usb1_ctrl_root_clk", "usb_core_ref", base + 0x44d0, 0);
+	clks[IMX8MN_CLK_USB1_CTRL_ROOT] = imx_clk_gate4("usb1_ctrl_root_clk", "usb_bus", base + 0x44d0, 0);
 	clks[IMX8MN_CLK_GPU_CORE_ROOT] = imx_clk_gate4("gpu_core_root_clk", "gpu_core_div", base + 0x44f0, 0);
 	clks[IMX8MN_CLK_USDHC1_ROOT] = imx_clk_gate4("usdhc1_root_clk", "usdhc1", base + 0x4510, 0);
 	clks[IMX8MN_CLK_USDHC2_ROOT] = imx_clk_gate4("usdhc2_root_clk", "usdhc2", base + 0x4520, 0);
-- 
2.35.1



