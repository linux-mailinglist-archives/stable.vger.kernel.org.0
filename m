Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665CC1EEDBC
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 00:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgFDWci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 18:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgFDWci (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 18:32:38 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EB6C08C5C0
        for <stable@vger.kernel.org>; Thu,  4 Jun 2020 15:32:37 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d7so8221389ioq.5
        for <stable@vger.kernel.org>; Thu, 04 Jun 2020 15:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=juliacomputing-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nG94eKmQPzachChhRZc7Y7pHTjGTzR49asGOXCRQh+A=;
        b=zP++UB2OK8m9ns4la9v/8g6CVzhB2g4rMb9FOMxFjcF/lLEss5WT+IxE1yopI5IJpf
         doOURN+gh4EQTFm8imFySp7uLfo5Nn/yHXJXvLFJriBzoE/WXyGwtT/eT2QiZYsVMGZW
         +dSEcLwMCxDcwSNaiXQ9hugE5afDZ2vUAcJUj7cLrYDkaV+cLWz3AmBMr5yaXZ+7+dZH
         M0Z4aH0BUJRv7N+JUfIfzu7ktujZ7Yi7R3cCEsgbtjI6dkOYx99AM6kQKgEAhqwkh7xT
         jE0fJzjILIm2WMGgINworZXnMmOKL6ooW8ZNZDeZBD3rAfHFAdhsQ4n9XJodOVHcbTB+
         s74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nG94eKmQPzachChhRZc7Y7pHTjGTzR49asGOXCRQh+A=;
        b=LQGj1pfYwP2PKIG3qr0COtl+/BBTAg+65I/QhqU3RP+9ecMO5N9CcbOC1Qo22JdJwD
         25S0MS+aj37P5DuvpnPgg0sfnuba1I3dLf16nsaQjfAkSao4nGmxJNeF6pWOqK/5qqEt
         PNbz/ko0BHwnX4Ok+dsN2VedSRbOiU39jBfZruAg49ZvfZ/PjkLH6CDV9N7/+W/i+tbf
         MQ1vJEYLLguKgbalzWCAwzUYOKmdATT8TJuj+ImndH/VU/IyfUpG4GmqyMVjiB4i0Xp3
         muAZvIscAzRM15YRZfvroNSxQkzoF0h36nQKAQ/mjnLDZwH3QQDbM6hjnK9c68Wz263Y
         ARkA==
X-Gm-Message-State: AOAM533V5eNUM2/jWzJEjcPHBriumMip+CRD0tWYqSG+laTV9DGH2h2D
        CB9lPXhP1wqwYMRw3wCjRmy+ZmfBPLn2tFQaeNhROQ==
X-Google-Smtp-Source: ABdhPJw8UBWBeeUwAM8Q79mui5tBSoo24FM+k9EeSNhwXZ01MUa0yAoPygsomRMRqKhKpZB52ek1b/hDSXUuzyIUjPU=
X-Received: by 2002:a5e:df49:: with SMTP id g9mr6066490ioq.153.1591309957089;
 Thu, 04 Jun 2020 15:32:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200603151033.11512-1-will@kernel.org> <20200603151033.11512-2-will@kernel.org>
 <CABV8kRwrnixNc074-jQhZzeucGHx9_e5FnQmBS=VuL=tFGjY-Q@mail.gmail.com>
 <20200603155338.GA12036@willie-the-truck> <CABV8kRxSjMY+d+F5aNzq1=5hXhVLGy6TbNLTUsCeSsAncwCzoA@mail.gmail.com>
 <20200604083210.GC30155@willie-the-truck>
In-Reply-To: <20200604083210.GC30155@willie-the-truck>
From:   Keno Fischer <keno@juliacomputing.com>
Date:   Thu, 4 Jun 2020 18:32:01 -0400
Message-ID: <CABV8kRyCz=BBab_1nw-he9Q4QUydNw4G_SQHz=v1W=veX8jX4w@mail.gmail.com>
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

> > With your proposed patch, we instead get
> > <- (ip: 0x0)
> > -> PTRACE_SINGLESTEP
> > <- (ip: 0x4 - seccomp trap)
> > -> PTRACE_SINGLESTEP
> > <- SIGTRAP (ip: 0x8 - TRAP_TRACE trap)
>
> Urgh, and actually, I think this is *only* the case if the seccomp
> handler actually changes a register in the target, right?

Ah yes, you are correct. Because otherwise the flag would not
get toggled at all. That does raise an additional question about
signal stops though, which have a similar issue. What if a single
step gets completed, but the singlestep trap gets pre-empted
by some other signal. What should PTRACE_SINGLESTEP
from such a signal stop do?

> In which case, your proposed patch should probably do something like:
>
>         if (dir == PTRACE_SYSCALL_EXIT) {
>                 bool stepping = test_thread_flag(TIF_SINGLESTEP);
>
>                 tracehook_report_syscall_exit(regs, stepping);
>                 user_rewind_single_step(regs);
>         }
>
> otherwise I think we could get a spurious SIGTRAP on return to userspace.
> What do you think?

Yes, this change seems reasonable, though you may want to make the
rewind conditional on stepping, since otherwise the armed pstate may
become visible to a signal handler/ptrace signal stop which may
be unexpected.

> This has also got me thinking about your other patch to report a pseudo-step
> exception on entry to a signal handler:
>
> https://lore.kernel.org/r/20200524043827.GA33001@juliacomputing.com
>
> Although we don't actually disarm the step logic there (and so you might
> expect a spurious SIGTRAP on the second instruction of the handler), I
> think it's ok because the tracer will either do PTRACE_SINGLESTEP (and
> rearm the state machine) or PTRACE_CONT (and so stepping will be
> disabled). Do you agree?

