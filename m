Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87F83A82C9
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 16:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhFOO2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 10:28:38 -0400
Received: from mail-oln040092068109.outbound.protection.outlook.com ([40.92.68.109]:46215
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231400AbhFOO2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 10:28:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfmUHBTrFrqoLhvmES0lhhw7+1sNL5SBaGp7EhIUpjq0q8grjtPwlir1SIc1iy9F41ng4VQwZbemOBv+5OCcM2xwhgTcOF2Jon/6dhNxDqt+WE7TiynUPNNo/yDUrl4IQZMoBRhdQmVZDDv3QWbtm+6pEy/aYz++AfNxSWym+m84UHxnKxGkiWukta+UbJx6tIYbK8NFm5G5U8Axqntov5N6Kb5jUp6Irnbp8N473/Djq0CzPhla/stphInJg5zGZzUcOB9FbQE5SpKmrLA1JwWLlRUzG9ldPIa6NWGLxqvV5Wu/n/nHabd1AB96a3DvjtQQEIPOct4uZK3UvuuEDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtbqfXIudMeA8nFBn7YKrFx4KlWrBXyBFWTvu8GEziw=;
 b=IG7xMaPcjMNTaGpvBVzPdXPo8gbJnkYv3PDnemLiSfCllzVV+X8GWDbvMa8NeO+kcr+QlnBcCyc5B+oseeyN2QvW6p7FgZ7YACxmIHxGu6q78he6thDsIbZoEDAkdnCqj89iPDtxXEReUIdMpvFvw6D84BD/mgpDiYTLNky8YYpOpSdzFQhs2rUz3wNFRaXdko+ePErNuxodq5pvqLAwbDc2eTuR63PfOleYmueYSXz3D9JtIO4WChzMAG3ok0no4dTTVlivp9Yp7MtweCc50pARu5ynplLy1t2Gpc7HsKsb8HK8eVFpfi6L0rvBktwqf4+Fj/VIwn2JMQriEVkY2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VE1EUR02FT025.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1e::48) by
 VE1EUR02HT064.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1e::316)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 15 Jun
 2021 14:26:10 +0000
Received: from AS8PR10MB4712.EURPRD10.PROD.OUTLOOK.COM
 (2a01:111:e400:7e1e::4e) by VE1EUR02FT025.mail.protection.outlook.com
 (2a01:111:e400:7e1e::109) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Tue, 15 Jun 2021 14:26:10 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:FDAA811DE1E606CCD8A6BC22431B81C771B93894EFD5B453C9A37128DEE99CDD;UpperCasedChecksum:B0162481BB0DC47EC5B9F3133A24F82951FE1072AD713ACD93FEA1C41DDF4FD3;SizeAsReceived:8958;Count:48
Received: from AS8PR10MB4712.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::844c:ffa:7f96:bdc8]) by AS8PR10MB4712.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::844c:ffa:7f96:bdc8%5]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 14:26:10 +0000
Subject: Re: [PATCH v9] exec: Fix dead-lock in de_thread with ptrace_attach
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Michal Hocko <mhocko@suse.com>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jamorris@linux.microsoft.com>,
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
References: <AM8PR10MB4708AFBD838138A84CE89EF8E4359@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <20210610143642.e4535dbdc0db0b1bd3ee5367@linux-foundation.org>
 <AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <877diwtn2p.fsf@disp2133>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AS8PR10MB47120E7A195A593C1377172CE4309@AS8PR10MB4712.EURPRD10.PROD.OUTLOOK.COM>
