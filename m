Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3DCE193F
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 13:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390783AbfJWLqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 07:46:47 -0400
Received: from [217.140.110.172] ([217.140.110.172]:49266 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2390566AbfJWLqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 07:46:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 864A4494;
        Wed, 23 Oct 2019 04:46:24 -0700 (PDT)
Received: from [192.168.0.9] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B41A03F6C4;
        Wed, 23 Oct 2019 04:46:22 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] sched/topology: Don't try to build empty sched
 domains
To:     Valentin Schneider <valentin.schneider@arm.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc:     lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, qperret@google.com,
        stable@vger.kernel.org
References: <20191015154250.12951-1-valentin.schneider@arm.com>
 <20191015154250.12951-2-valentin.schneider@arm.com>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <9134acf7-69bb-403b-2e9c-0eb7fb7efabd@arm.com>
Date:   Wed, 23 Oct 2019 13:46:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015154250.12951-2-valentin.schneider@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/10/2019 17:42, Valentin Schneider wrote:

[...]

> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index c52bc91f882b..a859e5539440 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -817,6 +817,11 @@ static int generate_sched_domains(cpumask_var_t **domains,
>  		struct cpuset *a = csa[i];
>  		int apn = a->pn;
>  
> +		if (cpumask_empty(a->effective_cpus)) {
> +			ndoms--;
> +			continue;
> +		}
> +
>  		for (j = 0; j < csn; j++) {
>  			struct cpuset *b = csa[j];
>  			int bpn = b->pn;
> @@ -859,6 +864,9 @@ static int generate_sched_domains(cpumask_var_t **domains,
>  			continue;
>  		}
>  
> +		if (cpumask_empty(a->effective_cpus))
> +			continue;
> +

Can you not just prevent that a cpuset pointer (cp) is added to the
cpuset array (csa[]) in case cpumask_empty(cp->effective_cpus)?

@@ -798,9 +800,14 @@ static int generate_sched_domains(cpumask_var_t
**domains, cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
                        continue;

-   if (is_sched_load_balance(cp))
+   if (is_sched_load_balance(cp) && !cpumask_empty(cp->effective_cpus))
            csa[csn++] = cp;

>  		dp = doms[nslot];
>  
>  		if (nslot == ndoms) {

[...]
