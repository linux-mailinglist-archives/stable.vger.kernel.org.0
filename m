Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D924185739
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 02:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCOBeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 21:34:01 -0400
Received: from mail-oln040092075105.outbound.protection.outlook.com ([40.92.75.105]:4992
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726705AbgCOBeA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Mar 2020 21:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+4M/xmhc023myQhgFcVgK9e5m3S/6YcivxKKHqF971tzl/d1IjZZB6vajrlVR/3ANsXohcq2I3kanwvWJVPYB1OMD17aiHgPffPk8jPA6GudjlDD/CZQw6OQ8esLf8XkVFYgDiHb5ZjY6AyjI/X+bvzCh3z11qv2hTNgCvkn4ilKAVDaT1sKHvfsMBWuzKcQglMwBM1LxBdCsX2wSsfVJxqlFr2teyVN4sqbUaUPYWZDKELgxjHGsgZ/NDY238EBm1+xpYCkwLlOQmWP0bOkPg3aJxjwkoKy5glZZ0ZmUbbeQ6h1Yb04pHbkgukZvqeHh8zDIBnL9GvUT9fHCO05A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0t14d3vmYMBeBtGI1RMkCE1K2Eye6ORicjQh/aQM3N0=;
 b=BKZPqoHj7tWWah96/MVM93xT7Z2ea/UZClZxfhlGbQf9Fxelf7J/qZOX2YZF27oJEHoZal+44UdFdPnj2X3Fw5/YHewtX7CHqw/vn9E7k5krb6esB8RgS+G5qPdsK8E3lCX72PcrEi4zCyeYnH2DXpADDerExXKRD0K7nWi9xqmT3+eaFpqz9Lzm+GVwANhZhCcWURUHNhmzBsXqqg1glXPJ2A/bwhUbTWpovmjr1sVgvc+ErKCV5nR62H5yAn1kD5PiqWRrAFCW1KbNCmdTJgXfVvNrfSYsEU1d4BjfIQ/91Vc4s5JY+z3bir2r//z5h3KRbH5NkBBZB5vpoyMoRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT009.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::38) by
 DB3EUR04HT180.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::107)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Sat, 14 Mar
 2020 09:57:13 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.54) by
 DB3EUR04FT009.mail.protection.outlook.com (10.152.24.230) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Sat, 14 Mar 2020 09:57:13 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:FF41864A883BD405ABA604C0AF65CA0A23BDC59744F8CBC7816B6A046E5E1DF5;UpperCasedChecksum:74E380B2237A95D772639194018BAF266B3CFDC8E72DFFDA53E86DBC29C52239;SizeAsReceived:10362;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2814.018; Sat, 14 Mar 2020
 09:57:13 +0000
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
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
 <f37a5d68-9674-533f-ee9c-a49174605710@virtuozzo.com>
 <87d09hn4kt.fsf@x220.int.ebiederm.org>
 <dbce35c7-c060-cfd8-bde1-98fd9a0747a9@virtuozzo.com>
 <87lfo5lju6.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170CF763987C24F22B38838E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sat, 14 Mar 2020 10:57:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15)
 To AM6PR03MB5170.eurprd03.prod.outlook.com (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <acae6b84-112c-b4b0-5f8d-8041225b6bbb@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Sat, 14 Mar 2020 09:57:05 +0000
X-Microsoft-Original-Message-ID: <acae6b84-112c-b4b0-5f8d-8041225b6bbb@hotmail.de>
X-TMN:  [dJMluiESOM82Wyv2Ut3LbvVwuH1v2vrc]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 02c07a97-1088-47f3-bd76-08d7c7fe1193
X-MS-TrafficTypeDiagnostic: DB3EUR04HT180:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCPnaL6f8n7O6hBYVhT/p8DbBrrs3yAla2HphQ0DWv4UnlsONnH3y4qrDhgVjbfIP61KEMn6qPdm5wLqMcwc7g5dWAPVWrRlpUhvHhzCTVc59RvzA7ehUWJlNExknLoyQX0Lg45fwftHjLUB8wtUQykZC2WFAr8rihe5xEBVIPYBNNxnuvXfQjYHuYaOZvn3Yu6oTDqGIc+OBGwWRq8nvxHtvtHg/JpYQOcMszIOb+Q=
X-MS-Exchange-AntiSpam-MessageData: Wn3kgHSfZD8gnOmY8gYrzpN0s5mmImPooFZkCxnxl4y4Q3tUDTiMYIbiScCXplHL1redMUXp3MipSNj/W/GIh5twJNCCHOTvw10F8CAGdI7WCBNRhTexlGloGxXNpBiNJUlprsOSBaCOKXD38YyrHg==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c07a97-1088-47f3-bd76-08d7c7fe1193
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 09:57:13.0178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/13/20 10:13 AM, Kirill Tkhai wrote:
> 
> Despite this should fix the problem, this looks like a broken puzzle.
> 
> We can't use bprm->cred as an identifier whether the mutex was locked or not.
> We can check for bprm->cred in regard to cred_guard_mutex, because of there is
> strong rule: "cred_guard_mutex is becomes locked together with bprm->cred assignment
> (see prepare_bprm_creds()), and it becomes unlocked together with bprm->cred zeroing".
> Take attention on modularity of all this: there is no dependencies between anything else.
> 
> In regard to newly introduced exec_update_mutex, your fix and source patch way look like
> an obfuscation. The mutex becomes deadly glued to unrelated bprm->cred and bprm->mm,
> and this introduces the problems in the future modifications and support of all involved
> entities. If someone wants to move some functions in relation to each other, there will
> be a pain, and this person will have to go again the same dependencies and bug way,
> Eric stepped on in the original patch.
> 

Okay, yes, valid points you make, thanks.
I just wanted to understand what was exactly wrong with this patch,
since the failure mode looked a lot like it was failing because of
something clobbering the data unexpectedly.


So I have posted a few updated patch for the failed one here:

[PATCH v3 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
[PATCH] pidfd: Use new infrastructure to fix deadlocks in execve

which replaces these:
[PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
https://lore.kernel.org/lkml/87zhcq4jdj.fsf_-_@x220.int.ebiederm.org/

[PATCH] pidfd: Stop taking cred_guard_mutex 
https://lore.kernel.org/lkml/87wo7svy96.fsf_-_@x220.int.ebiederm.org/


and a new patch series to fix deadlock in ptrace_attach and update doc:
[PATCH 0/2] exec: Fix dead-lock in de_thread with ptrace_attach
[PATCH 1/2] exec: Fix dead-lock in de_thread with ptrace_attach
[PATCH 2/2] doc: Update documentation of ->exec_*_mutex


Other patches needed, still valid:

[PATCH v2 1/5] exec: Only compute current once in flush_old_exec
https://lore.kernel.org/lkml/87pndm5y3l.fsf_-_@x220.int.ebiederm.org/

[PATCH v2 2/5] exec: Factor unshare_sighand out of de_thread and call it separately
https://lore.kernel.org/lkml/87k13u5y26.fsf_-_@x220.int.ebiederm.org/

[PATCH v2 4/5] exec: Move exec_mmap right after de_thread in flush_old_exec
https://lore.kernel.org/lkml/875zfe5xzb.fsf_-_@x220.int.ebiederm.org/

[PATCH 1/4] exec: Fix a deadlock in ptrace
https://lore.kernel.org/lkml/AM6PR03MB517033EAD25BED15CC84E17DE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH 2/4] selftests/ptrace: add test cases for dead-locks
https://lore.kernel.org/lkml/AM6PR03MB51703199741A2C27A78980FFE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH 3/4] mm: docs: Fix a comment in process_vm_rw_core
https://lore.kernel.org/lkml/AM6PR03MB5170ED6D4D216EEEEF400136E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH 4/4] kernel: doc: remove outdated comment cred.c
https://lore.kernel.org/lkml/AM6PR03MB517039DB07AB641C194FEA57E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH 1/4] kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
https://lore.kernel.org/lkml/AM6PR03MB517057A2269C3A4FB287B76EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH 2/4] proc: Use new infrastructure to fix deadlocks in execve
https://lore.kernel.org/lkml/AM6PR03MB51705D211EC8E7EA270627B1E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH 3/4] proc: io_accounting: Use new infrastructure to fix deadlocks in execve
https://lore.kernel.org/lkml/AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/

[PATCH 4/4] perf: Use new infrastructure to fix deadlocks in execve
https://lore.kernel.org/lkml/AM6PR03MB517035DEEDB9C8699CB6B34EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com/


I think most of the existing patches are already approved, but if
there are still change requests, please let me know.


Thanks
Bernd.
