Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC01D272F46
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgIUQz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbgIUQp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B834C2076B;
        Mon, 21 Sep 2020 16:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706726;
        bh=sw/fWsgM3s2NVqfVCcC9QdPZrbGrFpV00b5iqhj5Kug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAlIV26MpY4Cu0dRi5i799rqZ4JCwt9QjzOqpUbt9/lhgr1aRAfN50lL6dLwY67xm
         I9Pgv96rlTgnbQjxDKkuCa3UHnx9f2hbV1PPrq4CMdYh3GQr+VcJGpg7jzpQO8OPtc
         LnWLuB0LF6PwVVv+bq2/ZeZWN+7MJpFBfgRE0ot4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 070/118] drm/mediatek: Add missing put_device() call in mtk_drm_kms_init()
Date:   Mon, 21 Sep 2020 18:28:02 +0200
Message-Id: <20200921162039.589715174@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 2132940f2192824acf160d115192755f7c58a847 ]

if of_find_device_by_node() succeed, mtk_drm_kms_init() doesn't have
a corresponding put_device(). Thus add jump target to fix the exception
handling for this function implementation.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 7ad0433539f45..b77dc36be4224 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -165,7 +165,7 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 
 	ret = drmm_mode_config_init(drm);
 	if (ret)
-		return ret;
+		goto put_mutex_dev;
 
 	drm->mode_config.min_width = 64;
 	drm->mode_config.min_height = 64;
@@ -182,7 +182,7 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 
 	ret = component_bind_all(drm->dev, drm);
 	if (ret)
-		return ret;
+		goto put_mutex_dev;
 
 	/*
 	 * We currently support two fixed data streams, each optional,
@@ -229,7 +229,7 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 	}
 	if (!dma_dev->dma_parms) {
 		ret = -ENOMEM;
-		goto err_component_unbind;
+		goto put_dma_dev;
 	}
 
 	ret = dma_set_max_seg_size(dma_dev, (unsigned int)DMA_BIT_MASK(32));
@@ -256,9 +256,12 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 err_unset_dma_parms:
 	if (private->dma_parms_allocated)
 		dma_dev->dma_parms = NULL;
+put_dma_dev:
+	put_device(private->dma_dev);
 err_component_unbind:
 	component_unbind_all(drm->dev, drm);
-
+put_mutex_dev:
+	put_device(private->mutex_dev);
 	return ret;
 }
 
-- 
2.25.1



