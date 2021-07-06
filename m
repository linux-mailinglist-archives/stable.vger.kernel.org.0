Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49153BD4D1
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbhGFMRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232289AbhGFLbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263F161C66;
        Tue,  6 Jul 2021 11:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570559;
        bh=jH8NKxFTKwNu/qUdPjPesAKZszR0sQ/EmNDNJP5FCcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BG+xCv6bsUOBEQ4UiEf7oK7LhqgPQ/afvPkOEQ3bbuI6pZiFpfBpnpPMW/moJNgvn
         DnNXFNZVemsK/6ULieEVOF499GPiaSOo4XyXCwr6speDQ9LY+kDjax+/K1tl/kRpTS
         S0Oq2f4rVQPW7d1dXQO1J6+4t661LNMd4APdvWFNkkbRDiMwWvaXxoQKNXWaYvzS4y
         YG7o52jwCFHOwLSg5jQYzKIdQoS+UWT8ECTjoJ/ZJoo+ylu+3AfijXXbT7ZfSCMW9O
         luU52zTOn0utKXdGhqJAcqFS2HpqI3YTi9s97qm1Q9osswMnmVviJN3JoVLreycxfF
         Bn5s6Rcn570qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 027/137] drm/scheduler: Fix hang when sched_entity released
Date:   Tue,  6 Jul 2021 07:20:13 -0400
Message-Id: <20210706112203.2062605-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit c61cdbdbffc169dc7f1e6fe94dfffaf574fe672a ]

Problem: If scheduler is already stopped by the time sched_entity
is released and entity's job_queue not empty I encountred
a hang in drm_sched_entity_flush. This is because drm_sched_entity_is_idle
never becomes false.

Fix: In drm_sched_fini detach all sched_entities from the
scheduler's run queues. This will satisfy drm_sched_entity_is_idle.
Also wakeup all those processes stuck in sched_entity flushing
as the scheduler main thread which wakes them up is stopped by now.

v2:
Reverse order of drm_sched_rq_remove_entity and marking
s_entity as stopped to prevent reinserion back to rq due
to race.

v3:
Drop drm_sched_rq_remove_entity, only modify entity->stopped
and check for it in drm_sched_entity_is_idle

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210512142648.666476-14-andrey.grodzovsky@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |  3 ++-
 drivers/gpu/drm/scheduler/sched_main.c   | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 146380118962..2006cc057f99 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -113,7 +113,8 @@ static bool drm_sched_entity_is_idle(struct drm_sched_entity *entity)
 	rmb(); /* for list_empty to work without lock */
 
 	if (list_empty(&entity->list) ||
-	    spsc_queue_count(&entity->job_queue) == 0)
+	    spsc_queue_count(&entity->job_queue) == 0 ||
+	    entity->stopped)
 		return true;
 
 	return false;
diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 7111e0f527b0..b6c2757c3d83 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -887,9 +887,33 @@ EXPORT_SYMBOL(drm_sched_init);
  */
 void drm_sched_fini(struct drm_gpu_scheduler *sched)
 {
+	struct drm_sched_entity *s_entity;
+	int i;
+
 	if (sched->thread)
 		kthread_stop(sched->thread);
 
+	for (i = DRM_SCHED_PRIORITY_COUNT - 1; i >= DRM_SCHED_PRIORITY_MIN; i--) {
+		struct drm_sched_rq *rq = &sched->sched_rq[i];
+
+		if (!rq)
+			continue;
+
+		spin_lock(&rq->lock);
+		list_for_each_entry(s_entity, &rq->entities, list)
+			/*
+			 * Prevents reinsertion and marks job_queue as idle,
+			 * it will removed from rq in drm_sched_entity_fini
+			 * eventually
+			 */
+			s_entity->stopped = true;
+		spin_unlock(&rq->lock);
+
+	}
+
+	/* Wakeup everyone stuck in drm_sched_entity_flush for this scheduler */
+	wake_up_all(&sched->job_scheduled);
+
 	/* Confirm no work left behind accessing device structures */
 	cancel_delayed_work_sync(&sched->work_tdr);
 
-- 
2.30.2

