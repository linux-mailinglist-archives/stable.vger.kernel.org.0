Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005A5180940
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgCJUeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:34:15 -0400
Received: from mail-db8eur05olkn2076.outbound.protection.outlook.com ([40.92.89.76]:26657
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbgCJUeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 16:34:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WcIEyrTUfMaHQbnYYU69H60WcLBOcxjNjkw6M6FER+zQKxoO11BO2dl7HRFd9tkLp2hRbo6YZBLoIKjZH6Dvkfgcm0VRlkOQagDCRHbBxTmZLX0Deth0CMoWSB/BoG0EoNzfTBIt+atO+6imSn2Zl9JuNK8vvkcJIBsQBFxCZzsvQi6dWQUQ/CzuYRV03c1sAWLvoQ2VwN62r+vew6HnVHoqEQhueLl2Ucon8RzxVc/b8ti3wd1BWc1sn4bR7tvVhDMsEioCemVSRImRq2OFu/cmOhU6AjBH25hgkI+bqKUcCaytbb9X1UIi7ZQyh3XoYp8jQtBkdDuhDfPQbv7M1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAMMURuQOqpRTcA7Rkvbc6MqvIzvGiO1uSjjJcyUb30=;
 b=ACzEtZU1AHXhYWN4CHS7kzH9hPtpYLK0GAnGWq2FOlEpYr0dwSTzMQkIUu3qj2OmNiV88pJwcQB8O68m34jCoJQdcbaktX/j6qn4Gz8Oyq1LBsd18YL1Pi8Pb9vmCUYdRKZz+QbDcKRBN5ICMBzSFqSd/3dS4N4vt5ZQTIazOAD6trNm2uHRUMjzfLcfkdwC8zGQ+anEvWNIxCf7QM9J38viAFUGDBnHVQA98nEDxCWMMzaUTUMVcGkGoggaY71c8niC4ojDewYx8LDs479pANL9S65U/9KYiaMPBTcQLymUlj2Ea3VudfVOaAoSnM+q8gWeGdpwAzhdjliZPul0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB8EUR05FT064.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc0f::39) by
 DB8EUR05HT123.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc0f::467)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 20:34:07 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.238.55) by
 DB8EUR05FT064.mail.protection.outlook.com (10.233.239.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 20:34:07 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:6E2F2765202CE35416464C135C6FFBA2B719C05EE3CB6A8D11B988178C1F7E4F;UpperCasedChecksum:DEB30F3B4732FBB9D66C8D6B6912433D1AF3FA695E5EA99E62586E709F1D7555;SizeAsReceived:9951;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 20:34:06 +0000
Subject: Re: [PATCH v2 2/5] exec: Factor unshare_sighand out of de_thread and
 call it separately
To:     Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
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
References: <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87k13u5y26.fsf_-_@x220.int.ebiederm.org> <202003101319.BAE7B535A@keescook>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170BDBF7D6E4AC63B40E9C0E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 21:34:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <202003101319.BAE7B535A@keescook>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0034.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::21) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <413880a2-67ee-abda-4d94-5fbc3a5f2ce0@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0034.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 20:34:04 +0000
X-Microsoft-Original-Message-ID: <413880a2-67ee-abda-4d94-5fbc3a5f2ce0@hotmail.de>
X-TMN:  [DsNTvsup9lZ76RgwngAXzyrPQegfXQCx]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: c95913f9-1af9-44d2-566d-08d7c5326111
X-MS-TrafficTypeDiagnostic: DB8EUR05HT123:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2FGXk/Rw0XOCw+CWrOFh7T3lufTrUFbuwCliexGLVlvacylgONvHzVBqY/4sKRwJyrmwelZfnzrYhmqFWvw3zv7WIhY6BHRQtsyTbF9TrC2YovjA5P1Np90KcTFLE52GhBUj4+3xdaVoCaDRrJ0XWXUQYUfwQlZ2BA12wbLRqTfVmKdgjJjWzxOYRMh+M6T
X-MS-Exchange-AntiSpam-MessageData: e7isqGKnWltXNTIoA/I+4t0398dD8dlfkBFpzeaiBiLbycQwkT8t55u00tbQ61cOky4WnCESdGu8EllZSmXQo/yj41LeMrUAl8rJz5VYppDr0JR27TbKDloC7QJERB4uHq42/TAp26jmCOIT6hIf6A==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95913f9-1af9-44d2-566d-08d7c5326111
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 20:34:06.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8EUR05HT123
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 9:29 PM, Kees Cook wrote:
> On Sun, Mar 08, 2020 at 04:36:17PM -0500, Eric W. Biederman wrote:
>>
>> This makes the code clearer and makes it easier to implement a mutex
>> that is not taken over any locations that may block indefinitely waiting
>> for userspace.
>>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/exec.c | 39 ++++++++++++++++++++++++++-------------
>>  1 file changed, 26 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index c3f34791f2f0..ff74b9a74d34 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1194,6 +1194,23 @@ static int de_thread(struct task_struct *tsk)
>>  	flush_itimer_signals();
>>  #endif
> 
> Semi-related (existing behavior): in de_thread(), what keeps the thread
> group from changing? i.e.:
> 
>         if (thread_group_empty(tsk))
>                 goto no_thread_group;
> 
>         /*
>          * Kill all other threads in the thread group.
>          */
>         spin_lock_irq(lock);
> 	... kill other threads under lock ...
> 
> Why is the thread_group_emtpy() test not under lock?
> 

