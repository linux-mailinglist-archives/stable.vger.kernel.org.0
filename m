Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5621799D8D
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405314AbfHVRnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:43:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:47032 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405315AbfHVRn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 13:43:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id q139so4406276pfc.13
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 10:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=6IOaGnUD4mxduRmdxfDGgTsq+7+zuErL30N4WfZQUJg=;
        b=typmwV4DxiIjX786OwGD06aIxFTp+qy1+q3G/q+3uKSXV8Wu9ymDA3GRXFgcslgnHQ
         AfYBMsoMbiZ3hVuvQblxg2KLydBMyUdXlTPif7k/ur8y9mZ6oI9NOxfeHxM3XZ4ciu8w
         Qluo3Biqdjz2HtvR1oq31B5GcrEP8P78DVRfwpJpmRwrGtUctw17am3//F2iAK6pLKGI
         lbj/llZPW2MLuHquvGIYEnE3RapHyyBKqFC0/KlqLw0pFV4i58RN8wlbHRx7DpXLgcvd
         1s7fCIXr6sMzZoW/RH8i4UmcDdHdJQjjdk7ldI38RN5K6Gmw6+crU3Mg8SU3EKDUOshP
         uQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=6IOaGnUD4mxduRmdxfDGgTsq+7+zuErL30N4WfZQUJg=;
        b=dI56kZlMP03ly/Gny1cZiiFLU9Y/SKBrxTAT/IUf9NNJPwXqIPdizcbpGNLH4ITAQs
         n3rO6E1aAJLNghgWJDF17yeUulboTmLLwCiMEPwNv5lvsBuJ7oj3PgFQPVwoGdwEWu7g
         jrbjqGPt15K2AjCrkdGzZzMQq3PZbQhxjZ598dfIXNAxI5y+J0nvoeunyKSuvypXrgN/
         EaqOBI3m1RUfsfmYCZc6OtjPSRQseGHBKuhrH4JyJYE6dxXtAS6VXfolR9FgpOvBsrVw
         GObNbsRKWGgZ1c94uwmYqVOYOxfhfFgnPOWA4Wh7oxnPsrSmOo0Gyk8NibbsDR0oQy5E
         JKCw==
X-Gm-Message-State: APjAAAXCyL5ge3r/WXDMcD0vsCF8w4Dldq9gRQ6w01Dc4D/9BpWI5NZR
        nox4tduluuLl/i8nU7v7s+DSwvNquxClfg==
X-Google-Smtp-Source: APXvYqz+VrQ45BXYdArbTMZb1Lml83c2MchkPLghR2OpuSwsKJR61/80agQyoFrQOYugG33I94tlCA==
X-Received: by 2002:a62:1444:: with SMTP id 65mr342557pfu.145.1566495805684;
        Thu, 22 Aug 2019 10:43:25 -0700 (PDT)
Received: from bsegall-linux.svl.corp.google.com.localhost ([2620:15c:2cd:202:39d7:98b3:2536:e93f])
        by smtp.gmail.com with ESMTPSA id d3sm207973pjz.31.2019.08.22.10.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 10:43:24 -0700 (PDT)
From:   bsegall@google.com
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Valentin Schneider <valentin.schneider@arm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        liangyan.peng@linux.alibaba.com, shanpeic@linux.alibaba.com,
        xlpang@linux.alibaba.com, pjt@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] sched/fair: Add missing unthrottle_cfs_rq()
References: <0004fb54-cdee-2197-1cbf-6e2111d39ed9@arm.com>
        <20190820105420.7547-1-valentin.schneider@arm.com>
        <20190822092123.GL2349@hirez.programming.kicks-ass.net>
Date:   Thu, 22 Aug 2019 10:43:23 -0700
In-Reply-To: <20190822092123.GL2349@hirez.programming.kicks-ass.net> (Peter
        Zijlstra's message of "Thu, 22 Aug 2019 11:21:23 +0200")
Message-ID: <xm26pnkxhz9g.fsf@bsegall-linux.svl.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Aug 20, 2019 at 11:54:20AM +0100, Valentin Schneider wrote:
>> Turns out a cfs_rq->runtime_remaining can become positive in
>> assign_cfs_rq_runtime(), but this codepath has no call to
>> unthrottle_cfs_rq().
>> 
>> This can leave us in a situation where we have a throttled cfs_rq with
>> positive ->runtime_remaining, which breaks the math in
>> distribute_cfs_runtime(): this function expects a negative value so that
>> it may safely negate it into a positive value.
>> 
>> Add the missing unthrottle_cfs_rq(). While at it, add a WARN_ON where
>> we expect negative values, and pull in a comment from the mailing list
>> that didn't make it in [1].

This didn't exist because it's not supposed to be possible to call
account_cfs_rq_runtime on a throttled cfs_rq at all, so that's the
invariant being violated. Do you know what the code path causing this
looks like?

This would allow both list del and add while distribute is doing a
foreach, but I think that the racing behavior would just be to restart
the distribute loop, which is fine.



>> 
>> [1]: https://lkml.kernel.org/r/BANLkTi=NmCxKX6EbDQcJYDJ5kKyG2N1ssw@mail.gmail.com
>> 
>> Cc: <stable@vger.kernel.org>
>> Fixes: ec12cb7f31e2 ("sched: Accumulate per-cfs_rq cpu usage and charge against bandwidth")
>> Reported-by: Liangyan <liangyan.peng@linux.alibaba.com>
>> Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
>
> Thanks!
>
>> ---
>>  kernel/sched/fair.c | 17 ++++++++++++-----
>>  1 file changed, 12 insertions(+), 5 deletions(-)
>> 
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 1054d2cf6aaa..219ff3f328e5 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4385,6 +4385,11 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
>>  	return rq_clock_task(rq_of(cfs_rq)) - cfs_rq->throttled_clock_task_time;
>>  }
>>  
>> +static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
>> +{
>> +	return cfs_bandwidth_used() && cfs_rq->throttled;
>> +}
>> +
>>  /* returns 0 on failure to allocate runtime */
>>  static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>>  {
>> @@ -4411,6 +4416,9 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>>  
>>  	cfs_rq->runtime_remaining += amount;
>>  
>> +	if (cfs_rq->runtime_remaining > 0 && cfs_rq_throttled(cfs_rq))
>> +		unthrottle_cfs_rq(cfs_rq);
>> +
>>  	return cfs_rq->runtime_remaining > 0;
>>  }
>>  
>> @@ -4439,11 +4447,6 @@ void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
>>  	__account_cfs_rq_runtime(cfs_rq, delta_exec);
>>  }
>>  
>> -static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
>> -{
>> -	return cfs_bandwidth_used() && cfs_rq->throttled;
>> -}
>> -
>>  /* check whether cfs_rq, or any parent, is throttled */
>>  static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
>>  {
>> @@ -4628,6 +4631,10 @@ static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b, u64 remaining)
>>  		if (!cfs_rq_throttled(cfs_rq))
>>  			goto next;
>>  
>> +		/* By the above check, this should never be true */
>> +		WARN_ON(cfs_rq->runtime_remaining > 0);
>> +
>> +		/* Pick the minimum amount to return to a positive quota state */
>>  		runtime = -cfs_rq->runtime_remaining + 1;
>>  		if (runtime > remaining)
>>  			runtime = remaining;
>> -- 
>> 2.22.0
>> 
