Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAFAE99C27
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388550AbfHVRbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391875AbfHVRZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:50 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3966E2064A;
        Thu, 22 Aug 2019 17:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494749;
        bh=bL68iMJ3TJ2Mww0F06M3ZjctDATG3hXQLAa3FyGMF9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bQDj0mwtHPNpYfAEUcCWJuEUBY2BCouRcC2GswkXqMfbygQqENiax5mATduyvIiI
         77zFtOuoBjuUDTw3IudiJ2evthPmZC4fwqMsa5aazkXMQ7dVKst0ZIWfUKCEhtaGjr
         Mr5D45KEumRzTglZLN8M618N7w32cL99f2A9TPd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Smythies <dsmythies@telus.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 09/85] cpufreq: schedutil: Dont skip freq update when limits change
Date:   Thu, 22 Aug 2019 10:18:42 -0700
Message-Id: <20190822171731.403911636@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 600f5badb78c316146d062cfd7af4a2cfb655baa upstream.

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
Reported-by: Doug Smythies <dsmythies@telus.net>
Tested-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/cpufreq_schedutil.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -40,6 +40,7 @@ struct sugov_policy {
 	struct task_struct	*thread;
 	bool			work_in_progress;
 
+	bool			limits_changed;
 	bool			need_freq_update;
 };
 
@@ -90,8 +91,11 @@ static bool sugov_should_update_freq(str
 	    !cpufreq_this_cpu_can_update(sg_policy->policy))
 		return false;
 
-	if (unlikely(sg_policy->need_freq_update))
+	if (unlikely(sg_policy->limits_changed)) {
+		sg_policy->limits_changed = false;
+		sg_policy->need_freq_update = true;
 		return true;
+	}
 
 	delta_ns = time - sg_policy->last_freq_update_time;
 
@@ -405,7 +409,7 @@ static inline bool sugov_cpu_is_busy(str
 static inline void ignore_dl_rate_limit(struct sugov_cpu *sg_cpu, struct sugov_policy *sg_policy)
 {
 	if (cpu_bw_dl(cpu_rq(sg_cpu->cpu)) > sg_cpu->bw_dl)
-		sg_policy->need_freq_update = true;
+		sg_policy->limits_changed = true;
 }
 
 static void sugov_update_single(struct update_util_data *hook, u64 time,
@@ -425,7 +429,8 @@ static void sugov_update_single(struct u
 	if (!sugov_should_update_freq(sg_policy, time))
 		return;
 
-	busy = sugov_cpu_is_busy(sg_cpu);
+	/* Limits may have changed, don't skip frequency update */
+	busy = !sg_policy->need_freq_update && sugov_cpu_is_busy(sg_cpu);
 
 	util = sugov_get_util(sg_cpu);
 	max = sg_cpu->max;
@@ -798,6 +803,7 @@ static int sugov_start(struct cpufreq_po
 	sg_policy->last_freq_update_time	= 0;
 	sg_policy->next_freq			= 0;
 	sg_policy->work_in_progress		= false;
+	sg_policy->limits_changed		= false;
 	sg_policy->need_freq_update		= false;
 	sg_policy->cached_raw_freq		= 0;
 
@@ -849,7 +855,7 @@ static void sugov_limits(struct cpufreq_
 		mutex_unlock(&sg_policy->work_lock);
 	}
 
-	sg_policy->need_freq_update = true;
+	sg_policy->limits_changed = true;
 }
 
 static struct cpufreq_governor schedutil_gov = {


