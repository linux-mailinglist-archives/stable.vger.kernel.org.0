Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB6A176AAA
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgCCC0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:26:51 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46177 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgCCC0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 21:26:51 -0500
Received: by mail-pf1-f194.google.com with SMTP id o24so645288pfp.13
        for <stable@vger.kernel.org>; Mon, 02 Mar 2020 18:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uuCIfBrJnhC2RWZ3b46zhSPALaCgRQ8Eg5B/pVuFDGA=;
        b=cZpK/HtsEcWQ/CTSUQ1ubLYsVROBY8QOJEFoLwD66YBoteVTZuqDc2IoIDVno0Al7C
         SCXMT7VYKs9/cnCjAXky2ULLkm0bntcqMWmtEFYaHImX5ZSCHtkI/WzDqQTmEhiLLchm
         ut6E8bdbRO0GJnMDZkms29ClVRGdfGh2pMejQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uuCIfBrJnhC2RWZ3b46zhSPALaCgRQ8Eg5B/pVuFDGA=;
        b=blyt8BA/iUOP7zhoc0hVOraIzXRH79qBsLt/6GA7yyRCuZwW0J924u1WxGp9XHXPQt
         aSMtdYaf0mGP1CHs2y3ykhCZW3wTjvAw3qXuREiT0ytwyhiDw40wCKrT/WPPAa5j9xJg
         C7z1hIOYpDpLs09ZycIlMwFwTaraWyLagOZbojFyzsvUGLFlOBWkjc4KQfUuSBYv3Q8a
         D0tBx3sfDpo/pSsnCHlsQLPpsiew7xlxSyjut5BM9jY2FIjJl8HqZFNotS6JdG7WQryR
         znzOsUFPt7R5bgPV5FyIuoGwZkRJz2yb2k10alMRni8mRb5B0+lUrI5cDw9OIRHUFnwu
         kv0w==
X-Gm-Message-State: ANhLgQ0JhaFD6LkCvh/Lr/1rHPn++QLytIxEb+QtKVcZUY8sk1/4Zis1
        9KDKUt0jNUnaDktf9X/Z063JnlNmHGQ=
X-Google-Smtp-Source: ADFU+vvlcm87xXubPEMs3IXv/wlZn0X627KVNbEgL+NdE0Sm9XRM6huUjL2wvS3j84kucVc1XqEGfw==
X-Received: by 2002:a62:f94d:: with SMTP id g13mr1940932pfm.60.1583202410115;
        Mon, 02 Mar 2020 18:26:50 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ay10sm449077pjb.37.2020.03.02.18.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 18:26:49 -0800 (PST)
Date:   Mon, 2 Mar 2020 18:26:47 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCHv4] exec: Fix a deadlock in ptrace
Message-ID: <202003021531.C77EF10@keescook>
References: <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
 <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 02, 2020 at 10:18:07PM +0000, Bernd Edlinger wrote:
> This fixes a deadlock in the tracer when tracing a multi-threaded
> application that calls execve while more than one thread are running.
> 
> I observed that when running strace on the gcc test suite, it always
> blocks after a while, when expect calls execve, because other threads
> have to be terminated.  They send ptrace events, but the strace is no
> longer able to respond, since it is blocked in vm_access.
> 
> The deadlock is always happening when strace needs to access the
> tracees process mmap, while another thread in the tracee starts to
> execve a child process, but that cannot continue until the
> PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:
> 
> strace          D    0 30614  30584 0x00000000
> Call Trace:
> __schedule+0x3ce/0x6e0
> schedule+0x5c/0xd0
> schedule_preempt_disabled+0x15/0x20
> __mutex_lock.isra.13+0x1ec/0x520
> __mutex_lock_killable_slowpath+0x13/0x20
> mutex_lock_killable+0x28/0x30
> mm_access+0x27/0xa0
> process_vm_rw_core.isra.3+0xff/0x550
> process_vm_rw+0xdd/0xf0
> __x64_sys_process_vm_readv+0x31/0x40
> do_syscall_64+0x64/0x220
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> expect          D    0 31933  30876 0x80004003
> Call Trace:
> __schedule+0x3ce/0x6e0
> schedule+0x5c/0xd0
> flush_old_exec+0xc4/0x770
> load_elf_binary+0x35a/0x16c0
> search_binary_handler+0x97/0x1d0
> __do_execve_file.isra.40+0x5d4/0x8a0
> __x64_sys_execve+0x49/0x60
> do_syscall_64+0x64/0x220
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The proposed solution is to take the cred_guard_mutex only
> in a critical section at the beginning, and at the end of the
> execve function, and let PTRACE_ATTACH fail with EAGAIN while
> execve is not complete, but other functions like vm_access are
> allowed to complete normally.

