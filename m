Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF8918D91E
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCTU0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:26:11 -0400
Received: from mail-oln040092074016.outbound.protection.outlook.com ([40.92.74.16]:49318
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727039AbgCTU0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:26:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXFAKSLabCIOX+5xYo2zE6xLUwGcoOJNulJjj4rtqABS1bb+jbJrS2Hvf7aW/1sMz9LLILXH2W1nd+vXhKMcGOdU0VfWjd8wVkiSIB0ipXwq8GCDPhPANg+i3gbbkUgphCo5rIWgI9LRPoaPp5oyTR91TmMhmlRm8bf4HcRcMHeoAX1vyo1178nQn9zq/r/9cKkKwuy+CftKCjc3UvuJbNk8MZTvxWkmEOlrfjbrgQhSE51pJDpG/q0pr371B/l0pjWoG9FjiN7K9UwvgXFY0jPD/BAcDPHk8rtO/IdPIoEQdR6smi0F5+YmGabJDfsjbqXuNnqL61Esb/E8/wdb4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JfbhkBSgZXazwyxseEyQAUC1YhAoQp5Oog8RUXPNFw=;
 b=a4LZFo1iywMavDzd2QpM0phSwtpCfXnXOqSrZ/zcmIulOgVgjub9LR+pJvwz3hnAWwe5JsX4WYRl5+0wDCHHnK9qXl+TOKSIx01JdNVSVBB98WXaWm+EjKlLj2jYQviFTgUYIGQ9Xo11S0bgmUFgY7lTCUaZYy/q2jwbHRHZNu9E70I5SmGDeeFYKcpqc/9GdBQZuoNInrJElm+GSI11FU6K9HOHJBGrbFYt0OkSx0bhfvYFgA/HSNqw64RpLnNF8WfR7HfTYxcz7EWcGhscZ+gd5w8LpOIoFgdm6CIuHj90UT6hyD8BwI63JQ4RyHhLP27z15GHLCkjwacZpqn+0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::35) by
 DB3EUR04HT196.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::385)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:26:07 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:26:07 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:5140F074D3BA6EE72F72325EBF172E17A127F04B477E75084089DA1CF3B5176F;UpperCasedChecksum:5AA8F7F66C1A49E3636C4506443A487E85E327A921737B7C5C282F12946CA642;SizeAsReceived:9390;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:26:07 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 06/16] exec: Fix a deadlock in strace
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
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
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Message-ID: <AM6PR03MB51709A321EBA829CC36EE1F8E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:26:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0030.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::17) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <4512747c-4434-6bc3-f1c3-4476b5d9c341@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by FR2P281CA0030.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Fri, 20 Mar 2020 20:26:05 +0000
X-Microsoft-Original-Message-ID: <4512747c-4434-6bc3-f1c3-4476b5d9c341@hotmail.de>
X-TMN:  [GK3/1T/vuH3xlYbWn/t43WvJuwsfTCp8]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: e6fc08d2-3159-4c8c-166e-08d7cd0ceb7e
X-MS-TrafficTypeDiagnostic: DB3EUR04HT196:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13bkMFgKhwMHXmp/MgPMzW0+Sf6BXH7rx8M+TAdU7ZShxGvgx9YOlxJSY5yhN5407o1qNr//PIm30YwrYcGBu9UnldjR2vhYjiMCP9TN2TOp07k68ZcJ4eMgPgTqIMuDtpe+AtXMqrpsUXh8FmrJ88+QKv0bak5JQq07iARvXWkMZzdu6mEfQXBS5ihdJxix8ea3LowKd0CFTHA1SfI0c41b6LeBeunIj9jRiGfNrww=
X-MS-Exchange-AntiSpam-MessageData: jrODIZyMol/kLrqjf7M+F+AALMj102wpttvwXaKQYZNbSfdjnMTLyF53EmPY8XdR7FB6CmrNaVaXaeosO26s9OYtNsJZtrWDEPmlwaPVK4wLHBaTYi4HYSJbjwwCpU7tem5aK32ZBKQdvkeimZqo9w==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6fc08d2-3159-4c8c-166e-08d7cd0ceb7e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:26:07.3353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT196
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
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 036b692..e23ccac 100644
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
