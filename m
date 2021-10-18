Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDDD431E9E
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhJRODI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234722AbhJROAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:00:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75CEA614C8;
        Mon, 18 Oct 2021 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564547;
        bh=cGeHEmM9en7hGcOg7c05e1reK0g+LmJ4GhENykDmanM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2PYiskVc1jWmZzMNvMnUKNPOSytl34d/0Hs/rmDHYuW3uMWJD5zf84n1fn3751ySS
         V2p+CNpt/iQSgw7yXpTGNaCabIoMAWXu+DSl6BAqU7k0Y/y2H2EyKtsg9ZBvtBWEne
         +z1kIwcQalFecewY96nM9r+sKYno+dAhDUjgr8Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.14 130/151] drm/msm/a6xx: Track current ctx by seqno
Date:   Mon, 18 Oct 2021 15:25:09 +0200
Message-Id: <20211018132344.889672772@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

commit 14eb0cb4e9a7323c8735cf6c681ed8423ce6ae06 upstream.

In theory a context can be destroyed and a new one allocated at the same
address, making the pointer comparision to detect when we don't need to
update the current pagetables invalid.  Instead assign a sequence number
to each context on creation, and use this for the check.

Fixes: 84c31ee16f90 ("drm/msm/a6xx: Add support for per-instance pagetables")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |    6 +++---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h |   11 ++++++++++-
 drivers/gpu/drm/msm/msm_drv.c         |    3 +++
 drivers/gpu/drm/msm/msm_drv.h         |    1 +
 4 files changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -102,7 +102,7 @@ static void a6xx_set_pagetable(struct a6
 	u32 asid;
 	u64 memptr = rbmemptr(ring, ttbr0);
 
-	if (ctx == a6xx_gpu->cur_ctx)
+	if (ctx->seqno == a6xx_gpu->cur_ctx_seqno)
 		return;
 
 	if (msm_iommu_pagetable_params(ctx->aspace->mmu, &ttbr, &asid))
@@ -135,7 +135,7 @@ static void a6xx_set_pagetable(struct a6
 	OUT_PKT7(ring, CP_EVENT_WRITE, 1);
 	OUT_RING(ring, 0x31);
 
-	a6xx_gpu->cur_ctx = ctx;
+	a6xx_gpu->cur_ctx_seqno = ctx->seqno;
 }
 
 static void a6xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
@@ -1053,7 +1053,7 @@ static int a6xx_hw_init(struct msm_gpu *
 	/* Always come up on rb 0 */
 	a6xx_gpu->cur_ring = gpu->rb[0];
 
-	a6xx_gpu->cur_ctx = NULL;
+	a6xx_gpu->cur_ctx_seqno = 0;
 
 	/* Enable the SQE_to start the CP engine */
 	gpu_write(gpu, REG_A6XX_CP_SQE_CNTL, 1);
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
@@ -19,7 +19,16 @@ struct a6xx_gpu {
 	uint64_t sqe_iova;
 
 	struct msm_ringbuffer *cur_ring;
-	struct msm_file_private *cur_ctx;
+
+	/**
+	 * cur_ctx_seqno:
+	 *
+	 * The ctx->seqno value of the context with current pgtables
+	 * installed.  Tracked by seqno rather than pointer value to
+	 * avoid dangling pointers, and cases where a ctx can be freed
+	 * and a new one created with the same address.
+	 */
+	int cur_ctx_seqno;
 
 	struct a6xx_gmu gmu;
 
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -619,6 +619,7 @@ static void load_gpu(struct drm_device *
 
 static int context_init(struct drm_device *dev, struct drm_file *file)
 {
+	static atomic_t ident = ATOMIC_INIT(0);
 	struct msm_drm_private *priv = dev->dev_private;
 	struct msm_file_private *ctx;
 
@@ -632,6 +633,8 @@ static int context_init(struct drm_devic
 	ctx->aspace = msm_gpu_create_private_address_space(priv->gpu, current);
 	file->driver_priv = ctx;
 
+	ctx->seqno = atomic_inc_return(&ident);
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -59,6 +59,7 @@ struct msm_file_private {
 	int queueid;
 	struct msm_gem_address_space *aspace;
 	struct kref ref;
+	int seqno;
 };
 
 enum msm_mdp_plane_property {