Date:   Tue, 15 Jun 2021 16:26:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <877diwtn2p.fsf@disp2133>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TMN:  [o4eA+72NTNCcXTmombcfjuAyRhrLnYJP]
X-ClientProxiedBy: FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::15) To AS8PR10MB4712.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:31d::16)
X-Microsoft-Original-Message-ID: <cd31b4be-97ac-7af9-af51-60ae0f3124d0@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (84.57.55.161) by FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Tue, 15 Jun 2021 14:26:08 +0000
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 48
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 08ce5f7c-b91e-4aad-e142-08d93009852e
X-MS-TrafficTypeDiagnostic: VE1EUR02HT064:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: evTlw+ocPTvu1VDb+Jp5bAXiELOdBPM51BlrWXQgj/5mKf40zsz/8AjFYeglK1L0vzdbGiLeHpEITzbnAnmKK5rDoHIXNfFX9n1fGZ3FXWxbNDqNo804pO587LxVoQBUiiJyIjrv7q3LVN56+atePIneOWKD3+UUndKn/BfgG0wSQld1ayGvWjp8IhyCIJ1eH+3ZnmkRvrzpNE5kPgbcDgUL4EkN9m/U8RkKNqlUysMpiulxicmkr++L1t3YUx4YhK/LAKqseopgCaflkajhdwJiiK0epkTwh/E0t2ECebBJsNKvQxTWaW4A2MqSk4CXUdheL23lV1238MFwft0prBiGJhnNaj9vaQabnOkvFh7l1XmsiUqu84fJ8OaNNAdAJSWgD0u3GkFR84WjHZh+8zzT/B0cJrD3S+MDv3BH9XOTMb2zi9Om6GPlVfVkTUiv7X+Cc0D2o24dn8gN4DsQFtBOWeNYJuc9Hx771DyoGtM=
X-MS-Exchange-AntiSpam-MessageData: VuiBHywgFkg4j8aMRrGN8SUl8k//meDM2mZaGY6t1fCrr6j+Cvo4qWovnYj5wO9t7nxggHgAdmBte9hcDmRzTB0Cx8Ftr/zM+l3msjFohmlHjTkqj8RXiOOi7MnNbhyLKnxjUpors9/Ge/E+5Edy7w==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ce5f7c-b91e-4aad-e142-08d93009852e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 14:26:10.5558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR02FT025.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR02HT064
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for your review.

On 6/14/21 6:42 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> This introduces signal->unsafe_execve_in_progress,
>> which is used to fix the case when at least one of the
>> sibling threads is traced, and therefore the trace
>> process may dead-lock in ptrace_attach, but de_thread
>> will need to wait for the tracer to continue execution.
> 
> Userspace processes hang waiting for each other.  Not a proper kernel
> deadlock.  Annoying but not horrible.  Definitely worth fixing if we can.
> 

I wonder if I am used a wrong term in the title.
Do you have a suggestion for better wording?

>> The solution is to detect this situation and allow
>> ptrace_attach to continue, while de_thread() is still
>> waiting for traced zombies to be eventually released.
>> When the current thread changed the ptrace status from
>> non-traced to traced, we can simply abort the whole
>> execve and restart it by returning -ERESTARTSYS.
>> This needs to be done before changing the thread leader,
>> because the PTRACE_EVENT_EXEC needs to know the old
>> thread pid.
> 
> Except you are not detecting this situation.  Testing for t->ptrace
> finds tasks that have completed their ptrace attach and no longer need
> the cred_gaurd_mutex.
> 

The first phase of de_thread needs co-operation from a user task,
if and only if any task t except the thread leader has t->ptrace.
Taking tasks from RUNNING->EXIT_ZOMBIE only needs co-operation from kernel code,
that is using mutex_wait_killable(&sig->cred_guard_mutex).
Tasks with !t->ptrace are childs of the thread leader, and are automatically
sent to EXIT_DEAD, see kernel/exit.c (exit_notify):

        if (unlikely(tsk->ptrace)) {
                [...]
        } else if (thread_group_leader(tsk)) {
                autoreap = thread_group_empty(tsk) &&
                        do_notify_parent(tsk, tsk->exit_signal);
        } else {
                autoreap = true;
        }

        if (autoreap) {
                tsk->exit_state = EXIT_DEAD;
                list_add(&tsk->ptrace_entry, &dead);
        }

But tasks which are traced have a different parent, and will stay ZOMBIES
for as long as the tracer does not call waitpid or handle the SIGCHILD.

> You almost discover the related problem that involves PTRACE_EVENT_EXEC.
> 
> It will probably help to have a full description of all of the
> processes and states involved in the hang in your description
> so you can show how your proposed change avoids the problem.
> 

Ok, will try to do that.

>> Although it is technically after the point of no return,
>> we just have to reset bprm->point_of_no_return here,
>> since at this time only the other threads have received
>> a fatal signal, not the current thread.
> 
> No.  If you have killed other threads we are most definitely past the
> point where it is at all reasonable to return to userspace.
> Perfunctorily killing other threads may leave them with locks held and
> who knows what other problems.  Certainly it leaves the application
> unable to process a failure from exec and continue on.
> 

Yeah, I tend to agree.  I had assumed that returning -ERESTARTSYS will always
bounce-back to the same execve syscall, and that the restarted execve call
must succeed.  But especially the second assumption is not a given thing.

I wonder if that might work instead?