Sorry to be bummer, but I don't think this will work. A few more things
during the exec process depend on cred_guard_mutex being held.

If I'm reading this patch correctly, this changes the lifetime of the
cred_guard_mutex lock to be:
	- during prepare_bprm_creds()
	- from flush_old_exec() through install_exec_creds()
Before, cred_guard_mutex was held from prepare_bprm_creds() through
install_exec_creds().

That means, for example, that check_unsafe_exec()'s documented invariant
is violated:
    /*
     * determine how safe it is to execute the proposed program
     * - the caller must hold ->cred_guard_mutex to protect against
     *   PTRACE_ATTACH or seccomp thread-sync
     */
    static void check_unsafe_exec(struct linux_binprm *bprm) ...
which is looking at no_new_privs as well as other details, and making
decisions about the bprm state from the current state.

I think it also means that the potentially multiple invocations
of bprm_fill_uid() (via prepare_binprm() via binfmt_script.c and
binfmt_misc.c) would be changing bprm->cred details (uid, gid) without
a lock (another place where current's no_new_privs is evaluated).

Related, it also means that cred_guard_mutex is unheld for every
invocation of search_binary_handler() (which can loop via the previously
mentioned binfmt_script.c and binfmt_misc.c), if any of them have hidden
dependencies on cred_guard_mutex. (Thought I only see bprm_fill_uid()
currently.)

For seccomp, the expectations about existing thread states risks races
too. There are two locks held for TSYNC:
- current->sighand->siglock is held to keep new threads from
  appearing/disappearing, which would destroy filter refcounting and
  lead to memory corruption.
- cred_guard_mutex is held to keep no_new_privs in sync with filters to
  avoid no_new_privs and filter confusion during exec, which could
  lead to exploitable setuid conditions (see below).

Just racing a malicious thread during TSYNC is not a very strong
example (a malicious thread could do lots of fun things to "current"
before it ever got near calling TSYNC), but I think there is the risk
of mismatched/confused states that we don't want to allow. One is a
particularly bad state that could lead to privilege escalations (in the
form of the old "sendmail doesn't check setuid" flaw; if a setuid process
has a filter attached that silently fails a priv-dropping setuid call
and continues execution with elevated privs, it can be tricked into
doing bad things on behalf of the unprivileged parent, which was the
primary goal of the original use of cred_guard_mutex with TSYNC[1]):

thread A clones thread B
thread B starts setuid exec
thread A sets no_new_privs
thread A calls seccomp with TSYNC
thread A in seccomp_sync_threads() sets seccomp filter on self and thread B
thread B passes check_unsafe_exec() with no_new_privs unset
thread B reaches bprm_fill_uid() with no_new_privs unset and gains privs
thread A still in seccomp_sync_threads() sets no_new_privs on thread B
thread B finishes exec, now running with elevated privs, a filter chosen
         by thread A, _and_ nnp set (which doesn't matter)

With the original locking, thread B will fail check_unsafe_exec()
because filter and nnp state are changed together, with "atomicity"
protected by the cred_guard_mutex.

And this is just the bad state I _can_ see. I'm worried there are more...

All this said, I do see a small similarity here to the work I did to
stabilize stack rlimits (there was an ongoing problem with making multiple
decisions for the bprm based on current's state -- but current's state
was mutable during exec). For this, I saved rlim_stack to bprm and ignored
current's copy until exec ended and then stored bprm's copy into current.
If the only problem anyone can see here is the handling of no_new_privs,
we might be able to solve that similarly, at least disentangling tsync/nnp
from cred_guard_mutex.

-Kees

[1] https://lore.kernel.org/lkml/20140625142121.GD7892@redhat.com/

-- 
Kees Cook
