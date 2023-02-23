Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCF76A045E
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbjBWJDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbjBWJDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:03:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01400DBE9
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 01:02:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BDB9B811EC
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 09:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEF6C433D2;
        Thu, 23 Feb 2023 09:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677142977;
        bh=g1RvTyMCpiaNlDSslZMAf72AqR/8L6ocCF9Nh4fzAt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cD+BHJ/7biLEtc0GLq9MAjoLhdURKyesOcYPYgfk9x/B6ONRx1KogpqTkPzg1wNPF
         0Z8Vbmfk6MqB1ELth931koPCwk5VnhEEVAcfx8RAEMHC+cLRs1sgosjzENxShXnEP9
         jwGLgjxhDuOrbyj39g9uO0gkACkSRDHARf10RmAs=
Date:   Thu, 23 Feb 2023 10:02:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     jstultz@google.com, stable@vger.kernel.org
Subject: Re: [PATCH Backport 4.14, 4.19, 5.4] alarmtimer: Prevent starvation
 by small intervals and SIG_IGN
Message-ID: <Y/crvg1yYL7xJHWx@kroah.com>
References: <16768916935192@kroah.com>
 <87sfeznng7.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfeznng7.ffs@tglx>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 02:43:36PM +0100, Thomas Gleixner wrote:
> Commit d125d1349abeb46945dc5e98f7824bf688266f13 upstream.
> 
> syzbot reported a RCU stall which is caused by setting up an alarmtimer
> with a very small interval and ignoring the signal. The reproducer arms the
> alarm timer with a relative expiry of 8ns and an interval of 9ns. Not a
> problem per se, but that's an issue when the signal is ignored because then
> the timer is immediately rearmed because there is no way to delay that
> rearming to the signal delivery path.  See posix_timer_fn() and commit
> 58229a189942 ("posix-timers: Prevent softirq starvation by small intervals
> and SIG_IGN") for details.
> 
> The reproducer does not set SIG_IGN explicitely, but it sets up the timers
> signal with SIGCONT. That has the same effect as explicitely setting
> SIG_IGN for a signal as SIGCONT is ignored if there is no handler set and
> the task is not ptraced.
> 
> The log clearly shows that:
> 
>    [pid  5102] --- SIGCONT {si_signo=SIGCONT, si_code=SI_TIMER, si_timerid=0, si_overrun=316014, si_int=0, si_ptr=NULL} ---
> 
> It works because the tasks are traced and therefore the signal is queued so
> the tracer can see it, which delays the restart of the timer to the signal
> delivery path. But then the tracer is killed:
> 
>    [pid  5087] kill(-5102, SIGKILL <unfinished ...>
>    ...
>    ./strace-static-x86_64: Process 5107 detached
> 
> and after it's gone the stall can be observed:
> 
>    syzkaller login: [   79.439102][    C0] hrtimer: interrupt took 68471 ns
>    [  184.460538][    C1] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>    ...
>    [  184.658237][    C1] rcu: Stack dump where RCU GP kthread last ran:
>    [  184.664574][    C1] Sending NMI from CPU 1 to CPUs 0:
>    [  184.669821][    C0] NMI backtrace for cpu 0
>    [  184.669831][    C0] CPU: 0 PID: 5108 Comm: syz-executor192 Not tainted 6.2.0-rc6-next-20230203-syzkaller #0
>    ...
>    [  184.670036][    C0] Call Trace:
>    [  184.670041][    C0]  <IRQ>
>    [  184.670045][    C0]  alarmtimer_fired+0x327/0x670
> 
> posix_timer_fn() prevents that by checking whether the interval for
> timers which have the signal ignored is smaller than a jiffie and
> artifically delay it by shifting the next expiry out by a jiffie. That's
> accurate vs. the overrun accounting, but slightly inaccurate
> vs. timer_gettimer(2).
> 
> The comment in that function says what needs to be done and there was a fix
> available for the regular userspace induced SIG_IGN mechanism, but that did
> not work due to the implicit ignore for SIGCONT and similar signals. This
> needs to be worked on, but for now the only available workaround is to do
> exactly what posix_timer_fn() does:
> 
> Increase the interval of self-rearming timers, which have their signal
> ignored, to at least a jiffie.
> 
> Interestingly this has been fixed before via commit ff86bf0c65f1
> ("alarmtimer: Rate limit periodic intervals") already, but that fix got
> lost in a later rework.
> 
> Fixes: f2c45807d399 ("alarmtimer: Switch over to generic set/get/rearm routine")
> Reported-by: syzbot+b9564ba6e8e00694511b@syzkaller.appspotmail.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: John Stultz <jstultz@google.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/87k00q1no2.ffs@tglx
> ---
> Backport for 4.14, 4.19, 5.4

Now queued up, thanks.

greg k-h
