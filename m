Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCF17EC30
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 07:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387939AbfHBFoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 01:44:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42394 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732723AbfHBFoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 01:44:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so33244503plb.9
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 22:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IQiEltWXcaJ4ww5AxptfVEQnJ5UMr5Pimco/lTpuDRE=;
        b=AWtoJNTQKLi0c8mDS75fkbk24KpEbX7Z3HpsQ5ZCk7Iowak2phz7Hma5th9nwG6rt4
         5vhCMeeUidwGlPHoROnI+CbVRiNBRdz+8UgqyhDqZC6VSUhnylilIe2CkRhX4fpAj1pS
         YYPuA6mZEmrhWfPpMVINnKvYF9s+RCU4crV9T0rHo88AMcxll6r6Zn8KdOUobLf3jAgq
         d7WMo+P9jfqtF5hC4Nf3mzQYLI/P6SrxmrUuPRCy5rlBU9s0Ie9QLJkO72+XYz53sEKC
         vFRlMGxwV5khY/ApjPR/A4aOn48+zhq7/bINnhSPZSuHjBPdivQtfcCKwLNAFAIyEaH1
         JNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IQiEltWXcaJ4ww5AxptfVEQnJ5UMr5Pimco/lTpuDRE=;
        b=n4T3UWBaBPfnu3UB0i0UwCo6g3g6/rPb6gNEQX8cqoNBw2Wh71Bwzar5y5pMAK0olw
         u2mFLuFYMdJCGGIfTljYM2xOKuY6fQlwOzyKiCroOGONyEA29cHlAGCPnBQoa5JsvaDx
         GQr7QbdmZxJMQ6vSkizTQIjJ6VoKJV8kvmDID2WGu89wOFdAGVS1r9Rk2GRx9ffFErv1
         9KQ98Z5sOq3k7VCv5+QEavc6KB1OFO3V9MHYdj6JTDzQpXbfE8lHWSzobCPh3O35pZSb
         zvrG+jqVcjBt4GbRmmqsr0n4avBRq7SwH1EQZB/1pCe9cmhW3DMVZXbKMjfNKQOi5Hhl
         AcaA==
X-Gm-Message-State: APjAAAWB2Qt8LNRo1DRtQxZ6MrYdNNkNE52RdOSMcSx6nRjFet/GkA9q
        rrZvr32dFjZJ8qEKyf6u6IzF4g==
X-Google-Smtp-Source: APXvYqxrNT4X9tZPfwrYCWlcv+1SVd6J5e28alQnoNDdpQ5Eu+SUVRljHw3+ZDcSqVw2+KCs40UTCQ==
X-Received: by 2002:a17:902:bd06:: with SMTP id p6mr132909092pls.189.1564724683238;
        Thu, 01 Aug 2019 22:44:43 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id g8sm83671355pgk.1.2019.08.01.22.44.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 22:44:41 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Rafael Wysocki <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "v4 . 18+" <stable@vger.kernel.org>,
        Doug Smythies <doug.smythies@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 1/2] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Fri,  2 Aug 2019 11:14:29 +0530
Message-Id: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To avoid reducing the frequency of a CPU prematurely, we skip reducing
the frequency if the CPU had been busy recently.

This should not be done when the limits of the policy are changed, for
example due to thermal throttling. We should always get the frequency
within the new limits as soon as possible.

Trying to fix this by using only one flag, i.e. need_freq_update, can
lead to a race condition where the flag gets cleared without forcing us
to change the frequency at least once. And so this patch introduces
another flag to avoid that race condition.

Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
Reported-by: Doug Smythies <doug.smythies@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V2->V3:
- Updated commit log.

V1->V2:
- Fixed the race condition using a different flag.

@Doug: I haven't changed the code since you last tested these. Your
Tested-by tag can be useful while applying the patches. Thanks.

 kernel/sched/cpufreq_schedutil.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 636ca6f88c8e..2f382b0959e5 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -40,6 +40,7 @@ struct sugov_policy {
 	struct task_struct	*thread;
 	bool			work_in_progress;
 
+	bool			limits_changed;
 	bool			need_freq_update;
 };
 
@@ -89,8 +90,11 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 	    !cpufreq_this_cpu_can_update(sg_policy->policy))
 		return false;
 
-	if (unlikely(sg_policy->need_freq_update))
+	if (unlikely(sg_policy->limits_changed)) {
+		sg_policy->limits_changed = false;
+		sg_policy->need_freq_update = true;
 		return true;
+	}
 
 	delta_ns = time - sg_policy->last_freq_update_time;
 
@@ -437,7 +441,7 @@ static inline bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu) { return false; }
 static inline void ignore_dl_rate_limit(struct sugov_cpu *sg_cpu, struct sugov_policy *sg_policy)
 {
 	if (cpu_bw_dl(cpu_rq(sg_cpu->cpu)) > sg_cpu->bw_dl)
-		sg_policy->need_freq_update = true;
+		sg_policy->limits_changed = true;
 }
 
 static void sugov_update_single(struct update_util_data *hook, u64 time,
@@ -447,7 +451,7 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
 	struct sugov_policy *sg_policy = sg_cpu->sg_policy;
 	unsigned long util, max;
 	unsigned int next_f;
-	bool busy;
+	bool busy = false;
 
 	sugov_iowait_boost(sg_cpu, time, flags);
 	sg_cpu->last_update = time;
@@ -457,7 +461,9 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
 	if (!sugov_should_update_freq(sg_policy, time))
 		return;
 
-	busy = sugov_cpu_is_busy(sg_cpu);
+	/* Limits may have changed, don't skip frequency update */
+	if (!sg_policy->need_freq_update)
+		busy = sugov_cpu_is_busy(sg_cpu);
 
 	util = sugov_get_util(sg_cpu);
 	max = sg_cpu->max;
@@ -831,6 +837,7 @@ static int sugov_start(struct cpufreq_policy *policy)
 	sg_policy->last_freq_update_time	= 0;
 	sg_policy->next_freq			= 0;
 	sg_policy->work_in_progress		= false;
+	sg_policy->limits_changed		= false;
 	sg_policy->need_freq_update		= false;
 	sg_policy->cached_raw_freq		= 0;
 
@@ -879,7 +886,7 @@ static void sugov_limits(struct cpufreq_policy *policy)
 		mutex_unlock(&sg_policy->work_lock);
 	}
 
-	sg_policy->need_freq_update = true;
+	sg_policy->limits_changed = true;
 }
 
 struct cpufreq_governor schedutil_gov = {
-- 
2.21.0.rc0.269.g1a574e7a288b

