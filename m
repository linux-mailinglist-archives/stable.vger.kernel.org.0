Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5031771AE
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 09:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgCCI6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 03:58:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34855 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgCCI6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 03:58:31 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j93NM-0006xr-6q; Tue, 03 Mar 2020 08:58:04 +0000
Date:   Tue, 3 Mar 2020 09:58:02 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
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
Message-ID: <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202003021531.C77EF10@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 02, 2020 at 06:26:47PM -0800, Kees Cook wrote:
> On Mon, Mar 02, 2020 at 10:18:07PM +0000, Bernd Edlinger wrote:
> > This fixes a deadlock in the tracer when tracing a multi-threaded
> > application that calls execve while more than one thread are running.
> > 
> > I observed that when running strace on the gcc test suite, it always
> > blocks after a while, when expect calls execve, because other threads
> > have to be terminated.  They send ptrace events, but the strace is no
> > longer able to respond, since it is blocked in vm_access.
> > 
> > The deadlock is always happening when strace needs to access the
> > tracees process mmap, while another thread in the tracee starts to
> > execve a child process, but that cannot continue until the
> > PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:
> > 
> > strace          D    0 30614  30584 0x00000000
> > Call Trace:
> > __schedule+0x3ce/0x6e0
> > schedule+0x5c/0xd0
> > schedule_preempt_disabled+0x15/0x20
> > __mutex_lock.isra.13+0x1ec/0x520
> > __mutex_lock_killable_slowpath+0x13/0x20
> > mutex_lock_killable+0x28/0x30
> > mm_access+0x27/0xa0
> > process_vm_rw_core.isra.3+0xff/0x550
> > process_vm_rw+0xdd/0xf0
> > __x64_sys_process_vm_readv+0x31/0x40
> > do_syscall_64+0x64/0x220
> > entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > expect          D    0 31933  30876 0x80004003
> > Call Trace:
> > __schedule+0x3ce/0x6e0
> > schedule+0x5c/0xd0
> > flush_old_exec+0xc4/0x770
> > load_elf_binary+0x35a/0x16c0
> > search_binary_handler+0x97/0x1d0
> > __do_execve_file.isra.40+0x5d4/0x8a0
> > __x64_sys_execve+0x49/0x60
> > do_syscall_64+0x64/0x220
> > entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > The proposed solution is to take the cred_guard_mutex only
> > in a critical section at the beginning, and at the end of the
> > execve function, and let PTRACE_ATTACH fail with EAGAIN while
> > execve is not complete, but other functions like vm_access are
> > allowed to complete normally.
> 
> Sorry to be bummer, but I don't think this will work. A few more things
> during the exec process depend on cred_guard_mutex being held.
> 
> If I'm reading this patch correctly, this changes the lifetime of the
> cred_guard_mutex lock to be:
> 	- during prepare_bprm_creds()
> 	- from flush_old_exec() through install_exec_creds()
> Before, cred_guard_mutex was held from prepare_bprm_creds() through
> install_exec_creds().
> 
> That means, for example, that check_unsafe_exec()'s documented invariant
> is violated:
>     /*
>      * determine how safe it is to execute the proposed program
>      * - the caller must hold ->cred_guard_mutex to protect against
>      *   PTRACE_ATTACH or seccomp thread-sync
>      */
>     static void check_unsafe_exec(struct linux_binprm *bprm) ...
> which is looking at no_new_privs as well as other details, and making
> decisions about the bprm state from the current state.
> 
> I think it also means that the potentially multiple invocations
> of bprm_fill_uid() (via prepare_binprm() via binfmt_script.c and
> binfmt_misc.c) would be changing bprm->cred details (uid, gid) without
> a lock (another place where current's no_new_privs is evaluated).
> 
> Related, it also means that cred_guard_mutex is unheld for every
> invocation of search_binary_handler() (which can loop via the previously
> mentioned binfmt_script.c and binfmt_misc.c), if any of them have hidden
> dependencies on cred_guard_mutex. (Thought I only see bprm_fill_uid()
> currently.)

So one issue I see with having to reacquire the cred_guard_mutex might
be that this would allow tasks holding the cred_guard_mutex to block a
killed exec'ing task from exiting, right?
