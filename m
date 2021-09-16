Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCA240DAB2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbhIPNJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239495AbhIPNJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:09:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D21F6105A;
        Thu, 16 Sep 2021 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797710;
        bh=WrCk7hm+9TGDAWWUpDqv90hL/PZkzvFQQ2SVNq/4dBI=;
        h=Subject:To:Cc:From:Date:From;
        b=F4SIevCrI8E77YYRd5BS43QexzL7/BUCdMacpcGKN2WSeCSJA4avB1/zduA7plh3O
         PENivRfyM5gP6fmdkHPo3bI8JS7IvE79tF0us2JWLLDbAD2eQ39ywzNilAv/u9vOX3
         MwBVMB1pm7h6XxAtq0BDdBUFUV5KU9e7tFWseGmg=
Subject: FAILED: patch "[PATCH] drm/amdgpu: stop scheduler when calling hw_fini (v2)" failed to apply to 5.14-stable tree
To:     guchun.chen@amd.com, alexander.deucher@amd.com,
        andrey.grodzovsky@amd.com, christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:08:28 +0200
Message-ID: <1631797708228134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f7d6779df642720e22bffd449e683bb8690bd3bf Mon Sep 17 00:00:00 2001
From: Guchun Chen <guchun.chen@amd.com>
Date: Fri, 27 Aug 2021 18:31:41 +0800
Subject: [PATCH] drm/amdgpu: stop scheduler when calling hw_fini (v2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This gurantees no more work on the ring can be submitted
to hardware in suspend/resume case, otherwise a potential
race will occur and the ring will get no chance to stay
empty before suspend.

v2: Call drm_sched_resubmit_job before drm_sched_start to
restart jobs from the pending list.

Suggested-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index 14499f0de32d..8d682befe0d6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -552,6 +552,9 @@ void amdgpu_fence_driver_hw_fini(struct amdgpu_device *adev)
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
+		if (!ring->no_scheduler)
+			drm_sched_stop(&ring->sched, NULL);
+
 		/* You can't wait for HW to signal if it's gone */
 		if (!drm_dev_is_unplugged(&adev->ddev))
 			r = amdgpu_fence_wait_empty(ring);
@@ -611,6 +614,11 @@ void amdgpu_fence_driver_hw_init(struct amdgpu_device *adev)
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
+		if (!ring->no_scheduler) {
+			drm_sched_resubmit_jobs(&ring->sched);
+			drm_sched_start(&ring->sched, true);
+		}
+
 		/* enable the interrupt */
 		if (ring->fence_drv.irq_src)
 			amdgpu_irq_get(adev, ring->fence_drv.irq_src,

