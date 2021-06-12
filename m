Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B07B3A4CF5
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 07:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhFLFYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Jun 2021 01:24:31 -0400
Received: from mail-oln040092075035.outbound.protection.outlook.com ([40.92.75.35]:47489
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229446AbhFLFYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Jun 2021 01:24:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwHT2fUhnfDyfMLgAUWtea/tFUgGZkwoEJ0jezNM4J7+1lDxsgN59tVyh7GJMqnVgl0Kk5j3tLkXm3oa/FVsMCi7kfPTYhTKGPXXx+bTO4LSk/2cgk877vTOibAVAaZuZQdpTk53r0GMOHj9Q0PHA/E+CxaN0XuwAmNhHtsFjvuRSix8ES+4hAStvr3BZM60/NsijfgEYWNtCuHUVXPi27G7x1ehbCAB2SIdU1/gQ0hbvey2ZrxcttWGnkhItN8HtTtpIiznXqdLSrMJeM10c+iBCI/tefiQpKM4V2bh6eGqqolisNSiGwbqF1AkJb0Tb0+GhyTremtrxczAORb/AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSsom2Sf1kPaNEHn+PKSNOOurasJASTZLGQthLkgJGI=;
 b=oAH0vwf7yEIBcWCRPOvv2BgngifDpjnSmq3JHjIMVlRthIZMju8d+U5qiKLJVD8oy7TuCTs81SsEoktwfubgbbd0ve/CAggxJCKp0FrcO7ZH0F8bMocFFgELsGYV7gLJpfDJD8vI+qN2FJMM3u3zHht07BdYGHlDF/iVjU6U6MU2BmbHEyunb9503yX+ZrzDrjcIvMSBsNFHbB5pJ2x4JlIowSE3WhMiYXn7QllqOLeJx1+T19WweF60xmjrxwzgWg+D1OX9ouMIdBDG7VE+N0xXxbRKXF4TCVgfcCJE9tQNdqlmvdK+Jcqw9D+WBeCuGH3aZKLnIbHOijYd3JhUEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VI1EUR04FT007.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0e::49) by
 VI1EUR04HT100.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0e::215)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Sat, 12 Jun
 2021 05:22:29 +0000
Received: from AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 (2a01:111:e400:7e0e::41) by VI1EUR04FT007.mail.protection.outlook.com
 (2a01:111:e400:7e0e::229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Sat, 12 Jun 2021 05:22:29 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:8FEABE5776AB8FA3F06FEE53104E185A78916EA9219E852C3C660D42BC737D05;UpperCasedChecksum:D988F27773BE7F7771600642D99B748360376ACF07883EB47AFBC8B66620BD58;SizeAsReceived:9026;Count:48
Received: from AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e5e5:7b7a:5ea5:c75a]) by AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e5e5:7b7a:5ea5:c75a%7]) with mapi id 15.20.4219.021; Sat, 12 Jun 2021
 05:22:29 +0000
Subject: Re: [PATCH v9] exec: Fix dead-lock in de_thread with ptrace_attach
To:     Andrew Morton <akpm@linux-foundation.org>
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
References: <AM8PR10MB4708AFBD838138A84CE89EF8E4359@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <20210610143642.e4535dbdc0db0b1bd3ee5367@linux-foundation.org>
 <AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <20210611161655.0a3076495e59add166bac58a@linux-foundation.org>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM8PR10MB47083ADB99A7EB2CE5421D53E4339@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
