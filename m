Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8CF17FF04
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgCJNoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:44:00 -0400
Received: from mail-oln040092065099.outbound.protection.outlook.com ([40.92.65.99]:16342
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbgCJNnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:43:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5ImOMyV15xazCQUSFatxVnTzbzl8y7oJ+Knf6cleB34e0CiwdhZDk1NHJkqxj3qXMoakoFK8/SI04rjaUZoRQiMJpZXNii09Afb2SRPKsMlVLF/IccqTJL5klbB+qQ3wgV0+amfoNfMtrvfsnyejq48q5Jbn4KwUc8V9jux5GkuUkK+8A2PBQSAisDKdb20jZ74U0g/aSREQUIM8rgrVUNz2n1su4JV6hTe9D8BLjEGlVrv7WmVNZxhSP6Szcpn1qz9GDwQ/ijBPpzh34pyrR9MtOpPRNK16PJoKWdIcNeNqJzUxEx9v9ZUwsYOtRk6G3h4nxVkZWeXGFWDLuMGcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4zfls0EVuF8PrwzOKtaWxfLhwkhxIJe4QvvQmaAd2Y=;
 b=V7yKMEwAMUiWdaG1nyaej27Jf9VyfBLMRqxCfk9dsRwMB+T6bBkQY1UWAoa/6z+WYB1pewLeKEdZdTlFKY815vN2vMJUd2Fx9RfvtRUlQPItRPy8gYDHxowEj/HGZe8XCBsJIq/sMKL6yMKsuVxip0bBe49LikE8CiyWB3sZiGbEUIr/I/uhPe08mZLvP3KtWR4URPlzJN+Pj/mQe/Vb0Q7BPPRhUI2yN2Ht4DkPriGIwjWi3kqv9uINb1FAXCqBgFHtMAVSqJKeopOyLp3ttgKibEMxYUcXNrgkefCrrwXgj+IV15Jrc+iQhD2hbmob8xPgljGHRVLBufI9jHOCHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT023.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::34) by
 HE1EUR01HT041.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::309)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 13:43:44 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.52) by
 HE1EUR01FT023.mail.protection.outlook.com (10.152.0.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 13:43:44 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:6A02071DF6D3455C73EA464E66C2E68A03C377A18C5068A79EF334946D4561B7;UpperCasedChecksum:4FA046D215CECC6203338AA45E6C557CBBCC68E5D83A8CA642CBD62B6DA8D4DF;SizeAsReceived:10287;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 13:43:43 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 1/4] exec: Fix a deadlock in ptrace
To:     "Eric W. Biederman" <ebiederm@xmission.com>
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
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
Message-ID: <AM6PR03MB517033EAD25BED15CC84E17DE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 14:43:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <877dzt1fnf.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0107.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::48) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <28522c24-adde-701b-ddff-4a56c00be5b5@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0107.eurprd06.prod.outlook.com (2603:10a6:208:fa::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 13:43:42 +0000
X-Microsoft-Original-Message-ID: <28522c24-adde-701b-ddff-4a56c00be5b5@hotmail.de>
X-TMN:  [4S38XYKbJHcIuBBxHVs8f7dHCw5OqNk2]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 650263e8-be99-435b-713a-08d7c4f90c81
X-MS-TrafficTypeDiagnostic: HE1EUR01HT041:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xf/u/LtqXk7AUDF+8aJxwHAvz12RJR51GZYfLA6Psp2ccbA3/W857nVqxmThq3omv+/Fyhf5ofUSRFoStVtAoZU1N6TpbfxA7Et15Nzu2GMG+jQZ55Bw9m75uoXMR3d9n7olXAEfI8x/mC1GI43FvAKo1D2qLNmso6Xt4g4pXO6fEP6mGDCgd8DnL8NNVBB1m4irhp4a8YHkvIb9aCelv8uWRq6semKiy4gzvay3LQc=
X-MS-Exchange-AntiSpam-MessageData: t2XQflRz49vsutWm8UHTBqmBJlTEnwRoZIMQGpWdLCqDJcLo9UCOQz0tThlMB1E2b3l6UROG5hM9pqzwvqejTlatMCG1Nre3xZM2RAAyCD1DpmZ8tqEzUHupUOU7oeadxssmcoO/rsmD2OYHRMU6BQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 650263e8-be99-435b-713a-08d7c4f90c81
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 13:43:43.9080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT041
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a deadlock in the tracer when tracing a multi-threaded
application that calls execve while more than one thread are running.

I observed that when running strace on the gcc test suite, it always
blocks after a while, when expect calls execve, because other threads
have to be terminated.  They send ptrace events, but the strace is no
longer able to respond, since it is blocked in vm_access.

The deadlock is always happening when strace needs to access the
tracees process mmap, while another thread in the tracee starts to
execve a child process, but that cannot continue until the
PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:

strace          D    0 30614  30584 0x00000000
Call Trace:
__schedule+0x3ce/0x6e0
schedule+0x5c/0xd0
schedule_preempt_disabled+0x15/0x20
__mutex_lock.isra.13+0x1ec/0x520
__mutex_lock_killable_slowpath+0x13/0x20
mutex_lock_killable+0x28/0x30
mm_access+0x27/0xa0
process_vm_rw_core.isra.3+0xff/0x550
process_vm_rw+0xdd/0xf0
__x64_sys_process_vm_readv+0x31/0x40
do_syscall_64+0x64/0x220
entry_SYSCALL_64_after_hwframe+0x44/0xa9

expect          D    0 31933  30876 0x80004003
Call Trace:
__schedule+0x3ce/0x6e0
schedule+0x5c/0xd0
flush_old_exec+0xc4/0x770
load_elf_binary+0x35a/0x16c0
search_binary_handler+0x97/0x1d0
__do_execve_file.isra.40+0x5d4/0x8a0
__x64_sys_execve+0x49/0x60
do_syscall_64+0x64/0x220
entry_SYSCALL_64_after_hwframe+0x44/0xa9

This changes mm_access to use the new exec_update_mutex
instead of cred_guard_mutex.

This patch is based on the following patch by Eric W. Biederman:
"[PATCH 0/5] Infrastructure to allow fixing exec deadlocks"
Link: https://lore.kernel.org/lkml/87v9ne5y4y.fsf_-_@x220.int.ebiederm.org/

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index c12595a..5720ff3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1224,7 +1224,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 	struct mm_struct *mm;
 	int err;
 
-	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
+	err =  mutex_lock_killable(&task->signal->exec_update_mutex);
 	if (err)
 		return ERR_PTR(err);
 
@@ -1234,7 +1234,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 		mmput(mm);
 		mm = ERR_PTR(-EACCES);
 	}
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_update_mutex);
 
 	return mm;
 }
-- 
1.9.1
