Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98400177D43
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 18:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgCCRV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:21:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50095 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729786AbgCCRV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 12:21:28 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j9BDx-0006cR-KJ; Tue, 03 Mar 2020 17:20:53 +0000
Date:   Tue, 3 Mar 2020 18:20:52 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
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
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCHv5] exec: Fix a deadlock in ptrace
Message-ID: <20200303172052.fvqk4r7vbtxwo3ig@wittgenstein>
References: <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
 <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
 <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <20200303170109.y6q2acgydyzuh3mp@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200303170109.y6q2acgydyzuh3mp@wittgenstein>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 06:01:11PM +0100, Christian Brauner wrote:
> On Tue, Mar 03, 2020 at 04:48:01PM +0000, Bernd Edlinger wrote:
> > On 3/3/20 4:18 PM, Eric W. Biederman wrote:
> > > Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> > > 
> > >> This fixes a deadlock in the tracer when tracing a multi-threaded
> > >> application that calls execve while more than one thread are running.
> > >>
> > >> I observed that when running strace on the gcc test suite, it always
> > >> blocks after a while, when expect calls execve, because other threads
> > >> have to be terminated.  They send ptrace events, but the strace is no
> > >> longer able to respond, since it is blocked in vm_access.
> > >>
> > >> The deadlock is always happening when strace needs to access the
> > >> tracees process mmap, while another thread in the tracee starts to
> > >> execve a child process, but that cannot continue until the
> > >> PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:
> > > 
> > > A couple of things.
> > > 
> > > Why do we think it is safe to change the behavior exposed to userspace?
> > > Not the deadlock but all of the times the current code would not
> > > deadlock?
> > > 
> > > Especially given that this is a small window it might be hard for people
> > > to track down and report so we need a strong argument that this won't
> > > break existing userspace before we just change things.
> > > 
> > 
> > Hmm, I tend to agree.
> > 
> > > Usually surveying all of the users of a system call that we can find
> > > and checking to see if they might be affected by the change in behavior
> > > is difficult enough that we usually opt for not being lazy and
> > > preserving the behavior.
> > > 
> > > This patch is up to two changes in behavior now, that could potentially
> > > affect a whole array of programs.  Adding linux-api so that this change
> > > in behavior can be documented if/when this change goes through.
> > > 
> > 
> > One is PTRACE_ACCESS possibly returning EAGAIN, yes.
> > 
> > We could try to restrict that behavior change to when any
> > thread is ptraced when execve starts, can't be too complicated.
> > 
> > 
> > But the other is only SYS_seccomp returning EAGAIN, when a different
> > thread of the current process is calling execve at the same time.
> > 
> > I would consider it completely impossible to have any user-visual effect,
> > since de_thread is just terminating all threads, including the thread
> > where the -EAGAIN was returned, so we will never know what happened.
> 
> I think if we risk a user-space facing change we should try the simple
> thing first before making the fix more convoluted? But it's a tough
> call...

Actually, to get a _rough_ estimate of the possible impact I would
recommend you run the criu test suite (and possible the strace
test-suite) on a kernel with and without your fix. That's what I tend to
do when I touch code I fear will have impact on APIs that very deeply
touch core kernel. Criu's test-suite makes heavy use of ptrace and
usually runs into a bunch of interesting (exec) races too, and does have
tests for handling zombies processes etc. pp.

Should be relatively simple: create a vm and then criu build-dependencies,
git clone criu; cd criu; make; cd test; ./zdtm.py run -a --keep-going
If your system doesn't support Selinux properly, you need to disable it
when running the tests and you also need to make sure that you're using
python3 or change the shebang in zdtm.py to python3.

Just a recommendation.

Christian
