Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACBD119583
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfLJVVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:21:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbfLJVLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D486246AE;
        Tue, 10 Dec 2019 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012311;
        bh=ATa9QuIVN2+F0fqsudF0PnVInf1lvpTGDJ9Gp+lnndc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jL72VLSvctj16S9fCbfy6xbG/r6Cs3mUNzgn7LcdAKMvLyuTUhBn23+2NSK4YEbmV
         zbCBubjQlQAW1H96i5YU90rM/mqx5EbhkSKrc+76KWoXjExQAdO4xOxO/b9wGhpbCQ
         zj3ZEm0KM81PnvnBTuSk2e+B1X6WbOVdwpfQWPFs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 246/350] drm/amdgpu: Avoid accidental thread reactivation.
Date:   Tue, 10 Dec 2019 16:05:51 -0500
Message-Id: <20191210210735.9077-207-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit a28fda312a9fabdf0e5f5652449d6197c9fb0a90 ]

Problem:
During GPU reset we call the GPU scheduler to suspend it's
thread, those two functions in amdgpu also suspend and resume
the sceduler for their needs but this can collide with GPU
reset in progress and accidently restart a suspended thread
before time.

Fix:
Serialize with GPU reset.

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index 5652cc72ed3a9..81842ba8cd757 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -859,6 +859,9 @@ static int amdgpu_debugfs_test_ib(struct seq_file *m, void *data)
 	struct amdgpu_device *adev = dev->dev_private;
 	int r = 0, i;
 
+	/* Avoid accidently unparking the sched thread during GPU reset */
+	mutex_lock(&adev->lock_reset);
+
 	/* hold on the scheduler */
 	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {
 		struct amdgpu_ring *ring = adev->rings[i];
@@ -884,6 +887,8 @@ static int amdgpu_debugfs_test_ib(struct seq_file *m, void *data)
 		kthread_unpark(ring->sched.thread);
 	}
 
+	mutex_unlock(&adev->lock_reset);
+
 	return 0;
 }
 
@@ -1036,6 +1041,9 @@ static int amdgpu_debugfs_ib_preempt(void *data, u64 val)
 	if (!fences)
 		return -ENOMEM;
 
+	/* Avoid accidently unparking the sched thread during GPU reset */
+	mutex_lock(&adev->lock_reset);
+
 	/* stop the scheduler */
 	kthread_park(ring->sched.thread);
 
@@ -1075,6 +1083,8 @@ static int amdgpu_debugfs_ib_preempt(void *data, u64 val)
 	/* restart the scheduler */
 	kthread_unpark(ring->sched.thread);
 
+	mutex_unlock(&adev->lock_reset);
+
 	ttm_bo_unlock_delayed_workqueue(&adev->mman.bdev, resched);
 
 	if (fences)
-- 
2.20.1

