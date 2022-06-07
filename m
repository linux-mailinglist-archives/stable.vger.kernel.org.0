Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB025419E4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376958AbiFGV1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378632AbiFGVXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:23:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF111227365;
        Tue,  7 Jun 2022 12:00:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20356B82391;
        Tue,  7 Jun 2022 19:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B44AC34115;
        Tue,  7 Jun 2022 19:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628431;
        bh=JQE7vGWsZRjAHjJ8a52Qhw0oT6wu0apJy95muA6U7Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGI2R57AAnuOEl7v0TCxl23hmIsizYBJ461oUqosp+GsNrejkO8Uejdzp19i/orNp
         510RP5euW+4uyxNbRmmmMTqzuo/uD1jksLfSLX0gAEj3ttxdCqUSPTlFUiZwdz0fN/
         OWWRV8oRwngSOZHN2RLvp8D1Zrbrk1ewmhju5STM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 287/879] drm/mediatek: Fix DPI component detection for MT8192
Date:   Tue,  7 Jun 2022 18:56:45 +0200
Message-Id: <20220607165011.178129155@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit cfab37ff31afcd0f99f3cccbff1f8ffa11e44c00 ]

When support for MT8192 was added, the DPI device was not added to the
list of components to look for. This causes the secondary display
pipeline to not be able to fully bind, and the DRM driver subsequently
defers probing.

Add the DPI device compatible to list of DPI components to fix this.

Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20220225032754.140168-1-wenst@chromium.org/
Fixes: 01365f549c88 ("drm/mediatek: Add support for Mediatek SoC MT8192")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 247c6ff277ef..b0e4e5d68927 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -509,6 +509,8 @@ static const struct of_device_id mtk_ddp_comp_dt_ids[] = {
 	  .data = (void *)MTK_DPI },
 	{ .compatible = "mediatek,mt8183-dpi",
 	  .data = (void *)MTK_DPI },
+	{ .compatible = "mediatek,mt8192-dpi",
+	  .data = (void *)MTK_DPI },
 	{ .compatible = "mediatek,mt2701-dsi",
 	  .data = (void *)MTK_DSI },
 	{ .compatible = "mediatek,mt8173-dsi",
-- 
2.35.1



