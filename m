Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A167246BC1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388176AbgHQQCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388185AbgHQQCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:02:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A1D1206FA;
        Mon, 17 Aug 2020 16:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680138;
        bh=r5rm6ll5WBmlFIdky0kzG2SWcqXv1LKcGX9ms3WduZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/Y/8jGCH0pebUECGHX7pMQnhxjVAQBivm5VwV5f6ck3Abdmeuw072uFFen0rt5t2
         x9kKPlcsuwOimGMBXpzKLmimXwKO94KaQ6dECGjJGJ1P5nK36Rcsueyyzlht1xfoEw
         q3YxDPWHJ81RjwlSD0ZeOjUtG/be9XKN6D/VF3bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/270] drm/etnaviv: fix ref count leak via pm_runtime_get_sync
Date:   Mon, 17 Aug 2020 17:14:21 +0200
Message-Id: <20200817143758.755558350@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit c5d5a32ead1e3a61a07a1e59eb52a53e4a6b2a7f ]

in etnaviv_gpu_submit, etnaviv_gpu_recover_hang, etnaviv_gpu_debugfs,
and etnaviv_gpu_init the call to pm_runtime_get_sync increments the
counter even in case of failure, leading to incorrect ref count.
In case of failure, decrement the ref count before returning.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index d47d1a8e02198..8a26ea2a53348 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -713,7 +713,7 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 	ret = pm_runtime_get_sync(gpu->dev);
 	if (ret < 0) {
 		dev_err(gpu->dev, "Failed to enable GPU power domain\n");
-		return ret;
+		goto pm_put;
 	}
 
 	etnaviv_hw_identify(gpu);
@@ -802,6 +802,7 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 
 fail:
 	pm_runtime_mark_last_busy(gpu->dev);
+pm_put:
 	pm_runtime_put_autosuspend(gpu->dev);
 
 	return ret;
@@ -842,7 +843,7 @@ int etnaviv_gpu_debugfs(struct etnaviv_gpu *gpu, struct seq_file *m)
 
 	ret = pm_runtime_get_sync(gpu->dev);
 	if (ret < 0)
-		return ret;
+		goto pm_put;
 
 	dma_lo = gpu_read(gpu, VIVS_FE_DMA_LOW);
 	dma_hi = gpu_read(gpu, VIVS_FE_DMA_HIGH);
@@ -965,6 +966,7 @@ int etnaviv_gpu_debugfs(struct etnaviv_gpu *gpu, struct seq_file *m)
 	ret = 0;
 
 	pm_runtime_mark_last_busy(gpu->dev);
+pm_put:
 	pm_runtime_put_autosuspend(gpu->dev);
 
 	return ret;
@@ -978,7 +980,7 @@ void etnaviv_gpu_recover_hang(struct etnaviv_gpu *gpu)
 	dev_err(gpu->dev, "recover hung GPU!\n");
 
 	if (pm_runtime_get_sync(gpu->dev) < 0)
-		return;
+		goto pm_put;
 
 	mutex_lock(&gpu->lock);
 
@@ -997,6 +999,7 @@ void etnaviv_gpu_recover_hang(struct etnaviv_gpu *gpu)
 
 	mutex_unlock(&gpu->lock);
 	pm_runtime_mark_last_busy(gpu->dev);
+pm_put:
 	pm_runtime_put_autosuspend(gpu->dev);
 }
 
@@ -1269,8 +1272,10 @@ struct dma_fence *etnaviv_gpu_submit(struct etnaviv_gem_submit *submit)
 
 	if (!submit->runtime_resumed) {
 		ret = pm_runtime_get_sync(gpu->dev);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put_noidle(gpu->dev);
 			return NULL;
+		}
 		submit->runtime_resumed = true;
 	}
 
@@ -1287,6 +1292,7 @@ struct dma_fence *etnaviv_gpu_submit(struct etnaviv_gem_submit *submit)
 	ret = event_alloc(gpu, nr_events, event);
 	if (ret) {
 		DRM_ERROR("no free events\n");
+		pm_runtime_put_noidle(gpu->dev);
 		return NULL;
 	}
 
-- 
2.25.1



