Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAC0180906
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgCJUTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:19:16 -0400
Received: from mail-oln040092067053.outbound.protection.outlook.com ([40.92.67.53]:36576
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726307AbgCJUTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 16:19:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqYxXKvU9RcP8ga3wxe5uZ3FZxUk8mfE+NkPSBz5gOiRJUZPZKpVK4qMgPzq+mENd091MXb/wL1TB+Nb7BcCcH796zZr32OnJOp65cPE7TEseW6y0Puh6e2xCtDHhHTfM0bRRkA7AcdFBFfe8cJn3BfdMbyyqiNQh3GPRi2l0nUWwjgwwZmap2pkQQs/tXGCIk0Img/6tfPrF5YZWywV8uQgPg7XtjRboZdFaPVyqjGQTggapsjCV0fJbmcdcDNltMuanl1eLvI1/SEystMRwp6K5O3vc8XTd3khSdrMC7f/Qhr1KkOKXqTi4N6H9tVh+a8lk7/mRLoiz+85f76rlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGTpibA2a98iI3qOX4Bb+HeQu924Dp/7t2trJCixwwI=;
 b=Onleiu9ZIhQWQnh4DdczOvCbIv7wGX9KOg4pxFEE9/nZWqxpf5O/UjTFVz+/qe6wfSz447kXQ9TQEK9xKkLE3ISOIMu2gA1ooD+AeQ3W9Kq3sbfDcsbAUfW0QhF5ZEQtb0H57ZPjH0PRwyxV0RhHmUcSNyeiZ/9P63tzFemHWM1nHAhCHoC6rbRgKaJ8vKFt1eZHX0F1/MunRw5OoIutjimr9sIrhGnW1G4oA1oqADGKBkKmLG9CL99jlUqqMt95zIpzTzjrpCshthwX59nVzHo34vX5aquz/O70UkKD+kGj81+iyN9GR+Z1lfGHQdrceDu+E9clnD6lCBvUGz8d4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VE1EUR02FT050.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1e::3a) by
 VE1EUR02HT154.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1e::465)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 20:19:08 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.12.60) by
 VE1EUR02FT050.mail.protection.outlook.com (10.152.13.198) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 20:19:08 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:75B335AEC4F75D550E70D40E707B41863791464A4A2614DBBC8A7B9717E018FE;UpperCasedChecksum:CE690AD99C8ED899E3E9D7241EB9D336ED60526E2927906538A433033B031CDC;SizeAsReceived:10324;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 20:19:08 +0000
Subject: Re: [PATCH 3/4] proc: io_accounting: Use new infrastructure to fix
 deadlocks in execve