diff --git a/fs/exec.c b/fs/exec.c
index c7b1926..4490288 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1956,6 +1956,13 @@ static int do_execveat_common(int fd, struct filename *filename,
 out_free:
        free_bprm(bprm);
 
+       if (retval == -ERESTARTSYS && !fatal_signal_pending(current)) {
+               retval = do_execveat_common(fd, filename, argv, envp, flags);
+               if (retval < 0 && !fatal_signal_pending(current))
+                       force_sigsegv(SIGSEGV);
+               return retval;
+       }
+
 out_ret:
        putname(filename);
        return retval;
diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
index c7c2242..3b7d81fb 100644
--- a/tools/testing/selftests/ptrace/vmaccess.c
+++ b/tools/testing/selftests/ptrace/vmaccess.c
@@ -74,13 +74,13 @@ static void *thread(void *arg)
        k = waitpid(-1, &s, 0);
        ASSERT_EQ(k, pid);
        ASSERT_EQ(WIFSTOPPED(s), 1);
-       ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
+       ASSERT_EQ(WSTOPSIG(s), SIGTRAP);
        k = ptrace(PTRACE_CONT, pid, 0L, 0L);
        ASSERT_EQ(k, 0);
        k = waitpid(-1, &s, 0);
        ASSERT_EQ(k, pid);
        ASSERT_EQ(WIFSTOPPED(s), 1);
-       ASSERT_EQ(WSTOPSIG(s), SIGTRAP);
+       ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
        k = ptrace(PTRACE_CONT, pid, 0L, 0L);
        ASSERT_EQ(k, 0);
        k = waitpid(-1, &s, 0);


Since the SIGSTOP from the PTRACE_ACCESS is not handled before the restart,
the SIGSTOP and SIGTRAP events in the test case are in reversed order, but
that is a possible outcome too.

>> From the user's point of view the whole execve was
>> simply delayed until after the ptrace_attach.
> 
> Conceptually I like what you are trying to detect and do.
> However your description unfortunately does not match the code.
> 
> If you can find a test for another process waiting to ptrace_attach
> one of our threads before we enter into de_thread that would be a
> reasonable time to do something, and would potentially make a nice
> fix.
> 

No I don't see any way how to do that.

Unfortunately the tracer may or may not decide to do the ptrace_attach
at any time, and it is usually the same process that is unable to do
the waitpid because it is hanging in the ptrace_attach.


Bernd.

> 
> Eric
> 
>> Other threads die quickly since the cred_guard_mutex
>> is released, but a deadly signal is already pending.
>> In case the mutex_lock_killable misses the signal,
>> ->unsafe_execve_in_progress makes sure they release
>> the mutex immediately and return with -ERESTARTNOINTR.
>>
>> This means there is no API change, unlike the previous
>> version of this patch which was discussed here:
>>
>> https://lore.kernel.org/lkml/b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de/
>>
>> See tools/testing/selftests/ptrace/vmaccess.c
>> for a test case that gets fixed by this change.
>>
>> Note that since the test case was originally designed to
>> test the ptrace_attach returning an error in this situation,
>> the test expectation needed to be adjusted, to allow the
>> API to succeed at the first attempt.
>>
>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>> ---
>>  fs/exec.c                                 | 37 +++++++++++++++++++++++++++++--
>>  fs/proc/base.c                            |  6 +++++
>>  include/linux/sched/signal.h              | 13 +++++++++++
>>  kernel/ptrace.c                           |  9 ++++++++
>>  kernel/seccomp.c                          | 12 +++++++---
>>  tools/testing/selftests/ptrace/vmaccess.c | 25 ++++++++++++++-------
>>  6 files changed, 89 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 8344fba..c7b1926 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1040,6 +1040,8 @@ static int de_thread(struct task_struct *tsk)
>>  	struct signal_struct *sig = tsk->signal;
>>  	struct sighand_struct *oldsighand = tsk->sighand;
>>  	spinlock_t *lock = &oldsighand->siglock;
>> +	unsigned int prev_ptrace = tsk->ptrace;
>> +	struct task_struct *t = tsk;
>>  
>>  	if (thread_group_empty(tsk))
>>  		goto no_thread_group;
>> @@ -1062,6 +1064,17 @@ static int de_thread(struct task_struct *tsk)
>>  	if (!thread_group_leader(tsk))
>>  		sig->notify_count--;
>>  
>> +	while_each_thread(tsk, t) {
>> +		if (unlikely(t->ptrace) && t != tsk->group_leader)
>> +			sig->unsafe_execve_in_progress = true;
>> +	}
>> +
>> +	if (unlikely(sig->unsafe_execve_in_progress)) {
>> +		spin_unlock_irq(lock);
>> +		mutex_unlock(&sig->cred_guard_mutex);
>> +		spin_lock_irq(lock);
>> +	}
>> +
>>  	while (sig->notify_count) {
>>  		__set_current_state(TASK_KILLABLE);
>>  		spin_unlock_irq(lock);
>> @@ -1072,6 +1085,17 @@ static int de_thread(struct task_struct *tsk)
>>  	}
>>  	spin_unlock_irq(lock);
>>  
>> +	if (unlikely(sig->unsafe_execve_in_progress)) {
>> +		if (mutex_lock_killable(&sig->cred_guard_mutex))
>> +			goto killed;
>> +		sig->unsafe_execve_in_progress = false;
>> +		if (!prev_ptrace && tsk->ptrace) {
>> +			sig->group_exit_task = NULL;
>> +			sig->notify_count = 0;
>> +			return -ERESTARTSYS;
>> +		}
>> +	}
>> +
>>  	/*
>>  	 * At this point all other threads have exited, all we have to
>>  	 * do is to wait for the thread group leader to become inactive,
>> @@ -1255,8 +1279,11 @@ int begin_new_exec(struct linux_binprm * bprm)
>>  	 * Make this the only thread in the thread group.
>>  	 */
>>  	retval = de_thread(me);
>> -	if (retval)
>> +	if (retval) {
>> +		if (retval == -ERESTARTSYS)
>> +			bprm->point_of_no_return = false;
>>  		goto out;
>> +	}
>>  
>>  	/*
>>  	 * Cancel any io_uring activity across execve
>> @@ -1466,6 +1493,11 @@ static int prepare_bprm_creds(struct linux_binprm *bprm)
>>  	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
>>  		return -ERESTARTNOINTR;
>>  
>> +	if (unlikely(current->signal->unsafe_execve_in_progress)) {
>> +		mutex_unlock(&current->signal->cred_guard_mutex);
>> +		return -ERESTARTNOINTR;
>> +	}
>> +
>>  	bprm->cred = prepare_exec_creds();
>>  	if (likely(bprm->cred))
>>  		return 0;
>> @@ -1482,7 +1514,8 @@ static void free_bprm(struct linux_binprm *bprm)
>>  	}
>>  	free_arg_pages(bprm);
>>  	if (bprm->cred) {
>> -		mutex_unlock(&current->signal->cred_guard_mutex);
>> +		if (!current->signal->unsafe_execve_in_progress)
>> +			mutex_unlock(&current->signal->cred_guard_mutex);
>>  		abort_creds(bprm->cred);
>>  	}
>>  	if (bprm->file) {
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 3851bfc..3b2a55c 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -2739,6 +2739,12 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
>>  	if (rv < 0)
>>  		goto out_free;
>>  
>> +	if (unlikely(current->signal->unsafe_execve_in_progress)) {
>> +		mutex_unlock(&current->signal->cred_guard_mutex);
>> +		rv = -ERESTARTNOINTR;
>> +		goto out_free;
>> +	}
>> +
>>  	rv = security_setprocattr(PROC_I(inode)->op.lsm,
>>  				  file->f_path.dentry->d_name.name, page,
>>  				  count);
>> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
>> index 3f6a0fc..220a083 100644
>> --- a/include/linux/sched/signal.h
>> +++ b/include/linux/sched/signal.h
>> @@ -214,6 +214,17 @@ struct signal_struct {
>>  #endif
>>  
>>  	/*
>> +	 * Set while execve is executing but is *not* holding
>> +	 * cred_guard_mutex to avoid possible dead-locks.
>> +	 * The cred_guard_mutex is released *after* de_thread() has
>> +	 * called zap_other_threads(), therefore a fatal signal is
>> +	 * guaranteed to be already pending in the unlikely event, that
>> +	 * current->signal->unsafe_execve_in_progress happens to be
>> +	 * true after the cred_guard_mutex was acquired.
>> +	 */
>> +	bool unsafe_execve_in_progress;
>> +
>> +	/*
>>  	 * Thread is the potential origin of an oom condition; kill first on
>>  	 * oom
>>  	 */
>> @@ -227,6 +238,8 @@ struct signal_struct {
>>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>>  					 * credential calculations
>>  					 * (notably. ptrace)
>> +					 * Held while execve runs, except when
>> +					 * a sibling thread is being traced.
>>  					 * Deprecated do not use in new code.
>>  					 * Use exec_update_lock instead.
>>  					 */
>> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
>> index 61db50f..0cbc1eb 100644
>> --- a/kernel/ptrace.c
>> +++ b/kernel/ptrace.c
>> @@ -468,6 +468,14 @@ static int ptrace_traceme(void)
>>  {
>>  	int ret = -EPERM;
>>  
>> +	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
>> +		return -ERESTARTNOINTR;
>> +
>> +	if (unlikely(current->signal->unsafe_execve_in_progress)) {
>> +		mutex_unlock(&current->signal->cred_guard_mutex);
>> +		return -ERESTARTNOINTR;
>> +	}
>> +
>>  	write_lock_irq(&tasklist_lock);
>>  	/* Are we already being traced? */
>>  	if (!current->ptrace) {
>> @@ -483,6 +491,7 @@ static int ptrace_traceme(void)
>>  		}
>>  	}
>>  	write_unlock_irq(&tasklist_lock);
>> +	mutex_unlock(&current->signal->cred_guard_mutex);
>>  
>>  	return ret;
>>  }
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index 1d60fc2..b1389ee 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -1824,9 +1824,15 @@ static long seccomp_set_mode_filter(unsigned int flags,
>>  	 * Make sure we cannot change seccomp or nnp state via TSYNC
>>  	 * while another thread is in the middle of calling exec.
>>  	 */
>> -	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
>> -	    mutex_lock_killable(&current->signal->cred_guard_mutex))
>> -		goto out_put_fd;
>> +	if (flags & SECCOMP_FILTER_FLAG_TSYNC) {
>> +		if (mutex_lock_killable(&current->signal->cred_guard_mutex))
>> +			goto out_put_fd;
>> +
>> +		if (unlikely(current->signal->unsafe_execve_in_progress)) {
>> +			mutex_unlock(&current->signal->cred_guard_mutex);
>> +			goto out_put_fd;
>> +		}
>> +	}
>>  
>>  	spin_lock_irq(&current->sighand->siglock);
>>  
>> diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
>> index 4db327b..c7c2242 100644
>> --- a/tools/testing/selftests/ptrace/vmaccess.c
>> +++ b/tools/testing/selftests/ptrace/vmaccess.c
>> @@ -39,8 +39,15 @@ static void *thread(void *arg)
>>  	f = open(mm, O_RDONLY);
>>  	ASSERT_GE(f, 0);
>>  	close(f);
>> -	f = kill(pid, SIGCONT);
>> -	ASSERT_EQ(f, 0);
>> +	f = waitpid(-1, NULL, 0);
>> +	ASSERT_NE(f, -1);
>> +	ASSERT_NE(f, 0);
>> +	ASSERT_NE(f, pid);
>> +	f = waitpid(-1, NULL, 0);
>> +	ASSERT_EQ(f, pid);
>> +	f = waitpid(-1, NULL, 0);
>> +	ASSERT_EQ(f, -1);
>> +	ASSERT_EQ(errno, ECHILD);
>>  }
>>  
>>  TEST(attach)
>> @@ -57,22 +64,24 @@ static void *thread(void *arg)
>>  
>>  	sleep(1);
>>  	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
>> -	ASSERT_EQ(errno, EAGAIN);
>> -	ASSERT_EQ(k, -1);
>> +	ASSERT_EQ(k, 0);
>>  	k = waitpid(-1, &s, WNOHANG);
>>  	ASSERT_NE(k, -1);
>>  	ASSERT_NE(k, 0);
>>  	ASSERT_NE(k, pid);
>>  	ASSERT_EQ(WIFEXITED(s), 1);
>>  	ASSERT_EQ(WEXITSTATUS(s), 0);
>> -	sleep(1);
>> -	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
>> -	ASSERT_EQ(k, 0);
>>  	k = waitpid(-1, &s, 0);
>>  	ASSERT_EQ(k, pid);
>>  	ASSERT_EQ(WIFSTOPPED(s), 1);
>>  	ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
>> -	k = ptrace(PTRACE_DETACH, pid, 0L, 0L);
>> +	k = ptrace(PTRACE_CONT, pid, 0L, 0L);
>> +	ASSERT_EQ(k, 0);
>> +	k = waitpid(-1, &s, 0);
>> +	ASSERT_EQ(k, pid);
>> +	ASSERT_EQ(WIFSTOPPED(s), 1);
>> +	ASSERT_EQ(WSTOPSIG(s), SIGTRAP);
>> +	k = ptrace(PTRACE_CONT, pid, 0L, 0L);
>>  	ASSERT_EQ(k, 0);
>>  	k = waitpid(-1, &s, 0);
>>  	ASSERT_EQ(k, pid);
