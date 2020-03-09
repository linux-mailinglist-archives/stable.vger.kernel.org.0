Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC8A217E85E
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgCIT1N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 15:27:13 -0400
Received: from mail-oln040092074079.outbound.protection.outlook.com ([40.92.74.79]:25813
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725992AbgCIT1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 15:27:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQ67fH9gpW1qd/9XtnGUsZzxnLCp8kFPh/NnOGCAzZ8ZFNTYPvOJ2Ij22dURElGsjpgg4L/skOHGczm/stWQVUy7Bvl2hDdImr+gBSx9Wu5tyOV3/b2c9n1YbLukH1F1s8e2FXs0cMu3LpbI3EdRNPFLEdHvbv5YFCdusRMze3rTEfng6gqkHSSzndE5kYYdmQod/4GSugv4vtzkteUKv07a6yFPulUs1uJUz7cl6nRnYRKFgIdLwYsQu8Da4e+GZe/mX5O/Z8FIM73/7xD7Ggp8j8hgyFCGStI5fRrLuwwcX4B0vQa+7NfWd9Gib4SDNEf0c/F4I0gTdg8ad3EIwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qV+f3ezPIzB/u0ub2WCLVwnugNFFo6iQr9wWg3ERqBg=;
 b=F3opbmMqJQudRrtCQ2kXIDHj4M2LyXh2too0TaLD+7+b9damptesA5vF4BzVMKgkFiLGipJwQdKZJ3h7uhIc08htG3ql0A03UJGd9cYSh72B6MVScvIEx+DJZVriZOtna2/xA5R8Go6B8MmdGx6kpn/ikHDS+ccZevwZoYps+DEHPFhk8fGLvneOOYvIDAU2R/tY4kwaZXUKAaTNyPlsQsu3T9tDMZvpNF6QxfUhKtpdNuM/x2jvsFt04HJ8f0PjddyodeckucQi00B1ui/OMoLGHfJF7HG7xHtZ7AFYbf63k69tNk9nBsVJgc3TlEepIs+3m8lQxvsiZCczoysEqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR04FT025.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0d::35) by
 HE1EUR04HT242.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0d::185)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 19:27:07 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.26.60) by
 HE1EUR04FT025.mail.protection.outlook.com (10.152.27.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 19:27:07 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 19:27:07 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0051.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Mon, 9 Mar 2020 19:27:04 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Christian Brauner <christian.brauner@ubuntu.com>,
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
Subject: Re: [PATCH v2 1/5] exec: Only compute current once in flush_old_exec
Thread-Topic: [PATCH v2 1/5] exec: Only compute current once in flush_old_exec
Thread-Index: AQHV9ZHPFX16pJkAgEa5cakb87d5R6hASgaAgAA9eBuAAAV1gIAAGVQA
Date:   Mon, 9 Mar 2020 19:27:06 +0000
Message-ID: <AM6PR03MB5170051D0E2FF2B6772189F6E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87pndm5y3l.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170FBDA2F0F19ECF2906703E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87mu8p4elb.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51700E6A252CA1E3093B3ED8E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
In-Reply-To: <AM6PR03MB51700E6A252CA1E3093B3ED8E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0051.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::20) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:BBD5AB725885809191725ED86FF2795C5D228C0C94C44F429CAC1C5471B58054;UpperCasedChecksum:554CDE560CC1A53740F55DA4E0690775688176AD61F0B5C7B7E9AE58ACC25E50;SizeAsReceived:9989;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [A6bJYUQbLM4Tyu3Vck1oLGye8YGMUiax]
x-microsoft-original-message-id: <ac137e26-34c5-0ace-9e99-6b7447802a99@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 48f02d6a-a849-4537-5e8c-08d7c45fdab1
x-ms-traffictypediagnostic: HE1EUR04HT242:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Ub1ITtPpsoHh3oIsE6eM577SKl1VSH402Qiy9rN+wkLzHQL/abTL32qpbjYvBF8OlyZrrpqKi4wYijN9wbHYuT0AyUTEXK21KRajkKLoFiggKKaRZG8vL+rYaeNlGXtMj7kRQ9NI8R7UKNkz4cjYl5+NZO0wcssA+m3LgP28AshRLVaVEqGILwceUoBUz9C
x-ms-exchange-antispam-messagedata: D4sD6C0tRl3FbqRkJWniBTCI4db8FbZ5L9MzUGb14pVGdE5YMWal/8zaTiN9FInDYX28cKOEHpE895zrcN3bJHobbpHzXRgD4Kjpb5q+pjAtUxuAwHIMOpo5VO/7cHrEnww1DQDzWrYwJIT3BbvttQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <E0967702A2E3524C95DB0C9796E6FFA2@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f02d6a-a849-4537-5e8c-08d7c45fdab1
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 19:27:06.9207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR04HT242
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/20 6:56 PM, Bernd Edlinger wrote:
> On 3/9/20 6:34 PM, Eric W. Biederman wrote:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>
>>> On 3/8/20 10:35 PM, Eric W. Biederman wrote:
>>>>
>>>> Make it clear that current only needs to be computed once in
>>>> flush_old_exec.  This may have some efficiency improvements and it
>>>> makes the code easier to change.
>>>>
>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> ---
>>>>  fs/exec.c | 9 +++++----
>>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/exec.c b/fs/exec.c
>>>> index db17be51b112..c3f34791f2f0 100644
>>>> --- a/fs/exec.c
>>>> +++ b/fs/exec.c
>>>> @@ -1260,13 +1260,14 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
>>>>   */
>>>>  int flush_old_exec(struct linux_binprm * bprm)
>>>>  {
>>>> +	struct task_struct *me = current;
>>>>  	int retval;
>>>>  
>>>>  	/*
>>>>  	 * Make sure we have a private signal table and that
>>>>  	 * we are unassociated from the previous thread group.
>>>>  	 */
>>>> -	retval = de_thread(current);
>>>> +	retval = de_thread(me);
>>>>  	if (retval)
>>>>  		goto out;
>>>>  
>>>> @@ -1294,10 +1295,10 @@ int flush_old_exec(struct linux_binprm * bprm)
>>>>  	bprm->mm = NULL;
>>>>  
>>>>  	set_fs(USER_DS);
>>>> -	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
>>>> +	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
>>>>  					PF_NOFREEZE | PF_NO_SETAFFINITY);
>>>
>>> I wonder if this line should be aligned with the previous?
>>
>> In this case I don't think so.  The style used for second line is indent
>> with tabs as much as possible to the right.  I haven't changed that.
>>
>> Further mixing a change in indentation style with just a variable rename
>> will make the patch confusing to read because two things have to be
>> verified at the same time.
>>
>> So while I see why you ask I think this bit needs to stay as is.
>>
> 
> Ah, okay, I see.
> Thanks for explaining this rule, I was not aware of it,
> but I am still new here :)
> 

Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>


Bernd.
