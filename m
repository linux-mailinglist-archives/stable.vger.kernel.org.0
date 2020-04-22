Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFA41B4009
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbgDVKmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730125AbgDVKUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:20:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2CB214AF;
        Wed, 22 Apr 2020 10:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550849;
        bh=FQ8uavis3YI3bIVKci40KEZIaz+QKDXjqwdyCDx3XZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0nVzHx0w4UoUEEmfzyeayBEUcOmn8bFi0FDtiW24ku/+3VARTkq0vSsOOayW+lPm
         V85DCE9fANnJNEsO7nL7g18mTBy2wLcGXfwzpwYdQxRGQd4wRfyOsKZfgQaE+lGb3x
         mLlty6U77g8zVVZyHLI/DToyXM4H4wurTYkjffAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 117/118] bpf: Test_progs, add test to catch retval refine error handling
Date:   Wed, 22 Apr 2020 11:57:58 +0200
Message-Id: <20200422095049.951522413@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit d2db08c7a14e0b5eed6132baf258b80622e041a9 upstream.

Before this series the verifier would clamp return bounds of
bpf_get_stack() to [0, X] and this led the verifier to believe
that a JMP_JSLT 0 would be false and so would prune that path.

The result is anything hidden behind that JSLT would be unverified.
Add a test to catch this case by hiding an goto pc-1 behind the
check which will cause an infinite loop if not rejected.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/158560423908.10843.11783152347709008373.stgit@john-Precision-5820-Tower
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c    |    5 ++
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c |   26 +++++++++++
 2 files changed, 31 insertions(+)

--- a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
@@ -82,6 +82,7 @@ static void get_stack_print_output(void
 void test_get_stack_raw_tp(void)
 {
 	const char *file = "./test_get_stack_rawtp.o";
+	const char *file_err = "./test_get_stack_rawtp_err.o";
 	const char *prog_name = "raw_tracepoint/sys_enter";
 	int i, err, prog_fd, exp_cnt = MAX_CNT_RAWTP;
 	struct perf_buffer_opts pb_opts = {};
@@ -93,6 +94,10 @@ void test_get_stack_raw_tp(void)
 	struct bpf_map *map;
 	cpu_set_t cpu_set;
 
+	err = bpf_prog_load(file_err, BPF_PROG_TYPE_RAW_TRACEPOINT, &obj, &prog_fd);
+	if (CHECK(err >= 0, "prog_load raw tp", "err %d errno %d\n", err, errno))
+		return;
+
 	err = bpf_prog_load(file, BPF_PROG_TYPE_RAW_TRACEPOINT, &obj, &prog_fd);
 	if (CHECK(err, "prog_load raw tp", "err %d errno %d\n", err, errno))
 		return;
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+#define MAX_STACK_RAWTP 10
+
+SEC("raw_tracepoint/sys_enter")
+int bpf_prog2(void *ctx)
+{
+	__u64 stack[MAX_STACK_RAWTP];
+	int error;
+
+	/* set all the flags which should return -EINVAL */
+	error = bpf_get_stack(ctx, stack, 0, -1);
+	if (error < 0)
+		goto loop;
+
+	return error;
+loop:
+	while (1) {
+		error++;
+	}
+}
+
+char _license[] SEC("license") = "GPL";


