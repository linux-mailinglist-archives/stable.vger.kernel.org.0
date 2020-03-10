Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB66D17FF0A
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgCJNoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:44:13 -0400
Received: from mail-oln040092064070.outbound.protection.outlook.com ([40.92.64.70]:44472
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgCJNoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:44:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFhvp+Oo45MXHFV30ls6zqT7/546uqQptqKa+nZwGSFJbMbVs39WFCMR3R4+ZWtEAPmWz9sSFvBXcMZn0AT/yyLwW7fPZQV+dlBtynTVIP92g9Hxt3mC4Y7u2NXWrtqaQir7P0PO6wu+IfzH74keqMDowVxzqJzGSOSOpRA4Y/yvMjGVDbcIe0c/AV7POZGdy2re8ydZbI3rSxPq3OGoFEZpY8V32jOHuEcebdKL9+fn6muJ4RtebV5KSddLfS3ZYy7sGlR5cf/TgMsECc/ZUOX/9DVPFWSgsNP4byzCIhuIDwYFNrCk1fJ5RpqAF1VSV3aclDIfckMkv36j+4KKmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOZY463IAaXjiQVx7MRIl6eponpktQjQKIZPtfN8f0A=;
 b=cXWMpRR2CIXaZtvc0JBPdHMXIE7pdrMYY7W6C6JhFuzZdWpCjYoZepNahB2O+2VlSpx7pZ8TpRWAX05N85gT+L3sGVRt84yudbYdNT19apQzmZQHE+m2+vU1c4h71IFqhLRfscPzzvMwXdo3uXFUzNJ9HKE3rlGSHTYKnNs2zepozadCv+p3vXZ2r6CNhjqmwqgL5W2V/jrQyZmIUUfDqGyzUf6hePedfauhxZm6L9VUO569ZrrcRTc86IQnCh6na7FRhuWCEXoqN7FDcU5tXdGO0pb82xbZNwolU6vIRRo/4SBWAo5T+HgEzLtKz2Pw4pQKGZSZiQb11/Ybt1F1fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT023.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::37) by
 HE1EUR01HT005.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::492)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 13:44:03 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.52) by
 HE1EUR01FT023.mail.protection.outlook.com (10.152.0.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 13:44:03 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:2534592BB12048E38E56F803EF8B67E0599C52D4D49AF5C559ECF8080DBF5FF9;UpperCasedChecksum:01EBD96ECEB138968F5094E9AB20D61588959F6B6FFED1F4D775C0A1AC968775;SizeAsReceived:10294;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 13:44:03 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 2/4] selftests/ptrace: add test cases for dead-locks
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
Message-ID: <AM6PR03MB51703199741A2C27A78980FFE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 14:44:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <877dzt1fnf.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0084.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::25) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <fbd7c68e-4094-2f9b-fbb0-5f43a706128d@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0084.eurprd06.prod.outlook.com (2603:10a6:208:fa::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 13:44:01 +0000
X-Microsoft-Original-Message-ID: <fbd7c68e-4094-2f9b-fbb0-5f43a706128d@hotmail.de>
X-TMN:  [mbH5VsuP3pnDx5S83zh5PLwQRoDsVQ4R]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: f77651f4-c28d-44e1-771b-08d7c4f91823
X-MS-TrafficTypeDiagnostic: HE1EUR01HT005:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e3lk3mxrLBIqFPpGQyawO5+/E2DepRJw7nqU8+HOzUUV1tJZ5vXQ4OQxytSOH1PYS4u0VTkVrm3Ma/vPULqTzVD0oeY1W0nn/ROspV4OKXXw5aQI5BMO+LwqI3IQK7rlJjz9hgWJC0ShTt8eB+l4D4m3YnjZoNchxqx6NCl9ExDqRv035keCQeu5ZtRBYiEI
X-MS-Exchange-AntiSpam-MessageData: UD3Fct7HirAC7qOQjBjLnzGmOlwPO0C65kL3A1S8q+1f/GsK7MYg9HzUCHCkqI7sA+dMLnxcfKeES/ctFXneRsd1eCglzjw2FOhCdSEakOwSEYWbIuQP8ojNt0stkZgqAozUAM0tip7VaTqslbmwYw==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f77651f4-c28d-44e1-771b-08d7c4f91823
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 13:44:03.1660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT005
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds test cases for ptrace deadlocks.

Additionally fixes a compile problem in get_syscall_info.c,
observed with gcc-4.8.4:

get_syscall_info.c: In function 'get_syscall_info':
get_syscall_info.c:93:3: error: 'for' loop initial declarations are only
                                 allowed in C99 mode
   for (unsigned int i = 0; i < ARRAY_SIZE(args); ++i) {
   ^
get_syscall_info.c:93:3: note: use option -std=c99 or -std=gnu99 to compile
                               your code

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 tools/testing/selftests/ptrace/Makefile   |  4 +-
 tools/testing/selftests/ptrace/vmaccess.c | 86 +++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/ptrace/vmaccess.c

diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
index c0b7f89..2f1f532 100644
--- a/tools/testing/selftests/ptrace/Makefile
+++ b/tools/testing/selftests/ptrace/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -iquote../../../../include/uapi -Wall
+CFLAGS += -std=c99 -pthread -iquote../../../../include/uapi -Wall
 
-TEST_GEN_PROGS := get_syscall_info peeksiginfo
+TEST_GEN_PROGS := get_syscall_info peeksiginfo vmaccess
 
 include ../lib.mk
diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
new file mode 100644
index 0000000..4db327b
--- /dev/null
+++ b/tools/testing/selftests/ptrace/vmaccess.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
+ * All rights reserved.
+ *
+ * Check whether /proc/$pid/mem can be accessed without causing deadlocks
+ * when de_thread is blocked with ->cred_guard_mutex held.
+ */
+
+#include "../kselftest_harness.h"
+#include <stdio.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <signal.h>
+#include <unistd.h>
+#include <sys/ptrace.h>
+
+static void *thread(void *arg)
+{
+	ptrace(PTRACE_TRACEME, 0, 0L, 0L);
+	return NULL;
+}
+
+TEST(vmaccess)
+{
+	int f, pid = fork();
+	char mm[64];
+
+	if (!pid) {
+		pthread_t pt;
+
+		pthread_create(&pt, NULL, thread, NULL);
+		pthread_join(pt, NULL);
+		execlp("true", "true", NULL);
+	}
+
+	sleep(1);
+	sprintf(mm, "/proc/%d/mem", pid);
+	f = open(mm, O_RDONLY);
+	ASSERT_GE(f, 0);
+	close(f);
+	f = kill(pid, SIGCONT);
+	ASSERT_EQ(f, 0);
+}
+
+TEST(attach)
+{
+	int s, k, pid = fork();
+
+	if (!pid) {
+		pthread_t pt;
+
+		pthread_create(&pt, NULL, thread, NULL);
+		pthread_join(pt, NULL);
+		execlp("sleep", "sleep", "2", NULL);
+	}
+
+	sleep(1);
+	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
+	ASSERT_EQ(errno, EAGAIN);
+	ASSERT_EQ(k, -1);
+	k = waitpid(-1, &s, WNOHANG);
+	ASSERT_NE(k, -1);
+	ASSERT_NE(k, 0);
+	ASSERT_NE(k, pid);
+	ASSERT_EQ(WIFEXITED(s), 1);
+	ASSERT_EQ(WEXITSTATUS(s), 0);
+	sleep(1);
+	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
+	ASSERT_EQ(k, 0);
+	k = waitpid(-1, &s, 0);
+	ASSERT_EQ(k, pid);
+	ASSERT_EQ(WIFSTOPPED(s), 1);
+	ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
+	k = ptrace(PTRACE_DETACH, pid, 0L, 0L);
+	ASSERT_EQ(k, 0);
+	k = waitpid(-1, &s, 0);
+	ASSERT_EQ(k, pid);
+	ASSERT_EQ(WIFEXITED(s), 1);
+	ASSERT_EQ(WEXITSTATUS(s), 0);
+	k = waitpid(-1, NULL, 0);
+	ASSERT_EQ(k, -1);
+	ASSERT_EQ(errno, ECHILD);
+}
+
+TEST_HARNESS_MAIN
-- 
1.9.1
