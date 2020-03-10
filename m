Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2347617F26B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 09:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCJI4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 04:56:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57016 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgCJI4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 04:56:15 -0400
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jBaft-0001ga-GQ; Tue, 10 Mar 2020 08:55:41 +0000
Date:   Tue, 10 Mar 2020 09:55:40 +0100
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
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] exec: Move cleanup of posix timers on exec out of
 de_thread
Message-ID: <20200310085540.pztaty2mj62xt2nm@wittgenstein>
References: <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
 <20200309195909.h2lv5uawce5wgryx@wittgenstein>
 <877dztz415.fsf@x220.int.ebiederm.org>
 <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
 <87k13txnig.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87k13txnig.fsf@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 03:48:55PM -0500, Eric W. Biederman wrote:
> Christian Brauner <christian.brauner@ubuntu.com> writes:
> 
> > On Mon, Mar 09, 2020 at 03:06:46PM -0500, Eric W. Biederman wrote:
> >> Christian Brauner <christian.brauner@ubuntu.com> writes:
> >> 
> >> > On Sun, Mar 08, 2020 at 04:36:55PM -0500, Eric W. Biederman wrote:
> >> >> 
> >> >> These functions have very little to do with de_thread move them out
> >> >> of de_thread an into flush_old_exec proper so it can be more clearly
> >> >> seen what flush_old_exec is doing.
> >> >> 
> >> >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> >> ---
> >> >>  fs/exec.c | 10 +++++-----
> >> >>  1 file changed, 5 insertions(+), 5 deletions(-)
> >> >> 
> >> >> diff --git a/fs/exec.c b/fs/exec.c
> >> >> index ff74b9a74d34..215d86f77b63 100644
> >> >> --- a/fs/exec.c
> >> >> +++ b/fs/exec.c
> >> >> @@ -1189,11 +1189,6 @@ static int de_thread(struct task_struct *tsk)
> >> >
> >> > While you're cleaning up de_thread() wouldn't it be good to also take
> >> > the opportunity and remove the task argument from de_thread(). It's only
> >> > ever used with current. Could be done in one of your patches or as a
> >> > separate patch.
> >> 
> >> How does that affect the code generation?
> >
> > The same way renaming "tsk" to "me" does.
> >
> >> 
> >> My sense is that computing current once in flush_old_exec is much
> >> better than computing it in each function flush_old_exec calls.
> >> I remember that computing current used to be not expensive but
> >> noticable.
> >> 
> >> For clarity I can see renaming tsk to me.  So that it is clear we are
> >> talking about the current process, and not some arbitrary process.
> >
> > For clarity since de_thread() uses "tsk" giving the impression that any
> > task can be dethreaded while it's only ever used with current. It's just
> > a suggestion since you're doing the rename tsk->me anyway it would fit
> > with the series. You do whatever you want though.
> > (I just remember that the same request was made once to changes I did:
> > Don't pass current as arg when it's the only task passed.)
> 
> That's fair.
> 
> And I completely agree that we should at least rename tsk to me.
> Just for clarity.
> 
> My apologies if I am a little short.  My little son has been an extra
> handful lately.

No worries, stress is a thing most of us know too well.

Christian
