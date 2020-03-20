Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C9018D923
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCTU02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:26:28 -0400
Received: from mail-oln040092073070.outbound.protection.outlook.com ([40.92.73.70]:19905
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726789AbgCTU01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:26:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPlfI1VtCNTt7Ny+lfFPzpdqjSkJutIxzw98zi2c6iJAez9LprhTqoTiT0xcMtMPVtqRNBj5ldi5PJgNxIAeCdI1iNTXwi7ldtN/ymD2z2aaqtMxa8WT+k+U3IMQ/hv8im1Em40xIN6is443kfOrClgnjrVCz1bV6jx1l3vC++/9SiR3dMpQlQ7ht0Ochhc5j/3ZKTGrwLeQYkdxiZQ8/wUB3kw9yDHJU1eF3nNzbHuc++Nlg8zEs+dDmg/aSmbbzrc2q4gFyp7lJILhaZ6xyzmp7U5/7XNVYoPvqHz5W5srkKs3Kgt4xsPl8hCWHabx3GPl1/dHiJI++d+4EU1Uuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pd5tqvTa6xvEYJ44Dt5463qSdZ9On+0UnUjylKhegr8=;
 b=FNhJqb3WwBlB2kxhSAbX/BennsJ1dqlhotB/3ZHZxuSki1BnqmiyP2mLha2ic/7JdygmwnQBiB/Ol50W8DBy24Xy2CycpAwl47lAbQcHjdjvgjVIamvAb+hWSUrDwCRG9gxLXkgkNcAlMNMq+JEekVM+0gir73p4bNZgbe/MRKT0UuOZM+JTV9uGiX6fsMviXPMb2WY8tKAnk2UiduqbLVqvIQSkHfgB7GEixkxKOOvs4Fpnr3lUWABGkIXt2Sg5+uP5k91ZILo9+8igLv0pZVtAE4a9yGDkW6i0gLmGIa5Yfw7BTofF3vzRaQycdug1ohhCVW3fjuQnfj84ulMmSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::39) by
 DB3EUR04HT098.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::124)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:26:22 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:26:22 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:37CE4F438BC61B38067051E65AF3E2968517349F957219336FCCDA618C080E2F;UpperCasedChecksum:DBA3AA576F2428A0568806CE8995B99A0AA642CB8F5443D70BBEABA9F842296F;SizeAsReceived:9412;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:26:22 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 07/16] selftests/ptrace: add test cases for dead-locks
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
Message-ID: <AM6PR03MB517022530A9BECDBCAADC8D2E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:26:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:e6::45) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <a3be730a-ec79-4ab7-a0d6-e56227b68b0c@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR01CA0068.eurprd01.prod.exchangelabs.com (2603:10a6:208:e6::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Fri, 20 Mar 2020 20:26:21 +0000
X-Microsoft-Original-Message-ID: <a3be730a-ec79-4ab7-a0d6-e56227b68b0c@hotmail.de>
X-TMN:  [FczRzGiRDb3oaKdVwSJahXA7QSJR1crD]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: cd599a82-2d7d-4448-bf05-08d7cd0cf47d
X-MS-TrafficTypeDiagnostic: DB3EUR04HT098:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TjgjVV4YphAWfzM0xWYSz3GiS8CR2rQMIeDoSmT+afGjuP5wd9knGa93x5wyI5SWHfgjjX5YdqOYkuMwmIYnWeDHAl1/SukK9V+P+hU3wGBNVB1cl3656CSyi+vQVpRicY//1sTcQ5MaNX63OA0BKI9MLOIPdKyVkmx5ze4WWmY8gTdjq9dUVZtZr81d9bO8
X-MS-Exchange-AntiSpam-MessageData: aefkdQqnH8qqunrS9TsJiQLQVGvQorkqRk+FG2k2yzILNvP/AZR5/rAIWHvGP5H8F6pCBd9cgW82Z2UviAEu8BHl1Y9hkguLsdV2CiP/FC5KHMx4uBYgDvRGU8ZsQ0tlDR1ywr3eKp0bkMsWFOAelQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd599a82-2d7d-4448-bf05-08d7cd0cf47d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:26:22.4246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT098
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
Reviewed-by: Kees Cook <keescook@chromium.org>
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

