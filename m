Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7FC1A0338
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 02:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgDGAHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 20:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbgDGABj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FDEA2082D;
        Tue,  7 Apr 2020 00:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217698;
        bh=Tn71Trm0DME8p2CUNER4Dh2CEke6Q6TIQHnRwW+It9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzXtFBNR6t5AOE07gzlad/jyb7SqJtGTtTka+MFHFmppQN4mIrirUzaXGyf0jHQzl
         dUbyGMV0EPviGcLtvn05MU9mia4yKlz8cxdDd1uecd4j3ywF6oY4WjuWtbEICTJU5T
         XX7bApYOKSXANNMvzJVzFLQ/Zj36oBqInNpztuN0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yintian Tao <yttao@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.5 31/35] drm/scheduler: fix rare NULL ptr race
Date:   Mon,  6 Apr 2020 20:00:53 -0400
Message-Id: <20200407000058.16423-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yintian Tao <yttao@amd.com>

[ Upstream commit 3c0fdf3302cb4f186c871684eac5c407a107e480 ]

There is one one corner case at dma_fence_signal_locked
which will raise the NULL pointer problem just like below.
->dma_fence_signal
    ->dma_fence_signal_locked
	->test_and_set_bit
here trigger dma_fence_release happen due to the zero of fence refcount.

->dma_fence_put
    ->dma_fence_release
	->drm_sched_fence_release_scheduled
	    ->call_rcu
here make the union fled “cb_list” at finished fence
to NULL because struct rcu_head contains two pointer
which is same as struct list_head cb_list

Therefore, to hold the reference of finished fence at drm_sched_process_job
to prevent the null pointer during finished fence dma_fence_signal

[  732.912867] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  732.914815] #PF: supervisor write access in kernel mode
[  732.915731] #PF: error_code(0x0002) - not-present page
[  732.916621] PGD 0 P4D 0
[  732.917072] Oops: 0002 [#1] SMP PTI
[  732.917682] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G           OE     5.4.0-rc7 #1
[  732.918980] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.2-0-g33fbe13 by qemu-project.org 04/01/2014
[  732.920906] RIP: 0010:dma_fence_signal_locked+0x3e/0x100
[  732.938569] Call Trace:
[  732.939003]  <IRQ>
[  732.939364]  dma_fence_signal+0x29/0x50
[  732.940036]  drm_sched_fence_finished+0x12/0x20 [gpu_sched]
[  732.940996]  drm_sched_process_job+0x34/0xa0 [gpu_sched]
[  732.941910]  dma_fence_signal_locked+0x85/0x100
[  732.942692]  dma_fence_signal+0x29/0x50
[  732.943457]  amdgpu_fence_process+0x99/0x120 [amdgpu]
[  732.944393]  sdma_v4_0_process_trap_irq+0x81/0xa0 [amdgpu]

v2: hold the finished fence at drm_sched_process_job instead of
    amdgpu_fence_process
v3: resume the blank line

Signed-off-by: Yintian Tao <yttao@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 3c57e84222ca9..5bb9feddbfd6b 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -632,7 +632,9 @@ static void drm_sched_process_job(struct dma_fence *f, struct dma_fence_cb *cb)
 
 	trace_drm_sched_process_job(s_fence);
 
+	dma_fence_get(&s_fence->finished);
 	drm_sched_fence_finished(s_fence);
+	dma_fence_put(&s_fence->finished);
 	wake_up_interruptible(&sched->wake_up_worker);
 }
 
-- 
2.20.1

