Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9B84FBCF4
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 15:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244660AbiDKNY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 09:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240292AbiDKNY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 09:24:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF0A2DDD;
        Mon, 11 Apr 2022 06:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9BE4B815E9;
        Mon, 11 Apr 2022 13:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31369C385A4;
        Mon, 11 Apr 2022 13:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649683330;
        bh=wHmFp0VzOj0WHcJMekfPYEOiNkVMSATA9SGQpVR+GZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JSYjFG0gpJZTN3Jo3qs77DmP+DgFo+JR2G+YmePvrYdpeUdLvnrWCuI0HtyZXF/ts
         cuHmbYDd+EOGSk3mol0ZBps5/p2gDlQSZHhFRCPd2ZkE8ih+FJIUAmZCeFmKB73t6t
         Ddoq0lo4yLMkPTnvJWnTJYjOS87c2zur1BA8w4gY=
Date:   Mon, 11 Apr 2022 15:22:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@quicinc.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [tip: sched/core] sched/tracing: Don't re-read p->state when
 emitting sched_switch event
Message-ID: <YlQrf1KDjlidLAHl@kroah.com>
References: <20220120162520.570782-2-valentin.schneider@arm.com>
 <164614827941.16921.4995078681021904041.tip-bot2@tip-bot2>
 <20220308180240.qivyjdn4e3te3urm@wubuntu>
 <YiecMTy8ckUdXTQO@kroah.com>
 <20220308185138.ldxfqd242uxowymd@wubuntu>
 <20220409233829.o2s6tffuzujkx6w2@airbuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409233829.o2s6tffuzujkx6w2@airbuntu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 10, 2022 at 12:38:29AM +0100, Qais Yousef wrote:
> On 03/08/22 18:51, Qais Yousef wrote:
> > On 03/08/22 19:10, Greg KH wrote:
> > > On Tue, Mar 08, 2022 at 06:02:40PM +0000, Qais Yousef wrote:
> > > > +CC stable
> > > > 
> > > > On 03/01/22 15:24, tip-bot2 for Valentin Schneider wrote:
> > > > > The following commit has been merged into the sched/core branch of tip:
> > > > > 
> > > > > Commit-ID:     fa2c3254d7cfff5f7a916ab928a562d1165f17bb
> > > > > Gitweb:        https://git.kernel.org/tip/fa2c3254d7cfff5f7a916ab928a562d1165f17bb
> > > > > Author:        Valentin Schneider <valentin.schneider@arm.com>
> > > > > AuthorDate:    Thu, 20 Jan 2022 16:25:19 
> > > > > Committer:     Peter Zijlstra <peterz@infradead.org>
> > > > > CommitterDate: Tue, 01 Mar 2022 16:18:39 +01:00
> > > > > 
> > > > > sched/tracing: Don't re-read p->state when emitting sched_switch event
> > > > > 
> > > > > As of commit
> > > > > 
> > > > >   c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
> > > > > 
> > > > > the following sequence becomes possible:
> > > > > 
> > > > > 		      p->__state = TASK_INTERRUPTIBLE;
> > > > > 		      __schedule()
> > > > > 			deactivate_task(p);
> > > > >   ttwu()
> > > > >     READ !p->on_rq
> > > > >     p->__state=TASK_WAKING
> > > > > 			trace_sched_switch()
> > > > > 			  __trace_sched_switch_state()
> > > > > 			    task_state_index()
> > > > > 			      return 0;
> > > > > 
> > > > > TASK_WAKING isn't in TASK_REPORT, so the task appears as TASK_RUNNING in
> > > > > the trace event.
> > > > > 
> > > > > Prevent this by pushing the value read from __schedule() down the trace
> > > > > event.
> > > > > 
> > > > > Reported-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> > > > > Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> > > > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > > > Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > > > > Link: https://lore.kernel.org/r/20220120162520.570782-2-valentin.schneider@arm.com
> > > > 
> > > > Any objection to picking this for stable? I'm interested in this one for some
> > > > Android users but prefer if it can be taken by stable rather than backport it
> > > > individually.
> > > > 
> > > > I think it makes sense to pick the next one in the series too.
> > > 
> > > What commit does this fix in Linus's tree?
> > 
> > It should be this one: c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
> 
> Should this be okay to be picked up by stable now? I can see AUTOSEL has picked
> it up for v5.15+, but it impacts v5.10 too.

It does not apply to 5.10 at all, how did you test this?

{sigh}

Again, if you want this applied to any stable trees, please test that it
works and send the properly backported patches.

thanks,

greg k-h
