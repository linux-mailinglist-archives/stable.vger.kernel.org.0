Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFFE3A4B1C
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 01:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFKXSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 19:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229976AbhFKXSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 19:18:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 898A76124C;
        Fri, 11 Jun 2021 23:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623453416;
        bh=lMxz0DjlyuQqZF5qJPG3f9aj+1mihATa36IM+sjVrMI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=x2P3F19NBmj0X25SPv0T7/C1OWmNI0B4X1G1Smzk/tpOHcskH3da9D5FjsBNJeDGI
         EgyobsuGaTlfVOxZ29asRHSQ6kwFdc50XducX/Fy+IUTf/cGIG3lRWvOY0X6/DIo8C
         0fMoyUWvrfwTqbCFl8OmwEAXDYhnje56ZAB3HoZY=
Date:   Fri, 11 Jun 2021 16:16:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Michal Hocko <mhocko@suse.com>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jamorris@linux.microsoft.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Charles Haithcock <chaithco@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Helge Deller <deller@gmx.de>,
        YiFei Zhu <yifeifz2@illinois.edu>,
        Adrian Reber <areber@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v9] exec: Fix dead-lock in de_thread with ptrace_attach
Message-Id: <20210611161655.0a3076495e59add166bac58a@linux-foundation.org>
In-Reply-To: <AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
References: <AM8PR10MB4708AFBD838138A84CE89EF8E4359@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
        <20210610143642.e4535dbdc0db0b1bd3ee5367@linux-foundation.org>
        <AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Jun 2021 17:55:09 +0200 Bernd Edlinger <bernd.edlinger@hotmail.de> wrote:

> This introduces signal->unsafe_execve_in_progress,
> which is used to fix the case when at least one of the
> sibling threads is traced, and therefore the trace
> process may dead-lock in ptrace_attach, but de_thread
> will need to wait for the tracer to continue execution.
> 
> The solution is to detect this situation and allow
> ptrace_attach to continue, while de_thread() is still
> waiting for traced zombies to be eventually released.
> When the current thread changed the ptrace status from
> non-traced to traced, we can simply abort the whole
> execve and restart it by returning -ERESTARTSYS.
> This needs to be done before changing the thread leader,
> because the PTRACE_EVENT_EXEC needs to know the old
> thread pid.
> 
> Although it is technically after the point of no return,
> we just have to reset bprm->point_of_no_return here,
> since at this time only the other threads have received
> a fatal signal, not the current thread.
> 
> >From the user's point of view the whole execve was
> simply delayed until after the ptrace_attach.
> 
> Other threads die quickly since the cred_guard_mutex
> is released, but a deadly signal is already pending.
> In case the mutex_lock_killable misses the signal,
> ->unsafe_execve_in_progress makes sure they release
> the mutex immediately and return with -ERESTARTNOINTR.
> 
> This means there is no API change, unlike the previous
> version of this patch which was discussed here:
> 
> https://lore.kernel.org/lkml/b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de/
> 
> See tools/testing/selftests/ptrace/vmaccess.c
> for a test case that gets fixed by this change.
> 
> Note that since the test case was originally designed to
> test the ptrace_attach returning an error in this situation,
> the test expectation needed to be adjusted, to allow the
> API to succeed at the first attempt.
> 

err, sorry.  I replied to the v8 patch, not to v9.

--- a/fs/exec.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9
+++ a/fs/exec.c
@@ -1056,29 +1056,31 @@ static int de_thread(struct task_struct
 		return -EAGAIN;
 	}
 
-	while_each_thread(tsk, t) {
-		if (unlikely(t->ptrace) && t != tsk->group_leader)
-			sig->unsafe_execve_in_progress = true;
-	}
-
 	sig->group_exit_task = tsk;
 	sig->notify_count = zap_other_threads(tsk);
 	if (!thread_group_leader(tsk))
 		sig->notify_count--;
-	spin_unlock_irq(lock);
 
-	if (unlikely(sig->unsafe_execve_in_progress))
+	while_each_thread(tsk, t) {
+		if (unlikely(t->ptrace) && t != tsk->group_leader)
+			sig->unsafe_execve_in_progress = true;
+	}
+
+	if (unlikely(sig->unsafe_execve_in_progress)) {
+		spin_unlock_irq(lock);
 		mutex_unlock(&sig->cred_guard_mutex);
+		spin_lock_irq(lock);
+	}
 
-	for (;;) {
-		set_current_state(TASK_KILLABLE);
-		if (!sig->notify_count)
-			break;
+	while (sig->notify_count) {
+		__set_current_state(TASK_KILLABLE);
+		spin_unlock_irq(lock);
 		schedule();
 		if (__fatal_signal_pending(tsk))
 			goto killed;
+		spin_lock_irq(lock);
 	}
-	__set_current_state(TASK_RUNNING);
+	spin_unlock_irq(lock);
 
 	if (unlikely(sig->unsafe_execve_in_progress)) {
 		if (mutex_lock_killable(&sig->cred_guard_mutex))
_

