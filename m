Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332781EF0B3
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 06:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgFEEul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 00:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFEEul (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 00:50:41 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316FEC08C5C1
        for <stable@vger.kernel.org>; Thu,  4 Jun 2020 21:50:41 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z1so7521047qtn.2
        for <stable@vger.kernel.org>; Thu, 04 Jun 2020 21:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YYFG7BATzDU9S82kn1J9pAmjsSff6pBtSrBKC8WNkW4=;
        b=voSUTkVue/f33gxYggKRUpF/lSTr1yX6uz+45AZNhgIDzGoRewYun2f2OhxJFedXZt
         Jxz+i1E6i/vcElaB0MfcinsDMRXkbku8X5evQzJlxt4MZ91bUux4GYJfY108QEEjVEMP
         gh5wbdhEsS/AzLMcKA4fcKOOn2PknuTGpxM/1sxfHlhE0MwgNaZg4cXsdCUBJp8Wm5f/
         l0dcvS8OEh12bdSF0HTiY5nEsqX1mC6bQOdkHGGKMXIZXUwbEY7ZlQ7zkADrESxxAo8g
         JWrfCWj9ky8uFTvSnguz8cLLcUN5ZXoRSb4IwEDSl/aptJpik5lC55g3K4udcR80dgaZ
         O7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YYFG7BATzDU9S82kn1J9pAmjsSff6pBtSrBKC8WNkW4=;
        b=fTpvSliU58Ocg1aICImzqY/gsxWBFoIbvCOb6uZCbi67qtpPiAQHRVghuf7oV7jmNE
         Ksx+ptDY4Z6bt4NPyVU7gI9jMicelH3H6pfQvNMmZZguQQ9BpQ8JcZbWTCJtdtzxF5Vg
         LIP+QAGzXxLtUHW5Tpq9QsAFnW7iRS1E3Dvqk2ae6nGbrooiuuyPIe8wjpv8dJeg+fXf
         MnAYLOwBVFWJQI4K6lzOI7ZcFRKsZVlXVe16M4hb3HSkSv/UuZ7kU/7OGLavOgouberW
         2RgeVVCm+0XPRmU9ZFd9qBCj1xU/A10wIhBdIQwpcuPT0ZegU0VEeqs4LrbEDgJ3xM3+
         3vRA==
X-Gm-Message-State: AOAM532ViBUQtLxLe3xTJDP1fewzs/zO4CkCtfZCsIBRFHHL29dzLVHl
        SKJrScugOc+FKQbQH70dwc1AUHG7muA=
X-Google-Smtp-Source: ABdhPJyH2bZnxYvDqqW0X7W77nB5DLqb6gEl4yMJSEdCNauDD7NuYNwjAf/WG7pFmtnHhQsVk0qiWA==
X-Received: by 2002:ac8:7089:: with SMTP id y9mr8390185qto.355.1591332639288;
        Thu, 04 Jun 2020 21:50:39 -0700 (PDT)
Received: from [192.168.0.185] ([191.34.95.148])
        by smtp.gmail.com with ESMTPSA id z4sm6781241qtu.33.2020.06.04.21.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 21:50:38 -0700 (PDT)
Subject: Re: [PATCH 1/2] arm64: Override SPSR.SS when single-stepping is
 enabled
To:     Will Deacon <will@kernel.org>,
        Keno Fischer <keno@juliacomputing.com>
Cc:     linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org
References: <20200603151033.11512-1-will@kernel.org>
 <20200603151033.11512-2-will@kernel.org>
 <CABV8kRwrnixNc074-jQhZzeucGHx9_e5FnQmBS=VuL=tFGjY-Q@mail.gmail.com>
 <20200603155338.GA12036@willie-the-truck>
 <CABV8kRxSjMY+d+F5aNzq1=5hXhVLGy6TbNLTUsCeSsAncwCzoA@mail.gmail.com>
 <20200604083210.GC30155@willie-the-truck>
From:   Luis Machado <luis.machado@linaro.org>
Message-ID: <fdce5355-8a85-7bdc-0fba-a2a6c08cb0b8@linaro.org>
Date:   Fri, 5 Jun 2020 01:50:34 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200604083210.GC30155@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 6/4/20 5:32 AM, Will Deacon wrote:
> Hi Keno,
> 
> Cheers for the really helpful explanation. I have a bunch of
> questions/comments, since it's not very often that somebody shows up who
> understands how this is supposed to work and so I'd like to take advantage
> of that!
> 
> On Wed, Jun 03, 2020 at 12:56:24PM -0400, Keno Fischer wrote:
>> On Wed, Jun 3, 2020 at 11:53 AM Will Deacon <will@kernel.org> wrote:
>>>> However, at the same time as changing this, we should probably make sure
>>>> to enable the syscall exit pseudo-singlestep trap (similar issue as the other
>>>> patch I had sent for the signal pseudo-singlestep trap), since otherwise
>>>> ptracers might get confused about the lack of singlestep trap during a
>>>> singlestep -> seccomp -> singlestep path (which would give one trap
>>>> less with this patch than before).
>>>
>>> Hmm, I don't completely follow your example. Please could you spell it
>>> out a bit more? I fast-forward the stepping state machine on sigreturn,
>>> which I thought would be sufficient. Perhaps you're referring to a variant
>>> of the situation mentioned by Mark, which I didn't think could happen
>>> with ptrace [2].
>>
>> Sure suppose we have code like the following:
>>
>> 0x0: svc #0
>> 0x4: str x0, [x7]
>> ...
>>
>> Then, if there's a seccomp filter active that just does
>> SECCOMP_RET_TRACE of everything, right now we get traps:
>>
>> <- (ip: 0x0)
>> -> PTRACE_SINGLESTEP
>> <- (ip: 0x4 - seccomp trap)
>> -> PTRACE_SINGLESTEP
>> <- SIGTRAP (ip: 0x4 - TRAP_TRACE trap)
>> -> PTRACE_SINGLESTEP
>> <- SIGTRAP (ip: 0x8 - TRAP_TRACE trap)
>>
>> With your proposed patch, we instead get
>> <- (ip: 0x0)
>> -> PTRACE_SINGLESTEP
>> <- (ip: 0x4 - seccomp trap)
>> -> PTRACE_SINGLESTEP
>> <- SIGTRAP (ip: 0x8 - TRAP_TRACE trap)
> 
> Urgh, and actually, I think this is *only* the case if the seccomp
> handler actually changes a register in the target, right?
> 
> In which case, your proposed patch should probably do something like:
> 
> 	if (dir == PTRACE_SYSCALL_EXIT) {
> 		bool stepping = test_thread_flag(TIF_SINGLESTEP);
> 
> 		tracehook_report_syscall_exit(regs, stepping);
> 		user_rewind_single_step(regs);
> 	}
> 
> otherwise I think we could get a spurious SIGTRAP on return to userspace.
> What do you think?
> 
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
> 
>> This is problematic, because the ptracer may want to inspect the
>> result of the syscall instruction. On other architectures, this
>> problem is solved with a pseudo-singlestep trap that gets executed
>> if you resume from a syscall-entry-like trap with PTRACE_SINGLESTEP.
>> See the below patch for the change I'm proposing. There is a slight
>> issue with that patch, still: It now makes the x7 issue apply to the
>> singlestep trap at exit, so we should do the patch to fix that issue
>> before we apply that change (or manually check for this situation
>> and issue the pseudo-singlestep trap manually).
> 
> I don't see the dependency on the x7 issue; x7 is nobbled on syscall entry,
> so it will be nobbled in the psuedo-step trap as well as the hardware step
> trap on syscall return. I'd also like to backport this to stable, without
> having to backport an optional extension to the ptrace API for preserving
> x7. Or are you saying that the value of x7 should be PTRACE_SYSCALL_ENTER
> for the pseudo trap? That seems a bit weird to me, but then this is all
> weird anyway.
> 
>> My proposed patch below also changes
>>
>> <- (ip: 0x0)
>> -> PTRACE_SYSCALL
>> <- (ip: 0x4 - syscall entry trap)
>> -> PTRACE_SINGLESTEP
>> <- SIGTRAP (ip: 0x8 - TRAP_TRACE trap)
>>
>> to
>>
>> <- (ip: 0x0)
>> -> PTRACE_SYSCALL
>> <- (ip: 0x4 - syscall entry trap)
>> -> PTRACE_SINGLESTEP
>> <- SIGTRAP (ip: 0x4 - pseudo-singlestep exit trap)
>> -> PTRACE_SINGLESTEP
>> <- SIGTRAP (ip: 0x8 - TRAP_TRACE trap)
>>
>> But I consider that a bugfix, since that's how other architectures
>> behave and I was going to send in this patch for that reason anyway
>> (since this was another one of the aarch64 ptrace quirks we had to
>> work around).
> 
> I think that's still the case with my addition above, so that's good.
> Any other quirks you ran into that we should address here? Now that I have
> this stuff partially paged-in, it would be good to fix a bunch of this
> at once. I can send out a v2 which includes the two patches from you
> once we're agreed on the details.

Since we're discussing arm64 ptrace/kernel quirks, I'm gonna go ahead 
and describe a strange behavior on arm64 that I could not reproduce on 
x86, for example. I apologize for hijacking the thread if this is a 
non-issue or not related.

This is something I noticed when single-stepping over fork and vfork 
syscalls in GDB, so handling of PTRACE_EVENT_FORK, PTRACE_EVENT_VFORK 
and PTRACE_EVENT_VFORK_DONE.

The situation seems to happen more reliably with vforks since it is a 
two stage operation with VFORK and VFORK_DONE.

Suppose we're stopped at a vfork syscall instruction and that the child 
we spawn will exit immediately. If we attempt to single-step that 
particular instruction, this is what happens for arm64:

--

[Step over vfork syscall]
ptrace(PTRACE_SINGLESTEP, 63049, 0x1, SIG_0) = 0
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_TRAPPED, si_pid=63049, 
si_uid=13595, si_status=SIGTRAP, si_utime=0, si_stime=0} ---

