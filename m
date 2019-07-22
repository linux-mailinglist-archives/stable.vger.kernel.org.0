Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B41B6F6C5
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 02:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfGVAkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 20:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfGVAkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 20:40:18 -0400
Received: from localhost (unknown [216.243.17.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21184206BF;
        Mon, 22 Jul 2019 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563756017;
        bh=gPT+BxnYQ6P9BzQMa21BpYQtKFjc0KpfgzO3IKxyhrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hlGKNRdE9T8YadL5/A8vL6K2bCe76SqK2VEw0JX4AILg2qvTPmTFIYIVgyOPq0xlU
         fWbfBxMMFW61GnVKXqgOk/iGa2yxJqeJkfYHQaBW4vE49+0OUnwfZwrQ3QVyCWVigO
         ZZJkl8mCoHu5/Zk1hoKyE7BPLmZrhm7Vx6LYvorI=
Date:   Sun, 21 Jul 2019 20:40:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.2 190/249] cpufreq: Avoid calling
 cpufreq_verify_current_freq() from handle_update()
Message-ID: <20190722004016.GD1607@sasha-vm>
References: <20190715134655.4076-1-sashal@kernel.org>
 <20190715134655.4076-190-sashal@kernel.org>
 <b43e57ea-c5b8-b4c4-f58f-405e649aada1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b43e57ea-c5b8-b4c4-f58f-405e649aada1@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 11:25:00AM +0200, Rafael J. Wysocki wrote:
>On 7/15/2019 3:45 PM, Sasha Levin wrote:
>>From: Viresh Kumar <viresh.kumar@linaro.org>
>>
>>[ Upstream commit 70a59fde6e69d1d8579f84bf4555bfffb3ce452d ]
>>
>>On some occasions cpufreq_verify_current_freq() schedules a work whose
>>callback is handle_update(), which further calls cpufreq_update_policy()
>>which may end up calling cpufreq_verify_current_freq() again.
>>
>>On the other hand, when cpufreq_update_policy() is called from
>>handle_update(), the pointer to the cpufreq policy is already
>>available, but cpufreq_cpu_acquire() is still called to get it in
>>cpufreq_update_policy(), which should be avoided as well.
>>
>>To fix these issues, create a new helper, refresh_frequency_limits(),
>>and make both handle_update() call it cpufreq_update_policy().
>>
>>Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>[ rjw: Rename reeval_frequency_limits() as refresh_frequency_limits() ]
>>[ rjw: Changelog ]
>>Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  drivers/cpufreq/cpufreq.c | 26 ++++++++++++++++----------
>>  1 file changed, 16 insertions(+), 10 deletions(-)
>>
>>diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>>index e84bf0eb7239..876a4cb09de3 100644
>>--- a/drivers/cpufreq/cpufreq.c
>>+++ b/drivers/cpufreq/cpufreq.c
>>@@ -1114,13 +1114,25 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy, unsigned int cp
>>  	return ret;
>>  }
>>+static void refresh_frequency_limits(struct cpufreq_policy *policy)
>>+{
>>+	struct cpufreq_policy new_policy = *policy;
>>+
>>+	pr_debug("updating policy for CPU %u\n", policy->cpu);
>>+
>>+	new_policy.min = policy->user_policy.min;
>>+	new_policy.max = policy->user_policy.max;
>>+
>>+	cpufreq_set_policy(policy, &new_policy);
>>+}
>>+
>>  static void handle_update(struct work_struct *work)
>>  {
>>  	struct cpufreq_policy *policy =
>>  		container_of(work, struct cpufreq_policy, update);
>>-	unsigned int cpu = policy->cpu;
>>-	pr_debug("handle_update for cpu %u called\n", cpu);
>>-	cpufreq_update_policy(cpu);
>>+
>>+	pr_debug("handle_update for cpu %u called\n", policy->cpu);
>>+	refresh_frequency_limits(policy);
>>  }
>>  static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
>>@@ -2392,7 +2404,6 @@ int cpufreq_set_policy(struct cpufreq_policy *policy,
>>  void cpufreq_update_policy(unsigned int cpu)
>>  {
>>  	struct cpufreq_policy *policy = cpufreq_cpu_acquire(cpu);
>>-	struct cpufreq_policy new_policy;
>>  	if (!policy)
>>  		return;
>>@@ -2405,12 +2416,7 @@ void cpufreq_update_policy(unsigned int cpu)
>>  	    (cpufreq_suspended || WARN_ON(!cpufreq_update_current_freq(policy))))
>>  		goto unlock;
>>-	pr_debug("updating policy for CPU %u\n", cpu);
>>-	memcpy(&new_policy, policy, sizeof(*policy));
>>-	new_policy.min = policy->user_policy.min;
>>-	new_policy.max = policy->user_policy.max;
>>-
>>-	cpufreq_set_policy(policy, &new_policy);
>>+	refresh_frequency_limits(policy);
>>  unlock:
>>  	cpufreq_cpu_release(policy);
>
>I don't think this is suitable for -stable.

I've dropped it, thanks!

--
Thanks,
Sasha
