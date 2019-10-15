Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB7FD7405
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 12:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfJOK6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 06:58:38 -0400
Received: from foss.arm.com ([217.140.110.172]:35446 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfJOK6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 06:58:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7277528;
        Tue, 15 Oct 2019 03:58:37 -0700 (PDT)
Received: from [10.1.194.37] (e113632-lin.cambridge.arm.com [10.1.194.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5AEC03F68E;
        Tue, 15 Oct 2019 03:58:36 -0700 (PDT)
Subject: Re: [PATCH v2] sched/topology: Allow sched_asym_cpucapacity to be
 disabled
To:     Quentin Perret <qperret@google.com>
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org,
        Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com,
        stable@vger.kernel.org
References: <20191015102956.20133-1-valentin.schneider@arm.com>
 <20191015104010.GA242992@google.com>
From:   Valentin Schneider <valentin.schneider@arm.com>
Message-ID: <a3a1a3d9-5d3a-3ab3-0eaf-e63e0c401c99@arm.com>
Date:   Tue, 15 Oct 2019 11:58:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015104010.GA242992@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/10/2019 11:40, Quentin Perret wrote:
>> @@ -2124,8 +2124,17 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)
>>  	int i;
>>  
>>  	rcu_read_lock();
>> +
>> +	if (static_key_enabled(&sched_asym_cpucapacity)) {
>> +		unsigned int cpu = cpumask_any(cpu_map);
>> +
>> +		if (rcu_dereference(per_cpu(sd_asym_cpucapacity, cpu)))
>> +			static_branch_dec_cpuslocked(&sched_asym_cpucapacity);
> 
> Lockdep should scream for this :)

Bleh, yes indeed...

>> +	}
>> +
>>  	for_each_cpu(i, cpu_map)
>>  		cpu_attach_domain(NULL, &def_root_domain, i);
>> +
>>  	rcu_read_unlock();
>>  }
>>  
>> -- 
>> 2.22.0
>>
