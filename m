Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5243BCEF6
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbhGFL1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234863AbhGFLZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98F2261C79;
        Tue,  6 Jul 2021 11:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570349;
        bh=ntt+QbwwZjDylx63TgbvU9XSa74tzKkwq5pUAK4TrhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLGIviZT+mFxvSFun0mmPy4mZeZu8hmUxqkyE9qCDNJyuA8Ho+sph70bEdU8TqnFR
         iXwScehYLGdgx+D+YQG+fhLewjqP2HIF9PiAB5GzpQdFhiXYJil+7l/Tb9P5WVOBv9
         6IOAbTSGOJMmW7L/s8pzaveGgTiLT7uB8QFwLUaQgAMFh25FEUNroDnw9422rPnxiK
         1+1eEbQ+WtBjGtP/Ic89asCe/qpUT/wd9EbDCm/3a5G5oTiLxOK0eO2dX1vQ2iQaxE
         Zk52omqnz6D7POmAm579N30J/n0k57CtgrBRu0T0VWMITaHH0LqSRenGigMot8a/je
         tOHg8kPjL4Hxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.12 031/160] drm/sched: Avoid data corruptions
Date:   Tue,  6 Jul 2021 07:16:17 -0400
Message-Id: <20210706111827.2060499-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit 0b10ab80695d61422337ede6ff496552d8ace99d ]

Wait for all dependencies of a job  to complete before
killing it to avoid data corruptions.

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210519141407.88444-1-andrey.grodzovsky@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 72c39608236b..1b2fdf7f3ccd 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -222,11 +222,16 @@ static void drm_sched_entity_kill_jobs_cb(struct dma_fence *f,
 static void drm_sched_entity_kill_jobs(struct drm_sched_entity *entity)
 {
 	struct drm_sched_job *job;
+	struct dma_fence *f;
 	int r;
 
 	while ((job = to_drm_sched_job(spsc_queue_pop(&entity->job_queue)))) {
 		struct drm_sched_fence *s_fence = job->s_fence;
 
+		/* Wait for all dependencies to avoid data corruptions */
+		while ((f = job->sched->ops->dependency(job, entity)))
+			dma_fence_wait(f, false);
+
 		drm_sched_fence_scheduled(s_fence);
 		dma_fence_set_error(&s_fence->finished, -ESRCH);
 
-- 
2.30.2

