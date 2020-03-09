Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263F717E982
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgCIT7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 15:59:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38251 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgCIT7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 15:59:53 -0400
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jBOYR-0002mB-Lc; Mon, 09 Mar 2020 19:59:11 +0000
Date:   Mon, 9 Mar 2020 20:59:09 +0100
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
Message-ID: <20200309195909.h2lv5uawce5wgryx@wittgenstein>
References: <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 08, 2020 at 04:36:55PM -0500, Eric W. Biederman wrote:
> 
> These functions have very little to do with de_thread move them out
> of de_thread an into flush_old_exec proper so it can be more clearly
> seen what flush_old_exec is doing.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/exec.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index ff74b9a74d34..215d86f77b63 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1189,11 +1189,6 @@ static int de_thread(struct task_struct *tsk)

While you're cleaning up de_thread() wouldn't it be good to also take
the opportunity and remove the task argument from de_thread(). It's only
ever used with current. Could be done in one of your patches or as a
separate patch.

diff --git a/fs/exec.c b/fs/exec.c
index db17be51b112..ee108707e4b0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1061,8 +1061,9 @@ static int exec_mmap(struct mm_struct *mm)
  * disturbing other processes.  (Other processes might share the signal
  * table via the CLONE_SIGHAND option to clone().)
  */
-static int de_thread(struct task_struct *tsk)
+static int de_thread(void)
 {
+       struct task_struct *tsk = current;
        struct signal_struct *sig = tsk->signal;
        struct sighand_struct *oldsighand = tsk->sighand;
        spinlock_t *lock = &oldsighand->siglock;
@@ -1266,7 +1267,7 @@ int flush_old_exec(struct linux_binprm * bprm)
         * Make sure we have a private signal table and that
         * we are unassociated from the previous thread group.
         */
-       retval = de_thread(current);
+       retval = de_thread();
        if (retval)
                goto out;
