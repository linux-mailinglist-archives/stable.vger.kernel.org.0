Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F0626EB11
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgIRCC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726876AbgIRCCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C110123718;
        Fri, 18 Sep 2020 02:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394573;
        bh=mB0PswWSGZUE0hQctMizawBCYsl1DAYFkU5l1hbNNLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LctZEaljem9J0OpfHirw5iliTw8czdw5d2wr6BiQ1RR8TLpDZe1UvoZFT1GXRPfzO
         FCKq6vc1LYXjKrQmkO9dMDCVu7HOZ0wdSrkJ1lAn3VfuPSVMeVW6zFVaG/uPWiTa7h
         owNuAk4WCnLfwmHUqC7GIA+39Q95CQni+Mr4tbK8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Emily Deng <Emily.Deng@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 085/330] drm/scheduler: Avoid accessing freed bad job.
Date:   Thu, 17 Sep 2020 21:57:05 -0400
Message-Id: <20200918020110.2063155-85-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit 135517d3565b48f4def3b1b82008bc17eb5d1c90 ]

Problem:
Due to a race between drm_sched_cleanup_jobs in sched thread and
drm_sched_job_timedout in timeout work there is a possiblity that
bad job was already freed while still being accessed from the
timeout thread.

Fix:
Instead of just peeking at the bad job in the mirror list
remove it from the list under lock and then put it back later when
we are garanteed no race with main sched thread is possible which
is after the thread is parked.

v2: Lock around processing ring_mirror_list in drm_sched_cleanup_jobs.

v3: Rebase on top of drm-misc-next. v2 is not needed anymore as
drm_sched_get_cleanup_job already has a lock there.

v4: Fix comments to relfect latest code in drm-misc.

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Emily Deng <Emily.Deng@amd.com>
Tested-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/342356
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_main.c | 27 ++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 30c5ddd6d081c..134e9106ebac1 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -284,10 +284,21 @@ static void drm_sched_job_timedout(struct work_struct *work)
 	unsigned long flags;
 
 	sched = container_of(work, struct drm_gpu_scheduler, work_tdr.work);
+
+	/* Protects against concurrent deletion in drm_sched_get_cleanup_job */
+	spin_lock_irqsave(&sched->job_list_lock, flags);
 	job = list_first_entry_or_null(&sched->ring_mirror_list,
 				       struct drm_sched_job, node);
 
 	if (job) {
+		/*
+		 * Remove the bad job so it cannot be freed by concurrent
+		 * drm_sched_cleanup_jobs. It will be reinserted back after sched->thread
+		 * is parked at which point it's safe.
+		 */
+		list_del_init(&job->node);
+		spin_unlock_irqrestore(&sched->job_list_lock, flags);
+
 		job->sched->ops->timedout_job(job);
 
 		/*
@@ -298,6 +309,8 @@ static void drm_sched_job_timedout(struct work_struct *work)
 			job->sched->ops->free_job(job);
 			sched->free_guilty = false;
 		}
+	} else {
+		spin_unlock_irqrestore(&sched->job_list_lock, flags);
 	}
 
 	spin_lock_irqsave(&sched->job_list_lock, flags);
@@ -369,6 +382,20 @@ void drm_sched_stop(struct drm_gpu_scheduler *sched, struct drm_sched_job *bad)
 
 	kthread_park(sched->thread);
 
+	/*
+	 * Reinsert back the bad job here - now it's safe as
+	 * drm_sched_get_cleanup_job cannot race against us and release the
+	 * bad job at this point - we parked (waited for) any in progress
+	 * (earlier) cleanups and drm_sched_get_cleanup_job will not be called
+	 * now until the scheduler thread is unparked.
+	 */
+	if (bad && bad->sched == sched)
+		/*
+		 * Add at the head of the queue to reflect it was the earliest
+		 * job extracted.
+		 */
+		list_add(&bad->node, &sched->ring_mirror_list);
+
 	/*
 	 * Iterate the job list from later to  earlier one and either deactive
 	 * their HW callbacks or remove them from mirror list if they already
-- 
2.25.1

