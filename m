Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C075D7B81B
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 04:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfGaC7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 22:59:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36999 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfGaC7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 22:59:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id i70so20388354pgd.4
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 19:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B7l52D/cRUQyEKtM6D9Z02BVoe/7k/AeNEzc9yQ+CeI=;
        b=bkoXiW2ZCG3VyC8G6LPZgBZuI3y0v2RUc/ccSE0ChSGLNoZT6BX5NE8m9Z8F/1Y46T
         OlrlmQZ/RU9gu6V2zSy+QA4wqnBGe23ABaN6+GETOMjbLTwv1v0b6ssiRxV1BOsJR6OV
         Uq1l0VsAIibFVMIuqQKhdKY/kCgPlFwMeCZh5+PL7h55QoJDscTpXhbqdZiuWmNXmreq
         YpyyRZaweDEJoQ+Rsj6RPXrtLPb3B5O3q6827dDVLuy49O+OVtJuCmfTYghgQ0IhHMIu
         ZAZGttFO4gUbQBSHY8UfufkMuYWTuIvjBg4AE05QyoJdH+v2asCd9GLKgyhlytygWTJa
         xG3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B7l52D/cRUQyEKtM6D9Z02BVoe/7k/AeNEzc9yQ+CeI=;
        b=dzUYQ24Y3BsiXUKmKVky81IhULDpXPVQTbfmeqtQ9Z40PjnfnBZ5mUt4Bn3LmkiSZG
         EWzj8EQHNgw7hPWxeQu9WcP1Cc6ka39ufgSX9becoUiO9p3wawl/E+6hFb3SJYQx1ly+
         QdXSu2eF8bKVB1fpUdkACBDtfyIu/VeuPzczZcl0fe0CgunmaUTrRPUSUalJQXM+sj9Q
         w9KGJWCoKxCGYe51xMQ5KL5Yja1AijVLJygVSlqO/WiEj0tIjfc8zt6sHY2gDLvJkWf0
         LyxarqmycSR2W939YnZpeAqEy38ROMK6hsg0jQMsrRxSzRoxZW65HpbB1FPaA+Oo6PGU
         fkjw==
X-Gm-Message-State: APjAAAW+llB6LS6hF1elxGV/hFG9KSnogjI1JlxKT5fAUSPFp06laYOR
        Pg14Vy46GR5RFGsa0g1T9XzwcQ==
X-Google-Smtp-Source: APXvYqzX977xFiSHTriuRuGYyl0OLc4P0XfrtGSCyPCZP10LRC7cWGWRT5jd8/2+n6pShJuBgEhHow==
X-Received: by 2002:a17:90a:1b48:: with SMTP id q66mr502148pjq.83.1564541948328;
        Tue, 30 Jul 2019 19:59:08 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id v18sm63769086pgl.87.2019.07.30.19.59.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 19:59:07 -0700 (PDT)
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
Subject: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Wed, 31 Jul 2019 08:28:57 +0530
Message-Id: <04ff2be6ef108585d57aa2462aa7a4c676b6d1cd.1564541875.git.viresh.kumar@linaro.org>
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

Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
Reported-by: Doug Smythies <doug.smythies@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
@Doug: Can you please provide your Tested-by for this commit, as it
already fixed the issue around acpi-cpufreq driver.

We will continue to see what's wrong with intel-pstate though.

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

