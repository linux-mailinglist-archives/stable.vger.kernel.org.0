Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A7E591A58
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbiHMMv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiHMMv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:51:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9109140C9
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 747F160D24
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E95BC433D6;
        Sat, 13 Aug 2022 12:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660395085;
        bh=rqR8LRXGCH+0V4vsHV+6JkQXCpbRrIhCLMcAWRNOXQ8=;
        h=Subject:To:Cc:From:Date:From;
        b=QszQu0WUToCGEA+Rez9d5IMViKGk+GvdX/v2I0sWoUsDyoiFAKCGjy1ShYEDtzJ4G
         4I7+MC4GyQf6s58R4m35j4toi46sy37bVfZoGrQ0T1BKLVGhPAVYCPi/GJwxw424II
         1Df55LjtH07gK/DQeDVUcH5StMMed/zNz6zQkVA0=
Subject: FAILED: patch "[PATCH] drm/scheduler: Don't kill jobs in interrupt context" failed to apply to 5.19-stable tree
To:     dmitry.osipenko@collabora.com, andrey.grodzovsky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:51:18 +0200
Message-ID: <1660395078208114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7d64c40a7d96190d9d06e240305389e025295916 Mon Sep 17 00:00:00 2001
From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Date: Tue, 12 Apr 2022 01:15:36 +0300
Subject: [PATCH] drm/scheduler: Don't kill jobs in interrupt context

Interrupt context can't sleep. Drivers like Panfrost and MSM are taking
mutex when job is released, and thus, that code can sleep. This results
into "BUG: scheduling while atomic" if locks are contented while job is
freed. There is no good reason for releasing scheduler's jobs in IRQ
context, hence use normal context to fix the trouble.

Cc: stable@vger.kernel.org
Fixes: 542cff7893a3 ("drm/sched: Avoid lockdep spalt on killing a processes")
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220411221536.283312-1-dmitry.osipenko@collabora.com

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 191c56064f19..6b25b2f4f5a3 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -190,7 +190,7 @@ long drm_sched_entity_flush(struct drm_sched_entity *entity, long timeout)
 }
 EXPORT_SYMBOL(drm_sched_entity_flush);
 
-static void drm_sched_entity_kill_jobs_irq_work(struct irq_work *wrk)
+static void drm_sched_entity_kill_jobs_work(struct work_struct *wrk)
 {
 	struct drm_sched_job *job = container_of(wrk, typeof(*job), work);
 
@@ -207,8 +207,8 @@ static void drm_sched_entity_kill_jobs_cb(struct dma_fence *f,
 	struct drm_sched_job *job = container_of(cb, struct drm_sched_job,
 						 finish_cb);
 
-	init_irq_work(&job->work, drm_sched_entity_kill_jobs_irq_work);
-	irq_work_queue(&job->work);
+	INIT_WORK(&job->work, drm_sched_entity_kill_jobs_work);
+	schedule_work(&job->work);
 }
 
 static struct dma_fence *
diff --git a/include/drm/gpu_scheduler.h b/include/drm/gpu_scheduler.h
index 0fca8f38bee4..addb135eeea6 100644
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -28,7 +28,7 @@
 #include <linux/dma-fence.h>
 #include <linux/completion.h>
 #include <linux/xarray.h>
-#include <linux/irq_work.h>
+#include <linux/workqueue.h>
 
 #define MAX_WAIT_SCHED_ENTITY_Q_EMPTY msecs_to_jiffies(1000)
 
@@ -295,7 +295,7 @@ struct drm_sched_job {
 	 */
 	union {
 		struct dma_fence_cb		finish_cb;
-		struct irq_work 		work;
+		struct work_struct 		work;
 	};
 
 	uint64_t			id;

