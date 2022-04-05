Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8778E4F372D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346632AbiDELKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348911AbiDEJsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB18ED9E5;
        Tue,  5 Apr 2022 02:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E66961368;
        Tue,  5 Apr 2022 09:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AC1C385A0;
        Tue,  5 Apr 2022 09:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151436;
        bh=XDVEjUMqTpwWEOMlL/Q2oJIgCZcnl9tgaB3ynEV6gtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjGKHMQEULu8CLvx0ygdz4vZlN9DnpdXCPT3WYihqmbkgjmgCFL9TOZb8kbsIbBD4
         xdFEm4ponhDsJ05zSOJySQoSO4D9TGENv4M5MYRKJkGcLiKTZyfCiA/kssdJ9NpgwI
         Y02QlirCneiSAvqpUrpYxlvJ/gWEECPCbPIZthbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cai Huoqing <caihuoqing@baidu.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 375/913] drm/meson: Make use of the helper function devm_platform_ioremap_resourcexxx()
Date:   Tue,  5 Apr 2022 09:23:57 +0200
Message-Id: <20220405070351.088604519@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Cai Huoqing <caihuoqing@baidu.com>

[ Upstream commit d4cb82aa2e4bc0e46582a625cb41b64c83fdde49 ]

Use the devm_platform_ioremap_resource_byname() helper instead of
calling platform_get_resource_byname() and devm_ioremap_resource()
separately

Use the devm_platform_ioremap_resource() helper instead of
calling platform_get_resource() and devm_ioremap_resource()
separately

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210831135644.4576-1-caihuoqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c     | 3 +--
 drivers/gpu/drm/meson/meson_dw_hdmi.c | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 62846af2f5e5..923377f856de 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -206,8 +206,7 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 	priv->compat = match->compat;
 	priv->afbcd.ops = match->afbcd_ops;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vpu");
-	regs = devm_ioremap_resource(dev, res);
+	regs = devm_platform_ioremap_resource_byname(pdev, "vpu");
 	if (IS_ERR(regs)) {
 		ret = PTR_ERR(regs);
 		goto free_drm;
diff --git a/drivers/gpu/drm/meson/meson_dw_hdmi.c b/drivers/gpu/drm/meson/meson_dw_hdmi.c
index 2ed87cfdd735..0afbd1e70bfc 100644
--- a/drivers/gpu/drm/meson/meson_dw_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_dw_hdmi.c
@@ -978,7 +978,6 @@ static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 	struct dw_hdmi_plat_data *dw_plat_data;
 	struct drm_bridge *next_bridge;
 	struct drm_encoder *encoder;
-	struct resource *res;
 	int irq;
 	int ret;
 
@@ -1042,8 +1041,7 @@ static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 		return PTR_ERR(meson_dw_hdmi->hdmitx_phy);
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	meson_dw_hdmi->hdmitx = devm_ioremap_resource(dev, res);
+	meson_dw_hdmi->hdmitx = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(meson_dw_hdmi->hdmitx))
 		return PTR_ERR(meson_dw_hdmi->hdmitx);
 
-- 
2.34.1



