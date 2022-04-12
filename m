Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D9F4FD1D9
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240720AbiDLHJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352770AbiDLHF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:05:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046A64889B;
        Mon, 11 Apr 2022 23:48:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F3F8B818C8;
        Tue, 12 Apr 2022 06:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C31C385A6;
        Tue, 12 Apr 2022 06:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746121;
        bh=dvOuvkLBEN4EUP6zEmDLAeop9VeIEiE+x9OuTkj65Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyQ0JmpqvH3ifVpbtBKW3Pbim32h/k4LljhwCTTh/rAFpNeKrZvhO3ZzqoEej2GJY
         IM8RmI0u48giiOfsi1DFPLxlzjjVfGr6IFFaDgMT/tpis9u6+2UhgGYAWjYG7aRnbd
         FcfpQWwWdjmwqYYbKAJfQwaepWBlMcbJSP7gDqTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Liu Ying <victor.liu@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/277] drm/imx: dw_hdmi-imx: Fix bailout in error cases of probe
Date:   Tue, 12 Apr 2022 08:29:30 +0200
Message-Id: <20220412062946.869492670@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit e8083acc3f8cc2097917018e947fd4c857f60454 ]

In dw_hdmi_imx_probe(), if error happens after dw_hdmi_probe() returns
successfully, dw_hdmi_remove() should be called where necessary as
bailout.

Fixes: c805ec7eb210 ("drm/imx: dw_hdmi-imx: move initialization into probe")
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220128091944.3831256-1-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/dw_hdmi-imx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/dw_hdmi-imx.c b/drivers/gpu/drm/imx/dw_hdmi-imx.c
index 87428fb23d9f..a2277a0d6d06 100644
--- a/drivers/gpu/drm/imx/dw_hdmi-imx.c
+++ b/drivers/gpu/drm/imx/dw_hdmi-imx.c
@@ -222,6 +222,7 @@ static int dw_hdmi_imx_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	const struct of_device_id *match = of_match_node(dw_hdmi_imx_dt_ids, np);
 	struct imx_hdmi *hdmi;
+	int ret;
 
 	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi)
@@ -243,10 +244,15 @@ static int dw_hdmi_imx_probe(struct platform_device *pdev)
 	hdmi->bridge = of_drm_find_bridge(np);
 	if (!hdmi->bridge) {
 		dev_err(hdmi->dev, "Unable to find bridge\n");
+		dw_hdmi_remove(hdmi->hdmi);
 		return -ENODEV;
 	}
 
-	return component_add(&pdev->dev, &dw_hdmi_imx_ops);
+	ret = component_add(&pdev->dev, &dw_hdmi_imx_ops);
+	if (ret)
+		dw_hdmi_remove(hdmi->hdmi);
+
+	return ret;
 }
 
 static int dw_hdmi_imx_remove(struct platform_device *pdev)
-- 
2.35.1



