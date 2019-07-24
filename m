Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEF372DED
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 13:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfGXLnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 07:43:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43098 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbfGXLnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 07:43:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so21095226pgv.10
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 04:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GjrjrZefbeD4YNw97bdq0OFbFAiYcwQG6poDlhWKhMM=;
        b=UbOhy1e2mE6029WQB2ky4kzXsKCacJp7XvHsvOzPMzPEfEp2V5voZ8iEBMrUMb49u7
         7WU8eaDc1Nq7bKzPiaM8o7O4LVZ8d3SoVnwAaNDh8SY/WCvXHfmhrIecN5VbK+txJQWc
         6wt+GFOICFrR+hxzsRPv+WPd71h46Yqy5BPP5x1dgRs5aHAO9diYmgvNok9r86mgNkNA
         xVjLjW+IYc4b2A7ZyeSwD4qlZiMWBxvX7rX6GtOzd2OgNzZqexMZ70Z9vHe0xr2i7nJO
         fykz4SpLlrmH6lVf2LlgvICmgARBUw9+BBB7kHhNTessc42eEcddiEKU0TYsULBo+Fnx
         glMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GjrjrZefbeD4YNw97bdq0OFbFAiYcwQG6poDlhWKhMM=;
        b=rE9ADYufur0vtLbYhTwwEmc5YKdwsJBl6/2gYyC8K33FlwDjf5qMyY8ZB1d3U6cMP0
         ipvgsATOM+ZsYuRBsNJbT3M5/1qOOxe894oCPqv61ddk2DZ90is/5RrMo+ntdtVISdQ/
         NRLK62X33Lbm8XBkQUOIy2ByAciOpF6B0J5l8q5InXQ/BrwpeuFp4/D6S8RAhseHFmmJ
         j3Fnica6qUj1FbYEKB9y8nbgKS9noJsXdfJgHUsavTfCmKK+FRmPyEx4x1XXbxm3+oZN
         D4cTYC5BuMMy4HR56qaZ8s1VHTtkCSJ/WjpGsZCw6Wk/PONX+rlrPtStbmUlwbRDRB4G
         OKuA==
X-Gm-Message-State: APjAAAUXSaMalweVU/991EvjyFj1QA1nZy31mOM0UyuKlBKVrjn5i0mk
        yNMjGH5PEHSGiDpi43PVCzpMLQ==
X-Google-Smtp-Source: APXvYqzjd3zV6yzY8DnB2WP/0FMO1x3mVOy9nHpv0FZi2xKvAPJXj1D7UT1M9BonPwPvjb2pgfnYpA==
X-Received: by 2002:a17:90a:376f:: with SMTP id u102mr88017646pjb.5.1563968611498;
        Wed, 24 Jul 2019 04:43:31 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id p20sm71599817pgj.47.2019.07.24.04.43.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 04:43:29 -0700 (PDT)
Date:   Wed, 24 Jul 2019 17:13:27 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Doug Smythies <dsmythies@telus.net>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        "v4 . 18+" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: schedutil: Don't skip freq update when limits
 change
Message-ID: <20190724114327.apmx35c7a4tv3qt5@vireshk-i7>
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net>
 <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org>
 <001201d54125$a6a82350$f3f869f0$@net>
 <20190723091551.nchopfpqlmdmzvge@vireshk-i7>
 <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23-07-19, 12:27, Rafael J. Wysocki wrote:
> On Tue, Jul 23, 2019 at 11:15 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > Though there is one difference between intel_cpufreq and acpi_cpufreq,
> > intel_cpufreq has fast_switch_possible=true and so it uses slightly
> > different path in schedutil. I tried to look from that perspective as
> > well but couldn't find anything wrong.
> 
> acpi-cpufreq should use fast switching on the Doug's system too.

Ah okay.

> > If you still find intel_cpufreq to be broken, even with this patch,
> > please set fast_switch_possible=false instead of true in
> > __intel_pstate_cpu_init() and try tests again. That shall make it very
> > much similar to acpi-cpufreq driver.
> 
> I wonder if this helps.  Even so, we want fast switching to be used by
> intel_cpufreq.

With both using fast switching it shouldn't make any difference.

> Anyway, it looks like the change reverted by the Doug's patch
> introduced a race condition that had not been present before.  Namely,
> need_freq_update is cleared in get_next_freq() when it is set _or_
> when the new freq is different from the cached one, so in the latter
> case if it happens to be set by sugov_limits() after evaluating
> sugov_should_update_freq() (which returned 'true' for timing reasons),
> that update will be lost now. [Previously the update would not be
> lost, because the clearing of need_freq_update depended only on its
> current value.] Where it matters is that in the "need_freq_update set"
> case, the "premature frequency reduction avoidance" should not be
> applied (as you noticed and hence the $subject patch).
> 
> However, even with the $subject patch, need_freq_update may still be
> set by sugov_limits() after the check added by it and then cleared by
> get_next_freq(), so it doesn't really eliminate the problem.
> 
> IMO eliminating would require invalidating next_freq this way or
> another when need_freq_update is set in sugov_should_update_freq(),
> which was done before commit ecd2884291261e3fddbc7651ee11a20d596bb514.

Hmm, so to avoid locking in fast path we need two variable group to
protect against this kind of issues. I still don't want to override
next_freq with a special meaning as it can cause hidden bugs, we have
seen that earlier.

What about something like this then ?

-- 
viresh

-------------------------8<-------------------------
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
