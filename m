Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C951807BD
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 20:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCJTPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 15:15:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55079 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgCJTPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 15:15:41 -0400
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jBkLJ-0000Bk-RP; Tue, 10 Mar 2020 19:15:06 +0000
Date:   Tue, 10 Mar 2020 20:15:02 +0100
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
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH] pidfd: Stop taking cred_guard_mutex
Message-ID: <20200310191502.qcqxfkhh5k2gxyzp@wittgenstein>
References: <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
 <20200309195909.h2lv5uawce5wgryx@wittgenstein>
 <877dztz415.fsf@x220.int.ebiederm.org>
 <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
 <87k13txnig.fsf@x220.int.ebiederm.org>
 <20200310085540.pztaty2mj62xt2nm@wittgenstein>
 <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 01:52:05PM -0500, Eric W. Biederman wrote:
> 
> During exec some file descriptors are closed and the files struct is
> unshared.  But all of that can happen at other times and it has the
> same protections during exec as at ordinary times.  So stop taking the
> cred_guard_mutex as it is useless.
> 
> Furthermore he cred_guard_mutex is a bad idea because it is deadlock
> prone, as it is held in serveral while waiting possibly indefinitely
> for userspace to do something.
> 
> Cc: Sargun Dhillon <sargun@sargun.me>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/pid.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> Christian if you don't have any objections I will take this one through
> my tree.

Sure.
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

> 
> I tried to figure out why this code path takes the cred_guard_mutex and
> the archive on lore.kernel.org was not helpful in finding that part of
> the conversation.

Let me think a little harder and hopefully get back to you with a
sensible explanation.