Yes, I had thought about whether to re-arm the rewind the single-step logic,
but then realized that since the next event was a ptrace stop anyway, the
ptracer could decide. With your patch here, it would always just depend
on which ptrace continue method is used, which is fine.

> > This is problematic, because the ptracer may want to inspect the
> > result of the syscall instruction. On other architectures, this
> > problem is solved with a pseudo-singlestep trap that gets executed
> > if you resume from a syscall-entry-like trap with PTRACE_SINGLESTEP.
> > See the below patch for the change I'm proposing. There is a slight
> > issue with that patch, still: It now makes the x7 issue apply to the
> > singlestep trap at exit, so we should do the patch to fix that issue
> > before we apply that change (or manually check for this situation
> > and issue the pseudo-singlestep trap manually).
>
> I don't see the dependency on the x7 issue; x7 is nobbled on syscall entry,
> so it will be nobbled in the psuedo-step trap as well as the hardware step
> trap on syscall return. I'd also like to backport this to stable, without
> having to backport an optional extension to the ptrace API for preserving
> x7. Or are you saying that the value of x7 should be PTRACE_SYSCALL_ENTER
> for the pseudo trap? That seems a bit weird to me, but then this is all
> weird anyway.

So the issue here is that writes to x7 at the singlestep stop after a seccomp
stop will now be ignored (and reads incorrect), which is a definite change
in behavior and one that I would not recommend backporting to stable.
If you do want to backport something to stable, I would recommend making
the register modification conditional on !stepping for the backport.

> I think that's still the case with my addition above, so that's good.
> Any other quirks you ran into that we should address here? Now that I have
> this stuff partially paged-in, it would be good to fix a bunch of this
> at once. I can send out a v2 which includes the two patches from you
> once we're agreed on the details.

As for other quirks, the behavior with negative syscalls is a bit odd,
but not necessarily arm64 specific (though arm64 has an additional
quirk). I'd emailed about that separately here:

https://lkml.org/lkml/2020/5/22/1216

There's also the issue that orig_x0 is inaccessible, so syscall
restarts of syscalls that have had their registers modified by a
ptracer will potentially unexpectedly use the x0 value before
modification during restart, rather than the modified values.

My preference would be to fix these two issues along with the
x7 issue, by introducing a new regset that:
- Explicitly splits out orig_x0
- Sets regular x0 to -ENOSYS before the
   syscall entry stop (and using the orig_x0 value for syscall processing)
- Addresses the x7 issue

As I said, I'm planning to send a patch along these lines, but
haven't had the time yet. Perhaps this weekend.

Lastly, there was one additional issue with process_vm_readv,
which isn't directly ptrace related, but slightly adjacent (and
also no arm64 specific):
I wrote about that here: https://lkml.org/lkml/2020/5/24/466

I think that's everything I ran into from the kernel perspective,
though I'm not 100% done porting yet, so other things may come
up.

Keno