Date:   Sat, 12 Jun 2021 07:22:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <20210611161655.0a3076495e59add166bac58a@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TMN:  [aFNLHPsoJ68C119/vCHLf2raTx0FKyrt]
X-ClientProxiedBy: PR1P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::18) To AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:364::23)
X-Microsoft-Original-Message-ID: <4358d821-bcfb-4798-8e97-bae7ea5db0ba@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (84.57.61.94) by PR1P264CA0031.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19f::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Sat, 12 Jun 2021 05:22:27 +0000
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 48
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: aa108ed7-502b-4846-228b-08d92d6211f7
X-MS-TrafficTypeDiagnostic: VI1EUR04HT100:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TokmNAR9F4DiePMWXUXh3zwUGpVRTMGrtZDyBfGYfiao/McASA7oMRiOoiiw9lgz8SWQJPob6mbJbRR3UDjk8LZpZvEQEn/VAV2Tl8AO5YxFMdq0iOYWupJnoDixtGI5vmr3EZ6FLfI9AbwN0sLhF57n1bFvZJCPwYccl9ofGuA6NB14jjCBNVWRQV+nPRim4l5thLKoWR6/p64oxgwR4Wq7eaL6VuFYmy0RgQsoBzttHBed/Yn0q+bN0bug6sNbcRb0FBQlnE635d3u60wwp2CJXc6XmgUWmbJCaPPTAGQpEUVHYSxZvMdTS0HGgPWEYlryg5hbsAxgXtZLH76gBBT0QTxvJCLIyl3CGX+wZ4G8wq2+eWWDXFMhfl8pKgASwXXHezTrT7S8Xc9K5g9B1ojpKXibe94kEJY2eaAQWx3fxipjogomaT/uDHtuYI6nw2e59YV9KZgSlWe1AAAOeLeErILeSKA85fjBNTVF0Lc=
X-MS-Exchange-AntiSpam-MessageData: HPUNTPgKnK1z0kDN5WwNc8eJNryxIlAqBFRaBlyLU9o0+cAHJzS0nNaDJIeoWb8hsTfzBL2ca0JeACrntJi2BaG+3KMysMV+G/i2iOYOBYbvEi1ErDsRlZYa4d4jKyjTcKym9RAeblThc3gS9PNcmw==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa108ed7-502b-4846-228b-08d92d6211f7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2021 05:22:29.1414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR04FT007.eop-eur04.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR04HT100
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/12/21 1:16 AM, Andrew Morton wrote:
> On Fri, 11 Jun 2021 17:55:09 +0200 Bernd Edlinger <bernd.edlinger@hotmail.de> wrote:
> 
>> This introduces signal->unsafe_execve_in_progress,
>> which is used to fix the case when at least one of the
>> sibling threads is traced, and therefore the trace
>> process may dead-lock in ptrace_attach, but de_thread
>> will need to wait for the tracer to continue execution.
>>
>> The solution is to detect this situation and allow
>> ptrace_attach to continue, while de_thread() is still
>> waiting for traced zombies to be eventually released.
>> When the current thread changed the ptrace status from
>> non-traced to traced, we can simply abort the whole
>> execve and restart it by returning -ERESTARTSYS.
>> This needs to be done before changing the thread leader,
>> because the PTRACE_EVENT_EXEC needs to know the old
>> thread pid.
>>
>> Although it is technically after the point of no return,
>> we just have to reset bprm->point_of_no_return here,
>> since at this time only the other threads have received
>> a fatal signal, not the current thread.
>>
>> >From the user's point of view the whole execve was
>> simply delayed until after the ptrace_attach.
>>
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
> 
> err, sorry.  I replied to the v8 patch, not to v9.
> 

Sorry for the confusion.

Originally the loop here looked was entered with
sighand locked and was like this:

	while (sig->notify_count) {
		__set_current_state(TASK_KILLABLE);
		if (!sig->notify_count)
			break;
		spin_unlock_irq(lock);
		schedule();
		if (__fatal_signal_pending(tsk))
			goto killed;
	}
	spin_unlock_irq(lock);

v8 did this (tried avoid lots of spin-lock/unlocks):

	sig->group_exit_task = tsk;
	sig->notify_count = zap_other_threads(tsk);
	if (!thread_group_leader(tsk))
		sig->notify_count--;
	spin_unlock_irq(lock);

	if (unlikely(sig->unsafe_execve_in_progress))
		mutex_unlock(&sig->cred_guard_mutex);

	for (;;) {
		set_current_state(TASK_KILLABLE);
		if (!sig->notify_count)
			break;
		schedule();
		if (__fatal_signal_pending(tsk))
			goto killed;
	}

but here I overlooked that there is an execution path without
any spin-lock where sig->group_exit_task is set to NULL, which
could create a race with __signal_exit.

So v9 keeps the loop as it was, and instead does this:

	if (unlikely(sig->unsafe_execve_in_progress)) {
		spin_unlock_irq(lock);
		mutex_unlock(&sig->cred_guard_mutex);
		spin_lock_irq(lock);
	}

because I would not like to release the mutex while an
interrupt spin-lock is held.


Bernd.

> --- a/fs/exec.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9
> +++ a/fs/exec.c
> @@ -1056,29 +1056,31 @@ static int de_thread(struct task_struct
>  		return -EAGAIN;
>  	}
>  
> -	while_each_thread(tsk, t) {
> -		if (unlikely(t->ptrace) && t != tsk->group_leader)
> -			sig->unsafe_execve_in_progress = true;
> -	}
> -
>  	sig->group_exit_task = tsk;
>  	sig->notify_count = zap_other_threads(tsk);
>  	if (!thread_group_leader(tsk))
>  		sig->notify_count--;
> -	spin_unlock_irq(lock);
>  
> -	if (unlikely(sig->unsafe_execve_in_progress))
> +	while_each_thread(tsk, t) {
> +		if (unlikely(t->ptrace) && t != tsk->group_leader)
> +			sig->unsafe_execve_in_progress = true;
> +	}
> +
> +	if (unlikely(sig->unsafe_execve_in_progress)) {
> +		spin_unlock_irq(lock);
>  		mutex_unlock(&sig->cred_guard_mutex);
> +		spin_lock_irq(lock);
> +	}
>  
> -	for (;;) {
> -		set_current_state(TASK_KILLABLE);
> -		if (!sig->notify_count)
> -			break;
> +	while (sig->notify_count) {
> +		__set_current_state(TASK_KILLABLE);
> +		spin_unlock_irq(lock);
>  		schedule();
>  		if (__fatal_signal_pending(tsk))
>  			goto killed;
> +		spin_lock_irq(lock);
>  	}
> -	__set_current_state(TASK_RUNNING);
> +	spin_unlock_irq(lock);
>  
>  	if (unlikely(sig->unsafe_execve_in_progress)) {
>  		if (mutex_lock_killable(&sig->cred_guard_mutex))
> _
> 