To:     "Eric W. Biederman" <ebiederm@xmission.com>
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
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <878sk94eay.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y12yc7.fsf@x220.int.ebiederm.org> <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfcxlwy.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <874kuwvxkz.fsf@x220.int.ebiederm.org>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170A29F8D885147F1A3981EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 21:19:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <874kuwvxkz.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0119.eurprd07.prod.outlook.com
 (2603:10a6:207:7::29) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <ac2d76d8-edba-3964-592f-8ed02083acd4@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM3PR07CA0119.eurprd07.prod.outlook.com (2603:10a6:207:7::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.9 via Frontend Transport; Tue, 10 Mar 2020 20:19:06 +0000
X-Microsoft-Original-Message-ID: <ac2d76d8-edba-3964-592f-8ed02083acd4@hotmail.de>
X-TMN:  [7GqCFKberJhfiFLUY52XgHIF43KNN/eT]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: c1016142-1b55-42fb-9b87-08d7c5304979
X-MS-TrafficTypeDiagnostic: VE1EUR02HT154:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: phXLvVK2FVM1J0DFhowlYEqkAiwImwdQEN+TkWGH1bzRyDdh6I6xPTLd+ATlfTJomMJgSU0oHyBDbuE+SenREnvY4Vs2Rmq+sLC1Q7RRlpN9qEkrr2XbggfDV1uyt6MVCV5kj3XgNFVCvVgmDIpkBLvtDXjLOhQSNaQRoE8Of81QgKn97CgGj596RXB7GpQv
X-MS-Exchange-AntiSpam-MessageData: b9bxU13hHcjdDEK8dPbjocds0/ot4nU4Q2RLgeophtFuTbHQ1uz1FWLp9uXXNjmvYB6AZhmszKIubYpm9akws/mzIupuhDhXWovqRb5dLawECmaxmuq2hI8eXBvbt8r+gUFAnu1BryErbd64vUpNyA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1016142-1b55-42fb-9b87-08d7c5304979
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 20:19:08.0961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR02HT154
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 8:06 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> This changes do_io_accounting to use the new exec_update_mutex
>> instead of cred_guard_mutex.
>>
>> This fixes possible deadlocks when the trace is accessing
>> /proc/$pid/io for instance.
>>
>> This should be safe, as the credentials are only used for reading.
> 
> This is an improvement.
> 
> We probably want to do this just as an incremental step in making things
> better but perhaps I am blind but I am not finding the reason for
> guarding this with the cred_guard_mutex to be at all persuasive.
> 
> I think moving the ptrace_may_access check down to after the
> unlock_task_sighand would be just as effective at addressing the
> concerns raised in the original commit.  I think the task_lock provides
> all of the barrier we need to make it safe to move the ptrace_may_access
> checks safe.
> 
> The reason I say this is I don't see exec changing ->ioac.  Just
> performing some I/O which would update the io accounting statistics.
> 

Maybe the suid executable is starting up and doing io or not,
and what the program does immediately at startup is a secret,
that we want to keep secret but evil eve want to find out.
eve is using /proc/alice/io to do that.

It is a bit constructed, but seems like a security concern.
when we keep the exec_update_mutex while collecting the data, we
cannot see any io of the new process when the new credentials
don't allow that.


Bernd.

> Can anyone see if I am wrong?
> 
> Eric
> 
> 
> commit 293eb1e7772b25a93647c798c7b89bf26c2da2e0
> Author: Vasiliy Kulikov <segoon@openwall.com>
> Date:   Tue Jul 26 16:08:38 2011 -0700
> 
>     proc: fix a race in do_io_accounting()
>     
>     If an inode's mode permits opening /proc/PID/io and the resulting file
>     descriptor is kept across execve() of a setuid or similar binary, the
>     ptrace_may_access() check tries to prevent using this fd against the
>     task with escalated privileges.
>     
>     Unfortunately, there is a race in the check against execve().  If
>     execve() is processed after the ptrace check, but before the actual io
>     information gathering, io statistics will be gathered from the
>     privileged process.  At least in theory this might lead to gathering
>     sensible information (like ssh/ftp password length) that wouldn't be
>     available otherwise.
>     
>     Holding task->signal->cred_guard_mutex while gathering the io
>     information should protect against the race.
>     
>     The order of locking is similar to the one inside of ptrace_attach():
>     first goes cred_guard_mutex, then lock_task_sighand().
>     
>     Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
>     Cc: Al Viro <viro@zeniv.linux.org.uk>
>     Cc: <stable@kernel.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> 
> 
>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>> ---
>>  fs/proc/base.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 4fdfe4f..529d0c6 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -2770,7 +2770,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
>>  	unsigned long flags;
>>  	int result;
>>  
>> -	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
>> +	result = mutex_lock_killable(&task->signal->exec_update_mutex);
>>  	if (result)
>>  		return result;
>>  
>> @@ -2806,7 +2806,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
>>  	result = 0;
>>  
>>  out_unlock:
>> -	mutex_unlock(&task->signal->cred_guard_mutex);
>> +	mutex_unlock(&task->signal->exec_update_mutex);
>>  	return result;
>>  }
