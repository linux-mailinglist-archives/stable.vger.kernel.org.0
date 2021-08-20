Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FB23F295A
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 11:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhHTJkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 05:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236739AbhHTJkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 05:40:17 -0400
X-Greylist: delayed 134 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Aug 2021 02:39:39 PDT
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723B8C061575;
        Fri, 20 Aug 2021 02:39:39 -0700 (PDT)
Received: from iva8-c5ee4261001e.qloud-c.yandex.net (iva8-c5ee4261001e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a8a6:0:640:c5ee:4261])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id E9CC22E14D0;
        Fri, 20 Aug 2021 12:37:40 +0300 (MSK)
Received: from iva8-5ba4ca89b0c6.qloud-c.yandex.net (iva8-5ba4ca89b0c6.qloud-c.yandex.net [2a02:6b8:c0c:a8ae:0:640:5ba4:ca89])
        by iva8-c5ee4261001e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 7TNFDUqXmv-bc0WuVAg;
        Fri, 20 Aug 2021 12:37:40 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1629452260; bh=sLLsRL1I8judTG8/a2QYuzjSJMQb61/3K6LopvtlOeY=;
        h=In-Reply-To:References:Date:Message-ID:To:Subject:From:Cc;
        b=2w+ZCtMdyCPjSweZe4Y/etikVP+u7iPFn643sumPqJQ2JlVATqzTHSdzVjCjtMBWN
         mV3b0xfKRhxqqWqcAxRSfHgU9/DCCiXINZjTho77St886lFwFg/QodJCvU7X6A+Iru
         cRyT2zIFqBCEWJ+up/+OeLdzQSPX7YiPgNPaOfnk=
Authentication-Results: iva8-c5ee4261001e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dynamic-red3.dhcp.yndx.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by iva8-5ba4ca89b0c6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TrGrnGLMMM-bc2mPKOL;
        Fri, 20 Aug 2021 12:37:38 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Andrey Ryabinin <arbn@yandex-team.com>
Subject: Re: [PATCH 3/4] sched/cpuacct: fix user/system in shown
 cpuacct.usage*
To:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Boris Burkov <boris@bur.io>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210217120004.7984-3-arbn@yandex-team.com> <87r1kdl8se.fsf@oracle.com>
Message-ID: <e56570e5-5165-71e1-f4cc-b8ea2063aec8@yandex-team.com>
Date:   Fri, 20 Aug 2021 12:37:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <87r1kdl8se.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/18/21 1:22 AM, Daniel Jordan wrote:
> Andrey Ryabinin <arbn@yandex-team.com> writes:
> 
>> cpuacct has 2 different ways of accounting and showing user
>> and system times.
>>
>> The first one uses cpuacct_account_field() to account times
>> and cpuacct.stat file to expose them. And this one seems to work ok.
>>
>> The second one is uses cpuacct_charge() function for accounting and
>> set of cpuacct.usage* files to show times. Despite some attempts to
>> fix it in the past it still doesn't work. E.g. while running KVM
>> guest the cpuacct_charge() accounts most of the guest time as
>> system time. This doesn't match with user&system times shown in
>> cpuacct.stat or proc/<pid>/stat.
> 
> I couldn't reproduce this running a cpu bound load in a kvm guest on a
> nohz_full cpu on 5.11.  The time is almost entirely in cpuacct.usage and
> _user, while _sys stays low.
> 
> Could you say more about how you're seeing this?  Don't really doubt
> there's a problem, just wondering what you're doing.
> 


Yeah, I it's almost unnoticable if you run some load in guest like qemu.

But more simple case with busy loop in KVM_RUN triggers this:

# git clone https://github.com/aryabinin/kvmsample
# make
# mkdir /sys/fs/cgroup/cpuacct/test
# echo $$ > /sys/fs/cgroup/cpuacct/test/tasks
# ./kvmsample &
# for i in {1..5}; do cat /sys/fs/cgroup/cpuacct/test/cpuacct.usage_sys; sleep 1; done
1976535645
2979839428
3979832704
4983603153
5983604157

>> diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
>> index 941c28cf9738..7eff79faab0d 100644
>> --- a/kernel/sched/cpuacct.c
>> +++ b/kernel/sched/cpuacct.c
>> @@ -29,7 +29,7 @@ struct cpuacct_usage {
>>  struct cpuacct {
>>  	struct cgroup_subsys_state	css;
>>  	/* cpuusage holds pointer to a u64-type object on every CPU */
>> -	struct cpuacct_usage __percpu	*cpuusage;
> 
> Definition of struct cpuacct_usage can go away now.
> 

Done.

>> @@ -99,7 +99,8 @@ static void cpuacct_css_free(struct cgroup_subsys_state *css)
>>  static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
>>  				 enum cpuacct_stat_index index)
>>  {
>> -	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
>> +	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
>> +	u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
>>  	u64 data;
> 
> There's a BUG_ON below this that could probably be WARN_ON_ONCE while
> you're here
> 

Sure.

>> @@ -278,8 +274,8 @@ static int cpuacct_stats_show(struct seq_file *sf, void *v)
>>  	for_each_possible_cpu(cpu) {
>>  		u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
>>  
>> -		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_USER];
>> -		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_NICE];
>> +		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_USER];
>> +		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_NICE];
> 
> unnecessary whitespace change?
> 

yup
