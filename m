Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3B61778B2
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 15:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgCCOVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 09:21:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44158 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgCCOVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 09:21:24 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j98Pg-0002Id-SV; Tue, 03 Mar 2020 14:20:49 +0000
Date:   Tue, 3 Mar 2020 15:20:47 +0100
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
Message-ID: <20200303142047.mrenhvhihe5sm5wv@wittgenstein>
References: <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
 <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
 <AM6PR03MB5170E03613104B2ACE32F057E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51706AE0FE7DA0F3F507F6BAE4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AM6PR03MB51706AE0FE7DA0F3F507F6BAE4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 11:23:31AM +0000, Bernd Edlinger wrote:
> On 3/3/20 11:34 AM, Bernd Edlinger wrote:
> > On 3/3/20 9:58 AM, Christian Brauner wrote:
> >> So one issue I see with having to reacquire the cred_guard_mutex might
> >> be that this would allow tasks holding the cred_guard_mutex to block a
> >> killed exec'ing task from exiting, right?
> >>
> > 
> > Yes maybe, but I think it will not be worse than it is now.
> > Since the second time the mutex is acquired it is done with
> > mutex_lock_killable, so at least kill -9 should get it terminated.
> > 
> 
> 
> 
> >  static void free_bprm(struct linux_binprm *bprm)
> >  {
> >  	free_arg_pages(bprm);
> >  	if (bprm->cred) {
> > +		if (!bprm->called_flush_old_exec)
> > +			mutex_lock(&current->signal->cred_guard_mutex);
> > +		current->signal->cred_locked_for_ptrace = false;
> >  		mutex_unlock(&current->signal->cred_guard_mutex);
> 
> 
> Hmm, cough...
> actually when the mutex_lock_killable fails, due to kill -9, in flush_old_exec
> free_bprm locks the same mutex, this time unkillable, but I should better do
> mutex_lock_killable here, and if that fails, I can leave cred_locked_for_ptrace,
> it shouldn't matter, since this is a fatal signal anyway, right?

I think so, yes.
