Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA09C489282
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbiAJHoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240774AbiAJHmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:42:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3EDC03327F;
        Sun,  9 Jan 2022 23:35:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFE05B81161;
        Mon, 10 Jan 2022 07:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047D4C36AE9;
        Mon, 10 Jan 2022 07:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800097;
        bh=DpE+ZbuBDo/t28HF6sDMgSkYPiIXAr3H/aodqo04HhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mf+gBc9GXVUVqfckkrAqR1qY4js1q6s3QrGawTJ8nzXhDIrh7NI6lSxndPN0dsmGd
         SAYuQf5YsY5DXT3EyDeKaiHvxsf0gqN/LGync/wieY1UyT0dqrOvOVA7enOQZrhcFv
         8CHiLqQ8DVUNlvPeJuHe355XuAaPR/5Wwl3dajxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 71/72] Revert "drm/amdgpu: stop scheduler when calling hw_fini (v2)"
Date:   Mon, 10 Jan 2022 08:23:48 +0100
Message-Id: <20220110071823.961031554@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Len Brown <len.brown@intel.com>

commit df5bc0aa7ff6e2e14cb75182b4eda20253c711d4 upstream.

This reverts commit f7d6779df642720e22bffd449e683bb8690bd3bf.

This bisected regression has impacted suspend-resume stability
since 5.15-rc1. It regressed -stable via 5.14.10.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215315
Fixes: f7d6779df64 ("drm/amdgpu: stop scheduler when calling hw_fini (v2)")
Cc: Guchun Chen <guchun.chen@amd.com>
Cc: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -552,9 +552,6 @@ void amdgpu_fence_driver_hw_fini(struct
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
-		if (!ring->no_scheduler)
-			drm_sched_stop(&ring->sched, NULL);
-
 		/* You can't wait for HW to signal if it's gone */
 		if (!drm_dev_is_unplugged(&adev->ddev))
 			r = amdgpu_fence_wait_empty(ring);
@@ -614,11 +611,6 @@ void amdgpu_fence_driver_hw_init(struct
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
-		if (!ring->no_scheduler) {
-			drm_sched_resubmit_jobs(&ring->sched);
-			drm_sched_start(&ring->sched, true);
-		}
-
 		/* enable the interrupt */
 		if (ring->fence_drv.irq_src)
 			amdgpu_irq_get(adev, ring->fence_drv.irq_src,


