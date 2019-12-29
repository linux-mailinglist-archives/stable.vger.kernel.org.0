Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6D212C6F4
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732228AbfL2RwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:52:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732227AbfL2RwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90224206DB;
        Sun, 29 Dec 2019 17:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641933;
        bh=/MGZMritNQOwXndeVzohQvOB7mj9LAIEocrmTIbrBfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYFU1U8mV/KW0HXLntxbAN3DeyTAlS8EW0K+T3nB+EjSnqC5pppu3rV9Dgog6U+Vx
         T5UJpn+6FrK3sB4M9E/Gp7d6vNvw1M4xBUpMHlHY71Ul8DlPDT2nxhg5f0yPTj1bhq
         9tBZUzFy1JAR+qYKwK4YCyx5/wemeXnMoAOuxmXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 271/434] drm/amdgpu: Avoid accidental thread reactivation.
Date:   Sun, 29 Dec 2019 18:25:24 +0100
Message-Id: <20191229172719.940429557@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5652cc72ed3a..81842ba8cd75 100644
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
 
@@ -1075,6 +1083,8 @@ failure:
 	/* restart the scheduler */
 	kthread_unpark(ring->sched.thread);
 
+	mutex_unlock(&adev->lock_reset);
+
 	ttm_bo_unlock_delayed_workqueue(&adev->mman.bdev, resched);
 
 	if (fences)
-- 
2.20.1



