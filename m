Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A9434CAEE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhC2IlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234872AbhC2IkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 399F460C41;
        Mon, 29 Mar 2021 08:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007195;
        bh=J+OJapO/LU9j+9AC6CZF501CwFFDmYzO23IbBdyCzNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXNvhtN6o2+ZMXer6aB0a6EEhRecgtJOWAm3ktGmNyDRYftGCv6xfRL4K5IRgZtQg
         NCXJf0aFt6QoBcjO3D6cTzdueLmb4Qyv9Nbwx8Paif9G+yc2njuZBvtH+rQBubKt4X
         BURNXdaAVqfa7gVIcvv+wJcI4WutcRaaZj9gp4s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.11 254/254] selftest/bpf: Add a test to check trampoline freeing logic.
Date:   Mon, 29 Mar 2021 09:59:30 +0200
Message-Id: <20210329075641.411827417@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit eddbe8e6521401003e37e7848ef72e75c10ee2aa upstream.

Add a selftest for commit e21aa341785c ("bpf: Fix fexit trampoline.")
to make sure that attaching fexit prog to a sleeping kernel function
will trigger appropriate trampoline and program destruction.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210318004523.55908-1-alexei.starovoitov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/fexit_sleep.c |   82 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/fexit_sleep.c      |   31 +++++++
 2 files changed, 113 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_sleep.c

--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#define _GNU_SOURCE
+#include <sched.h>
+#include <test_progs.h>
+#include <time.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include "fexit_sleep.skel.h"
+
+static int do_sleep(void *skel)
+{
+	struct fexit_sleep *fexit_skel = skel;
+	struct timespec ts1 = { .tv_nsec = 1 };
+	struct timespec ts2 = { .tv_sec = 10 };
+
+	fexit_skel->bss->pid = getpid();
+	(void)syscall(__NR_nanosleep, &ts1, NULL);
+	(void)syscall(__NR_nanosleep, &ts2, NULL);
+	return 0;
+}
+
+#define STACK_SIZE (1024 * 1024)
+static char child_stack[STACK_SIZE];
+
+void test_fexit_sleep(void)
+{
+	struct fexit_sleep *fexit_skel = NULL;
+	int wstatus, duration = 0;
+	pid_t cpid;
+	int err, fexit_cnt;
+
+	fexit_skel = fexit_sleep__open_and_load();
+	if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
+		goto cleanup;
+
+	err = fexit_sleep__attach(fexit_skel);
+	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
+		goto cleanup;
+
+	cpid = clone(do_sleep, child_stack + STACK_SIZE, CLONE_FILES | SIGCHLD, fexit_skel);
+	if (CHECK(cpid == -1, "clone", strerror(errno)))
+		goto cleanup;
+
+	/* wait until first sys_nanosleep ends and second sys_nanosleep starts */
+	while (READ_ONCE(fexit_skel->bss->fentry_cnt) != 2);
+	fexit_cnt = READ_ONCE(fexit_skel->bss->fexit_cnt);
+	if (CHECK(fexit_cnt != 1, "fexit_cnt", "%d", fexit_cnt))
+		goto cleanup;
+
+	/* close progs and detach them. That will trigger two nop5->jmp5 rewrites
+	 * in the trampolines to skip nanosleep_fexit prog.
+	 * The nanosleep_fentry prog will get detached first.
+	 * The nanosleep_fexit prog will get detached second.
+	 * Detaching will trigger freeing of both progs JITed images.
+	 * There will be two dying bpf_tramp_image-s, but only the initial
+	 * bpf_tramp_image (with both _fentry and _fexit progs will be stuck
+	 * waiting for percpu_ref_kill to confirm). The other one
+	 * will be freed quickly.
+	 */
+	close(bpf_program__fd(fexit_skel->progs.nanosleep_fentry));
+	close(bpf_program__fd(fexit_skel->progs.nanosleep_fexit));
+	fexit_sleep__detach(fexit_skel);
+
+	/* kill the thread to unwind sys_nanosleep stack through the trampoline */
+	kill(cpid, 9);
+
+	if (CHECK(waitpid(cpid, &wstatus, 0) == -1, "waitpid", strerror(errno)))
+		goto cleanup;
+	if (CHECK(WEXITSTATUS(wstatus) != 0, "exitstatus", "failed"))
+		goto cleanup;
+
+	/* The bypassed nanosleep_fexit prog shouldn't have executed.
+	 * Unlike progs the maps were not freed and directly accessible.
+	 */
+	fexit_cnt = READ_ONCE(fexit_skel->bss->fexit_cnt);
+	if (CHECK(fexit_cnt != 1, "fexit_cnt", "%d", fexit_cnt))
+		goto cleanup;
+
+cleanup:
+	fexit_sleep__destroy(fexit_skel);
+}
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fexit_sleep.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char LICENSE[] SEC("license") = "GPL";
+
+int pid = 0;
+int fentry_cnt = 0;
+int fexit_cnt = 0;
+
+SEC("fentry/__x64_sys_nanosleep")
+int BPF_PROG(nanosleep_fentry, const struct pt_regs *regs)
+{
+	if ((int)bpf_get_current_pid_tgid() != pid)
+		return 0;
+
+	fentry_cnt++;
+	return 0;
+}
+
+SEC("fexit/__x64_sys_nanosleep")
+int BPF_PROG(nanosleep_fexit, const struct pt_regs *regs, int ret)
+{
+	if ((int)bpf_get_current_pid_tgid() != pid)
+		return 0;
+
+	fexit_cnt++;
+	return 0;
+}


