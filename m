Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7275518090E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCJUWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:22:51 -0400
Received: from mail-oln040092064048.outbound.protection.outlook.com ([40.92.64.48]:13873
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726271AbgCJUWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 16:22:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyy9rVWfIi0ZLcOh9NP/2Ybi87RgWVxqCAtHekZYcw/EpIRXxsK4Vx/ZyuBpwv6Cg/Et1fZakQZLPVHn6mNVE2vNixNQreP6Oe4Ja5YIaA4NtK7XtmL/1+i4EIcSVcF4ohNszp00VViA5NScEYCIhZNA/maWDABc0bMctHgH1qNTLjo24MogI02wOdPwDb4Q7YaJJlMeLGw6kIYz+7jV59ZdfIKEgIeWr+IZmlDr/LUO9XVHLNV0G3LlDMJdclbvo7tCQto8nRDo5+/v6lvhfazi25vwVPjyyTsrVYBGJrPb6yBbnaa6tRyiucTeTZNs1B47WMGgx2qEkur9HDMM5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcXB5XtDW/edbdTpwusVzq1L82skS1gFXqVS9psypK0=;
 b=c3O6kSTUW3rwRjrFu3HMlDxTTrOOlrF5NJX63RX37YMyfK03e+k9+xYxcYz2QSxQ0jrUJ+THmuhnS9np2Xu9peqnBrzo7Xww8RAMYUIXBEsxb1Pjn8u/EXEVsOhWV9N9JSV1wPDSjiqMN9zq1qQAJru+h+4haEXzdXnuELB1DM4bs4aYn5L12OKRrVoTShdB6Kdu7tPS92svuB8V9HJztNw3NBqrhFvc44brLI+4JOe8e5BChe9OEi5m8wms7EGRe9J5mqqzWPOdfAEBVmTZz/Fbk5FJk18J4ru/M6O6hkqlJsIFWbD3EXCRVcTx+6fOHpL1CI2INaXpXUMKm6NwEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VE1EUR01FT006.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e19::35) by
 VE1EUR01HT071.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e19::152)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 20:22:44 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.2.60) by
 VE1EUR01FT006.mail.protection.outlook.com (10.152.2.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 20:22:44 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:3CE61C4B30ED919C1D3E3EDD324DF5C05B73CCFB3F236699179013E6DD687BDC;UpperCasedChecksum:AEDC134E5B3D3B2925787B5CF20DB733AC0D6676C08BC3BB6EF68BC4ACE0E56D;SizeAsReceived:11076;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 20:22:43 +0000
Subject: Re: [PATCH] pidfd: Stop taking cred_guard_mutex
To:     Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
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
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>
References: <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
 <20200309195909.h2lv5uawce5wgryx@wittgenstein>
 <877dztz415.fsf@x220.int.ebiederm.org>
 <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
 <87k13txnig.fsf@x220.int.ebiederm.org>
 <20200310085540.pztaty2mj62xt2nm@wittgenstein>
 <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
 <CAG48ez2cUZMVOAXfHPNjKjYsMSaWkjUjOCHo0KYZ+oXQUW4viA@mail.gmail.com>
 <87k13sui1p.fsf@x220.int.ebiederm.org>
 <CAG48ez2vRgaEVJ=Rs8gn6HkGO6syL8MpSOUq7BNN+OUE1uYxCA@mail.gmail.com>
 <CAG48ez1LjW1xAGe-5tNtstCWxG2bkiHaQUMOcJNjx=z-2Wc2Jw@mail.gmail.com>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170AF454A8A9C37891B12B2E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 21:22:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <CAG48ez1LjW1xAGe-5tNtstCWxG2bkiHaQUMOcJNjx=z-2Wc2Jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR0202CA0033.eurprd02.prod.outlook.com
 (2603:10a6:208:1::46) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <7fec923a-0c06-b3c6-4d1c-8ffb3519eb0b@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR0202CA0033.eurprd02.prod.outlook.com (2603:10a6:208:1::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 20:22:41 +0000
X-Microsoft-Original-Message-ID: <7fec923a-0c06-b3c6-4d1c-8ffb3519eb0b@hotmail.de>
X-TMN:  [aY89ty6Xt9qP2QHF2IaNBexmBBz8dkRA]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 13e8903e-ea6c-4526-8199-08d7c530c98e
X-MS-TrafficTypeDiagnostic: VE1EUR01HT071:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QkxE4mMk6tSDP+UWD5iUrYlrTJ3Aeue0iIsK0QsbJikWLq6nnBzlcQg0c/llesJ24sM93h45h5LMTPmqO7IP3Q+Z7pw3Dp18QWaz4FM+0fyn1kw0FB9TtxuI8NxD6Qtz9GrWfAK3mW8BhXxlAy9S6CSWYlJYKOpAT5qbBLIFPdKVAHMVCkmVH1gfu7qAH5nE
X-MS-Exchange-AntiSpam-MessageData: 1DCOQLrn/aCJKAHLqkDJxKluroCpBT5TS5sYnA87kM+ObmAi+rYw8oDyKMmreKgDYrqsTgvUmOBySYjxyZSna52y01KtUgSRp62aayhGWHbzyJoR7ZzM4jHY0UjyTLDdDYJe8OKXCONrB6HDW7xweA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13e8903e-ea6c-4526-8199-08d7c530c98e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 20:22:42.9684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR01HT071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 9:10 PM, Jann Horn wrote:
> On Tue, Mar 10, 2020 at 9:00 PM Jann Horn <jannh@google.com> wrote:
>> On Tue, Mar 10, 2020 at 8:29 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> Jann Horn <jannh@google.com> writes:
>>>> On Tue, Mar 10, 2020 at 7:54 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>> During exec some file descriptors are closed and the files struct is
>>>>> unshared.  But all of that can happen at other times and it has the
>>>>> same protections during exec as at ordinary times.  So stop taking the
>>>>> cred_guard_mutex as it is useless.
>>>>>
>>>>> Furthermore he cred_guard_mutex is a bad idea because it is deadlock
>>>>> prone, as it is held in serveral while waiting possibly indefinitely
>>>>> for userspace to do something.
> [...]
>>>> If you make this change, then if this races with execution of a setuid
>>>> program that afterwards e.g. opens a unix domain socket, an attacker
>>>> will be able to steal that socket and inject messages into
>>>> communication with things like DBus. procfs currently has the same
>>>> race, and that still needs to be fixed, but at least procfs doesn't
>>>> let you open things like sockets because they don't have a working
>>>> ->open handler, and it enforces the normal permission check for
>>>> opening files.
>>>
>>> It isn't only exec that can change credentials.  Do we need a lock for
>>> changing credentials?
> [...]
>>> If we need a lock around credential change let's design and build that.
>>> Having a mismatch between what a lock is designed to do, and what
>>> people use it for can only result in other bugs as people get confused.
>>
>> Hmm... what benefits do we get from making it a separate lock? I guess
>> it would allow us to make it a per-task lock instead of a
>> signal_struct-wide one? That might be helpful...
> 
> But actually, isn't the core purpose of the cred_guard_mutex to guard
> against concurrent credential changes anyway? That's what almost
> everyone uses it for, and it's in the name...
> 

The main reason d'etre of exec_update_mutex is to get a consitent
view of task->mm and task credentials.

The reason why you want the cred_guard_mutex, is that some action
is changing the resulting credentials that the execve is about
to install, and that is the data flow in the opposite direction.


Bernd.
