Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D68D18E553
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 23:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgCUWx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 18:53:28 -0400
Received: from mail-oln040092069093.outbound.protection.outlook.com ([40.92.69.93]:51332
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726859AbgCUWx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 18:53:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2Y9mruYKhbUrImtJFe5CDt11MdXD63sNHASV4CEe8i9fWfwJVrrElABRoPFgStrfTFCjVfoI5Nh+OBKj6IKgerGgJhRgpI309+HPT1bMfv+48w2iJT+gyJT6qXe9cZxzHTePe0iE4KV3WIDyXQ47U5U0FOqvQ+/czVNnrIiBoyTa/5h4bqShF/2yIWkWBsCiNU2Sg6bBVETL0Nrd747G6asWKoANe/indtwCpWtr+CyiPP1kbSzHkbaEPLBFZ9umPDbdVzkHIlzxFhqsCT/YDGRvw8SiN36ABoskhkU0g9T1HHcN6WSiFmu0rnqlPbT4/YDq4ORtMHQfvXNva/aLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVX0RExiiLfPEtVkikkDnkeUd86tjMBMfu5NzmYuZT0=;
 b=WHTkmeGg2XToeBbff437QxHhvzBmQXsspo6n6U+LuMsEFjvzjRirlhY3SXmQgD7gm6blXqWE+bx98b1POWpVx10rsSvcJiRg9yamR5F6rTpHHoziLroulsd1LcNcz3xQEMOXQdnmnx5GWaAqFr4UJLCsq+XncmN0+csw7QqKKFPvhqxEkMMqdgqiWLPWYdAhacmMI2T/Al+IMORmmbxpAUQGOiJ+t1e3QvlQhzuxgxSeQ+9pYu8Uv6wupJgSJVXBazVDbq5WblEpJCp5oeYGtS09sAXPVE4A+L70OQJtoZnHkRCZwEAwTTy3sxVVjDy9YKUHSwHhOv5Daq12G+VgEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR02FT064.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1d::36) by
 HE1EUR02HT064.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1d::315)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Sat, 21 Mar
 2020 22:53:19 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.10.52) by
 HE1EUR02FT064.mail.protection.outlook.com (10.152.11.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Sat, 21 Mar 2020 22:53:19 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:01C4DCF5FDE9EFDBD2460762F28478E7593B6238B7EE2A8B1F62A4631F023DE4;UpperCasedChecksum:8FE68762A64831AD98D80B11655804569AE010027E7F4D54E8AE1E08FBEEF15F;SizeAsReceived:10116;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.021; Sat, 21 Mar 2020
 22:53:19 +0000
Subject: Re: [PATCH v4 3/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
References: <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
 <AM6PR03MB5170353DF3575FF7742BB155E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <532ce6a3-f0df-e3e4-6966-473c608246e1@virtuozzo.com>
 <AM6PR03MB51705D8A5631B53844CE447CE4F60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <13c4d333-9c33-8036-3142-dac22c392c60@virtuozzo.com>
 <AM6PR03MB5170110A5D332DD0C1AC929FE4F70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <f7c1508a-a456-6ae4-a81e-8e8aa41d8d39@virtuozzo.com>
 <AM6PR03MB5170946BCC61F5D6CA233390E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703082215BDFE074E9D735E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <20200319091907.GC3495501@kroah.com>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB51707C912CFAE40FF965C811E4F20@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sat, 21 Mar 2020 23:53:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <20200319091907.GC3495501@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::11) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <63283332-befe-1290-6b18-f774c986ddc9@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by FR2P281CA0024.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.17 via Frontend Transport; Sat, 21 Mar 2020 22:53:18 +0000
X-Microsoft-Original-Message-ID: <63283332-befe-1290-6b18-f774c986ddc9@hotmail.de>
X-TMN:  [6QBtbUp/34wbOGa7A8V7VpMyw/umrTyd]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 08dc1875-3879-4303-c515-08d7cdeaa65e
X-MS-TrafficTypeDiagnostic: HE1EUR02HT064:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZP3QTdZlASRKnROnIqt3HGmRpoyq2mdM4pnRw5B6vT3Sk2BR+PnZJtA89pyg9bwTYXObg9EYPqZX3mLVhC26BB4M3yu0rgpUOqSpV/QUmZ1CpTrnR2ddcHTu+4wyoJqa9HxEhV+xLCspggnXCKZ3HeqPfppTPbGGqPEQNUAjSQGqj1rCrPiGVjc8Jn74QIIILzA/0BkK1i/MHMVitDQTyN0tbm6b+//9h/VUxZdP4A=
X-MS-Exchange-AntiSpam-MessageData: 7nMOEVbAa+4FHaYui1/OIlx2cSlo4d4VaNsyPJUHhz/AWwL+v6FFwIiq2L5/YwRTciewcD2FSS0KzOMAWgFk/pW5uPH7zkZm3UbuB42jTTdAAU9VKK7QXEHnFOhssbhiQFZrC8WAzkj/qxBNaTwsbA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08dc1875-3879-4303-c515-08d7cdeaa65e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2020 22:53:19.6922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT064
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/19/20 10:19 AM, Greg Kroah-Hartman wrote:
> On Thu, Mar 19, 2020 at 10:13:20AM +0100, Bernd Edlinger wrote:
>> Ah, sorry this is actuall v4 5/5.
>> Should I send a new version or can you handle it?
> 
> This thread is a total crazy mess of different versions.
> 
> I know I can't unwind any of this, so I _STRONGLY_ suggest resending the
> whole series, properly versioned, as a new thread.
> 
> Would you want to try to pick out the proper patches from this pile?
> 
> thanks,
> 
> greg k-h
> 

Okay, meanwhile I collected everything I could find from this thread
and sent it again:

[PATCH v6 00/16] Infrastructure to allow fixing exec deadlocks
https://lore.kernel.org/lkml/AM6PR03MB5170B2F5BE24A28980D05780E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 01/16] exec: Only compute current once in flush_old_exec
https://lore.kernel.org/lkml/AM6PR03MB5170FC93B158EB8179F91D6AE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 02/16] exec: Factor unshare_sighand out of de_thread and call it separately
https://lore.kernel.org/lkml/AM6PR03MB51708AECEA6E05CAE2FDC166E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 03/16] exec: Move cleanup of posix timers on exec out of de_thread
https://lore.kernel.org/lkml/AM6PR03MB5170CCB8D8B36F6002446FBDE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 04/16] exec: Move exec_mmap right after de_thread in flush_old_exec
https://lore.kernel.org/lkml/AM6PR03MB5170FDB2C9B5225224B76398E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 05/16] exec: Add exec_update_mutex to replace cred_guard_mutex
https://lore.kernel.org/lkml/AM6PR03MB5170739C1B582B37E637279EE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 06/16] exec: Fix a deadlock in strace
https://lore.kernel.org/lkml/AM6PR03MB51709A321EBA829CC36EE1F8E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 07/16] selftests/ptrace: add test cases for dead-locks
https://lore.kernel.org/lkml/AM6PR03MB517022530A9BECDBCAADC8D2E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 08/16] mm: docs: Fix a comment in process_vm_rw_core
https://lore.kernel.org/lkml/AM6PR03MB517027F6ACBB4CF2D9BF014CE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 09/16] kernel: doc: remove outdated comment cred.c
https://lore.kernel.org/lkml/AM6PR03MB51705CEFAB7D02E6EA6CEBA6E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 10/16] kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
https://lore.kernel.org/lkml/AM6PR03MB5170FFDE1D7BF09DD2663EDEE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 11/16] proc: Use new infrastructure to fix deadlocks in execve
https://lore.kernel.org/lkml/AM6PR03MB5170C4D177DD76E3C65E8033E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 12/16] proc: io_accounting: Use new infrastructure to fix deadlocks in execve
https://lore.kernel.org/lkml/AM6PR03MB51701CB541B08F21D56DCAC9E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 13/16] perf: Use new infrastructure to fix deadlocks in execve
https://lore.kernel.org/lkml/AM6PR03MB51704A188C3A1FA02B76B9EFE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH v6 14/16] pidfd: Use new infrastructure to fix deadlocks in execve
https://lore.kernel.org/lkml/e2ae1c06-b205-a053-d36c-045be27b3138@hotmail.de/

[PATCH v6 15/16] exec: Fix dead-lock in de_thread with ptrace_attach
https://lore.kernel.org/lkml/b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de/

[PATCH v6 16/16] doc: Update documentation of ->exec_*_mutex
https://lore.kernel.org/lkml/3ce46b88-7ed3-2f21-c0ed-8f6055d38ebb@hotmail.de/


Each of the patches in this series build on the previous one and are independent from the following
patches.  So if one or more of these turn out to be controversial, the previous patches are still an
improvement, especially [PATCH v6 06/16] which fixes the deadlock in strace, this one fixes the most
important tracing deadlocks.


Thanks
Bernd.
