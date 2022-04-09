Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A18B4FAB22
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 01:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiDIXkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 19:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiDIXkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 19:40:42 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C17AB99;
        Sat,  9 Apr 2022 16:38:32 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B3CCED1;
        Sat,  9 Apr 2022 16:38:32 -0700 (PDT)
Received: from airbuntu (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F0013F5A1;
        Sat,  9 Apr 2022 16:38:30 -0700 (PDT)
Date:   Sun, 10 Apr 2022 00:38:29 +0100
From:   Qais Yousef <qais.yousef@arm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@quicinc.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [tip: sched/core] sched/tracing: Don't re-read p->state when
 emitting sched_switch event
Message-ID: <20220409233829.o2s6tffuzujkx6w2@airbuntu>
References: <20220120162520.570782-2-valentin.schneider@arm.com>
 <164614827941.16921.4995078681021904041.tip-bot2@tip-bot2>
 <20220308180240.qivyjdn4e3te3urm@wubuntu>
 <YiecMTy8ckUdXTQO@kroah.com>
 <20220308185138.ldxfqd242uxowymd@wubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220308185138.ldxfqd242uxowymd@wubuntu>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/08/22 18:51, Qais Yousef wrote:
> On 03/08/22 19:10, Greg KH wrote:
> > On Tue, Mar 08, 2022 at 06:02:40PM +0000, Qais Yousef wrote:
> > > +CC stable
> > > 
> > > On 03/01/22 15:24, tip-bot2 for Valentin Schneider wrote:
> > > > The following commit has been merged into the sched/core branch of tip:
> > > > 
> > > > Commit-ID:     fa2c3254d7cfff5f7a916ab928a562d1165f17bb
> > > > Gitweb:        https://git.kernel.org/tip/fa2c3254d7cfff5f7a916ab928a562d1165f17bb
> > > > Author:        Valentin Schneider <valentin.schneider@arm.com>
> > > > AuthorDate:    Thu, 20 Jan 2022 16:25:19 
> > > > Committer:     Peter Zijlstra <peterz@infradead.org>
> > > > CommitterDate: Tue, 01 Mar 2022 16:18:39 +01:00
> > > > 
> > > > sched/tracing: Don't re-read p->state when emitting sched_switch event
> > > > 
> > > > As of commit
> > > > 
> > > >   c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
> > > > 
> > > > the following sequence becomes possible:
> > > > 
> > > > 		      p->__state = TASK_INTERRUPTIBLE;
> > > > 		      __schedule()
> > > > 			deactivate_task(p);
> > > >   ttwu()
> > > >     READ !p->on_rq
> > > >     p->__state=TASK_WAKING
> > > > 			trace_sched_switch()
> > > > 			  __trace_sched_switch_state()
> > > > 			    task_state_index()
> > > > 			      return 0;
> > > > 
> > > > TASK_WAKING isn't in TASK_REPORT, so the task appears as TASK_RUNNING in
> > > > the trace event.
> > > > 
> > > > Prevent this by pushing the value read from __schedule() down the trace
> > > > event.
> > > > 
> > > > Reported-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> > > > Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> > > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > > Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > > > Link: https://lore.kernel.org/r/20220120162520.570782-2-valentin.schneider@arm.com
> > > 
> > > Any objection to picking this for stable? I'm interested in this one for some
> > > Android users but prefer if it can be taken by stable rather than backport it
> > > individually.
> > > 
> > > I think it makes sense to pick the next one in the series too.
> > 
> > What commit does this fix in Linus's tree?
> 
> It should be this one: c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")

Should this be okay to be picked up by stable now? I can see AUTOSEL has picked
it up for v5.15+, but it impacts v5.10 too.

Thanks!

--
Qais Yousef
