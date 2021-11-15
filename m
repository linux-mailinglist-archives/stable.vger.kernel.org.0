Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389EB452403
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351728AbhKPBfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242081AbhKOSgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:36:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1D1C63268;
        Mon, 15 Nov 2021 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999355;
        bh=PWRPyJ4SWoaDvKTSxU4rb+kcgPf1SgaM1x4oGlcrMLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cngtQhcgF2ZFoV7nkrDB8b9b3czSVCuuDhTtIb8pU8b9627z0qogiRAL13P+Pd9eF
         uzfH4BYEJLE+lnqiFdQepbR4YIgharR3jwg81YFI//m6akF9o5aC6aW7yoN7J7x54h
         DxDynech1o1a5pAVuAzxfh+Ah9hcaMvciDlmW0ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Sierra <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Philip Yang <philip.yang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 267/849] drm/amdkfd: rm BO resv on validation to avoid deadlock
Date:   Mon, 15 Nov 2021 17:55:50 +0100
Message-Id: <20211115165429.283674269@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sierra <alex.sierra@amd.com>

[ Upstream commit ec6abe831a843208e99a59adf108adba22166b3f ]

This fix the deadlock with the BO reservations during SVM_BO evictions
while allocations in VRAM are concurrently performed. More specific,
while the ttm waits for the fence to be signaled (ttm_bo_wait), it
already has the BO reserved. In parallel, the restore worker might be
running, prefetching memory to VRAM. This also requires to reserve the
BO, but blocks the mmap semaphore first. The deadlock happens when the
SVM_BO eviction worker kicks in and waits for the mmap semaphore held
in restore worker. Preventing signal the fence back, causing the
deadlock until the ttm times out.

We don't need to hold the BO reservation anymore during validation
and mapping. Now the physical addresses are taken from hmm_range_fault.
We also take migrate_mutex to prevent range migration while
validate_and_map update GPU page table.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index e85035fd1ccb4..b6a19ac2bc607 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1303,7 +1303,7 @@ struct svm_validate_context {
 	struct svm_range *prange;
 	bool intr;
 	unsigned long bitmap[MAX_GPU_INSTANCE];
-	struct ttm_validate_buffer tv[MAX_GPU_INSTANCE+1];
+	struct ttm_validate_buffer tv[MAX_GPU_INSTANCE];
 	struct list_head validate_list;
 	struct ww_acquire_ctx ticket;
 };
@@ -1330,11 +1330,6 @@ static int svm_range_reserve_bos(struct svm_validate_context *ctx)
 		ctx->tv[gpuidx].num_shared = 4;
 		list_add(&ctx->tv[gpuidx].head, &ctx->validate_list);
 	}
-	if (ctx->prange->svm_bo && ctx->prange->ttm_res) {
-		ctx->tv[MAX_GPU_INSTANCE].bo = &ctx->prange->svm_bo->bo->tbo;
-		ctx->tv[MAX_GPU_INSTANCE].num_shared = 1;
-		list_add(&ctx->tv[MAX_GPU_INSTANCE].head, &ctx->validate_list);
-	}
 
 	r = ttm_eu_reserve_buffers(&ctx->ticket, &ctx->validate_list,
 				   ctx->intr, NULL);
-- 
2.33.0



