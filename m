Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493D8180A74
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgCJVad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:30:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58351 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgCJVad (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:30:33 -0400
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jBmRs-0000sm-Qb; Tue, 10 Mar 2020 21:30:00 +0000
Date:   Tue, 10 Mar 2020 22:29:57 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Jann Horn <jannh@google.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
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
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH] pidfd: Stop taking cred_guard_mutex
Message-ID: <20200310212957.aatd4yzjwsyudi2g@wittgenstein>
References: <877dztz415.fsf@x220.int.ebiederm.org>
 <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
 <87k13txnig.fsf@x220.int.ebiederm.org>
 <20200310085540.pztaty2mj62xt2nm@wittgenstein>
 <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
 <CAG48ez2cUZMVOAXfHPNjKjYsMSaWkjUjOCHo0KYZ+oXQUW4viA@mail.gmail.com>
 <87k13sui1p.fsf@x220.int.ebiederm.org>
 <CAG48ez2vRgaEVJ=Rs8gn6HkGO6syL8MpSOUq7BNN+OUE1uYxCA@mail.gmail.com>
 <CAG48ez1LjW1xAGe-5tNtstCWxG2bkiHaQUMOcJNjx=z-2Wc2Jw@mail.gmail.com>
 <87lfo8rkqo.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87lfo8rkqo.fsf@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 03:57:35PM -0500, Eric W. Biederman wrote:
> Jann Horn <jannh@google.com> writes:
> 
> > On Tue, Mar 10, 2020 at 9:00 PM Jann Horn <jannh@google.com> wrote:
> >> On Tue, Mar 10, 2020 at 8:29 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> > Jann Horn <jannh@google.com> writes:
> >> > > On Tue, Mar 10, 2020 at 7:54 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> > >> During exec some file descriptors are closed and the files struct is
> >> > >> unshared.  But all of that can happen at other times and it has the
> >> > >> same protections during exec as at ordinary times.  So stop taking the
> >> > >> cred_guard_mutex as it is useless.
> >> > >>
> >> > >> Furthermore he cred_guard_mutex is a bad idea because it is deadlock
> >> > >> prone, as it is held in serveral while waiting possibly indefinitely
> >> > >> for userspace to do something.
> > [...]
> >> > > If you make this change, then if this races with execution of a setuid
> >> > > program that afterwards e.g. opens a unix domain socket, an attacker
> >> > > will be able to steal that socket and inject messages into
> >> > > communication with things like DBus. procfs currently has the same
> >> > > race, and that still needs to be fixed, but at least procfs doesn't
> >> > > let you open things like sockets because they don't have a working
> >> > > ->open handler, and it enforces the normal permission check for
> >> > > opening files.
> >> >
> >> > It isn't only exec that can change credentials.  Do we need a lock for
> >> > changing credentials?
> > [...]
> >> > If we need a lock around credential change let's design and build that.
> >> > Having a mismatch between what a lock is designed to do, and what
> >> > people use it for can only result in other bugs as people get confused.
> >>
> >> Hmm... what benefits do we get from making it a separate lock? I guess
> >> it would allow us to make it a per-task lock instead of a
> >> signal_struct-wide one? That might be helpful...
> >
> > But actually, isn't the core purpose of the cred_guard_mutex to guard
> > against concurrent credential changes anyway? That's what almost
> > everyone uses it for, and it's in the name...
> 
> Having been through all of the users nope.
> 
> Maybe someone tried to repurpose for that.  I haven't traced through
> when it went the it was renamed from cred_exec_mutex to
> cred_guard_mutex.
> 
> The original purpose was to make make exec and ptrace deadlock.  But it
> was seen as being there to allow safely calculating the new credentials
> before the point of now return.  Because if a process is ptraced or not
> affects the new credential calculations.  Unfortunately offering that
> guarantee fundamentally leads to deadlock.
> 
> So ptrace_attach and seccomp use the cred_guard_mutex to guarantee
> a deadlock.
> 
> The common use is to take cred_guard_mutex to guard the window when
> credentials and process details are out of sync in exec.  But there
> is at least do_io_accounting that seems to have the same justification
> for holding __pidfd_fget.
> 
> With effort I suspect we can replace exec_change_mutex with task_lock.
> When we are guaranteed to be single threaded placing exec_change_mutex
> in signal_struct doesn't really help us (except maybe in some races?).
> 
> The deep problem is no one really understands cred_guard_mutex so it is
> a mess.  Code with poorly defined semantics is always wrong somewhere

This is a good point. When discussing patches sensitive to credential
changes cred_guard_mutex was always introduced as having the purpose to
guard against concurrent credential changes. And I'm pretty sure that
that's how most people have been using it for quite a long time. I mean,
it's at least the case for seccomp and proc and probably quite a few
more. So the problem seems to me that it has clear _intended_ semantics
that runs into issues in all sorts of cases. So if cred_guard_mutex is
not that then we seem to need to provide something that serves it's
intended purpose.
