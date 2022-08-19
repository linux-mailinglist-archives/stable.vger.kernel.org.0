Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A3E599F7A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351314AbiHSQHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351432AbiHSQFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAF710BE00;
        Fri, 19 Aug 2022 08:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E722616FD;
        Fri, 19 Aug 2022 15:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17360C433B5;
        Fri, 19 Aug 2022 15:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924506;
        bh=GS1BWbFJARh6QNENN/HRDmTcg2DRzvBQ6icflFq/bEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDACznHNwWioKxmmtONRE/QH9Y69jE2mYS32GUY45zo2aM6y/j+d/9wV+Jst1JHW2
         gnlmpY46VKRS4tcLdpyLvJsFJzMtkcCSom2ywN/Zbk3qKQ4AQf/ECFyFl67G52V8nX
         a1CtNLotMpRdmRY6f5Dss3+wT6+Tu1WjKyzK8+o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/545] drm/vc4: drv: Remove the DSI pointer in vc4_drv
Date:   Fri, 19 Aug 2022 17:39:23 +0200
Message-Id: <20220819153837.998234535@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 51f4fcd9c4ea867c3b4fe58111f342ad0e80642a ]

That pointer isn't used anywhere, so there's no point in keeping it.

Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20201203132543.861591-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.h | 1 -
 drivers/gpu/drm/vc4/vc4_dsi.c | 9 ---------
 2 files changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.h b/drivers/gpu/drm/vc4/vc4_drv.h
index 9809c3a856c6..921463625d82 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -77,7 +77,6 @@ struct vc4_dev {
 	struct vc4_hvs *hvs;
 	struct vc4_v3d *v3d;
 	struct vc4_dpi *dpi;
-	struct vc4_dsi *dsi1;
 	struct vc4_vec *vec;
 	struct vc4_txp *txp;
 
diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index 153ad9048db5..6222e4058c85 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -1449,7 +1449,6 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct drm_device *drm = dev_get_drvdata(master);
-	struct vc4_dev *vc4 = to_vc4_dev(drm);
 	struct vc4_dsi *dsi = dev_get_drvdata(dev);
 	struct vc4_dsi_encoder *vc4_dsi_encoder;
 	struct drm_panel *panel;
@@ -1602,9 +1601,6 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 	if (ret)
 		return ret;
 
-	if (dsi->port == 1)
-		vc4->dsi1 = dsi;
-
 	drm_simple_encoder_init(drm, dsi->encoder, DRM_MODE_ENCODER_DSI);
 	drm_encoder_helper_add(dsi->encoder, &vc4_dsi_encoder_helper_funcs);
 
@@ -1633,8 +1629,6 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 static void vc4_dsi_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
-	struct vc4_dev *vc4 = to_vc4_dev(drm);
 	struct vc4_dsi *dsi = dev_get_drvdata(dev);
 
 	if (dsi->bridge)
@@ -1646,9 +1640,6 @@ static void vc4_dsi_unbind(struct device *dev, struct device *master,
 	 */
 	list_splice_init(&dsi->bridge_chain, &dsi->encoder->bridge_chain);
 	drm_encoder_cleanup(dsi->encoder);
-
-	if (dsi->port == 1)
-		vc4->dsi1 = NULL;
 }
 
 static const struct component_ops vc4_dsi_ops = {
-- 
2.35.1



