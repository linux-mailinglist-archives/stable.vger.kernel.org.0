Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CDE180859
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 20:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgCJTnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 15:43:06 -0400
Received: from mail-oln040092067074.outbound.protection.outlook.com ([40.92.67.74]:51778
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726497AbgCJTnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 15:43:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2A6kAmnRgrMVHWi9QphwkbAopL04pJ4Ojz/DJkMax3rdMvc/1StmbSUG80B7liZ5W5SIXuRZewtv6n5bqASGRg+cga/vla+IyokmyInPqxwvtBrtpPL5Jhewwiv+7Hp+ZqiurFIQ1FT+ywZTEiCz5oNaaWjO4pquJxCQDvj2yNapcCML+kDBnrTZPxoGevS3hizyDignZRWYsHUfzs3C/529yN2/DBbTfDTeW6b6JFi+BfA3Y2yv1zmmXMBxRB3e3PY22qS+eXs0QzqIr7Iab6vf6uPZLn8vgMZBWRaVuWXFifxpXOhzBMQSppNVd/Kqgw6gYYhcH/MCvOPHzVjrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFm4MTuYTt1g52hWoTGB38cRFGP+hcZZsEueMK0bonk=;
 b=Crut7EAiwkTW15dZn+d0R2mx6yFAL0s9OPut8XcgeKPkPyHPASoDAjttc7kvYYfC7sgmQ8AdiLtM4dQ/9kBwwSf83PcSuDyWo6Xhaj3wtJas1B1KlEy8ag3LTN1Ky6YYC2gyfuza56C63Ed7+KlDj1DYt75OFgOTXP4vyfta/Xh+gXVdm85Nkff88ZIDmtoFs8JZdFB3L+tT4SNgkAIatdQDYqOdktjW+T64RNTrzlgalGLvmWW0kFjKEBkberrEF41AkRZZ6X72M8dqGHkMtuYQbPouc70sKakvegH02lq+hpQNVNDPNaYar9o+3D8LswQHv97f3fW8N7m9eMcXzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR02FT053.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1d::37) by
 HE1EUR02HT035.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1d::363)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 19:42:58 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.10.58) by
 HE1EUR02FT053.mail.protection.outlook.com (10.152.11.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 19:42:58 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:2F08D4F2D70E50DF6E3FAE1F1920DEFF60C6DFD89655B01D8F22B0ED78D886EF;UpperCasedChecksum:6D1B31FA854788FD84D6A550CA28869AE1F9EBA85ECB92ECAA0EE7B238949F73;SizeAsReceived:10336;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 19:42:57 +0000
Subject: Re: [PATCH 1/4] kernel/kcmp.c: Use new infrastructure to fix
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
 <AM6PR03MB517057A2269C3A4FB287B76EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k13svxtw.fsf@x220.int.ebiederm.org>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB517005BA273D6438BD5D0E71E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 20:42:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <87k13svxtw.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0032.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::19) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <829be068-5eb6-c666-3698-c22f5061325c@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0032.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 19:42:54 +0000
X-Microsoft-Original-Message-ID: <829be068-5eb6-c666-3698-c22f5061325c@hotmail.de>
X-TMN:  [tNZkuW7gjgOMltWxmQ8Hzlzcv5wn7a0h]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: c7d23077-feba-41d8-387a-08d7c52b3bbc
X-MS-TrafficTypeDiagnostic: HE1EUR02HT035:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /A6B93GpstSE72sN071qFFvGm5n1xwNuBerrX3YuMDEaPjvB0lgwKBWpPRLjgOnsrSHMqTUUksuE7BLCgGGb5TQdz0G8ZwBXN9ZUluUSrKXyB/0lroSugYDge0q0kyq5R7U8VwSXKubsDPrEbDgCtqKLEL+4q8a5IJrw65FfvDFTFtDdG4etpv2d2NqGK/YK
X-MS-Exchange-AntiSpam-MessageData: 94Y4s0sbg/84LyuryjYzBZWsAFrOxf78nL5OWh35eAEVgpjHBUxVZh9Xy0LueRQDdbC8f1bIuxi81snKwfQKogQoJI5rosHMmUx94RXVRwkp6iH0lt5yd2+CIRCfpB8pVMGiujjolS1Oe2AwdoliDA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d23077-feba-41d8-387a-08d7c52b3bbc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 19:42:57.5669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT035
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 8:01 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> This changes kcmp_epoll_target to use the new exec_update_mutex
>> instead of cred_guard_mutex.
>>
>> This should be safe, as the credentials are only used for reading,
>> and furthermore ->mm and ->sighand are updated on execve,
>> but only under the new exec_update_mutex.
>>
> 
> Can you add a comment that the exec_update_mutex is not needed for
> KCMP_FILE?  As both sets of credentials during exec are valid
> for accessing the files so exec_update_mutex does not matter.
> 

some files are closed by do_close_on_exec,
so in theory this allows you to examine files that
were open in the old user but closed for the new user
with either credential.

It is not a race condition, but it may be a security
concern.

> I don't think exec_update_mutex is needed for KCMP_SYSVSEM
> or KCMP_EPOLL_TFD either.  As I don't think exec changes either
> one of those.
> 

KCMP_EPOLL_TFD is also accessing file pointers,
that is possible.

It might be that KCMP_SYSVSEM is a missed optimization, but
I may have overlooked something.
I'd rather err on the safe side.

> Eric
> 
> 
>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>> ---
>>  kernel/kcmp.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/kcmp.c b/kernel/kcmp.c
>> index a0e3d7a..b3ff928 100644
>> --- a/kernel/kcmp.c
>> +++ b/kernel/kcmp.c
>> @@ -173,8 +173,8 @@ static int kcmp_epoll_target(struct task_struct *task1,
>>  	/*
>>  	 * One should have enough rights to inspect task details.
>>  	 */
>> -	ret = kcmp_lock(&task1->signal->cred_guard_mutex,
>> -			&task2->signal->cred_guard_mutex);
>> +	ret = kcmp_lock(&task1->signal->exec_update_mutex,
>> +			&task2->signal->exec_update_mutex);
>>  	if (ret)
>>  		goto err;
>>  	if (!ptrace_may_access(task1, PTRACE_MODE_READ_REALCREDS) ||
>> @@ -229,8 +229,8 @@ static int kcmp_epoll_target(struct task_struct *task1,
>>  	}
>>  
>>  err_unlock:
>> -	kcmp_unlock(&task1->signal->cred_guard_mutex,
>> -		    &task2->signal->cred_guard_mutex);
>> +	kcmp_unlock(&task1->signal->exec_update_mutex,
>> +		    &task2->signal->exec_update_mutex);
>>  err:
>>  	put_task_struct(task1);
>>  	put_task_struct(task2);
