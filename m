Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C93E1DCA
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 16:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406225AbfJWOMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 10:12:32 -0400
Received: from [217.140.110.172] ([217.140.110.172]:53276 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2405316AbfJWOMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 10:12:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A90CA492;
        Wed, 23 Oct 2019 07:12:08 -0700 (PDT)
Received: from [10.1.194.37] (e113632-lin.cambridge.arm.com [10.1.194.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8C4A3F71F;
        Wed, 23 Oct 2019 07:12:05 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] sched/topology: Don't try to build empty sched
 domains
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc:     lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, qperret@google.com,
        stable@vger.kernel.org
References: <20191015154250.12951-1-valentin.schneider@arm.com>
 <20191015154250.12951-2-valentin.schneider@arm.com>
 <9134acf7-69bb-403b-2e9c-0eb7fb7efabd@arm.com>
From:   Valentin Schneider <valentin.schneider@arm.com>
Message-ID: <595dc187-bbe7-bd24-a322-db0d777697c0@arm.com>
Date:   Wed, 23 Oct 2019 15:12:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9134acf7-69bb-403b-2e9c-0eb7fb7efabd@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/10/2019 12:46, Dietmar Eggemann wrote:
> Can you not just prevent that a cpuset pointer (cp) is added to the
> cpuset array (csa[]) in case cpumask_empty(cp->effective_cpus)?
> 
> @@ -798,9 +800,14 @@ static int generate_sched_domains(cpumask_var_t
> **domains, cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
>                         continue;
> 
> -   if (is_sched_load_balance(cp))
> +   if (is_sched_load_balance(cp) && !cpumask_empty(cp->effective_cpus))
>             csa[csn++] = cp;
> 

I think you're right. Let me give it a shot and I'll spin a v4 with this +
better changelog for the key.

>>  		dp = doms[nslot];
>>  
>>  		if (nslot == ndoms) {
> 
> [...]
> 
