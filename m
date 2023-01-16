Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D69366C10D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjAPOH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbjAPOGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:06:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEDC23C62;
        Mon, 16 Jan 2023 06:03:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D201B80F3B;
        Mon, 16 Jan 2023 14:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70A4C433F2;
        Mon, 16 Jan 2023 14:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877804;
        bh=9bW+Y5q9GNqp0uZwNUBA+UrM1bzAjFJMd1MQ8mDzQjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqqA718pxab1KY1IkT/3za3x1wK43IpLJhhMeLCaRo/+o/NajWvhr/NMJ4KOwb5sw
         3w+Kva1PKEyjBX9Q6geaeiPoJjq12CCWF7HQKjN/tSAQ4yM5BQu32eMm7jwEnJq+lL
         iHLWMDMACvPyXh+Z8j0Fms3yOLMsLF6dOSd+/nta1rXKsFa6f9JNdateLAByFqtD6G
         BkqH1ioFdHGRmDCKoRDsXA0sPcwhw0k+QwL07x5xqyIHU1zGdSg6FneyTpQ5JicLQl
         feiUjrzO5PWk32JqnIKx9d/79AS4x0IC3OWRJnhz9htjbDbqxbpbVHDDtGhzBSqnqC
         ZF4VkU6L2B8Rw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Huang <jinhuieric.huang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 36/53] drm/amdkfd: Fix NULL pointer error for GC 11.0.1 on mGPU
Date:   Mon, 16 Jan 2023 09:01:36 -0500
Message-Id: <20230116140154.114951-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit a6941f89d7c6a6ba49316bbd7da2fb2f719119a7 ]

The point bo->kfd_bo is NULL for queue's write pointer BO
when creating queue on mGPU. To avoid using the pointer
fixes the error.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c      | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 29f045079a3e..404c839683b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2130,7 +2130,7 @@ int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_device *adev, struct amdgpu_b
 	}
 
 	amdgpu_amdkfd_remove_eviction_fence(
-		bo, bo->kfd_bo->process_info->eviction_fence);
+		bo, bo->vm_bo->vm->process_info->eviction_fence);
 
 	amdgpu_bo_unreserve(bo);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index ecb4c3abc629..c06ada0844ba 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -200,7 +200,7 @@ static int add_queue_mes(struct device_queue_manager *dqm, struct queue *q,
 	queue_input.wptr_addr = (uint64_t)q->properties.write_ptr;
 
 	if (q->wptr_bo) {
-		wptr_addr_off = (uint64_t)q->properties.write_ptr - (uint64_t)q->wptr_bo->kfd_bo->va;
+		wptr_addr_off = (uint64_t)q->properties.write_ptr & (PAGE_SIZE - 1);
 		queue_input.wptr_mc_addr = ((uint64_t)q->wptr_bo->tbo.resource->start << PAGE_SHIFT) + wptr_addr_off;
 	}
 
-- 
2.35.1

