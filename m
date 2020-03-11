Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80551822A3
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 20:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbgCKTil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 15:38:41 -0400
Received: from mail-oln040092074027.outbound.protection.outlook.com ([40.92.74.27]:64694
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730913AbgCKTil (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 15:38:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxqizhXowGPVQb7gyJLcQECU/FqGhfzGmQd1MewWia2Rm4433r3CHJAgdJ/x8P52wZNKoDFaJzfvjbrcSKunKyxlQNV5Z0ycDmdwjdlHEVwMdaz1vDNEjOjJizINvoQAHg11chLO2OX4a7LdM9N5KCDe51IDl5SUkc3WT1eWRvDTWNXVxB3PIqObObuu60XsS4M7coyYr/9s7Hm5FdNCPNrpUnUc7IynwByLclkIMTzZkyunnGvLe2mOfxdX1pqElQxtTCFtyB2edKSXD7NYHCJuQrYj6UeFXWjnLakDgdKw/t5/rdbNWuOv2ToDONH8vVwU3hW1GS0nY9Scwy3LxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nx7o+DSt7gNZ1iatttl7B9FP5QzBo0eRm3uNP7bG0E=;
 b=IuQPrn8WZwdVbjJAdoDhhAQaab+yyRCpg5J/efjDp2ppirKGrPiaRnhiBYMxwXvg8Nk1EaGm+Qo7HQnX38zrpd8G/UR5y4QBv4540hyZY2zVpcuxrz6oXReevd4DcnGpnLdJWQJk1GoevRD7pdk8ippkvJGAIvoGo3ULOjMkC6Pu+Mt2HlHu2LNOKuEsbChcfvPxn+e62tfKZ2+5p7mD5tGfuq/AwnM3NZVqh9xnQ9Z8i3TOTYmGQp/dC1oXJbF8S5K2WgOyzrOhKcgsxEQ0J8HDM+2pFeZtCVOUkB5KD6LuK5rirYB+8r02aSY1qSPZ+UUqNChc6vFoWpPqXh/WQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT031.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::36) by
 DB3EUR04HT004.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::445)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Wed, 11 Mar
 2020 19:38:38 +0000
Received: from PR2PR03MB5179.eurprd03.prod.outlook.com (10.152.24.54) by
 DB3EUR04FT031.mail.protection.outlook.com (10.152.24.239) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Wed, 11 Mar 2020 19:38:38 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:366CCCF2C02D71A0751CB0FC9F5A248A87BFE6D9F1FB3B1F06D9EAAB83B13DF6;UpperCasedChecksum:CA563FFDA8E05A80BB7B26D6AD28A01FB23FE5E84E8A0F30CDEE3775B2D8A5CF;SizeAsReceived:9923;Count:50
