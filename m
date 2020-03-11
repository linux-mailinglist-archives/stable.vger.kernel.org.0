Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546F2181975
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgCKNSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:18:47 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45093 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729563AbgCKNSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 09:18:47 -0400
Received: by mail-qt1-f196.google.com with SMTP id a4so1459832qto.12
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 06:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zDG99WdLxXHRHqpAlE4Kr1ARB/kw0xCVrFSECDHGZtI=;
        b=q2g5HVw45ub4qGRZ2TmDqz7+EKzIMByrNXJhF81OYjk/jYlezSEqyhXBqp++FkcEt0
         858p4kZ6NhfElMa1zAMCQhA6c8eamD5vSCMRn66bUt/44G1VB2VTwF2CtnOjDfN44vT4
         xFrpaapDi0X/QCAMv0RohFR7QhtqWIWsT/R+8svf7qWwliC9FfXnBxsLRwRvYatoOe3y
         YRihct1KoRRzLNUEAeEz7diIsm691okbgkntQagMJOb34wvIvT2gRYzxjyU+rcCbGSkB
         NqxeNpU/9TuYa9LNT/nixb+StSpI9kJ/ZQxlkWagradtzMWPPvzcX7eCGD8dUM19aKok
         f/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zDG99WdLxXHRHqpAlE4Kr1ARB/kw0xCVrFSECDHGZtI=;
        b=Jhx+y81rpf08UEBlCU9OteCOglEzbLhy/d/x34uDTAeqWbZfp9dgr4/c8ZvBHGsgOP
         uwIITIfUFtQb5bskBjhONFH4Ye/Fs/BhgmQ3WHVHP1EeFAf9HD4WpL3yybZs2XDYkO5J
         yqaqfhiqnF1zbT7hF9F6ZGgBTvrmyFr8LZyvzUIQHU329LqKUwAXC7nWeMowc6YsKXLb
         mALQzn4g+C7UMdA5sAMaJnnQmVhDv+rCWNKeMHB06yLlQskdSV1Nu3xTektP+6zf0y9z
         JitOd5d+PAm8jYpvn/+gM8ZhQwOz28kq2zb71byp5WN8VFWc5IFIRIczMi6/B+4HorJ3
         x1Hw==
X-Gm-Message-State: ANhLgQ38SQGogOnrGOWMjnhD2Scx4tarNxhcTNguKePk7k4XDiJpZOPO
        Cyc9PDJDf8VPJU0yy8KqIDU59g==
X-Google-Smtp-Source: ADFU+vvyf/otIhRI5V52VFI74VzOt7p3eyskKWVi8qCEB+MqKvGW/EWFmgBlovQQ04OmuFPDLYwJWg==
X-Received: by 2002:ac8:1add:: with SMTP id h29mr2659982qtk.258.1583932723562;
        Wed, 11 Mar 2020 06:18:43 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id k4sm24944752qtj.74.2020.03.11.06.18.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2020 06:18:42 -0700 (PDT)
Message-ID: <1583932719.7365.171.camel@lca.pw>
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
From:   Qian Cai <cai@lca.pw>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
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
Date:   Wed, 11 Mar 2020 09:18:39 -0400
In-Reply-To: <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
         <87k142lpfz.fsf@x220.int.ebiederm.org>
         <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
         <875zfmloir.fsf@x220.int.ebiederm.org>
         <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
         <87v9nmjulm.fsf@x220.int.ebiederm.org>
         <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
         <202003021531.C77EF10@keescook>
         <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
         <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
         <87v9nlii0b.fsf@x220.int.ebiederm.org>
         <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
         <87a74xi4kz.fsf@x220.int.ebiederm.org>
         <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
         <87r1y8dqqz.fsf@x220.int.ebiederm.org>
         <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
         <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
         <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
         <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
         <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2020-03-08 at 16:38 -0500, Eric W. Biederman wrote:
> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
> over the userspace accesses as the arguments from userspace are read.
> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
> threads are killed.  The cred_guard_mutex is held over
> "put_user(0, tsk->clear_child_tid)" in exit_mm().
> 
> Any of those can result in deadlock, as the cred_guard_mutex is held
> over a possible indefinite userspace waits for userspace.
> 
> Add exec_update_mutex that is only held over exec updating process
> with the new contents of exec, so that code that needs not to be
> confused by exec changing the mm and the cred in ways that can not
> happen during ordinary execution of a process.
> 
> The plan is to switch the users of cred_guard_mutex to
> exec_udpate_mutex one by one.  This lets us move forward while still
> being careful and not introducing any regressions.
> 
> Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
> Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
> Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
> Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
> Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
> Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
> Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

This patch will trigger a warning during boot,

