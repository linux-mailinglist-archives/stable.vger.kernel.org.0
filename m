Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C23177C68
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 17:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgCCQvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 11:51:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49178 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730115AbgCCQvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 11:51:20 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j9Akd-0004ZP-Kd; Tue, 03 Mar 2020 16:50:35 +0000
Date:   Tue, 3 Mar 2020 17:50:34 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
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
        linux-api@vger.kernel.org
Subject: Re: [PATCHv5] exec: Fix a deadlock in ptrace
Message-ID: <20200303165034.5w76hbatbnr64pkd@wittgenstein>
References: <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
 <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
 <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nlii0b.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87v9nlii0b.fsf@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 09:18:44AM -0600, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
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
> 
> A couple of things.
> 
> Why do we think it is safe to change the behavior exposed to userspace?
> Not the deadlock but all of the times the current code would not
> deadlock?
> 
> Especially given that this is a small window it might be hard for people
> to track down and report so we need a strong argument that this won't
> break existing userspace before we just change things.
> 
> Usually surveying all of the users of a system call that we can find
> and checking to see if they might be affected by the change in behavior
> is difficult enough that we usually opt for not being lazy and
> preserving the behavior.
> 
> This patch is up to two changes in behavior now, that could potentially
> affect a whole array of programs.  Adding linux-api so that this change
> in behavior can be documented if/when this change goes through.
> 
> If you can split the documentation and test fixes out into separate
> patches that would help reviewing this code, or please make it explicit
> that the your are changing documentation about behavior that is changing
> with this patch.

Agreed. I think it'd be good to do it in three patches:
1. unrelated documentation update
2. fix + documentation changes specific to the fix
3. test(s)

Christian
