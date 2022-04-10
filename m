Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604F34FB0CA
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 01:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiDJXZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 19:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiDJXZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 19:25:15 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2940115810;
        Sun, 10 Apr 2022 16:23:03 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7616.dip0.t-ipconnect.de [93.221.118.22])
        by mail.itouring.de (Postfix) with ESMTPSA id 91BD2124EC0;
        Mon, 11 Apr 2022 01:22:58 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 4733CF01601;
        Mon, 11 Apr 2022 01:22:58 +0200 (CEST)
Subject: Re: [tip: sched/core] sched/tracing: Don't re-read p->state when
 emitting sched_switch event
To:     Qais Yousef <qais.yousef@arm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@quicinc.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>, x86@kernel.org,
        stable@vger.kernel.org
References: <20220120162520.570782-2-valentin.schneider@arm.com>
 <164614827941.16921.4995078681021904041.tip-bot2@tip-bot2>
 <20220308180240.qivyjdn4e3te3urm@wubuntu> <YiecMTy8ckUdXTQO@kroah.com>
 <20220308185138.ldxfqd242uxowymd@wubuntu>
 <20220409233829.o2s6tffuzujkx6w2@airbuntu>
 <20220410220608.cdf6hmf5mwcqzwun@airbuntu>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <db6ec3a4-3ac9-e96b-d7a5-3e1b4de2adc8@applied-asynchrony.com>
Date:   Mon, 11 Apr 2022 01:22:58 +0200
MIME-Version: 1.0
In-Reply-To: <20220410220608.cdf6hmf5mwcqzwun@airbuntu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-04-11 00:06, Qais Yousef wrote:
> On 04/10/22 00:38, Qais Yousef wrote:
>> On 03/08/22 18:51, Qais Yousef wrote:
>>> On 03/08/22 19:10, Greg KH wrote:
>>>> On Tue, Mar 08, 2022 at 06:02:40PM +0000, Qais Yousef wrote:
>>>>> +CC stable
>>>>>
>>>>> On 03/01/22 15:24, tip-bot2 for Valentin Schneider wrote:
>>>>>> The following commit has been merged into the sched/core branch of tip:
>>>>>>
>>>>>> Commit-ID:     fa2c3254d7cfff5f7a916ab928a562d1165f17bb
>>>>>> Gitweb:        https://git.kernel.org/tip/fa2c3254d7cfff5f7a916ab928a562d1165f17bb
>>>>>> Author:        Valentin Schneider <valentin.schneider@arm.com>
>>>>>> AuthorDate:    Thu, 20 Jan 2022 16:25:19
>>>>>> Committer:     Peter Zijlstra <peterz@infradead.org>
>>>>>> CommitterDate: Tue, 01 Mar 2022 16:18:39 +01:00
>>>>>>
>>>>>> sched/tracing: Don't re-read p->state when emitting sched_switch event
>>>>>>
>>>>>> As of commit
>>>>>>
>>>>>>    c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
>>>>>>
>>>>>> the following sequence becomes possible:
>>>>>>
>>>>>> 		      p->__state = TASK_INTERRUPTIBLE;
>>>>>> 		      __schedule()
>>>>>> 			deactivate_task(p);
>>>>>>    ttwu()
>>>>>>      READ !p->on_rq
>>>>>>      p->__state=TASK_WAKING
>>>>>> 			trace_sched_switch()
>>>>>> 			  __trace_sched_switch_state()
>>>>>> 			    task_state_index()
>>>>>> 			      return 0;
>>>>>>
>>>>>> TASK_WAKING isn't in TASK_REPORT, so the task appears as TASK_RUNNING in
>>>>>> the trace event.
>>>>>>
>>>>>> Prevent this by pushing the value read from __schedule() down the trace
>>>>>> event.
>>>>>>
>>>>>> Reported-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
>>>>>> Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
>>>>>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>>>>> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
>>>>>> Link: https://lore.kernel.org/r/20220120162520.570782-2-valentin.schneider@arm.com
>>>>>
>>>>> Any objection to picking this for stable? I'm interested in this one for some
>>>>> Android users but prefer if it can be taken by stable rather than backport it
>>>>> individually.
>>>>>
>>>>> I think it makes sense to pick the next one in the series too.
>>>>
>>>> What commit does this fix in Linus's tree?
>>>
>>> It should be this one: c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
>>
>> Should this be okay to be picked up by stable now? I can see AUTOSEL has picked
>> it up for v5.15+, but it impacts v5.10 too.
> 
> commit: fa2c3254d7cfff5f7a916ab928a562d1165f17bb
> subject: sched/tracing: Don't re-read p->state when emitting sched_switch event
> 
> This patch has an impact on Android 5.10 users who experience tooling breakage.
> Is it possible to include in 5.10 LTS please?
> 
> It was already picked up for 5.15+ by AUTOSEL and only 5.10 is missing.
> 

https://lore.kernel.org/stable/Yk2PQzynOVOzJdPo@kroah.com/

However, since then further investigation (still in progress) has shown that this
may have been the fault of the tool in question, so if you can verify that tracing
sched still works for you with this patch in 5.15.x then by all means
let's merge it.

-h
