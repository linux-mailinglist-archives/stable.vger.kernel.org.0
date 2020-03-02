Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7F9175F14
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 17:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgCBQCv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 2 Mar 2020 11:02:51 -0500
Received: from mail-oln040092075088.outbound.protection.outlook.com ([40.92.75.88]:31362
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727030AbgCBQCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 11:02:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=je2RXnG16y7NtkPWMF1zyTw5A33hyaZklCJPpq2ssSJno+cm3UGWwnoP4UWF8XLgHj0kc9Q2kidPh0ttod03kCAYm9L2umMtrvoGsVoUH+z+lifyTzUy6NHJYsp0hMrMuz5aRV3ghBrUDzh4nuveB2YSgkWGEubOHLYpadSpU9cKXpvI+LHob56TDaiVs3MyIUpqyVOGk94tq80p8rEIpLOhVTaPuk342FCdSqRg8mMR1s7PgERsiA4UJrQQF1BKR8TaUjDQX5derZeG5bCqEx8cWNnTNfFZ+uDCHywB8QQ2QpPrac21SnFvvAHbEnpL80fIhlf9QY948BLsaXMUBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugYMYDjtDWGkDUB+qcm3BpyPM1qsEjY4td3FtEgCv5o=;
 b=KEdz1wAqCyGKNR6LMG8VWFYrUTImppcPYJMExRojR2pMQqWx6qN6d150pMyvf7JP1JFohfCD05GfFCtbih5qKtKt3BxRGyFxj/72MAMkzKO0yeH3BSc0W5lO/LmIWZSqkVG7fGwCqBG6zboB9kM1ExmuRMCbs0U+zwf/807q35+6p+nvZXGBoycVgbEM4qAcHukLa8ZCU8q+q9mmjqVVc4PRZbITk0MjC2/rAv9661whhfTtO+1mj1jedLYk9c4GgMhkhvw8cGajtK/R4kAof/7kHQpjPaePhg5WpVBgNgmLYhuH6RGWKJ0rkN7SGXaxv1dun17epIypmJuX9ddc2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB3EUR04FT028.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::39) by
 DB3EUR04HT086.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::111)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Mon, 2 Mar
 2020 16:02:46 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.58) by
 DB3EUR04FT028.mail.protection.outlook.com (10.152.24.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 16:02:46 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 16:02:46 +0000
Received: from [192.168.1.101] (92.77.140.102) by FRYP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Mon, 2 Mar 2020 16:02:45 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
        Kees Cook <keescook@chromium.org>,
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
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCHv2] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv2] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8AjGwZG4WijWc0+aQpdADP+q6qg02ufjgACXoYCAAASqH4AAAMAA
Date:   Mon, 2 Mar 2020 16:02:46 +0000
Message-ID: <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <CAG48ez3QHVpMJ9Rb_Q4LEE6uAqQJeS1Myu82U=fgvUfoeiscgw@mail.gmail.com>
 <20200301185244.zkofjus6xtgkx4s3@wittgenstein>
 <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
 <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
In-Reply-To: <87k142lpfz.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FRYP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::23)
 To AM6PR03MB5170.eurprd03.prod.outlook.com (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:EE7FB4A1F22E77C5C75377EF02B552EB133B89EE617356F5276311CEA1CF0AD8;UpperCasedChecksum:496B99C73651966DAA91F10A28864B699E97B29E8D02E46B5F5DE04D6DB6FF0D;SizeAsReceived:9310;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [kSYEysC4SiccGesrCrUHP0/d1EvB53nl]
x-microsoft-original-message-id: <dd57f56a-436e-067b-66e5-d2b8d6465139@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 616d6ef6-bc85-4308-8d3a-08d7bec32617
x-ms-traffictypediagnostic: DB3EUR04HT086:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eEK+e5KAclWlOlAAn8XMCi95cq3q9/R7QdS9DM4ouOxM70qm4UKOk4cm+9tzQBoIW8rQbjKhc5hh6EVO9IRLzeM2YMN44TvQgPy7ge7MwSQoxh3/5voQCMWCMXOF9ZVOtu7Sfjx2UZiK+Xa67hEdgX0uxD98uddpwGxcCyP4qi37WwHzWT5r5dZmVDEuZXe+
x-ms-exchange-antispam-messagedata: ohDQMtYLuVYlPaKhrZLlFUvPCsox8rDD54wuxyD6Ka1bHs2ImLJaxG7p6YlusvReXllRwXlxHEwEKfaJCg1MNBUQJ3pWXEKTQYbEN01VDWz+662eMoMTCCzgFzIEDKse+sIzjsVuAsbuiLVRMcR7IA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <B4FA37A5D9EF064A8F106F1FF744B0E3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 616d6ef6-bc85-4308-8d3a-08d7bec32617
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 16:02:46.6050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT086
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/2/20 4:57 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>>
>> I tried this with s/EACCESS/EACCES/.
>>
>> The test case in this patch is not fixed, but strace does not freeze,
>> at least with my setup where it did freeze repeatable.
> 
> Thanks, That is what I was aiming at.
> 
> So we have one method we can pursue to fix this in practice.
> 
>> That is
>> obviously because it bypasses the cred_guard_mutex.  But all other
>> process that access this file still freeze, and cannot be
>> interrupted except with kill -9.
>>
>> However that smells like a denial of service, that this
>> simple test case which can be executed by guest, creates a /proc/$pid/mem
>> that freezes any process, even root, when it looks at it.
>> I mean: "ln -s README /proc/$pid/mem" would be a nice bomb.
> 
> Yes.  Your the test case in your patch a variant of the original
> problem.
> 
> 
> I have been staring at this trying to understand the fundamentals of the
> original deeper problem.
> 
> The current scope of cred_guard_mutex in exec is because being ptraced
> causes suid exec to act differently.  So we need to know early if we are
> ptraced.
> 

It has a second use, that it prevents two threads entering execve,
which would probably result in disaster.

> If that case did not exist we could reduce the scope of the
> cred_guard_mutex in exec to where your patch puts the cred_change_mutex.
> 
> I am starting to think reworking how we deal with ptrace and exec is the
> way to solve this problem.
> 
> Eric
> 
