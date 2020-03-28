Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62AA1969D6
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 23:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgC1WdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 18:33:19 -0400
Received: from mail-vi1eur05olkn2020.outbound.protection.outlook.com ([40.92.90.20]:53600
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727151AbgC1WdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Mar 2020 18:33:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6ZPzGrOgk5n0HE94J5P7Qf/JBAkPTVLkU/lQsJNoa67Pt9mHAxv4U8UerMkE2pQ97QFhh1w1fTd8xfYgINbYslUC8l1xxBzNp8xNZgXIS+p66VAF5kmXopQmbTDuQg2bM8HRE0XV6uFaLKldt0pYT8PjaQxBvn2yMRgf+k6DxNMaajTGz8k5II25THmY6CMq6QJtdmDp5bUMfgXuyKpAq3wFcy2FXjylJ8TNb4eYQHi4MukmyrkAQ2yNwGCkbmofj9sDFHIZLBlmie2NMnK7Pz7WEXHrUMbrgJiIe+nmMFhWZuXLKnSKD9udrQUIMogpuEaQ4kqEd6YH6Z1LFTJIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHzRx0DZ4kZOpnuBwE/f6X/qED4fp9P8EPBb08k75Bk=;
 b=LSZ6wdfi/UmWPmCRWLnG0UpnaUn6lcb+rndkeToT8n996QR6TLrZfbhIpI5N4ZoVpsiurGjKx2pkSO+eV+Nl2wjBxW5HqSefxPl+Lf3xLBckOVfn8xa0JZoIhDAY3kJ3Zim796OM4QPhR05ILbuqY3Sl1wE4vxF0IWqAb0emh33NKvt9cScRstXKA7fT7ag6JDYjIWI2/R9vBx86hQRm7k3okXHozRiAmLq4WUZEXUn2m6dpgOY+BAuiDXG2yyoa3UQCtHh8b7q5KbcpEA4XB4qf2wHDeARBPrSHqbnXupRUWH4AztUcbHUIoaItvCKiTON6sTvqPw1KflP0QI7s1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB8EUR05FT029.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc0f::52) by
 DB8EUR05HT204.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc0f::475)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.17; Sat, 28 Mar
 2020 22:32:38 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.238.54) by
 DB8EUR05FT029.mail.protection.outlook.com (10.233.239.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.17 via Frontend Transport; Sat, 28 Mar 2020 22:32:38 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:07C77262F52CC5A0909879BEA80AE5195078149DF8382879DA587CD3D938E4C3;UpperCasedChecksum:629D2025165B1AF1E6127CB4CC865450842B380AAD5D08EEF0AB9C897C481B57;SizeAsReceived:9474;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.025; Sat, 28 Mar 2020
 22:32:38 +0000
Subject: Re: [PATCH v6 00/16] Infrastructure to allow fixing exec deadlocks
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
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
References: <AM6PR03MB5170B2F5BE24A28980D05780E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rpg8o7v.fsf@x220.int.ebiederm.org>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170938306F22C3CF61CC573E4CD0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sat, 28 Mar 2020 23:32:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <871rpg8o7v.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0009.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::19) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <3b999eea-781e-ea54-3cad-1e3d31704e35@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZRAP278CA0009.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Sat, 28 Mar 2020 22:32:36 +0000
X-Microsoft-Original-Message-ID: <3b999eea-781e-ea54-3cad-1e3d31704e35@hotmail.de>
X-TMN:  [Wb+RayWrRxNa9tP0qc+L6Ys6ZZ4B7nLV]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: aa64989f-b15f-4b08-4772-08d7d367eb51
X-MS-TrafficTypeDiagnostic: DB8EUR05HT204:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qLc/zbJBOpOw9Xagz3/d8ZqTii00cEZk7SpuJ4KXTnWqwBVu23pTGKb+0xxGR0FmfYDk88t1kzZayd4WTG0AMu+LLTJ+W9IzWbNQQyJZYHKSjk17+ot18jq6ORxanEUbzTxOmMnTbv4momX21JsIklM3kKcowBcSU37+zlLkbiuj62rTUMxGHpQwdSTvRPFRBbMKB9E88rVQ0nzOzA1kIH9aBIMROgk5joTRZWvXFWs=
X-MS-Exchange-AntiSpam-MessageData: F/awmNM0cKPdFfpmZ6zrODiCLG4bMc50yzrue4hvpAlrErlVRpMUAwgVVT9ZdqjpRqUbnZr++ETxSfW/4BMotH+pZsUVUwhYoZkPXTOrLnSb3yFYc55UqWpLJomT0crY8sdlQYovrsh9DHn3UT9ViQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa64989f-b15f-4b08-4772-08d7d367eb51
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2020 22:32:38.4596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8EUR05HT204
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/20 4:10 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> This is an infrastructure change that makes way for fixing this issue.
>> Each patch was already posted previously so this is just a cleanup of
>> the original mailing list thread(s) which got out of control by now.
>>
>> Everything started here:
>> https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>>
>> I added reviewed-by tags from the mailing list threads, except when
>> withdrawn.
>>
>> It took a lot longer than expected to collect everything from the
>> mailinglist threads, since several commit messages have been infected
>> with typos, and they got fixed without a new patch version.
>>
>> - Correct the point of no return.
>> - Add two new mutexes to replace cred_guard_mutex.
>> - Fix each use of cred_guard_mutex.
>> - Update documentation.
>> - Add a test case.
>>
>> Bernd Edlinger (11):
>>   exec: Fix a deadlock in strace
>>   selftests/ptrace: add test cases for dead-locks
>>   mm: docs: Fix a comment in process_vm_rw_core
>>   kernel: doc: remove outdated comment cred.c
>>   kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
>>   proc: Use new infrastructure to fix deadlocks in execve
>>   proc: io_accounting: Use new infrastructure to fix deadlocks in execve
>>   perf: Use new infrastructure to fix deadlocks in execve
>>   pidfd: Use new infrastructure to fix deadlocks in execve
>>   exec: Fix dead-lock in de_thread with ptrace_attach
>>   doc: Update documentation of ->exec_*_mutex
>>
>> Eric W. Biederman (5):
>>   exec: Only compute current once in flush_old_exec
>>   exec: Factor unshare_sighand out of de_thread and call it separately
>>   exec: Move cleanup of posix timers on exec out of de_thread
>>   exec: Move exec_mmap right after de_thread in flush_old_exec
>>   exec: Add exec_update_mutex to replace cred_guard_mutex
>>
>>  Documentation/security/credentials.rst    |  29 +++++--
>>  fs/exec.c                                 | 122 ++++++++++++++++++++++--------
>>  fs/proc/base.c                            |  23 +++---
>>  include/linux/binfmts.h                   |   8 +-
>>  include/linux/sched/signal.h              |  17 ++++-
>>  init/init_task.c                          |   3 +-
>>  kernel/cred.c                             |   4 +-
>>  kernel/events/core.c                      |  12 +--
>>  kernel/fork.c                             |   7 +-
>>  kernel/kcmp.c                             |   8 +-
>>  kernel/pid.c                              |   4 +-
>>  kernel/ptrace.c                           |  20 ++++-
>>  kernel/seccomp.c                          |  15 ++--
>>  mm/process_vm_access.c                    |   2 +-
>>  tools/testing/selftests/ptrace/Makefile   |   4 +-
>>  tools/testing/selftests/ptrace/vmaccess.c |  86 +++++++++++++++++++++
>>  16 files changed, 278 insertions(+), 86 deletions(-)
>>  create mode 100644 tools/testing/selftests/ptrace/vmaccess.c
> 
> Two small nits.
> 
> - You reposted my patches with adding your signed-off-by
> - You reposted my patches and did not include a "From:"
>   in the body so "git am" listed you as the author.

Oh, do I understand you right, that I can add a From: in the
*body* of the mail, and then the From: in the MIME header part
which I cannot change is ignored, so I can make you the author?


Thanks
Bernd.

> 
> I have fixed those up and will be merging this code to linux-next,
> unless you object.
> 
> Eric
> 