[vfork event for child 63052]
ptrace(PTRACE_GETEVENTMSG, 63049, NULL, [63052]) = 0

...

[Detach child]
ptrace(PTRACE_DETACH, 63052, NULL, SIG_0) = 0
ptrace(PTRACE_CONT, 63049, 0x1, SIG_0)  = 0
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_TRAPPED, si_pid=63049, 
si_uid=13595, si_status=SIGTRAP, si_utime=0, si_stime=0} ---

...

ptrace(PTRACE_SINGLESTEP, 63049, 0x1, SIG_0) = 0
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_TRAPPED, si_pid=63049, 
si_uid=13595, si_status=SIGCHLD, si_utime=0, si_stime=0} ---

--

For x86-64, we have this:

--

[Step over vfork syscall]
ptrace(PTRACE_SINGLESTEP, 13484, 0x1, SIG_0) = 0
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_TRAPPED, si_pid=13484, 
si_uid=1000, si_status=SIGTRAP, si_utime=0, si_stime=0} ---
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_TRAPPED, si_pid=13493, 
si_uid=1000, si_status=SIGSTOP, si_utime=0, si_stime=0} ---

[vfork event for child 13493]
ptrace(PTRACE_GETEVENTMSG, 13484, NULL, [13493]) = 0

...

[Detach child]
ptrace(PTRACE_DETACH, 13493, NULL, SIG_0) = 0
ptrace(PTRACE_CONT, 13484, 0x1, SIG_0)  = 0
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_TRAPPED, si_pid=13484, 
si_uid=1000, si_status=SIGTRAP, si_utime=0, si_stime=0} ---

...

ptrace(PTRACE_SINGLESTEP, 13484, 0x1, SIG_0) = 0
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_TRAPPED, si_pid=13484, 
si_uid=1000, si_status=SIGTRAP, si_utime=0, si_stime=0} ---

--

There are a couple things off:

1 - x86-64 seems to get an extra SIGSTOP when we single-step over the 
vfork syscall, though this doesn't seem to do any harm.

2 - This is the one that throws GDB off. In the last single-step 
request, arm64 gets a SIGCHLD instead of the SIGTRAP x86-64 gets.

I did some experiments with it, and it seems the last SIGCHLD is more 
prone to being delivered (instead of a SIGTRAP) if we put some load on 
the machine (by firing off processes or producing a lot of screen output 
for example).

Does this ring any bells? I suppose signal delivery order is not 
guaranteed in this context, but x86-64 seems to deliver them 
consistently in the same order.