[   19.707214][    T1] pci 0035:01:00.0: enabling device (0545 -> 0547)
[   19.707287][    T1] EEH: Capable adapter found: recovery enabled.
[   19.732541][    T1] cpuidle-powernv: Default stop: psscr =
0x0000000000000330,mask=0x00000000003003ff
[   19.732567][    T1] cpuidle-powernv: Deepest stop: psscr =
0x0000000000300375,mask=0x00000000003003ff
[   19.732598][    T1] cpuidle-powernv: First stop level that may lose SPRs =
0x4
[   19.732617][    T1] cpuidle-powernv: First stop level that may lose timebase
= 0x10
[   19.769784][    T1] HugeTLB registered 2.00 MiB page size, pre-allocated 0
pages
[   19.769810][    T1] HugeTLB registered 1.00 GiB page size, pre-allocated 0
pages
[   19.789344][  T718] 
[   19.789367][  T718] =====================================
[   19.789379][  T718] WARNING: bad unlock balance detected!
[   19.789393][  T718] 5.6.0-rc5-next-20200311+ #4 Not tainted
[   19.789414][  T718] -------------------------------------
[   19.789426][  T718] kworker/u257:0/718 is trying to release lock (&sig-
>exec_update_mutex) at:
[   19.789459][  T718] [<c0000000004c6770>] free_bprm+0xe0/0xf0
[   19.789481][  T718] but there are no more locks to release!
[   19.789502][  T718] 
[   19.789502][  T718] other info that might help us debug this:
[   19.789537][  T718] 1 lock held by kworker/u257:0/718:
[   19.789558][  T718]  #0: c000001fa8842808 (&sig->cred_guard_mutex){+.+.}, at:
__do_execve_file.isra.33+0x1b0/0xda0
[   19.789611][  T718] 
[   19.789611][  T718] stack backtrace:
[   19.789645][  T718] CPU: 8 PID: 718 Comm: kworker/u257:0 Not tainted 5.6.0-
rc5-next-20200311+ #4
[   19.789681][  T718] Call Trace:
[   19.789703][  T718] [c000000dad8cfa70] [c000000000979b40]
dump_stack+0xf4/0x164 (unreliable)
[   19.789742][  T718] [c000000dad8cfac0] [c0000000001c1d78]
print_unlock_imbalance_bug+0x118/0x140
[   19.789780][  T718] [c000000dad8cfb40] [c0000000001ceaa0]
lock_release+0x270/0x520
[   19.789817][  T718] [c000000dad8cfbf0] [c0000000009a2898]
__mutex_unlock_slowpath+0x68/0x400
[   19.789854][  T718] [c000000dad8cfcc0] [c0000000004c6770] free_bprm+0xe0/0xf0
[   19.789900][  T718] [c000000dad8cfcf0] [c0000000004c845c]
__do_execve_file.isra.33+0x44c/0xda0
__do_execve_file at fs/exec.c:1904
[   19.789938][  T718] [c000000dad8cfde0] [c0000000001391d8]
call_usermodehelper_exec_async+0x218/0x250
[   19.789977][  T718] [c000000dad8cfe20] [c00000000000b748]
ret_from_kernel_thread+0x5c/0x74

> ---
>  fs/exec.c                    | 9 +++++++++
>  include/linux/sched/signal.h | 9 ++++++++-
>  init/init_task.c             | 1 +
>  kernel/fork.c                | 1 +
>  4 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index d820a7272a76..ffeebb1f167b 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1014,6 +1014,7 @@ static int exec_mmap(struct mm_struct *mm)
>  {
>  	struct task_struct *tsk;
>  	struct mm_struct *old_mm, *active_mm;
> +	int ret;
>  
>  	/* Notify parent that we're no longer interested in the old VM */
>  	tsk = current;
> @@ -1034,6 +1035,11 @@ static int exec_mmap(struct mm_struct *mm)
>  			return -EINTR;
>  		}
>  	}
> +
> +	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
> +	if (ret)
> +		return ret;
> +
>  	task_lock(tsk);
>  	active_mm = tsk->active_mm;
>  	membarrier_exec_mmap(mm);
> @@ -1438,6 +1444,8 @@ static void free_bprm(struct linux_binprm *bprm)
>  {
>  	free_arg_pages(bprm);
>  	if (bprm->cred) {
> +		if (!bprm->mm)
> +			mutex_unlock(&current->signal->exec_update_mutex);
>  		mutex_unlock(&current->signal->cred_guard_mutex);
>  		abort_creds(bprm->cred);
>  	}
> @@ -1487,6 +1495,7 @@ void install_exec_creds(struct linux_binprm *bprm)
>  	 * credentials; any time after this it may be unlocked.
>  	 */
>  	security_bprm_committed_creds(bprm);
> +	mutex_unlock(&current->signal->exec_update_mutex);
>  	mutex_unlock(&current->signal->cred_guard_mutex);
>  }
>  EXPORT_SYMBOL(install_exec_creds);
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index 88050259c466..a29df79540ce 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -224,7 +224,14 @@ struct signal_struct {
>  
>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>  					 * credential calculations
> -					 * (notably. ptrace) */
> +					 * (notably. ptrace)
> +					 * Deprecated do not use in new code.
> +					 * Use exec_update_mutex instead.
> +					 */
> +	struct mutex exec_update_mutex;	/* Held while task_struct is being
> +					 * updated during exec, and may have
> +					 * inconsistent permissions.
> +					 */
>  } __randomize_layout;
>  
>  /*
> diff --git a/init/init_task.c b/init/init_task.c
> index 9e5cbe5eab7b..bd403ed3e418 100644
> --- a/init/init_task.c
> +++ b/init/init_task.c
> @@ -26,6 +26,7 @@ static struct signal_struct init_signals = {
>  	.multiprocess	= HLIST_HEAD_INIT,
>  	.rlim		= INIT_RLIMITS,
>  	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
> +	.exec_update_mutex = __MUTEX_INITIALIZER(init_signals.exec_update_mutex),
>  #ifdef CONFIG_POSIX_TIMERS
>  	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
>  	.cputimer	= {
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 60a1295f4384..12896a6ecee6 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
>  
>  	mutex_init(&sig->cred_guard_mutex);
> +	mutex_init(&sig->exec_update_mutex);
>  
>  	return 0;
>  }
