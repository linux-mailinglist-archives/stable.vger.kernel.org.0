Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849D94123A1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378290AbhITS0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378267AbhITSYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E4A961A7E;
        Mon, 20 Sep 2021 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158686;
        bh=/1p7iBhADNAkoLnetj2OnEFIcoCVQK2JPIY4M1vP1y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkRvemvT4o0c2Zx0H2M5pdGJxf4mSi22+HN2DFntWcbwrIEKpCsNClLWNf3znmSbV
         n6TUwEFAnDLQgwkWT0fUZOvfbBhTM7IGcOVYo2NLXukVMVv7rXJAN4wEZ8SdkrGcJ6
         UxEY5JYM9mdqLKpuf+tRzp06AA5bWDc7nl+zVxxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Michael Walle <michael@walle.cc>, Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.10 010/122] drm/etnaviv: return context from etnaviv_iommu_context_get
Date:   Mon, 20 Sep 2021 18:43:02 +0200
Message-Id: <20210920163916.106979942@linuxfoundation.org>
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

commit 78edefc05e41352099ffb8f06f8d9b2d091e29cd upstream.

Being able to have the refcount manipulation in an assignment makes
it much easier to parse the code.

Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marek Vasut <marex@denx.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c     |    3 +--
 drivers/gpu/drm/etnaviv/etnaviv_gem.c        |    3 +--
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c |    3 +--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c        |    6 ++----
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h        |    4 +++-
 5 files changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -397,8 +397,7 @@ void etnaviv_buffer_queue(struct etnaviv
 		if (switch_mmu_context) {
 			struct etnaviv_iommu_context *old_context = gpu->mmu_context;
 
-			etnaviv_iommu_context_get(mmu_context);
-			gpu->mmu_context = mmu_context;
+			gpu->mmu_context = etnaviv_iommu_context_get(mmu_context);
 			etnaviv_iommu_context_put(old_context);
 		}
 
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -305,8 +305,7 @@ struct etnaviv_vram_mapping *etnaviv_gem
 		list_del(&mapping->obj_node);
 	}
 
-	etnaviv_iommu_context_get(mmu_context);
-	mapping->context = mmu_context;
+	mapping->context = etnaviv_iommu_context_get(mmu_context);
 	mapping->use = 1;
 
 	ret = etnaviv_iommu_map_gem(mmu_context, etnaviv_obj,
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
@@ -532,8 +532,7 @@ int etnaviv_ioctl_gem_submit(struct drm_
 		goto err_submit_objects;
 
 	submit->ctx = file->driver_priv;
-	etnaviv_iommu_context_get(submit->ctx->mmu);
-	submit->mmu_context = submit->ctx->mmu;
+	submit->mmu_context = etnaviv_iommu_context_get(submit->ctx->mmu);
 	submit->exec_state = args->exec_state;
 	submit->flags = args->flags;
 
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1353,12 +1353,10 @@ struct dma_fence *etnaviv_gpu_submit(str
 	}
 
 	if (!gpu->mmu_context) {
-		etnaviv_iommu_context_get(submit->mmu_context);
-		gpu->mmu_context = submit->mmu_context;
+		gpu->mmu_context = etnaviv_iommu_context_get(submit->mmu_context);
 		etnaviv_gpu_start_fe_idleloop(gpu);
 	} else {
-		etnaviv_iommu_context_get(gpu->mmu_context);
-		submit->prev_mmu_context = gpu->mmu_context;
+		submit->prev_mmu_context = etnaviv_iommu_context_get(gpu->mmu_context);
 	}
 
 	if (submit->nr_pmrs) {
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
@@ -105,9 +105,11 @@ void etnaviv_iommu_dump(struct etnaviv_i
 struct etnaviv_iommu_context *
 etnaviv_iommu_context_init(struct etnaviv_iommu_global *global,
 			   struct etnaviv_cmdbuf_suballoc *suballoc);
-static inline void etnaviv_iommu_context_get(struct etnaviv_iommu_context *ctx)
+static inline struct etnaviv_iommu_context *
+etnaviv_iommu_context_get(struct etnaviv_iommu_context *ctx)
 {
 	kref_get(&ctx->refcount);
+	return ctx;
 }
 void etnaviv_iommu_context_put(struct etnaviv_iommu_context *ctx);
 void etnaviv_iommu_restore(struct etnaviv_gpu *gpu,


