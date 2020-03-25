Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41DD192C9E
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 16:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgCYPeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 11:34:08 -0400
Received: from mail-oln040092073081.outbound.protection.outlook.com ([40.92.73.81]:58075
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727491AbgCYPeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 11:34:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJyOKbFax2ocUSObLnSB6HpJrRCuqUOaMGfEP7dSe5nryNuXNcC9vLbOVV6DATWGYsK4OGbHnPwoKdFqWCGFDft5fIBSbuU4U9It64vOK4aCa2WkyAuQloAaf0VImF7mdOocpSabvjmcTEW468hG9IQVjnrYS52NLONysISN9TPK9TTAegYew32ja1rcEfKGx8l4oLpF0QB7Z0QlbbO3VyCaCaRnDLfbuC8k5VP4L7ETOlf/fCHo2E/MDblaTyneSjXLhoR6olMh0wNtNhsfFMUWgYJNyvOmKxCniIz35K2Ian8Ums04C4yxG5qTCiG6e/Sr5wXnwAmAomgPMbNJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHEAfxyeHNHUmU44+JfSC6YAxU4F1ltg966fBoY0xaU=;
 b=GR9wi6OdHZMLka1J/wrp3ww5kux+yv6m4Hutr6aAemSNLYG1ankQKijv9B0kyR9GAeb4mmisPmAFogb8OS4UfO9fVQxpOvJ8xoddLSmjifevTDr6Zay2ksOV3OFbTfoJtWb9guifrN6Cf/vfvY9Rf4S+rYOfYoJNd5Fkz236w7d7NYEnsBBYv3z/dlzfX/yU4hXlDW6QeHXQgb1ZUBL5/I/3V/EKsIvnf62tRceHPgGj5GD4Y97X6bfTXu2E2GNNXuuWUEJH2LXX2ssqIHNiFZfXxls/JfgSFd5QU19oFMQ/YOsZ04GSYsltyxiS29EyOUOIdBpla5TECFlPpPdgig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VI1EUR04FT006.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0e::35) by
 VI1EUR04HT144.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0e::297)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Wed, 25 Mar
 2020 15:34:01 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.28.54) by
 VI1EUR04FT006.mail.protection.outlook.com (10.152.29.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.17 via Frontend Transport; Wed, 25 Mar 2020 15:34:01 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:4AAD6836FE538CDF8AF68AC2ED4D7FFBC4A37267FFD4C303F6BB0D01D6F2DC6C;UpperCasedChecksum:25F98A184ADA56E1533207F6A44430EDAE2DF66E5D652E24468A8AFA9D9ADD3D;SizeAsReceived:9490;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 15:34:01 +0000
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
Message-ID: <AM6PR03MB51705AB7D87FA2B1B2FA7E9DE4CE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Wed, 25 Mar 2020 16:33:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <871rpg8o7v.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0039.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::16) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <30eb0124-2caa-691b-f6fb-c455bcbf7cfd@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0039.eurprd06.prod.outlook.com (2603:10a6:208:aa::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Wed, 25 Mar 2020 15:33:59 +0000
X-Microsoft-Original-Message-ID: <30eb0124-2caa-691b-f6fb-c455bcbf7cfd@hotmail.de>
X-TMN:  [pK0e5P8LabNnnmzdmthTsN27RTEENStv]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: cf570ee4-3236-4a01-5b19-08d7d0d1f139
X-MS-TrafficTypeDiagnostic: VI1EUR04HT144:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yx2OwSobsUQwWVTsjflmK+TAEFqO6VGEcGf+vmUBC4d9iRXNZjBEODVvjTw6mK0DHNwOEPQ6F0XnK+OnMGHcdECEyxB0gdASWlqzF+h7UE5Bhhax0ah04hkIhI2H/r3HIrOvO1X4M7FqPDhibY2Bds1TCua5N/Imp+f/5p26HcBHll/Pt3Vvsm1/BVOT6rkpZGB7DANO4i6zC37J51n0OBn9pUvA7a8xvZZSrR95tJo=
X-MS-Exchange-AntiSpam-MessageData: 3dt37pAi19rIS17cpqVyU5RA0CmG201HpNHHDf2ziJdSAI85WypK/dmTk5TPyQjtlydjWuMrAcBW1CSyfmb8O4jjes9TGzb8sKbYhMNkeEP+yo7ZqClNFg+udqe1Rqg8OJHKx5FaAU7EpkJLIGaADw==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf570ee4-3236-4a01-5b19-08d7d0d1f139
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 15:34:01.4082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR04HT144
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
> 
> I have fixed those up and will be merging this code to linux-next,
> unless you object.
> 

Thanks, I have not expected that a From: which names a different domain
than hotmail.de would be forwarded by the SMTP servers I have to use.
Actually I was not even aware of the problem at all.

The Patch "exec: Add exec_update_mutex to replace cred_guard_mutex"
was initially reviewed-by: bernd.edlinger@hotmail.de but it turned out
to be faulty, so I update your patch faithfully, and did a small change
to fix the patch, therefore it is actually 99% your and 1% my patch,
therefore I figured I should be in a signed-off-by: together with you.
BTW: I saw a Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com> on the mailing list,
you should add that as well.


Thanks
Bernd.
