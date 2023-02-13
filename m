Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AFB694946
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjBMO6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjBMO54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:57:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BED21BAFE
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2101B80E62
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C6BC433D2;
        Mon, 13 Feb 2023 14:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300230;
        bh=Hkx8/qx5/TOUzgIyU0M9AD20QuW7FfZS1los6aRa73Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eO0TXMwAbYFO4AjEDcREe3yun6YRbI8Tn3/MdYO2/lzlc+6u02AcsFOW4iLuo/aWE
         Oz3DqXu+o/NLB17HIO5Tpy8/+9H+TZnPZv5P2oq11fRq2jc3AQBXu0uSIHQWH+Azsj
         +RwLv5luTiDMlmjBrdrXARzNE3d0Bkz9KteDLZQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 108/114] drm/amdgpu/fence: Fix oops due to non-matching drm_sched init/fini
Date:   Mon, 13 Feb 2023 15:49:03 +0100
Message-Id: <20230213144747.804028610@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

commit 5ad7bbf3dba5c4a684338df1f285080f2588b535 upstream.

Currently amdgpu calls drm_sched_fini() from the fence driver sw fini
routine - such function is expected to be called only after the
respective init function - drm_sched_init() - was executed successfully.

Happens that we faced a driver probe failure in the Steam Deck
recently, and the function drm_sched_fini() was called even without
its counter-part had been previously called, causing the following oops:

amdgpu: probe of 0000:04:00.0 failed with error -110
BUG: kernel NULL pointer dereference, address: 0000000000000090
PGD 0 P4D 0
Oops: 0002 [#1] PREEMPT SMP NOPTI
CPU: 0 PID: 609 Comm: systemd-udevd Not tainted 6.2.0-rc3-gpiccoli #338
Hardware name: Valve Jupiter/Jupiter, BIOS F7A0113 11/04/2022
RIP: 0010:drm_sched_fini+0x84/0xa0 [gpu_sched]
[...]
Call Trace:
 <TASK>
 amdgpu_fence_driver_sw_fini+0xc8/0xd0 [amdgpu]
 amdgpu_device_fini_sw+0x2b/0x3b0 [amdgpu]
 amdgpu_driver_release_kms+0x16/0x30 [amdgpu]
 devm_drm_dev_init_release+0x49/0x70
 [...]

To prevent that, check if the drm_sched was properly initialized for a
given ring before calling its fini counter-part.

Notice ideally we'd use sched.ready for that; such field is set as the latest
thing on drm_sched_init(). But amdgpu seems to "override" the meaning of such
field - in the above oops for example, it was a GFX ring causing the crash, and
the sched.ready field was set to true in the ring init routine, regardless of
the state of the DRM scheduler. Hence, we ended-up using sched.ops as per
Christian's suggestion [0], and also removed the no_scheduler check [1].

[0] https://lore.kernel.org/amd-gfx/984ee981-2906-0eaf-ccec-9f80975cb136@amd.com/
[1] https://lore.kernel.org/amd-gfx/cd0e2994-f85f-d837-609f-7056d5fb7231@amd.com/

Fixes: 067f44c8b459 ("drm/amdgpu: avoid over-handle of fence driver fini in s3 test (v2)")
Suggested-by: Christian König <christian.koenig@amd.com>
Cc: Guchun Chen <guchun.chen@amd.com>
Cc: Luben Tuikov <luben.tuikov@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -564,7 +564,13 @@ void amdgpu_fence_driver_sw_fini(struct
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
-		if (!ring->no_scheduler)
+		/*
+		 * Notice we check for sched.ops since there's some
+		 * override on the meaning of sched.ready by amdgpu.
+		 * The natural check would be sched.ready, which is
+		 * set as drm_sched_init() finishes...
+		 */
+		if (ring->sched.ops)
 			drm_sched_fini(&ring->sched);
 
 		for (j = 0; j <= ring->fence_drv.num_fences_mask; ++j)


