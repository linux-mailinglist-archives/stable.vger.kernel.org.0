Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F339E4FAC3D
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 08:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiDJGQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 02:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiDJGQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 02:16:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F81BA3;
        Sat,  9 Apr 2022 23:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C1A260ED2;
        Sun, 10 Apr 2022 06:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DD8C385A1;
        Sun, 10 Apr 2022 06:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649571246;
        bh=riXjiNxoLF8mDSf3ncTuLYxn5erKsgT1pWzC0ZYs/yE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U64HF4HQ04+XF3DuslJ07g8B8r53kPQw0qbe6DDzegUIzwPraU9NpcoUTtn+Zjne7
         on9wj0WjdSWqyKyU0pPiu5tqPmZMEmM1cULh87Gi3CoW1p2s4alhSAgzDkHr9NLst+
         8/qFf7q/fsZ4ROBKgHwiTF9VAJe4ipFYoR0L4YYo=
Date:   Sun, 10 Apr 2022 08:14:03 +0200
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
Message-ID: <YlJ1q0zohdPvQBUd@kroah.com>
References: <20220120162520.570782-1-valentin.schneider@arm.com>
 <20220120162520.570782-3-valentin.schneider@arm.com>
 <20220409234224.q57dr43bpcll3ryv@airbuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220409234224.q57dr43bpcll3ryv@airbuntu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 10, 2022 at 12:42:24AM +0100, Qais Yousef wrote:
> +CC stable
> 
> On 01/20/22 16:25, Valentin Schneider wrote:
> > TASK_RTLOCK_WAIT currently isn't part of TASK_REPORT, thus a task blocking
> > on an rtlock will appear as having a task state == 0, IOW TASK_RUNNING.
> > 
> > The actual state is saved in p->saved_state, but reading it after reading
> > p->__state has a few issues:
> > o that could still be TASK_RUNNING in the case of e.g. rt_spin_lock
> > o ttwu_state_match() might have changed that to TASK_RUNNING
> > 
> > As pointed out by Eric, adding TASK_RTLOCK_WAIT to TASK_REPORT implies
> > exposing a new state to userspace tools which way not know what to do with
> > them. The only information that needs to be conveyed here is that a task is
> > waiting on an rt_mutex, which matches TASK_UNINTERRUPTIBLE - there's no
> > need for a new state.
> > 
> > Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> 
> Any objection for this to be picked up by stable? We care about Patch 1 only in
> this series for stable, but it seems sensible to pick this one too, no strong
> feeling if it is omitted though.
> 
> AFAICT it seems the problem dates back since commit:
> 
> 	1593baab910d ("sched/debug: Implement consistent task-state printing")
> 
> or even before. I think v4.14+ is good enough.


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
