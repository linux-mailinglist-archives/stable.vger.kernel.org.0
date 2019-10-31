Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B90EB60B
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 18:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfJaRXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 13:23:24 -0400
Received: from foss.arm.com ([217.140.110.172]:52846 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbfJaRXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Oct 2019 13:23:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DEEB1FB;
        Thu, 31 Oct 2019 10:23:23 -0700 (PDT)
Received: from [10.188.222.161] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C35D3F6C4;
        Thu, 31 Oct 2019 10:23:21 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] sched/topology: Don't try to build empty sched
 domains
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc:     linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com,
        qperret@google.com, stable@vger.kernel.org
References: <20191023153745.19515-1-valentin.schneider@arm.com>
 <20191023153745.19515-2-valentin.schneider@arm.com>
 <20191031162334.GA18570@blackbody.suse.cz>
From:   Valentin Schneider <valentin.schneider@arm.com>
Message-ID: <3752bca9-a670-f415-4aaa-e8ff75ea6fcc@arm.com>
Date:   Thu, 31 Oct 2019 18:23:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031162334.GA18570@blackbody.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michal,

On 31/10/2019 17:23, Michal Koutný wrote:
> On Wed, Oct 23, 2019 at 04:37:44PM +0100, Valentin Schneider <valentin.schneider@arm.com> wrote:
>> Prevent generate_sched_domains() from returning empty cpumasks, and add
>> some assertion in build_sched_domains() to scream bloody murder if it
>> happens again.
> Good catch. It makes sense to prune the empty domains in
> generate_sched_domains already.
> 
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index c52bc91f882b..c87ee6412b36 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -798,7 +798,8 @@ static int generate_sched_domains(cpumask_var_t **domains,
>>  		    cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
>>  			continue;
>>  
>> -		if (is_sched_load_balance(cp))
>> +		if (is_sched_load_balance(cp) &&
>> +		    !cpumask_empty(cp->effective_cpus))
>>  			csa[csn++] = cp;
> If I didn't overlook anything, cp->effective_cpus can contain CPUs
> exluded by housekeeping_cpumask(HK_FLAG_DOMAIN) later, i.e. possibly
> still returning domains with empty cpusets.
> 
> I'd suggest moving the emptiness check down into the loop where domain
> cpumasks are ultimately constructed.
> 

Ah, wasn't aware of this - thanks for having a look!

I think I need to have the check before the final cpumask gets built,
because at this point the cpumask array is already built and it's handed
off directly to the sched domain rebuild.

Do you reckon the following would work? 

----8<----
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c87ee6412b36..e4c10785dc7c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -798,8 +798,14 @@ static int generate_sched_domains(cpumask_var_t **domains,
 		    cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
 			continue;
 
+		/*
+		 * Skip cpusets that would lead to an empty sched domain.
+		 * That could be because effective_cpus is empty, or because
+		 * it's only spanning CPUs outside the housekeeping mask.
+		 */
 		if (is_sched_load_balance(cp) &&
-		    !cpumask_empty(cp->effective_cpus))
+		    cpumask_intersects(cp->effective_cpus,
+				       housekeeping_cpumask(HK_FLAG_DOMAIN)))
 			csa[csn++] = cp;
 
 		/* skip @cp's subtree if not a partition root */
