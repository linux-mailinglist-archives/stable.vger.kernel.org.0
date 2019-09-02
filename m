Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 503AFA5956
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 16:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbfIBO1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 10:27:46 -0400
Received: from foss.arm.com ([217.140.110.172]:55702 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731482AbfIBO1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 10:27:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C67A4344;
        Mon,  2 Sep 2019 07:27:45 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 724073F59C;
        Mon,  2 Sep 2019 07:27:44 -0700 (PDT)
Date:   Mon, 2 Sep 2019 15:27:42 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH ARM64 v4.4 V3 12/44] arm64: cpufeature: Test 'matches'
 pointer to find the end of the list
Message-ID: <20190902142741.GB9922@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <617ad445043f040c5ab986b9620b2ba7847b561e.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617ad445043f040c5ab986b9620b2ba7847b561e.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:03:57PM +0530, Viresh Kumar wrote:
> From: James Morse <james.morse@arm.com>
> 
> commit 644c2ae198412c956700e55a2acf80b2541f6aa5 upstream.
> 
> CPU feature code uses the desc field as a test to find the end of the list,
> this means every entry must have a description. This generates noise for
> entries in the list that aren't really features, but combinations of them.
> e.g.
> > CPU features: detected feature: Privileged Access Never
> > CPU features: detected feature: PAN and not UAO
> 
> These combination features are needed for corner cases with alternatives,
> where cpu features interact.
> 
> Change all walkers of the arm64_features[] and arm64_hwcaps[] lists to test
> 'matches' not 'desc', and only print 'desc' if it is non-NULL.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by : Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/arm64/kernel/cpufeature.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

From looking at my 4.9.y/{meltdown,spectre} banches on kernel.org [1,2],
and chasing the history v4.4..v4.9, there are a number of patches I'd
expect to have alongside this that I don't spot in this series:

* e3661b128e53ee281e1e7c589a5b647890bd6d7c ("arm64: Allow a capability to be checked on a single CPU")
* 8f4137588261d7504f4aa022dc9d1a1fd1940e8e ("arm64: Allow checking of a CPU-local erratum")
* 67948af41f2e6818edeeba5182811c704d484949 ("arm64: capabilities: Handle duplicate entries for a capability")
* edf298cfce47ab7279d03b5203ae2ef3a58e49db ("arm64: cpufeature: __this_cpu_has_cap() shouldn't stop early")

... which IIUC are necessary for big.LITTLE to work correctly.

Have you verified this for big.LITTLE?

Thanks,
Mark.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=stable/4.9.y/meltdown
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=stable/4.9.y/spectre

> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c1eddc07d996..bdb4cd9ffccf 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -744,7 +744,7 @@ static void setup_cpu_hwcaps(void)
>  	int i;
>  	const struct arm64_cpu_capabilities *hwcaps = arm64_hwcaps;
>  
> -	for (i = 0; hwcaps[i].desc; i++)
> +	for (i = 0; hwcaps[i].matches; i++)
>  		if (hwcaps[i].matches(&hwcaps[i]))
>  			cap_set_hwcap(&hwcaps[i]);
>  }
> @@ -754,11 +754,11 @@ void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
>  {
>  	int i;
>  
> -	for (i = 0; caps[i].desc; i++) {
> +	for (i = 0; caps[i].matches; i++) {
>  		if (!caps[i].matches(&caps[i]))
>  			continue;
>  
> -		if (!cpus_have_cap(caps[i].capability))
> +		if (!cpus_have_cap(caps[i].capability) && caps[i].desc)
>  			pr_info("%s %s\n", info, caps[i].desc);
>  		cpus_set_cap(caps[i].capability);
>  	}
> @@ -772,7 +772,7 @@ static void enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
>  {
>  	int i;
>  
> -	for (i = 0; caps[i].desc; i++)
> +	for (i = 0; caps[i].matches; i++)
>  		if (caps[i].enable && cpus_have_cap(caps[i].capability))
>  			/*
>  			 * Use stop_machine() as it schedules the work allowing
> @@ -884,7 +884,7 @@ void verify_local_cpu_capabilities(void)
>  		return;
>  
>  	caps = arm64_features;
> -	for (i = 0; caps[i].desc; i++) {
> +	for (i = 0; caps[i].matches; i++) {
>  		if (!cpus_have_cap(caps[i].capability) || !caps[i].sys_reg)
>  			continue;
>  		/*
> @@ -897,7 +897,7 @@ void verify_local_cpu_capabilities(void)
>  			caps[i].enable(NULL);
>  	}
>  
> -	for (i = 0, caps = arm64_hwcaps; caps[i].desc; i++) {
> +	for (i = 0, caps = arm64_hwcaps; caps[i].matches; i++) {
>  		if (!cpus_have_hwcap(&caps[i]))
>  			continue;
>  		if (!feature_matches(__raw_read_system_reg(caps[i].sys_reg), &caps[i]))
> -- 
> 2.21.0.rc0.269.g1a574e7a288b
> 
