Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EAE179367
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 16:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgCDPap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 10:30:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60406 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgCDPao (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 10:30:44 -0500
Received: from b2b-5-147-251-51.unitymedia.biz ([5.147.251.51] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j9VyE-0002FV-Te; Wed, 04 Mar 2020 15:30:03 +0000
Date:   Wed, 4 Mar 2020 16:30:02 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Kees Cook <keescook@chromium.org>,
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
Message-ID: <20200304153002.ck77l6nifnvn647p@wittgenstein>
References: <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
 <AM6PR03MB5170B5C1B95CB1D065EE3AFAE4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003022103.196C313623@keescook>
 <AM6PR03MB5170A15099986CEC3189F251E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AM6PR03MB5170A15099986CEC3189F251E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 08:08:26AM +0000, Bernd Edlinger wrote:
> On 3/3/20 6:29 AM, Kees Cook wrote:
> > On Tue, Mar 03, 2020 at 04:54:34AM +0000, Bernd Edlinger wrote:
> >> On 3/3/20 3:26 AM, Kees Cook wrote:
> >>> On Mon, Mar 02, 2020 at 10:18:07PM +0000, Bernd Edlinger wrote:
> >>>> [...]
> >>>
> >>> If I'm reading this patch correctly, this changes the lifetime of the
> >>> cred_guard_mutex lock to be:
> >>> 	- during prepare_bprm_creds()
> >>> 	- from flush_old_exec() through install_exec_creds()
> >>> Before, cred_guard_mutex was held from prepare_bprm_creds() through
> >>> install_exec_creds().
> > 
> > BTW, I think the effect of this change (i.e. my paragraph above) should
> > be distinctly called out in the commit log if this solution moves
> > forward.
> > 
> 
> Okay, will do.
> 
> >>> That means, for example, that check_unsafe_exec()'s documented invariant
> >>> is violated:
> >>>     /*
> >>>      * determine how safe it is to execute the proposed program
> >>>      * - the caller must hold ->cred_guard_mutex to protect against
> >>>      *   PTRACE_ATTACH or seccomp thread-sync
> >>>      */
> >>
> >> Oh, right, I haven't understood that hint...
> > 
> > I know no_new_privs is checked there, but I haven't studied the
> > PTRACE_ATTACH part of that comment. If that is handled with the new
> > check, this comment should be updated.
> > 
> 
> Okay, I change that comment to:
> 
> /*
>  * determine how safe it is to execute the proposed program
>  * - the caller must have set ->cred_locked_in_execve to protect against
>  *   PTRACE_ATTACH or seccomp thread-sync
>  */
> 
> >>> I think it also means that the potentially multiple invocations
> >>> of bprm_fill_uid() (via prepare_binprm() via binfmt_script.c and
> >>> binfmt_misc.c) would be changing bprm->cred details (uid, gid) without
> >>> a lock (another place where current's no_new_privs is evaluated).
> >>
> >> So no_new_privs can change from 0->1, but should not
> >> when execve is running.
> >>
> >> As long as the calling thread is in execve it won't do this,
> >> and the only other place, where it may set for other threads
> >> is in seccomp_sync_threads, but that can easily be avoided see below.
> > 
> > Yeah, everything was fine until I had to go complicate things with
> > TSYNC. ;) The real goal is making sure an exec cannot gain privs while
> > later gaining a seccomp filter from an unpriv process. The no_new_privs
> > flag was used to control this, but it required that the filter not get
> > applied during exec.
> > 
> >>> Related, it also means that cred_guard_mutex is unheld for every
> >>> invocation of search_binary_handler() (which can loop via the previously
> >>> mentioned binfmt_script.c and binfmt_misc.c), if any of them have hidden
> >>> dependencies on cred_guard_mutex. (Thought I only see bprm_fill_uid()
> >>> currently.)
> >>>
> >>> For seccomp, the expectations about existing thread states risks races
> >>> too. There are two locks held for TSYNC:
> >>> - current->sighand->siglock is held to keep new threads from
> >>>   appearing/disappearing, which would destroy filter refcounting and
> >>>   lead to memory corruption.
> >>
> >> I don't understand what you mean here.
> >> How can this lead to memory corruption?
> > 
> > Mainly this is a matter of how seccomp manages its filter hierarchy
> > (since the filters are shared through process ancestry), so if a thread
> > appears in the middle of TSYNC it may be racing another TSYNC and break
> > ancestry, leading to bad reference counting on process death, etc.
> > (Though, yes, with refcount_t now, things should never corrupt, just
> > waste memory.)
> > 
> 
> I assume for now, that the current->sighand->siglock held while iterating all
> threads is sufficient here.
> 
> >>> - cred_guard_mutex is held to keep no_new_privs in sync with filters to
> >>>   avoid no_new_privs and filter confusion during exec, which could
> >>>   lead to exploitable setuid conditions (see below).
> >>>
> >>> Just racing a malicious thread during TSYNC is not a very strong
> >>> example (a malicious thread could do lots of fun things to "current"
> >>> before it ever got near calling TSYNC), but I think there is the risk
> >>> of mismatched/confused states that we don't want to allow. One is a
> >>> particularly bad state that could lead to privilege escalations (in the
> >>> form of the old "sendmail doesn't check setuid" flaw; if a setuid process
> >>> has a filter attached that silently fails a priv-dropping setuid call
> >>> and continues execution with elevated privs, it can be tricked into
> >>> doing bad things on behalf of the unprivileged parent, which was the
> >>> primary goal of the original use of cred_guard_mutex with TSYNC[1]):
> >>>
> >>> thread A clones thread B
> >>> thread B starts setuid exec
> >>> thread A sets no_new_privs
> >>> thread A calls seccomp with TSYNC
> >>> thread A in seccomp_sync_threads() sets seccomp filter on self and thread B
> >>> thread B passes check_unsafe_exec() with no_new_privs unset
> >>> thread B reaches bprm_fill_uid() with no_new_privs unset and gains privs
> >>> thread A still in seccomp_sync_threads() sets no_new_privs on thread B
> >>> thread B finishes exec, now running with elevated privs, a filter chosen
> >>>          by thread A, _and_ nnp set (which doesn't matter)
> >>>
> >>> With the original locking, thread B will fail check_unsafe_exec()
> >>> because filter and nnp state are changed together, with "atomicity"
> >>> protected by the cred_guard_mutex.
> >>>
> >>
> >> Ah, good point, thanks!
> >>
> >> This can be fixed by checking current->signal->cred_locked_for_ptrace
> >> while the cred_guard_mutex is locked, like this for instance:
> >>
> >> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> >> index b6ea3dc..377abf0 100644
> >> --- a/kernel/seccomp.c
> >> +++ b/kernel/seccomp.c
> >> @@ -342,6 +342,9 @@ static inline pid_t seccomp_can_sync_threads(void)
> >>         BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
> >>         assert_spin_locked(&current->sighand->siglock);
> >>  
> >> +       if (current->signal->cred_locked_for_ptrace)
> >> +               return -EAGAIN;
> >> +
> > 
> > Hmm. I guess something like that could work. TSYNC expects to be able to
> > report _which_ thread wrecked the call, though... I wonder if in_execve
> > could be used to figure out the offending thread. Hm, nope, that would
> > be outside of lock too (and all users are "current" right now, so the
> > lock wasn't needed before).
> > 
> 
> I could move that in_execve = 1 to prepare_bprm_creds, if it really matters,
> but the caller will die quickly and cannot do anything with that information
> when another thread executes execve, right?
> 
> >>         /* Validate all threads being eligible for synchronization. */
> >>         caller = current;
> >>         for_each_thread(caller, thread) {
> >>
> >>
> >>> And this is just the bad state I _can_ see. I'm worried there are more...
> >>>
> >>> All this said, I do see a small similarity here to the work I did to
> >>> stabilize stack rlimits (there was an ongoing problem with making multiple
> >>> decisions for the bprm based on current's state -- but current's state
> >>> was mutable during exec). For this, I saved rlim_stack to bprm and ignored
> >>> current's copy until exec ended and then stored bprm's copy into current.
> >>> If the only problem anyone can see here is the handling of no_new_privs,
> >>> we might be able to solve that similarly, at least disentangling tsync/nnp
> >>> from cred_guard_mutex.
> >>>
> >>
> >> I still think that is solvable with using cred_locked_for_ptrace and
> >> simply make the tsync fail if it would otherwise be blocked.
> > 
> > I wonder if we can find a better name than "cred_locked_for_ptrace"?
> > Maybe "cred_unfinished" or "cred_locked_in_exec" or something?
> > 
> 
> Yeah, I'd go with "cred_locked_in_execve".
> 
> > And the comment on bool cred_locked_for_ptrace should mention that
> > access is only allowed under cred_guard_mutex lock.
> > 
> 
> okay.
> 
> >>>> +	sig->cred_locked_for_ptrace = false;
> > 
> > This is redundant to the zalloc -- I think you can drop it (unless
> > someone wants to keep it for clarify?)
> > 
> 
> I'll remove that here and in init/init_task.c
> 
> > Also, I think cred_locked_for_ptrace needs checking deeper, in
> > __ptrace_may_access(), not in ptrace_attach(), since LOTS of things make
> > calls to ptrace_may_access() holding cred_guard_mutex, expecting that to
> > be sufficient to see a stable version of the thread...
> > 
> 
> No, these need to be addressed individually, but most users just want
> to know if the current credentials are sufficient at this moment, but will
> not change the credentials, as ptrace and TSYNC do. 
> 
> BTW: Not all users have cred_guard_mutex, see mm/migrate.c,
> mm/mempolicy.c, kernel/futex.c, fs/proc/namespaces.c etc.
> So adding an access to cred_locked_for_execve in ptrace_may_access is
> probably not an option.

That could be solved by e.g. adding ptrace_may_access_{no}exec() taking
cred_guard_mutex.
