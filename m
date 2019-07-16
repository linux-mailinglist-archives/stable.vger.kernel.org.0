Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D9A6A4BF
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 11:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfGPJVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 05:21:38 -0400
Received: from mga04.intel.com ([192.55.52.120]:50341 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbfGPJVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 05:21:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 02:21:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,497,1557212400"; 
   d="scan'208";a="172490148"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.128.254]) ([10.249.128.254])
  by orsmga006.jf.intel.com with ESMTP; 16 Jul 2019 02:21:35 -0700
Subject: Re: [PATCH AUTOSEL 4.19 123/158] cpufreq: Don't skip frequency
 validation for has_target() drivers
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
References: <20190715141809.8445-1-sashal@kernel.org>
 <20190715141809.8445-123-sashal@kernel.org>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <92ae669e-654c-40b2-0470-e9280d9c2dd0@intel.com>
Date:   Tue, 16 Jul 2019 11:21:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190715141809.8445-123-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/2019 4:17 PM, Sasha Levin wrote:
> From: Viresh Kumar <viresh.kumar@linaro.org>
>
> [ Upstream commit 9801522840cc1073f8064b4c979b7b6995c74bca ]
>
> CPUFREQ_CONST_LOOPS was introduced in a very old commit from pre-2.6
> kernel release by commit 6a4a93f9c0d5 ("[CPUFREQ] Fix 'out of sync'
> issue").
>
> Basically, that commit does two things:
>
>   - It adds the frequency verification code (which is quite similar to
>     what we have today as well).
>
>   - And it sets the CPUFREQ_CONST_LOOPS flag only for setpolicy drivers,
>     rightly so based on the code we had then. The idea was to avoid
>     frequency validation for setpolicy drivers as the cpufreq core doesn't
>     know what frequency the hardware is running at and so no point in
>     doing frequency verification.
>
> The problem happened when we started to use the same CPUFREQ_CONST_LOOPS
> flag for constant loops-per-jiffy thing as well and many has_target()
> drivers started using the same flag and unknowingly skipped the
> verification of frequency. There is no logical reason behind skipping
> frequency validation because of the presence of CPUFREQ_CONST_LOOPS
> flag otherwise.
>
> Fix this issue by skipping frequency validation only for setpolicy
> drivers and always doing it for has_target() drivers irrespective of
> the presence or absence of CPUFREQ_CONST_LOOPS flag.
>
> cpufreq_notify_transition() is only called for has_target() type driver
> and not for set_policy type, and the check is simply redundant. Remove
> it as well.
>
> Also remove () around freq comparison statement as they aren't required
> and checkpatch also warns for them.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/cpufreq/cpufreq.c | 13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index d3213594d1a7..80942ec34efd 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -321,12 +321,10 @@ static void cpufreq_notify_transition(struct cpufreq_policy *policy,
>   		 * which is not equal to what the cpufreq core thinks is
>   		 * "old frequency".
>   		 */
> -		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
> -			if (policy->cur && (policy->cur != freqs->old)) {
> -				pr_debug("Warning: CPU frequency is %u, cpufreq assumed %u kHz\n",
> -					 freqs->old, policy->cur);
> -				freqs->old = policy->cur;
> -			}
> +		if (policy->cur && policy->cur != freqs->old) {
> +			pr_debug("Warning: CPU frequency is %u, cpufreq assumed %u kHz\n",
> +				 freqs->old, policy->cur);
> +			freqs->old = policy->cur;
>   		}
>   
>   		for_each_cpu(freqs->cpu, policy->cpus) {
> @@ -1543,8 +1541,7 @@ static unsigned int __cpufreq_get(struct cpufreq_policy *policy)
>   	if (policy->fast_switch_enabled)
>   		return ret_freq;
>   
> -	if (ret_freq && policy->cur &&
> -		!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
> +	if (has_target() && ret_freq && policy->cur) {
>   		/* verify no discrepancy between actual and
>   					saved value exists */
>   		if (unlikely(ret_freq != policy->cur)) {

This is not -stable material, please drop it.


