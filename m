Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EF24123AB
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378807AbhITS0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44429 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378270AbhITSYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A18496140B;
        Mon, 20 Sep 2021 17:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158691;
        bh=eAJfSoPUmGcbBrfoMQCdLBzHWEflbt8dhav77gTZedI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtxtKRLCpak4ZDwYdr2PKdrJv2cXv9A6Dglch1i+rdiH5SbyZw2oAqnlAneQxGsp7
         wmDrdqYbhYSmPBKRxdndLZj8pmWC5/ZPDn/g39U3ncAlw/EfBG0ntBoG9u2xBQ2OeY
         fjqrVHGHtIhoF2zJrSlB/YmY/zLXYxXMyFAtzMU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Michael Walle <michael@walle.cc>, Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.10 012/122] drm/etnaviv: stop abusing mmu_context as FE running marker
Date:   Mon, 20 Sep 2021 18:43:04 +0200
Message-Id: <20210920163916.172113518@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 23e0f5a57d0ecec86e1fc82194acd94aede21a46 upstream.

While the DMA frontend can only be active when the MMU context is set, the
reverse isn't necessarily true, as the frontend can be stopped while the
MMU state is kept. Stop treating mmu_context being set as a indication that
the frontend is running and instead add a explicit property.

Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marek Vasut <marex@denx.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c |   10 ++++++++--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -561,6 +561,8 @@ static int etnaviv_hw_reset(struct etnav
 	/* We rely on the GPU running, so program the clock */
 	etnaviv_gpu_update_clock(gpu);
 
+	gpu->fe_running = false;
+
 	return 0;
 }
 
@@ -623,6 +625,8 @@ void etnaviv_gpu_start_fe(struct etnaviv
 			  VIVS_MMUv2_SEC_COMMAND_CONTROL_ENABLE |
 			  VIVS_MMUv2_SEC_COMMAND_CONTROL_PREFETCH(prefetch));
 	}
+
+	gpu->fe_running = true;
 }
 
 static void etnaviv_gpu_start_fe_idleloop(struct etnaviv_gpu *gpu)
@@ -1352,7 +1356,7 @@ struct dma_fence *etnaviv_gpu_submit(str
 		goto out_unlock;
 	}
 
-	if (!gpu->mmu_context) {
+	if (!gpu->fe_running) {
 		gpu->mmu_context = etnaviv_iommu_context_get(submit->mmu_context);
 		etnaviv_gpu_start_fe_idleloop(gpu);
 	} else {
@@ -1561,7 +1565,7 @@ int etnaviv_gpu_wait_idle(struct etnaviv
 
 static int etnaviv_gpu_hw_suspend(struct etnaviv_gpu *gpu)
 {
-	if (gpu->initialized && gpu->mmu_context) {
+	if (gpu->initialized && gpu->fe_running) {
 		/* Replace the last WAIT with END */
 		mutex_lock(&gpu->lock);
 		etnaviv_buffer_end(gpu);
@@ -1576,6 +1580,8 @@ static int etnaviv_gpu_hw_suspend(struct
 
 		etnaviv_iommu_context_put(gpu->mmu_context);
 		gpu->mmu_context = NULL;
+
+		gpu->fe_running = false;
 	}
 
 	gpu->exec_state = -1;
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -101,6 +101,7 @@ struct etnaviv_gpu {
 	struct workqueue_struct *wq;
 	struct drm_gpu_scheduler sched;
 	bool initialized;
+	bool fe_running;
 
 	/* 'ring'-buffer: */
 	struct etnaviv_cmdbuf buffer;


