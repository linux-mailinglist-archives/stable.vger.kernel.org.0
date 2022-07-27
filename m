Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDCA582F80
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241932AbiG0R0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241961AbiG0RZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:25:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E31B7D7A5;
        Wed, 27 Jul 2022 09:46:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1420B821A6;
        Wed, 27 Jul 2022 16:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9EAC433B5;
        Wed, 27 Jul 2022 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940399;
        bh=GhYgZIgGTDUbTK6LWYbZValzjDD+lImexv1IGjxCoo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcahtjh209Ui9ATS61UTeX1/MCJNXN7Ecs8jgPzXFUohoE27CG/AmmyEXxXKc5p2x
         cj9BCqZiqp8Q5ZnttlerQEtyaTeMw7DHLvp0qb+/2l9kjmKkDX/NeY+qiHb0CUmwza
         XXuigjrmwT0g7/SrMGR5dNFj/ViTFBLwvTKPgudY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Subject: [PATCH 5.18 010/158] drm/scheduler: Dont kill jobs in interrupt context
Date:   Wed, 27 Jul 2022 18:11:14 +0200
Message-Id: <20220727161021.852697362@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 9b04369b060fd4885f728b7a4ab4851ffb1abb64 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |    6 +++---
 include/drm/gpu_scheduler.h              |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -190,7 +190,7 @@ long drm_sched_entity_flush(struct drm_s
 }
 EXPORT_SYMBOL(drm_sched_entity_flush);
 
-static void drm_sched_entity_kill_jobs_irq_work(struct irq_work *wrk)
+static void drm_sched_entity_kill_jobs_work(struct work_struct *wrk)
 {
 	struct drm_sched_job *job = container_of(wrk, typeof(*job), work);
 
@@ -207,8 +207,8 @@ static void drm_sched_entity_kill_jobs_c
 	struct drm_sched_job *job = container_of(cb, struct drm_sched_job,
 						 finish_cb);
 
-	init_irq_work(&job->work, drm_sched_entity_kill_jobs_irq_work);
-	irq_work_queue(&job->work);
+	INIT_WORK(&job->work, drm_sched_entity_kill_jobs_work);
+	schedule_work(&job->work);
 }
 
 static struct dma_fence *
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -28,7 +28,7 @@
 #include <linux/dma-fence.h>
 #include <linux/completion.h>
 #include <linux/xarray.h>
-#include <linux/irq_work.h>
+#include <linux/workqueue.h>
 
 #define MAX_WAIT_SCHED_ENTITY_Q_EMPTY msecs_to_jiffies(1000)
 
@@ -294,7 +294,7 @@ struct drm_sched_job {
 	 */
 	union {
 		struct dma_fence_cb		finish_cb;
-		struct irq_work 		work;
+		struct work_struct 		work;
 	};
 
 	uint64_t			id;


