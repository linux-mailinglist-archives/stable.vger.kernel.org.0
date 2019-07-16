Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FE76A4D9
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 11:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbfGPJZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 05:25:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:26805 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfGPJZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 05:25:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 02:25:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,497,1557212400"; 
   d="scan'208";a="172490719"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.128.254]) ([10.249.128.254])
  by orsmga006.jf.intel.com with ESMTP; 16 Jul 2019 02:25:01 -0700
Subject: Re: [PATCH AUTOSEL 5.2 190/249] cpufreq: Avoid calling
 cpufreq_verify_current_freq() from handle_update()
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
References: <20190715134655.4076-1-sashal@kernel.org>
 <20190715134655.4076-190-sashal@kernel.org>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <b43e57ea-c5b8-b4c4-f58f-405e649aada1@intel.com>
Date:   Tue, 16 Jul 2019 11:25:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190715134655.4076-190-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/2019 3:45 PM, Sasha Levin wrote:
> From: Viresh Kumar <viresh.kumar@linaro.org>
>
> [ Upstream commit 70a59fde6e69d1d8579f84bf4555bfffb3ce452d ]
>
> On some occasions cpufreq_verify_current_freq() schedules a work whose
> callback is handle_update(), which further calls cpufreq_update_policy()
> which may end up calling cpufreq_verify_current_freq() again.
>
> On the other hand, when cpufreq_update_policy() is called from
> handle_update(), the pointer to the cpufreq policy is already
> available, but cpufreq_cpu_acquire() is still called to get it in
> cpufreq_update_policy(), which should be avoided as well.
>
> To fix these issues, create a new helper, refresh_frequency_limits(),
> and make both handle_update() call it cpufreq_update_policy().
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> [ rjw: Rename reeval_frequency_limits() as refresh_frequency_limits() ]
> [ rjw: Changelog ]
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/cpufreq/cpufreq.c | 26 ++++++++++++++++----------
>   1 file changed, 16 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index e84bf0eb7239..876a4cb09de3 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1114,13 +1114,25 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy, unsigned int cp
>   	return ret;
>   }
>   
> +static void refresh_frequency_limits(struct cpufreq_policy *policy)
> +{
> +	struct cpufreq_policy new_policy = *policy;
> +
> +	pr_debug("updating policy for CPU %u\n", policy->cpu);
> +
> +	new_policy.min = policy->user_policy.min;
> +	new_policy.max = policy->user_policy.max;
> +
> +	cpufreq_set_policy(policy, &new_policy);
> +}
> +
>   static void handle_update(struct work_struct *work)
>   {
>   	struct cpufreq_policy *policy =
>   		container_of(work, struct cpufreq_policy, update);
> -	unsigned int cpu = policy->cpu;
> -	pr_debug("handle_update for cpu %u called\n", cpu);
> -	cpufreq_update_policy(cpu);
> +
> +	pr_debug("handle_update for cpu %u called\n", policy->cpu);
> +	refresh_frequency_limits(policy);
>   }
>   
>   static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
> @@ -2392,7 +2404,6 @@ int cpufreq_set_policy(struct cpufreq_policy *policy,
>   void cpufreq_update_policy(unsigned int cpu)
>   {
>   	struct cpufreq_policy *policy = cpufreq_cpu_acquire(cpu);
> -	struct cpufreq_policy new_policy;
>   
>   	if (!policy)
>   		return;
> @@ -2405,12 +2416,7 @@ void cpufreq_update_policy(unsigned int cpu)
>   	    (cpufreq_suspended || WARN_ON(!cpufreq_update_current_freq(policy))))
>   		goto unlock;
>   
> -	pr_debug("updating policy for CPU %u\n", cpu);
> -	memcpy(&new_policy, policy, sizeof(*policy));
> -	new_policy.min = policy->user_policy.min;
> -	new_policy.max = policy->user_policy.max;
> -
> -	cpufreq_set_policy(policy, &new_policy);
> +	refresh_frequency_limits(policy);
>   
>   unlock:
>   	cpufreq_cpu_release(policy);

I don't think this is suitable for -stable.


