Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6904B176D
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 22:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344520AbiBJVJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 16:09:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344480AbiBJVJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 16:09:15 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322C026C2
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 13:09:15 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id ki18-20020a17090ae91200b001b8be87e9abso2677351pjb.1
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 13:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5fXnl/zudRlsBaPCWqOQG/BbvW0HiBY1sLTM/v1mLFA=;
        b=QibC25dEvOYcURSpRQEpOkucBKDrWlDRsi+8kdqduZx4sLEuXF0pkvu+F7bRWCHjIe
         bltm1u+VTQmR61UkCRsKYD3E0hS1Abt7G61MgZ5Q0w3uA/i0UhCTlcFcCOLxDhIBuq+w
         WeZ0gcnVD4cHILndhMQkgYaqhFz8Kimx+8zQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5fXnl/zudRlsBaPCWqOQG/BbvW0HiBY1sLTM/v1mLFA=;
        b=YgtGWiNpfzc6oiszy0ALlzMKpEbqBsCRL95ELgl5Gn+0OGoBd8CikI6249JHvKltrQ
         2jfq4s5qj1gNgk7q9isbtIfr2EadDOTJ4XjjznhSCDs4cWkjQJr0PVHhWK+XGaI1c0Nn
         OwE1yg508UeP5cYvxaYE7bhitdmMUThXil5sHoaWoEvCgqbvWPU9BnUwfvA5aVEG+1Jk
         4RPcg4mp6kZc1tQXsZWYcrszv9B4xnCyRTygSqpPjCm6WwCUTqs5UTxpF6JlLIhYOPRh
         lnV+wQ2tlhA9hH2NxIRuTq2XR+ymblHJxNEuGIsz2WEEXkJnHyuq6OTU8U1JgnTiB/za
         m41Q==
X-Gm-Message-State: AOAM533l8oYzysCij2QQeaxem/WY5Bo8RV234TFgfqw4tXMR1MJ5FTek
        6bfNwD8VFHrZyqk32B6M/aJciQ==
X-Google-Smtp-Source: ABdhPJy30sCEW54x3m+/Y52i3WOAn4oQ+v00ptLFoUMzH69cKTRaNO0Kcem2NoYBDzvdjY7R5URPCA==
X-Received: by 2002:a17:903:1c4:: with SMTP id e4mr9362662plh.147.1644527354547;
        Thu, 10 Feb 2022 13:09:14 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id oa10sm1119190pjb.54.2022.02.10.13.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:09:14 -0800 (PST)
Date:   Thu, 10 Feb 2022 13:09:13 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jann Horn <jannh@google.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] signal: HANDLER_EXIT should clear SIGNAL_UNKILLABLE
Message-ID: <202202101254.1174AB2B@keescook>
References: <20220210025321.787113-1-keescook@chromium.org>
 <20220210025321.787113-2-keescook@chromium.org>
 <CAG48ez1m7XJ1wJvTHtNorH480jTWNgdrn5Q1LTZZQ4uve3r4Sw@mail.gmail.com>
 <202202100935.FB3E60FA5@keescook>
 <CAG48ez3fG7S1dfE2-JAtyOZUK=0_iZ03scf+oD6gwVyD1Qp33g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3fG7S1dfE2-JAtyOZUK=0_iZ03scf+oD6gwVyD1Qp33g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 07:01:39PM +0100, Jann Horn wrote:
> On Thu, Feb 10, 2022 at 6:37 PM Kees Cook <keescook@chromium.org> wrote:
> > On Thu, Feb 10, 2022 at 05:18:39PM +0100, Jann Horn wrote:
> > > On Thu, Feb 10, 2022 at 3:53 AM Kees Cook <keescook@chromium.org> wrote:
> > > > Fatal SIGSYS signals were not being delivered to pid namespace init
> > > > processes. Make sure the SIGNAL_UNKILLABLE doesn't get set for these
> > > > cases.
> > > >
> > > > Reported-by: Robert Święcki <robert@swiecki.net>
> > > > Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > Fixes: 00b06da29cf9 ("signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > ---
> > > >  kernel/signal.c | 5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/kernel/signal.c b/kernel/signal.c
> > > > index 38602738866e..33e3ee4f3383 100644
> > > > --- a/kernel/signal.c
> > > > +++ b/kernel/signal.c
> > > > @@ -1342,9 +1342,10 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
> > > >         }
> > > >         /*
> > > >          * Don't clear SIGNAL_UNKILLABLE for traced tasks, users won't expect
> > > > -        * debugging to leave init killable.
> > > > +        * debugging to leave init killable, unless it is intended to exit.
> > > >          */
> > > > -       if (action->sa.sa_handler == SIG_DFL && !t->ptrace)
> > > > +       if (action->sa.sa_handler == SIG_DFL &&
> > > > +           (!t->ptrace || (handler == HANDLER_EXIT)))
> > > >                 t->signal->flags &= ~SIGNAL_UNKILLABLE;
> > >
> > > You're changing the subclause:
> > >
> > > !t->ptrace
> > >
> > > to:
> > >
> > > (!t->ptrace || (handler == HANDLER_EXIT))
> > >
> > > which means that the change only affects cases where the process has a
> > > ptracer, right? That's not the scenario the commit message is talking
> > > about...
> >
> > Sorry, yes, I was not as accurate as I should have been in the commit
> > log. I have changed it to:
> >
> > Fatal SIGSYS signals (i.e. seccomp RET_KILL_* syscall filter actions)
> > were not being delivered to ptraced pid namespace init processes. Make
> > sure the SIGNAL_UNKILLABLE doesn't get set for these cases.
> 
> So basically force_sig_info() is trying to figure out whether
> get_signal() will later on check for SIGNAL_UNKILLABLE (the SIG_DFL
> case), and if so, it clears the flag from the target's signal_struct
> that marks the process as unkillable?
> 
> This used to be:
> 
> if (action->sa.sa_handler == SIG_DFL)
>     t->signal->flags &= ~SIGNAL_UNKILLABLE;
> 
> Then someone noticed that in the ptrace case, the signal might not
> actually end up being consumed by the target process, and added the
> "&& !t->ptrace" clause in commit
> eb61b5911bdc923875cde99eb25203a0e2b06d43.
> 
> And now Robert Swiecki noticed that that still didn't accurately model
> what'll happen in get_signal().
> 
> This seems hacky to me, and also racy: What if, while you're going
> through a SECCOMP_RET_KILL_PROCESS in an unkillable process, some
> other thread e.g. concurrently changes the disposition of SIGSYS from
> a custom handler to SIG_DFL?

Do you mean after force_sig_info_to_task() has finished but before
get_signal()? SA_IMMUTABLE will block changes to the action.

If you mean before force_sig_info_to_task(), I don't see how that's
possible since it's under lock:

        if (blocked || ignored || (handler != HANDLER_CURRENT)) {
                action->sa.sa_handler = SIG_DFL;
                if (handler == HANDLER_EXIT)
                        action->sa.sa_flags |= SA_IMMUTABLE;
	...
        if (action->sa.sa_handler == SIG_DFL &&
            (!t->ptrace || (handler == HANDLER_EXIT)))
                t->signal->flags &= ~SIGNAL_UNKILLABLE;

Given handler = HANDLER_EXIT, it'll always be SIG_DFL.

> Instead of trying to figure out whether the signal would have been
> fatal without SIGNAL_UNKILLABLE, I think it would be better to find a
> way to tell the signal-handling code that SIGNAL_UNKILLABLE should be
> bypassed for this specific signal, or something along those lines...
> but of course that's also kind of messy because the signal-sending
> code might fall back to just using the pending signal mask on
> allocation failure IIRC?

My original patch aimed that way:

diff --git a/kernel/signal.c b/kernel/signal.c
index 9b04631acde8..c124a09de6de 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2787,7 +2787,8 @@ bool get_signal(struct ksignal *ksig)
 		 * case, the signal cannot be dropped.
 		 */
 		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
-				!sig_kernel_only(signr))
+				!sig_kernel_only(signr) &&
+				!(ka->sa.sa_flags & SA_IMMUTABLE))
 			continue;
 
 		if (sig_kernel_stop(signr)) {

But I don't think there's a race, and Eric's suggestion seemed
better in the sense that the state change is entirely contained by
force_sig_info_to_task().

-Kees

-- 
Kees Cook