Received: from PR2PR03MB5179.eurprd03.prod.outlook.com
 ([fe80::5914:cd4e:9863:88c2]) by PR2PR03MB5179.eurprd03.prod.outlook.com
 ([fe80::5914:cd4e:9863:88c2%5]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 19:38:38 +0000
Subject: Re: [PATCH 2/4] proc: Use new infrastructure to fix deadlocks in
 execve
To:     Kees Cook <keescook@chromium.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
References: <87r1y12yc7.fsf@x220.int.ebiederm.org>
 <87k13t2xpd.fsf@x220.int.ebiederm.org> <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfcxlwy.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705D211EC8E7EA270627B1E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003111208.640025F75@keescook>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <PR2PR03MB5179D83C617929DFF76EB11BE4FC0@PR2PR03MB5179.eurprd03.prod.outlook.com>
Date:   Wed, 11 Mar 2020 20:38:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <202003111208.640025F75@keescook>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0107.eurprd07.prod.outlook.com
 (2603:10a6:207:7::17) To PR2PR03MB5179.eurprd03.prod.outlook.com
 (2603:10a6:101:25::12)
X-Microsoft-Original-Message-ID: <12e38caf-cd81-15bb-0f6e-c53ed2cabdae@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM3PR07CA0107.eurprd07.prod.outlook.com (2603:10a6:207:7::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.9 via Frontend Transport; Wed, 11 Mar 2020 19:38:34 +0000
X-Microsoft-Original-Message-ID: <12e38caf-cd81-15bb-0f6e-c53ed2cabdae@hotmail.de>
X-TMN:  [AYF23+fkc86AnRk6FHpxGeBnU4JhYZ5N]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 860b4db5-a7f4-4cad-bbaf-08d7c5f3cabc
X-MS-TrafficTypeDiagnostic: DB3EUR04HT004:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oeW4fZgyDIkVqd6f3sDWM700pD4I3P9Z6mDYV67IIuiFhwILMBd5Ky5MOJCweljF6Lf4ZyVMhGJoaFhZAJJnsh0v2rApaGZL1m1eIvspu8r7rfxNJdaT6HH9JFL5BzPRxZS3FiMLrl1SlTds6vb0juhskeH4vIFUvcIxVnxQ+RXngM5UmhpuXfF63FhFb3YH
X-MS-Exchange-AntiSpam-MessageData: w9Wy/jGhlm+2KTCL8XOZJu/40LPAvvmmKkvHfIh0bKiLndqYEGoFVH8QfbcP9FQ11qLWrUyckUlranK24dHQ8xkfiFPwNwuMXIV5yA59Ngbm2oB7EVvFbd37ZRhGuwXZ1MDmLEwn+Az2BXthI5uy8A==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 860b4db5-a7f4-4cad-bbaf-08d7c5f3cabc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 19:38:38.0437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT004
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/11/20 8:10 PM, Kees Cook wrote:
> On Tue, Mar 10, 2020 at 06:45:32PM +0100, Bernd Edlinger wrote:
>> This changes lock_trace to use the new exec_update_mutex
>> instead of cred_guard_mutex.
>>
>> This fixes possible deadlocks when the trace is accessing
>> /proc/$pid/stack for instance.
>>
>> This should be safe, as the credentials are only used for reading,
>> and task->mm is updated on execve under the new exec_update_mutex.
>>
>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> 
> I have the same question here as in 3/4. I should probably rescind my
> Reviewed-by until I'm convinced about the security-safety of this -- why
> is this not a race against cred changes?
> 

The credentials of a thread that is currently executing execve is already
set in the bprm structure, however the credential in the task structure
is not yet changed, as well as the process memory map keeps stable
until the exec_update_mutex is acquired.

What is done with this functions is access the call stack of the
process before the new executable is actually started.

There would immediately be a severe security problem if we did
not use any mutex as the check would be then with the old credential,
but the stack trace would potentially reveal secret function
calls that are done by a setuid program when it starts up.


Bernd.


> -Kees
> 
>> ---
>>  fs/proc/base.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index ebea950..4fdfe4f 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -403,11 +403,11 @@ static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
>>  
>>  static int lock_trace(struct task_struct *task)
>>  {
>> -	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
>> +	int err = mutex_lock_killable(&task->signal->exec_update_mutex);
>>  	if (err)
>>  		return err;
>>  	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH_FSCREDS)) {
>> -		mutex_unlock(&task->signal->cred_guard_mutex);
>> +		mutex_unlock(&task->signal->exec_update_mutex);
>>  		return -EPERM;
>>  	}
>>  	return 0;
>> @@ -415,7 +415,7 @@ static int lock_trace(struct task_struct *task)
>>  
>>  static void unlock_trace(struct task_struct *task)
>>  {
>> -	mutex_unlock(&task->signal->cred_guard_mutex);
>> +	mutex_unlock(&task->signal->exec_update_mutex);
>>  }
>>  
>>  #ifdef CONFIG_STACKTRACE
>> -- 
>> 1.9.1
> 
