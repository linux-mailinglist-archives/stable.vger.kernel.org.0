Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578994D1FC9
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242020AbiCHSMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiCHSMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:12:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0805676C;
        Tue,  8 Mar 2022 10:11:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34AEAB81C00;
        Tue,  8 Mar 2022 18:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4DDC340EB;
        Tue,  8 Mar 2022 18:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646763060;
        bh=UGnQ+9PXtGIKt1K2UPOABZIYq3sN0VamEDK6RQWFxyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IaaDcWeIhFPuSlJRYeoVRqf1GU4wq85BvxkDp9OlbDMHhN/kWO9W86U6GfiiQTXLH
         OvK19ZpPKazfKRKzI017BQcW/a0OGgUqG7XnTY2jpcmkYZiC3HreFlOYN179sSpLCC
         NE3FGvUSBeMFEdrmI97jdjkjPhJc8oNy7zx7Q+Xo=
Date:   Tue, 8 Mar 2022 19:10:57 +0100
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
Message-ID: <YiecMTy8ckUdXTQO@kroah.com>
References: <20220120162520.570782-2-valentin.schneider@arm.com>
 <164614827941.16921.4995078681021904041.tip-bot2@tip-bot2>
 <20220308180240.qivyjdn4e3te3urm@wubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308180240.qivyjdn4e3te3urm@wubuntu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 06:02:40PM +0000, Qais Yousef wrote:
> +CC stable
> 
> On 03/01/22 15:24, tip-bot2 for Valentin Schneider wrote:
> > The following commit has been merged into the sched/core branch of tip:
> > 
> > Commit-ID:     fa2c3254d7cfff5f7a916ab928a562d1165f17bb
> > Gitweb:        https://git.kernel.org/tip/fa2c3254d7cfff5f7a916ab928a562d1165f17bb
> > Author:        Valentin Schneider <valentin.schneider@arm.com>
> > AuthorDate:    Thu, 20 Jan 2022 16:25:19 
> > Committer:     Peter Zijlstra <peterz@infradead.org>
> > CommitterDate: Tue, 01 Mar 2022 16:18:39 +01:00
> > 
> > sched/tracing: Don't re-read p->state when emitting sched_switch event
> > 
> > As of commit
> > 
> >   c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
> > 
> > the following sequence becomes possible:
> > 
> > 		      p->__state = TASK_INTERRUPTIBLE;
> > 		      __schedule()
> > 			deactivate_task(p);
> >   ttwu()
> >     READ !p->on_rq
> >     p->__state=TASK_WAKING
> > 			trace_sched_switch()
> > 			  __trace_sched_switch_state()
> > 			    task_state_index()
> > 			      return 0;
> > 
> > TASK_WAKING isn't in TASK_REPORT, so the task appears as TASK_RUNNING in
> > the trace event.
> > 
> > Prevent this by pushing the value read from __schedule() down the trace
> > event.
> > 
> > Reported-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> > Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > Link: https://lore.kernel.org/r/20220120162520.570782-2-valentin.schneider@arm.com
> 
> Any objection to picking this for stable? I'm interested in this one for some
> Android users but prefer if it can be taken by stable rather than backport it
> individually.
> 
> I think it makes sense to pick the next one in the series too.

What commit does this fix in Linus's tree?

Once it hits Linus's tree, let stable@vger.kernel.org know what the git
commit id is in Linus's tree.

thanks,

greg k-h
