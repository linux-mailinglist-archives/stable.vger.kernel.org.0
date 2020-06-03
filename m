Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE81ED497
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 18:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFCQ5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 12:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgFCQ5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 12:57:00 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00A9C08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 09:57:00 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l6so3228991ilo.2
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 09:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=juliacomputing-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KQT1mSk5GZAejsG86TNk9V0+f37wlqbJ20Yhgw/mpdQ=;
        b=ikMGc0vtUJcDbPMcm9sHlaQy6v+9UgeKgDwVp8aGldO90KIg6YELvKjHLpgXmHjgnK
         Zdph4F7NLsjR64BpFd/RRXi3Pe72kJFb3LxIoMgCTmGJ3aevdThOzGbQmRVyCR+iKvFG
         ZcM0y4KBNgoBvDnqxkgtya9cgY8fEciPd7buBwArznatxhbBHIk/oeqbK5emxgo7+wkK
         aBdz7wgAEzybjBG928SmAXEAKGyfvT9QziP6SnVsjOGYTK3uzEL09oqybiJf2x8XRB1S
         qqrRRCTGZVPFAc5WF5nQyS1p8OpYRrN4WE1UkQmaT4VOtfWgLxv6VvPL2zD7Rme6TtUS
         EnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KQT1mSk5GZAejsG86TNk9V0+f37wlqbJ20Yhgw/mpdQ=;
        b=BN8uo2rFMlQ4g6DRRFOU7rDO8wdJ9/J4PV/jPJ5PuU//ivwRoD4j562EEX+6YYxcFZ
         J0pbktauYYGEZ6rlrmbubMJfRzMbcJO+qXf18WxkPPquhnO/bfG/67p4VH7zPnbb0VEz
         dPRu+3pGh7TigQMaphZCw6/sc36svgILd4tJgpRz1CTIRwYuTzDL4hZDPVWcSAIiC3uq
         thmBxudmNgPSh87Yj/69/MfIHVzthqBwSa67BX5EurApleDUYJjfIDNj8+C6YN20/1zo
         K4p2f3eyuu5Yd4xvTU0jPLnloemYq7aZAPD4710vYuDOdwH5cruRgh6MTKaEukhoRP0A
         XEMw==
X-Gm-Message-State: AOAM530jt+BQU47XcsYg919+lheUawCCAhGuKwFgRRNlFVPJFUL/lWuz
        jsYwQTKsHHRC0C9hp8QGbqh41z1qTACH0I+bbrYGXw==
X-Google-Smtp-Source: ABdhPJyHkno5yldGr9+v1MKHFlCKN57QArtAe9koNMdcOi9e1WsgIT/9Z751om+WZdbXL3BHa29oO+amRPLqnYHlYtA=
X-Received: by 2002:a92:290b:: with SMTP id l11mr437220ilg.145.1591203420134;
 Wed, 03 Jun 2020 09:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200603151033.11512-1-will@kernel.org> <20200603151033.11512-2-will@kernel.org>
 <CABV8kRwrnixNc074-jQhZzeucGHx9_e5FnQmBS=VuL=tFGjY-Q@mail.gmail.com> <20200603155338.GA12036@willie-the-truck>
In-Reply-To: <20200603155338.GA12036@willie-the-truck>
From:   Keno Fischer <keno@juliacomputing.com>
Date:   Wed, 3 Jun 2020 12:56:24 -0400
Message-ID: <CABV8kRxSjMY+d+F5aNzq1=5hXhVLGy6TbNLTUsCeSsAncwCzoA@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: Override SPSR.SS when single-stepping is enabled
To:     Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        Mark Rutland <mark.rutland@arm.com>,
        Luis Machado <luis.machado@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 3, 2020 at 11:53 AM Will Deacon <will@kernel.org> wrote:
> > However, at the same time as changing this, we should probably make sure
> > to enable the syscall exit pseudo-singlestep trap (similar issue as the other
> > patch I had sent for the signal pseudo-singlestep trap), since otherwise
> > ptracers might get confused about the lack of singlestep trap during a
> > singlestep -> seccomp -> singlestep path (which would give one trap
> > less with this patch than before).
>
> Hmm, I don't completely follow your example. Please could you spell it
> out a bit more? I fast-forward the stepping state machine on sigreturn,
> which I thought would be sufficient. Perhaps you're referring to a variant
> of the situation mentioned by Mark, which I didn't think could happen
> with ptrace [2].

Sure suppose we have code like the following:

0x0: svc #0
0x4: str x0, [x7]
...

Then, if there's a seccomp filter active that just does
SECCOMP_RET_TRACE of everything, right now we get traps:

<- (ip: 0x0)
-> PTRACE_SINGLESTEP
<- (ip: 0x4 - seccomp trap)
-> PTRACE_SINGLESTEP
<- SIGTRAP (ip: 0x4 - TRAP_TRACE trap)
-> PTRACE_SINGLESTEP
<- SIGTRAP (ip: 0x8 - TRAP_TRACE trap)

With your proposed patch, we instead get
<- (ip: 0x0)
-> PTRACE_SINGLESTEP
<- (ip: 0x4 - seccomp trap)
-> PTRACE_SINGLESTEP
<- SIGTRAP (ip: 0x8 - TRAP_TRACE trap)

This is problematic, because the ptracer may want to inspect the
result of the syscall instruction. On other architectures, this
problem is solved with a pseudo-singlestep trap that gets executed
if you resume from a syscall-entry-like trap with PTRACE_SINGLESTEP.
See the below patch for the change I'm proposing. There is a slight
issue with that patch, still: It now makes the x7 issue apply to the
singlestep trap at exit, so we should do the patch to fix that issue
before we apply that change (or manually check for this situation
and issue the pseudo-singlestep trap manually).

My proposed patch below also changes

<- (ip: 0x0)
-> PTRACE_SYSCALL
<- (ip: 0x4 - syscall entry trap)
-> PTRACE_SINGLESTEP
<- SIGTRAP (ip: 0x8 - TRAP_TRACE trap)

to

<- (ip: 0x0)
-> PTRACE_SYSCALL
<- (ip: 0x4 - syscall entry trap)
-> PTRACE_SINGLESTEP
<- SIGTRAP (ip: 0x4 - pseudo-singlestep exit trap)
-> PTRACE_SINGLESTEP
<- SIGTRAP (ip: 0x8 - TRAP_TRACE trap)

But I consider that a bugfix, since that's how other architectures
behave and I was going to send in this patch for that reason anyway
(since this was another one of the aarch64 ptrace quirks we had to
work around).

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index b3d3005d9515..104cfcf117d0 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1820,7 +1820,7 @@ static void tracehook_report_syscall(struct pt_regs *regs,
        regs->regs[regno] = dir;

        if (dir == PTRACE_SYSCALL_EXIT)
-               tracehook_report_syscall_exit(regs, 0);
+               tracehook_report_syscall_exit(regs,
test_thread_flag(TIF_SINGLESTEP));
        else if (tracehook_report_syscall_entry(regs))
                forget_syscall(regs);
