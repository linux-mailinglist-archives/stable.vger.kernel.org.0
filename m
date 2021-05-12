Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0387F37C797
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhELQA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237930AbhELP4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D80B961937;
        Wed, 12 May 2021 15:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833331;
        bh=wVleOt7jaroLatdPaam+e/ZZJbmQYuTD+K6ndpfBHOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjD4mzeE1LjsXzVQYuH3dREdKGRnK6/HDvEP08+KFTyiBTTMFZXJxF5k/ae8Uc7CY
         vDNWmj5A0DBN/M5Qv3UW0CXJywlZdtEBNHnuIROQl6Ly8Y+LnvEP+Lc9ITG9W7Onya
         8j4dC1QeSfY6dvDwEJXUZPDFl3reZoZ+VWkPaVNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 072/601] drm/amdgpu: fix concurrent VM flushes on Vega/Navi v2
Date:   Wed, 12 May 2021 16:42:29 +0200
Message-Id: <20210512144830.196897523@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 20a5f5a98e1bb3d40acd97e89299e8c2d22784be upstream.

Starting with Vega the hardware supports concurrent flushes
of VMID which can be used to implement per process VMID
allocation.

But concurrent flushes are mutual exclusive with back to
back VMID allocations, fix this to avoid a VMID used in
two ways at the same time.

v2: don't set ring to NULL

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Tested-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c |   19 +++++++++++--------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c  |    6 ++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h  |    1 +
 3 files changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -215,7 +215,11 @@ static int amdgpu_vmid_grab_idle(struct
 	/* Check if we have an idle VMID */
 	i = 0;
 	list_for_each_entry((*idle), &id_mgr->ids_lru, list) {
-		fences[i] = amdgpu_sync_peek_fence(&(*idle)->active, ring);
+		/* Don't use per engine and per process VMID at the same time */
+		struct amdgpu_ring *r = adev->vm_manager.concurrent_flush ?
+			NULL : ring;
+
+		fences[i] = amdgpu_sync_peek_fence(&(*idle)->active, r);
 		if (!fences[i])
 			break;
 		++i;
@@ -281,7 +285,7 @@ static int amdgpu_vmid_grab_reserved(str
 	if (updates && (*id)->flushed_updates &&
 	    updates->context == (*id)->flushed_updates->context &&
 	    !dma_fence_is_later(updates, (*id)->flushed_updates))
-	    updates = NULL;
+		updates = NULL;
 
 	if ((*id)->owner != vm->immediate.fence_context ||
 	    job->vm_pd_addr != (*id)->pd_gpu_addr ||
@@ -290,6 +294,10 @@ static int amdgpu_vmid_grab_reserved(str
 	     !dma_fence_is_signaled((*id)->last_flush))) {
 		struct dma_fence *tmp;
 
+		/* Don't use per engine and per process VMID at the same time */
+		if (adev->vm_manager.concurrent_flush)
+			ring = NULL;
+
 		/* to prevent one context starved by another context */
 		(*id)->pd_gpu_addr = 0;
 		tmp = amdgpu_sync_peek_fence(&(*id)->active, ring);
@@ -365,12 +373,7 @@ static int amdgpu_vmid_grab_used(struct
 		if (updates && (!flushed || dma_fence_is_later(updates, flushed)))
 			needs_flush = true;
 
-		/* Concurrent flushes are only possible starting with Vega10 and
-		 * are broken on Navi10 and Navi14.
-		 */
-		if (needs_flush && (adev->asic_type < CHIP_VEGA10 ||
-				    adev->asic_type == CHIP_NAVI10 ||
-				    adev->asic_type == CHIP_NAVI14))
+		if (needs_flush && !adev->vm_manager.concurrent_flush)
 			continue;
 
 		/* Good, we can use this VMID. Remember this submission as
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -3145,6 +3145,12 @@ void amdgpu_vm_manager_init(struct amdgp
 {
 	unsigned i;
 
+	/* Concurrent flushes are only possible starting with Vega10 and
+	 * are broken on Navi10 and Navi14.
+	 */
+	adev->vm_manager.concurrent_flush = !(adev->asic_type < CHIP_VEGA10 ||
+					      adev->asic_type == CHIP_NAVI10 ||
+					      adev->asic_type == CHIP_NAVI14);
 	amdgpu_vmid_mgr_init(adev);
 
 	adev->vm_manager.fence_context =
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -331,6 +331,7 @@ struct amdgpu_vm_manager {
 	/* Handling of VMIDs */
 	struct amdgpu_vmid_mgr			id_mgr[AMDGPU_MAX_VMHUBS];
 	unsigned int				first_kfd_vmid;
+	bool					concurrent_flush;
 
 	/* Handling of VM fences */
 	u64					fence_context;


