Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC624D844E
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241483AbiCNMWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243626AbiCNMVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B5F54FA5;
        Mon, 14 Mar 2022 05:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86EF7608C4;
        Mon, 14 Mar 2022 12:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AF8C340E9;
        Mon, 14 Mar 2022 12:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260190;
        bh=dVGoPrrWRTVHA4L6rhMCbLqZZdospTvDe05WnMPVvFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtiqJ63sYxe1yOsuMCUs1nSeZ8aGGyhCuZn+BK99bTn6IxYJ8Yo9q2PZo8sd5xTNG
         9o82BkcBav8kZ9REmriEmfrXwP6m+KZXkV1mPu3kdel+OFBBgyiNOaihbUDFaPAVYi
         XPRNYFs/gwxnL+V4295A0KMozaXsS/nPdrUQr4uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 082/121] tracing/osnoise: Make osnoise_main to sleep for microseconds
Date:   Mon, 14 Mar 2022 12:54:25 +0100
Message-Id: <20220314112746.409684021@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b58674e8644a..58c788b0ca27 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1437,6 +1437,37 @@ static int run_osnoise(void)
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
@@ -1445,30 +1476,10 @@ static struct cpumask save_cpumask;
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



