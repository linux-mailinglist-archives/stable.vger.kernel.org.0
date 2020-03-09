Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A33CC17E854
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgCITZD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 15:25:03 -0400
Received: from mail-oln040092074084.outbound.protection.outlook.com ([40.92.74.84]:21838
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbgCITZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 15:25:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5fR3R6NRmtmYFXf90r1KviiRMR7E1L7qiV+TTXxEk2OZaJScmjYKT1+bdO8wsFAj98rWUpgLjUSYChGM98RgOr+jqcAekTSHIfm0hoDrwELnFNfCWERtepNkT0qCCtWI40uOuPQ5jn6cBEhVS6eq8P3+kvpOf9kAmxyRo7VPrSN5VD+OfDynNG2uhNl0Pt1Hxlqy4JUSlzNgrPgsmrBe0LfDtBdiF3n5YHiKMvEubCEFhbaKk75KgseWQYtlbKzWx9xgoL6xJba3MkfeTA+uaGDRk45DEBKOkXeLxrGL1qicLyHa9XGHAGqacotRR6a2s6orLmIml72x+i8fL6+Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtVsWtk2lDzAfqdQxqczErsKzeZfKoLfMiXjfWi5gyI=;
 b=ClyikgLAz2iIcV0Nk8UDJPBK4wy4xDUTlBecsqwpwTh1rT1og5FK2nkaboV3DmCS/OBQEl2QJRRH3sgveVZ/KIgh8kQH+uG9jZbOlaKMZpXINQmlKKJrFbrJavtLg67Pfw8qT/btpXfxhbw6ItVdGHwHlFJpusuWTDYz3zYZlSYlGhj6gKLCZ4RMAzBIEAbuc1ESNzPG04W70WEVkG/QJarEeLU5q5//zYeBPOsJWdPSxAlEJkUF7+VaKdGUNkVFiMaD72z1/ymLj7EvhXITr7banpy73duSHyfqpcbcq2d0OaqEVd7tprvQHmCtMakFs+iR6GoHf4oTDSmJCEBMaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR04FT025.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0d::35) by
 HE1EUR04HT225.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0d::410)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 19:24:58 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.26.60) by
 HE1EUR04FT025.mail.protection.outlook.com (10.152.27.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 19:24:58 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 19:24:58 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR0102CA0029.eurprd01.prod.exchangelabs.com (2603:10a6:208:14::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Mon, 9 Mar 2020 19:24:56 +0000
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
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Topic: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Index: AQHV9ZJHYfsGvDLnM0SksOJ5MpqOZahARvEAgABCQ42AAAUtgIAAA0/bgAADytmAAANO2YAAAnOAgAAE4zCAAAWQgA==
Date:   Mon, 9 Mar 2020 19:24:58 +0000
Message-ID: <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <878sk94eay.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y12yc7.fsf@x220.int.ebiederm.org> <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
In-Reply-To: <871rq12vxu.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0102CA0029.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::42) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:71A99711ADA16EC1C24CC5F8D4E994C5C61558DC91E28170A71D7A2DE7384D8B;UpperCasedChecksum:138B6000CDB757DAF3D086CF6285744E3811657112A8F186F10221148F6207F1;SizeAsReceived:9999;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [B/29M+tTQ8jZwO8bBX+aFjHrnBQUzxaI]
x-microsoft-original-message-id: <8bc15c6d-2811-5965-cf3a-0dee5d3ef4a7@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 5b640f5a-1970-4e2f-2a79-08d7c45f8e32
x-ms-traffictypediagnostic: HE1EUR04HT225:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yRwriaax4luQh2eE4Kv/5gl1xgtV+JhFn3r4omhcZdQLtpEnZ5wArAUY4QNOr9h2IZIMedZxh+rethkj8ygU0pcUw/1z20Mmt+DeKfEBy6dVNVB9GGIRS0wJwO0n+/dU/4JSft9BH+xomh1RItAhwsuXYvw9U3slEuQRKa89/6j+UP2Oh6AidizbkcozgOSgMI2zIDI+G18wMkpMWz2COa8Mq1fFnGz9kBwFiCRCBe4=
x-ms-exchange-antispam-messagedata: ihJ0a1uBNLzETZ0EmKa6rky1cWiaSkYyOGteR6EOKC18aVBNv+NQojy58E5NM24js9Phk+70KCAHX1D/k7WThPHE2uRSy6XlGK8SCQCnVBeuJlHfU+++kQzGOumEGPWBhsUPpC6BDlGBMcqv1aoohQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <D977AB8180FC5246BAA1C16ED22CAA18@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b640f5a-1970-4e2f-2a79-08d7c45f8e32
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 19:24:58.6072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR04HT225
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/9/20 8:02 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/9/20 7:36 PM, Eric W. Biederman wrote:
>>>
>>>
>>> Does that sound better?
>>>
>>
>> almost done.
> 
> I think this text is finally clean.
> 
>     exec: Add exec_update_mutex to replace cred_guard_mutex
>     
>     The cred_guard_mutex is problematic as it is held over possibly
>     indefinite waits for userspace.  The possilbe indefinite waits for
>     userspace that I have identified are: The cred_guard_mutex is held in
>     PTRACE_EVENT_EXIT waiting for the tracer.  The cred_guard_mutex is
>     held over "put_user(0, tsk->clear_child_tid)" in exit_mm().  The
>     cred_guard_mutex is held over "get_user(futex_offset, ...")  in
>     exit_robust_list.  The cred_guard_mutex held over copy_strings.
>     
>     The functions get_user and put_user can trigger a page fault which can
>     potentially wait indefinitely in the case of userfaultfd or if
>     userspace implements part of the page fault path.
>     
>     In any of those cases the userspace process that the kernel is waiting
>     for might make a different system call that winds up taking the
>     cred_guard_mutex and result in deadlock.
>     
>     Holding a mutex over any of those possibly indefinite waits for
>     userspace does not appear necessary.  Add exec_update_mutex that will
>     just cover updating the process during exec where the permissions and
>     the objects pointed to by the task struct may be out of sync.
>     
>     The plan is to switch the users of cred_guard_mutex to
>     exec_update_mutex one by one.  This lets us move forward while still
>     being careful and not introducing any regressions.
>     
>     Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
>     Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>     Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
>     Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
>     Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
>     Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
>     Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")

I checked the urls they all work.
Just one last question, are these git references?
I can't find them in my linux git tree (cloned from linus' git)?

Sorry for being pedantically.


>     Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> 
> Bernd do you want to give me your Reviewed-by for this part of the
> series?
> 

Sure also the other parts of course.

Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>

> After that do you think you can write the obvious patch for mm_access?
> 

Yes, I can do that.
I also have some typos in comments, will make them extra patches as well.

I wonder if the test case is okay to include the ptrace_attach altough
that is not yet passing?


Thanks
Bernd.
