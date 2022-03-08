Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CB74D1F99
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbiCHSDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiCHSDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:03:40 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24AF724F2B;
        Tue,  8 Mar 2022 10:02:43 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E7FFE1516;
        Tue,  8 Mar 2022 10:02:42 -0800 (PST)
Received: from wubuntu (unknown [10.57.71.199])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8AB03FA45;
        Tue,  8 Mar 2022 10:02:41 -0800 (PST)
Date:   Tue, 8 Mar 2022 18:02:40 +0000
From:   Qais Yousef <qais.yousef@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-tip-commits@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@quicinc.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [tip: sched/core] sched/tracing: Don't re-read p->state when
 emitting sched_switch event
Message-ID: <20220308180240.qivyjdn4e3te3urm@wubuntu>
References: <20220120162520.570782-2-valentin.schneider@arm.com>
 <164614827941.16921.4995078681021904041.tip-bot2@tip-bot2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <164614827941.16921.4995078681021904041.tip-bot2@tip-bot2>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+CC stable

On 03/01/22 15:24, tip-bot2 for Valentin Schneider wrote:
> The following commit has been merged into the sched/core branch of tip:
> 
> Commit-ID:     fa2c3254d7cfff5f7a916ab928a562d1165f17bb
> Gitweb:        https://git.kernel.org/tip/fa2c3254d7cfff5f7a916ab928a562d1165f17bb
> Author:        Valentin Schneider <valentin.schneider@arm.com>
> AuthorDate:    Thu, 20 Jan 2022 16:25:19 
> Committer:     Peter Zijlstra <peterz@infradead.org>
> CommitterDate: Tue, 01 Mar 2022 16:18:39 +01:00
> 
> sched/tracing: Don't re-read p->state when emitting sched_switch event
> 
> As of commit
> 
>   c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
> 
> the following sequence becomes possible:
> 
> 		      p->__state = TASK_INTERRUPTIBLE;
> 		      __schedule()
> 			deactivate_task(p);
>   ttwu()
>     READ !p->on_rq
>     p->__state=TASK_WAKING
> 			trace_sched_switch()
> 			  __trace_sched_switch_state()
> 			    task_state_index()
> 			      return 0;
> 
> TASK_WAKING isn't in TASK_REPORT, so the task appears as TASK_RUNNING in
> the trace event.
> 
> Prevent this by pushing the value read from __schedule() down the trace
> event.
> 
> Reported-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Link: https://lore.kernel.org/r/20220120162520.570782-2-valentin.schneider@arm.com

Any objection to picking this for stable? I'm interested in this one for some
Android users but prefer if it can be taken by stable rather than backport it
individually.

I think it makes sense to pick the next one in the series too.

Thanks!

--
Qais Yousef
