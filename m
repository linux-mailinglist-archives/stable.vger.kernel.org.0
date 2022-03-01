Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0342E4C963E
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiCAUUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237888AbiCAUTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:19:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C4B3ED34;
        Tue,  1 Mar 2022 12:18:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44A09B81D41;
        Tue,  1 Mar 2022 20:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7718C340EF;
        Tue,  1 Mar 2022 20:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165894;
        bh=nRfjjQt3uhzoWzj1Y0kgrQEh80Jjl3cSm8J1LKRJfU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkdHvPixXp/ztYPz1s/jLw9Be/OJeXs3A6JDRrpq/KDhcIlrSYjlZs5lFuyvnY7rK
         3f4eL5Ptkg3mPiRAAgxyGdAegjVk10aZ+2wGbKLEVsU5T0Sf3KO7mVGHymVnA6d1i8
         qMOd5TDRwn8zLSNp/aAuArHcPeUnXNJL9GhFU7vZ+OYdInIoz603mcg7gLEBOcmIo9
         RbWMmM2c3WH7v3KVntl5beX/9o1XnnAorA3AJcGkY0TkkJfHnraFbPa87c7q26ofv+
         WzJzRgyZ0JpZU9sxIPIBk2FU07N1PqQY2ULTjdo6I3H1RlDjgMt5UwzwGevwMHNMo2
         czvD7PMNI7saA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 21/23] tracing/osnoise: Make osnoise_main to sleep for microseconds
Date:   Tue,  1 Mar 2022 15:16:20 -0500
Message-Id: <20220301201629.18547-21-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit dd990352f01ee9a6c6eee152e5d11c021caccfe4 ]

osnoise's runtime and period are in the microseconds scale, but it is
currently sleeping in the millisecond's scale. This behavior roots in the
usage of hwlat as the skeleton for osnoise.

Make osnoise to sleep in the microseconds scale. Also, move the sleep to
a specialized function.

Link: https://lkml.kernel.org/r/302aa6c7bdf2d131719b22901905e9da122a11b2.1645197336.git.bristot@kernel.org

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_osnoise.c | 53 ++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 65a518649997b..fc491d0aee5a0 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1249,6 +1249,37 @@ static int run_osnoise(void)
 static struct cpumask osnoise_cpumask;
 static struct cpumask save_cpumask;
 
+/*
+ * osnoise_sleep - sleep until the next period
+ */
+static void osnoise_sleep(void)
+{
+	u64 interval;
+	ktime_t wake_time;
+
+	mutex_lock(&interface_lock);
+	interval = osnoise_data.sample_period - osnoise_data.sample_runtime;
+	mutex_unlock(&interface_lock);
+
+	/*
+	 * differently from hwlat_detector, the osnoise tracer can run
+	 * without a pause because preemption is on.
+	 */
+	if (!interval) {
+		/* Let synchronize_rcu_tasks() make progress */
+		cond_resched_tasks_rcu_qs();
+		return;
+	}
+
+	wake_time = ktime_add_us(ktime_get(), interval);
+	__set_current_state(TASK_INTERRUPTIBLE);
+
+	while (schedule_hrtimeout_range(&wake_time, 0, HRTIMER_MODE_ABS)) {
+		if (kthread_should_stop())
+			break;
+	}
+}
+
 /*
  * osnoise_main - The osnoise detection kernel thread
  *
@@ -1257,30 +1288,10 @@ static struct cpumask save_cpumask;
  */
 static int osnoise_main(void *data)
 {
-	u64 interval;
 
 	while (!kthread_should_stop()) {
-
 		run_osnoise();
-
-		mutex_lock(&interface_lock);
-		interval = osnoise_data.sample_period - osnoise_data.sample_runtime;
-		mutex_unlock(&interface_lock);
-
-		do_div(interval, USEC_PER_MSEC);
-
-		/*
-		 * differently from hwlat_detector, the osnoise tracer can run
-		 * without a pause because preemption is on.
-		 */
-		if (interval < 1) {
-			/* Let synchronize_rcu_tasks() make progress */
-			cond_resched_tasks_rcu_qs();
-			continue;
-		}
-
-		if (msleep_interruptible(interval))
-			break;
+		osnoise_sleep();
 	}
 
 	return 0;
-- 
2.34.1

