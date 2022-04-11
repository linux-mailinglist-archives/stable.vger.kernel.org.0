Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DFB4FBCEF
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 15:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346427AbiDKNWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 09:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346430AbiDKNWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 09:22:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CCC3B55D;
        Mon, 11 Apr 2022 06:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D50C160C97;
        Mon, 11 Apr 2022 13:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE07C385A4;
        Mon, 11 Apr 2022 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649683236;
        bh=WdFDWYiySeQmCiU3XtGDypeqW1qu4cDgLgqYMUNK8jI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BYTUUPuuYGWA146wrzCr84CGE4K/0JmVi7iZq2fNqmcimbKQjrcPHWqSs685tCmQM
         W3b7Bkh2BcHbvWPIUVXFqYsa6ackLhUaslAh0Xa1elFs2nxO56m/ADKtf/ctx5+phl
         ckINQVVas7ySbzUIMchAKARgpYiSkbL8gJyIypBc=
Date:   Mon, 11 Apr 2022 15:20:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Abhijeet Dharmapurikar <adharmap@quicinc.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Gladkov <legion@kernel.org>,
        "Kenta.Tada@sony.com" <Kenta.Tada@sony.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ed Tsai <ed.tsai@mediatek.com>,
        Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH v3 2/2] sched/tracing: Report TASK_RTLOCK_WAIT tasks as
 TASK_UNINTERRUPTIBLE
Message-ID: <YlQrITm6kR6wF1+Z@kroah.com>
References: <20220120162520.570782-1-valentin.schneider@arm.com>
 <20220120162520.570782-3-valentin.schneider@arm.com>
 <20220409234224.q57dr43bpcll3ryv@airbuntu>
 <YlJ1q0zohdPvQBUd@kroah.com>
 <20220410221325.fimxzpzg26zmmsiz@airbuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220410221325.fimxzpzg26zmmsiz@airbuntu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 10, 2022 at 11:13:25PM +0100, Qais Yousef wrote:
> On 04/10/22 08:14, Greg KH wrote:
> > On Sun, Apr 10, 2022 at 12:42:24AM +0100, Qais Yousef wrote:
> > > +CC stable
> > > 
> > > On 01/20/22 16:25, Valentin Schneider wrote:
> > > > TASK_RTLOCK_WAIT currently isn't part of TASK_REPORT, thus a task blocking
> > > > on an rtlock will appear as having a task state == 0, IOW TASK_RUNNING.
> > > > 
> > > > The actual state is saved in p->saved_state, but reading it after reading
> > > > p->__state has a few issues:
> > > > o that could still be TASK_RUNNING in the case of e.g. rt_spin_lock
> > > > o ttwu_state_match() might have changed that to TASK_RUNNING
> > > > 
> > > > As pointed out by Eric, adding TASK_RTLOCK_WAIT to TASK_REPORT implies
> > > > exposing a new state to userspace tools which way not know what to do with
> > > > them. The only information that needs to be conveyed here is that a task is
> > > > waiting on an rt_mutex, which matches TASK_UNINTERRUPTIBLE - there's no
> > > > need for a new state.
> > > > 
> > > > Reported-by: Uwe Kleine-K�nig <u.kleine-koenig@pengutronix.de>
> > > > Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> > > 
> > > Any objection for this to be picked up by stable? We care about Patch 1 only in
> > > this series for stable, but it seems sensible to pick this one too, no strong
> > > feeling if it is omitted though.
> > > 
> > > AFAICT it seems the problem dates back since commit:
> > > 
> > > 	1593baab910d ("sched/debug: Implement consistent task-state printing")
> > > 
> > > or even before. I think v4.14+ is good enough.
> > 
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> > 
> > </formletter>
> 
> Apologies.
> 
> commit: 25795ef6299f07ce3838f3253a9cb34f64efcfae
> Subject: sched/tracing: Report TASK_RTLOCK_WAIT tasks as TASK_UNINTERRUPTIBLE
> 
> I am interested in Patch 1 in this series as I know it impacts some Android
> 5.10 users. But this patch seems a good candidate for stable too since it was
> observed by a user (Uwe) and AFAICT the problem dates back to v4.14+ kernels.
> 
> Suggested kernels: v4.14+. This has already been picked up by AUTOSEL for
> v5.15+ stable trees.

I do not think you have tested this in any of those kernels, as it
breaks the build :(

Please send a set of patches, properly backported and tested, that you
wish to see applied to stable kernels and we will be glad to review them
and apply them.  But to suggest patches to be merged that you have not
even tested is not good.

thanks,

greg k-h
