Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A891461E3FB
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiKFRGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiKFRFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:05:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A232AE02C;
        Sun,  6 Nov 2022 09:05:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1F6F60C3F;
        Sun,  6 Nov 2022 17:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB47C433D7;
        Sun,  6 Nov 2022 17:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754306;
        bh=KztOp8qiQQ6o2p8/9EWNV2l4Add6B6H4zZ667ATuFoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNju25cFvZmr2XsP6FQvZtmd6zaIyeAtVNkjxYMJIBWGxlRL2WFBibdaT2or+VTQz
         yNWQziz7rhpyoUSYd7/NjekHisjsgetMRiKT6mMnmEtrORA3mavIT3+h1XEj//4oWm
         y3FKwnY6FWd2m0cs6/qJe6AmFhhRSHMWZg3mNNAPYqwGQin8OqStIzU82q6dV+ocms
         tHo83nbbRuYSISWCAImEA2gzzh7pnGOg/NsxLwxNuVcaVvWpBOzBlkO0ew4mK6rOwQ
         wtYBo9+CFGN/Gt3pVP7xRY9WD2VwD7yGCDdGz3EPV9vt9b8BmtcelqgM0zD6c6zES2
         qSz0BQpd2x9kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Sasha Levin <sashal@kernel.org>, airlied@gmail.com,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 29/30] drm/scheduler: fix fence ref counting
Date:   Sun,  6 Nov 2022 12:03:41 -0500
Message-Id: <20221106170345.1579893-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christian König <christian.koenig@amd.com>

[ Upstream commit b3af84383e7abdc5e63435817bb73a268e7c3637 ]

We leaked dependency fences when processes were beeing killed.

Additional to that grab a reference to the last scheduled fence.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220929180151.139751-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 6b25b2f4f5a3..7ef1a086a6fb 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -207,6 +207,7 @@ static void drm_sched_entity_kill_jobs_cb(struct dma_fence *f,
 	struct drm_sched_job *job = container_of(cb, struct drm_sched_job,
 						 finish_cb);
 
+	dma_fence_put(f);
 	INIT_WORK(&job->work, drm_sched_entity_kill_jobs_work);
 	schedule_work(&job->work);
 }
@@ -234,8 +235,10 @@ static void drm_sched_entity_kill_jobs(struct drm_sched_entity *entity)
 		struct drm_sched_fence *s_fence = job->s_fence;
 
 		/* Wait for all dependencies to avoid data corruptions */
-		while ((f = drm_sched_job_dependency(job, entity)))
+		while ((f = drm_sched_job_dependency(job, entity))) {
 			dma_fence_wait(f, false);
+			dma_fence_put(f);
+		}
 
 		drm_sched_fence_scheduled(s_fence);
 		dma_fence_set_error(&s_fence->finished, -ESRCH);
@@ -250,6 +253,7 @@ static void drm_sched_entity_kill_jobs(struct drm_sched_entity *entity)
 			continue;
 		}
 
+		dma_fence_get(entity->last_scheduled);
 		r = dma_fence_add_callback(entity->last_scheduled,
 					   &job->finish_cb,
 					   drm_sched_entity_kill_jobs_cb);
-- 
2.35.1

