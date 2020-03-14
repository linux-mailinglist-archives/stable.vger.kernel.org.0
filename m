Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217331856CD
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 02:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgCOB3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 21:29:09 -0400
Received: from mail-oln040092074027.outbound.protection.outlook.com ([40.92.74.27]:63812
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726682AbgCOB3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Mar 2020 21:29:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj2QAR3fyzt55tNewV+HVaQwzPSdYVGluuTRC3FCSRXv3q6n8kmKxB3VdkBaZzcPXWYDh+BaOAKbkdJmUgacjlVF9ulRlyCteCLjyGMRUnplrFrjMZy1ObBeO+9jtzUgFowqunAtBaoptwkuyl6JBxrWyJaYRY6MzyKtQqgMhpVaieOIFPVNjks2g4+bOdQ3BiIZIHhczEwZBbdfpjODIoxSTKu/rLGoWPRjHhyXKNKpJLx+y4qZuxiSTuDMDV6/As9leO3BW7QNp+kmdcQweuaoiXnCocr2AtDP/crujaCjb2OrD/AVsxp0pKADff6XI8TT2Wo07wLea0Y+ibQgqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RaNHNTXco7dC0LKO/lrZy/NgK6an+A8UGbJpG7c+e40=;
 b=Y/iJWSoBSGkkUI1wY1XRFpt3r8hvlVHwxYcshwN/sFNpIyYw34HZuX4iShyMOH/FSjvB718OsSbP2ObpdFowAN/PjPeQ2nC535j1wN6GZP/g9yFyLfp7VvIz2ao0tiaBQhSl7UFw5kRThvWN84wL/5wtq1CluzB9OnKbOt0J21HxEZNkk1y7nH8b6OnSpEU86Uk6FUo1eun2BEWtPWthVaX/kcR7FtPQ7Jzx8RmSxzKEHSrp9dmk7TuEaHVzzKuNZ36D2a+EG8/gKm6XmTFFg7zJ2eVH/hfHCxHVwTBU+EdbCe6+rJ4K9pOKBte1x72ahJRglBPsX2e0f2qYlpyXbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT026.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::3b) by
 DB3EUR04HT135.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::357)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Sat, 14 Mar
 2020 10:02:25 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.53) by
 DB3EUR04FT026.mail.protection.outlook.com (10.152.24.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Sat, 14 Mar 2020 10:02:25 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:BD2C72D9285EAE5C2552CA84FE4A830EED809BF9432C3B6F1FBFBED07DA9B213;UpperCasedChecksum:B8ABAE09E7C5A03152C084FB04CDE5892C360733E9845E02793A2837A8C5CCA3;SizeAsReceived:10340;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2814.018; Sat, 14 Mar 2020
 10:02:25 +0000
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
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
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <f37a5d68-9674-533f-ee9c-a49174605710@virtuozzo.com>
 <87d09hn4kt.fsf@x220.int.ebiederm.org>
 <dbce35c7-c060-cfd8-bde1-98fd9a0747a9@virtuozzo.com>
 <87lfo5lju6.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
 <AM6PR03MB5170CF763987C24F22B38838E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Message-ID: <AM6PR03MB5170813CDCAA105535F84C93E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sat, 14 Mar 2020 11:02:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <AM6PR03MB5170CF763987C24F22B38838E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16)
 To AM6PR03MB5170.eurprd03.prod.outlook.com (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <5fc2d244-e019-a8c2-12cd-5becc1f64431@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Sat, 14 Mar 2020 10:02:22 +0000
X-Microsoft-Original-Message-ID: <5fc2d244-e019-a8c2-12cd-5becc1f64431@hotmail.de>
X-TMN:  [8BKZP+A/aEwb1zWiEIcHxcohTDDRQT0B]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 4386b005-a97d-4763-147e-08d7c7fecbd4
X-MS-TrafficTypeDiagnostic: DB3EUR04HT135:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yv+f1E8//TivHezlLJswCtUkxwxWFD00NYI8UW+Qp1QXKf25MInLATc6tHQJtQaqGvFvo+jhya4Zfd32v3LFTXGUFr2S9CS+1llHsKQ2Q9J7P2agoCtr3kldW1Xu6o7dr8nbjVRylepnKmzaFL6KXjT+Qim+2hbYDnDysNT4ra/cRbuc2hp6IKf+uRjW739u+A+XPTTGuV4tkRdMWXpFS5iuMbpRlSzXbAsFJTq5yVc=
X-MS-Exchange-AntiSpam-MessageData: 13WqQVIE9ylqnsCOYhuHE1G70dAATh6wD2uA7zvA9E+YpeCurxiHsMz+hu4CCkjKugdmHcN7cq3UYYMwPYiMz0QxbG9vFqAw3Fpqe6+V/bzcMGS1PTNfx1n66wp1S3XttTFb/4ACf7IwDEAJmitNLA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4386b005-a97d-4763-147e-08d7c7fecbd4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 10:02:25.4716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT135
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/14/20 10:57 AM, Bernd Edlinger wrote:
> On 3/13/20 10:13 AM, Kirill Tkhai wrote:
>>
>> Despite this should fix the problem, this looks like a broken puzzle.
>>
>> We can't use bprm->cred as an identifier whether the mutex was locked or not.
>> We can check for bprm->cred in regard to cred_guard_mutex, because of there is
>> strong rule: "cred_guard_mutex is becomes locked together with bprm->cred assignment
>> (see prepare_bprm_creds()), and it becomes unlocked together with bprm->cred zeroing".
>> Take attention on modularity of all this: there is no dependencies between anything else.
>>
>> In regard to newly introduced exec_update_mutex, your fix and source patch way look like
>> an obfuscation. The mutex becomes deadly glued to unrelated bprm->cred and bprm->mm,
>> and this introduces the problems in the future modifications and support of all involved
>> entities. If someone wants to move some functions in relation to each other, there will
>> be a pain, and this person will have to go again the same dependencies and bug way,
>> Eric stepped on in the original patch.
>>
> 
> Okay, yes, valid points you make, thanks.
> I just wanted to understand what was exactly wrong with this patch,
> since the failure mode looked a lot like it was failing because of
> something clobbering the data unexpectedly.
> 
> 
> So I have posted a few updated patch for the failed one here:
> 
> [PATCH v3 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
> [PATCH] pidfd: Use new infrastructure to fix deadlocks in execve
> 
> which replaces these:
> [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
> https://lore.kernel.org/lkml/87zhcq4jdj.fsf_-_@x220.int.ebiederm.org/
> 
> [PATCH] pidfd: Stop taking cred_guard_mutex 
> https://lore.kernel.org/lkml/87wo7svy96.fsf_-_@x220.int.ebiederm.org/
> 
> 
> and a new patch series to fix deadlock in ptrace_attach and update doc:
> [PATCH 0/2] exec: Fix dead-lock in de_thread with ptrace_attach
> [PATCH 1/2] exec: Fix dead-lock in de_thread with ptrace_attach
> [PATCH 2/2] doc: Update documentation of ->exec_*_mutex
> 
> 
> Other patches needed, still valid:
> 
> [PATCH v2 1/5] exec: Only compute current once in flush_old_exec
> https://lore.kernel.org/lkml/87pndm5y3l.fsf_-_@x220.int.ebiederm.org/
> 
> [PATCH v2 2/5] exec: Factor unshare_sighand out of de_thread and call it separately
> https://lore.kernel.org/lkml/87k13u5y26.fsf_-_@x220.int.ebiederm.org/
> 

Ah, sorry, forgot this one:
[PATCH v2 3/5] exec: Move cleanup of posix timers on exec out of de_thread
https://lore.kernel.org/lkml/87eeu25y14.fsf_-_@x220.int.ebiederm.org/

> [PATCH v2 4/5] exec: Move exec_mmap right after de_thread in flush_old_exec
> https://lore.kernel.org/lkml/875zfe5xzb.fsf_-_@x220.int.ebiederm.org/
> 
> [PATCH 1/4] exec: Fix a deadlock in ptrace
> https://lore.kernel.org/lkml/AM6PR03MB517033EAD25BED15CC84E17DE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/
> 
> [PATCH 2/4] selftests/ptrace: add test cases for dead-locks
> https://lore.kernel.org/lkml/AM6PR03MB51703199741A2C27A78980FFE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/
> 
> [PATCH 3/4] mm: docs: Fix a comment in process_vm_rw_core
> https://lore.kernel.org/lkml/AM6PR03MB5170ED6D4D216EEEEF400136E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/
> 
> [PATCH 4/4] kernel: doc: remove outdated comment cred.c
> https://lore.kernel.org/lkml/AM6PR03MB517039DB07AB641C194FEA57E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/
> 
> [PATCH 1/4] kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
> https://lore.kernel.org/lkml/AM6PR03MB517057A2269C3A4FB287B76EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/
> 
> [PATCH 2/4] proc: Use new infrastructure to fix deadlocks in execve
> https://lore.kernel.org/lkml/AM6PR03MB51705D211EC8E7EA270627B1E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/
> 
> [PATCH 3/4] proc: io_accounting: Use new infrastructure to fix deadlocks in execve
> https://lore.kernel.org/lkml/AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/
> 
> [PATCH 4/4] perf: Use new infrastructure to fix deadlocks in execve
> https://lore.kernel.org/lkml/AM6PR03MB517035DEEDB9C8699CB6B34EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/
> 
> 
> I think most of the existing patches are already approved, but if
> there are still change requests, please let me know.
> 
> 
> Thanks
> Bernd.
> 

Hope it is correct now.
I haven't seen the new patches on the kernel archives yet,
so I cannot add URLs for them.

Bernd.
