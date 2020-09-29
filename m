Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739B127C8A1
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731796AbgI2MD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729595AbgI2Lie (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A8022207;
        Tue, 29 Sep 2020 11:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379505;
        bh=u1qOtWnMXAlI04ZQS3g+oAR6V6XOrFj1hlQQ0sO9zp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W05wgn7fajc8j2OQ0OgApBpODPsjOm56XyJ+Fpf6bW3+WGvOwAJ7ybUy7kE1CZcjH
         QSHhE6PIjmJ0vPlP5/hSDTopu6Nbp7PWMgM9Gu6sw3uXUxLGVtHdc/wi7MZOjASRnH
         iN8OdYhmEeaUCWQ0RUlEjnc2zXFIbOX82rZqVuk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/388] selftests/ptrace: add test cases for dead-locks
Date:   Tue, 29 Sep 2020 12:58:45 +0200
Message-Id: <20200929110019.871205043@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernd Edlinger <bernd.edlinger@hotmail.de>

[ Upstream commit 2de4e82318c7f9d34f4b08599a612cd4cd10bf0b ]

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
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ptrace/Makefile   |  4 +-
 tools/testing/selftests/ptrace/vmaccess.c | 86 +++++++++++++++++++++++
 2 files changed, 88 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/ptrace/vmaccess.c

diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
index c0b7f89f09300..2f1f532c39dbc 100644
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
index 0000000000000..4db327b445862
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
2.25.1



