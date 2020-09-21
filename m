Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1E2272F41
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgIUQpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbgIUQpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1728723998;
        Mon, 21 Sep 2020 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706718;
        bh=z/ffxFJFSkBTieCOO7Z4rdWZaAoFjf95X+Dji5IxViM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXWoi9evuMFQaqS6ahHThJA17i6HDNJgdEzUmkihLW/vXoJGblDDgk8q8bu7QlEBg
         METxMeUDmZSsVllyVaehzeecSrPAX84lJhGF2dYrD+8/9YH4WTuUiYUawWkwWOtgwk
         XtrWOWjqPZEhG4ve2oa6w5OEreQOTGKABNLwn/W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 067/118] drm/mediatek: Use CPU when fail to get cmdq event
Date:   Mon, 21 Sep 2020 18:27:59 +0200
Message-Id: <20200921162039.465490829@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chun-Kuang Hu <chunkuang.hu@kernel.org>

[ Upstream commit f85acdad07fe36b91f2244263a890bf372528326 ]

Even though cmdq client is created successfully, without the cmdq event,
cmdq could not work correctly, so use CPU when fail to get cmdq event.

Fixes: 60fa8c13ab1a ("drm/mediatek: Move gce event property to mutex device node")
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index 7cd8f415fd029..d8b43500f12d1 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -834,13 +834,19 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 			drm_crtc_index(&mtk_crtc->base));
 		mtk_crtc->cmdq_client = NULL;
 	}
-	ret = of_property_read_u32_index(priv->mutex_node,
-					 "mediatek,gce-events",
-					 drm_crtc_index(&mtk_crtc->base),
-					 &mtk_crtc->cmdq_event);
-	if (ret)
-		dev_dbg(dev, "mtk_crtc %d failed to get mediatek,gce-events property\n",
-			drm_crtc_index(&mtk_crtc->base));
+
+	if (mtk_crtc->cmdq_client) {
+		ret = of_property_read_u32_index(priv->mutex_node,
+						 "mediatek,gce-events",
+						 drm_crtc_index(&mtk_crtc->base),
+						 &mtk_crtc->cmdq_event);
+		if (ret) {
+			dev_dbg(dev, "mtk_crtc %d failed to get mediatek,gce-events property\n",
+				drm_crtc_index(&mtk_crtc->base));
+			cmdq_mbox_destroy(mtk_crtc->cmdq_client);
+			mtk_crtc->cmdq_client = NULL;
+		}
+	}
 #endif
 	return 0;
 }
-- 
2.25.1



