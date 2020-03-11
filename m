Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D232B1810C8
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 07:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgCKGdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 02:33:43 -0400
Received: from mail-oln040092072109.outbound.protection.outlook.com ([40.92.72.109]:36565
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725976AbgCKGdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 02:33:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BkQoyodOGuanQqn60XJdSuIGNIs45f03IhjyrDsXdDbSIXfuUJcS600Rx8jrFVL/lPzIJ1t2fIcLPIsKRvkt6hzIMQ5ToctS7v+zX7OIXUDZGMpBhR/dxuFM/+mbgwknsKmoG5xyAIThlCCFmn1BU6uUta8rOGuhcUrZur/CR0rKVAjQfPTxt7MK9jWhhAYkQYCpgJw0ns9ku2asV1gNExAU347JxkJtL2bPCLUCQkLXT89Fl4U6HEm0ohLAPe92y+hdFLxTeQoV9uv38dppeY9YeR9cNywu0DPEb+9YWT2i6VwF4GdXabxKKarvCTiJ/a8TJrIYy6niCl7tl2K4gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hy2oJALEc5rzaRAd9jlN7dgF3YpzFHwMOZPWzaYkvX8=;
 b=UXrphSl8pY0asCOaJdEvc/0khUwZ2aPNI8+6NjKgfOxl5SuzF093oGocGFVbusBbLcceT8r2ULt4q38JQEqBeWpWduSGYOSP/heQPzThADhyjKZzZAPVCaxVAOLpVwDcuSuZaZqaeR1CMseikbwJkSeVjrzbM4P+cVj+BYziVf5kuHXIdvG6NwbEZehh9lk+9cKmFz42iLVJ2wtWQGB/S92zht0amnNed5gQq7gVcOi/40tdXsc9TkoFwvfgKfPtI07f+vXsVlZ36aAIYi912BO3ib+rD9CJhaMyIcrB87u+CzwblRwOsO7roEfqxD8m6nsR4fMsOmfVriKk2wMFCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB5EUR03FT044.eop-EUR03.prod.protection.outlook.com
 (2a01:111:e400:7e0a::35) by
 DB5EUR03HT066.eop-EUR03.prod.protection.outlook.com (2a01:111:e400:7e0a::489)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Wed, 11 Mar
 2020 06:33:37 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.20.58) by
 DB5EUR03FT044.mail.protection.outlook.com (10.152.21.167) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Wed, 11 Mar 2020 06:33:37 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:9AA8DFA6C3A9D231681078A0264FE7C5FBEBCC42E563BD0A5AAD11D2D2E43FB4;UpperCasedChecksum:66486F57FF7ACD5D0388A7B1F71234B9E9C2C1BE88299172EF692828864231CD;SizeAsReceived:10301;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 06:33:37 +0000
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
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
 <CAG48ez13XXWNRLrPFRHRsvPKSwSK1-6k+1F7QujWOJtVuk0QHg@mail.gmail.com>
 <87wo7roq2c.fsf@x220.int.ebiederm.org>
 <CAG48ez1j2=pdj0nc1syHkh6X4d=aHuCH1srzA6hT7+32QD+6Gg@mail.gmail.com>
 <87k13roigf.fsf@x220.int.ebiederm.org>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB51709C444F21281F6A40F039E4FC0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Wed, 11 Mar 2020 07:33:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <87k13roigf.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0043.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::20) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <08352807-ae9f-368a-10a8-0d284f7510ac@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0043.eurprd06.prod.outlook.com (2603:10a6:208:aa::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13 via Frontend Transport; Wed, 11 Mar 2020 06:33:35 +0000
X-Microsoft-Original-Message-ID: <08352807-ae9f-368a-10a8-0d284f7510ac@hotmail.de>
X-TMN:  [IKTO541afmV/36yuJTHQVWsz8qLIFX6S]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 585b81e9-adc5-4e44-76a4-08d7c586210a
X-MS-TrafficTypeDiagnostic: DB5EUR03HT066:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xK7OpJJS8zwMqLWYqI2c0TOpKAxTlKPMIWVgvnhSfKX/f1I7LQ4IPWv+z2uU413o7USqSFvcMHro8SmLl/O9TNUi+ZwwVkfzacevSZam64DNTxUjpQ3LLBOAN66084UGGXXCglABKNDxy3HSbXuv5xPV1cWpYRK2KvRRaKvn/e3pMQ/YcnNUj6jvbbeVe3vB
X-MS-Exchange-AntiSpam-MessageData: DqAC6CZ4s6U6h9IMUICg4ejxyShJTUELeTZpgzZkzTnZRym9NrkwWspoLdn+Q+LCJtNXUI0Od+XNS7P+2IZfe86tkTm+lFfWGP7uT5sG7bbqiZUzYu4JKy4CQqjp/+qLHc1qVPhsxCl6hAAQ/hKURw==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585b81e9-adc5-4e44-76a4-08d7c586210a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 06:33:37.0625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT066
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/11/20 1:15 AM, Eric W. Biederman wrote:
> Jann Horn <jannh@google.com> writes:
> 
>> On Tue, Mar 10, 2020 at 10:33 PM Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Jann Horn <jannh@google.com> writes:
>>>> On Sun, Mar 8, 2020 at 10:41 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>>>> over the userspace accesses as the arguments from userspace are read.
>>>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>>>>> threads are killed.  The cred_guard_mutex is held over
>>>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>>>
>>>>> Any of those can result in deadlock, as the cred_guard_mutex is held
>>>>> over a possible indefinite userspace waits for userspace.
>>>>>
>>>>> Add exec_update_mutex that is only held over exec updating process
>>>>> with the new contents of exec, so that code that needs not to be
>>>>> confused by exec changing the mm and the cred in ways that can not
>>>>> happen during ordinary execution of a process.
>>>>>
>>>>> The plan is to switch the users of cred_guard_mutex to
>>>>> exec_udpate_mutex one by one.  This lets us move forward while still
>>>>> being careful and not introducing any regressions.
>>>> [...]
>>>>> @@ -1034,6 +1035,11 @@ static int exec_mmap(struct mm_struct *mm)
>>>>>                         return -EINTR;
>>>>>                 }
>>>>>         }
>>>>> +
>>>>> +       ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
>>>>> +       if (ret)
>>>>> +               return ret;
>>>>
>>>> We're already holding the old mmap_sem, and now nest the
>>>> exec_update_mutex inside it; but then while still holding the
>>>> exec_update_mutex, we do mmput(), which can e.g. end up in ksm_exit(),
>>>> which can do down_write(&mm->mmap_sem) from __ksm_exit(). So I think
>>>> at least lockdep will be unhappy, and I'm not sure whether it's an
>>>> actual problem or not.
>>>
>>> Good point.  I should double check the lock ordering here with mmap_sem.
>>> It doesn't look like mmput takes mmap_sem
>>
>> You sure about that? mmput() -> __mmput() -> ksm_exit() ->
>> __ksm_exit() -> down_write(&mm->mmap_sem)
>>
>> Or also: mmput() -> __mmput() -> khugepaged_exit() ->
>> __khugepaged_exit() -> down_write(&mm->mmap_sem)
>>
>> Or is there a reason why those paths can't happen?
> 
> Clearly I didn't look far enough. 
> 
> I will adjust this so that exec_update_mutex is taken before mmap_sem.
> Anything else is just asking for trouble.
> 

Note that vm_access does also mmput under the exec_update_mutex.
So I don't see a huge problem here.
But maybe I missed something.


Bernd.