A new thread cannot created when only one thread is executing,
right?

>>  
>> +	BUG_ON(!thread_group_leader(tsk));
>> +	return 0;
>> +
>> +killed:
>> +	/* protects against exit_notify() and __exit_signal() */
> 
> I wonder if include/linux/sched/task.h's definition of tasklist_lock
> should explicitly gain note about group_exit_task and notify_count,
> or, alternatively, signal.h's section on these fields should gain a
> comment? tasklist_lock is unmentioned in signal.h... :(
> 
>> +	read_lock(&tasklist_lock);
>> +	sig->group_exit_task = NULL;
>> +	sig->notify_count = 0;
>> +	read_unlock(&tasklist_lock);
>> +	return -EAGAIN;
>> +}
>> +
>> +
>> +static int unshare_sighand(struct task_struct *me)
>> +{
>> +	struct sighand_struct *oldsighand = me->sighand;
>> +
>>  	if (refcount_read(&oldsighand->count) != 1) {
>>  		struct sighand_struct *newsighand;
>>  		/*
>> @@ -1210,23 +1227,13 @@ static int de_thread(struct task_struct *tsk)
>>  
>>  		write_lock_irq(&tasklist_lock);
>>  		spin_lock(&oldsighand->siglock);
>> -		rcu_assign_pointer(tsk->sighand, newsighand);
>> +		rcu_assign_pointer(me->sighand, newsighand);
>>  		spin_unlock(&oldsighand->siglock);
>>  		write_unlock_irq(&tasklist_lock);
>>  
>>  		__cleanup_sighand(oldsighand);
>>  	}
>> -
>> -	BUG_ON(!thread_group_leader(tsk));
>>  	return 0;
>> -
>> -killed:
>> -	/* protects against exit_notify() and __exit_signal() */
>> -	read_lock(&tasklist_lock);
>> -	sig->group_exit_task = NULL;
>> -	sig->notify_count = 0;
>> -	read_unlock(&tasklist_lock);
>> -	return -EAGAIN;
>>  }
>>  
>>  char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
>> @@ -1264,13 +1271,19 @@ int flush_old_exec(struct linux_binprm * bprm)
>>  	int retval;
>>  
>>  	/*
>> -	 * Make sure we have a private signal table and that
>> -	 * we are unassociated from the previous thread group.
>> +	 * Make this the only thread in the thread group.
>>  	 */
>>  	retval = de_thread(me);
>>  	if (retval)
>>  		goto out;
>>  
>> +	/*
>> +	 * Make the signal table private.
>> +	 */
>> +	retval = unshare_sighand(me);
>> +	if (retval)
>> +		goto out;
>> +
>>  	/*
>>  	 * Must be called _before_ exec_mmap() as bprm->mm is
>>  	 * not visibile until then. This also enables the update
>> -- 
>> 2.25.0
> 
> Otherwise, yes, sensible separation.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
