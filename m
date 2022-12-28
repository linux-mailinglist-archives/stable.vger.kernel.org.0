Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BF2657B42
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiL1PTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiL1PTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:19:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933BC13FB1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:19:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 218DF6155A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32751C433D2;
        Wed, 28 Dec 2022 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240772;
        bh=afBfh8TpuOC3gNh8WIupk+O/4jtTztxTy/A5QLQ+9wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srPmtWkDd7wXP7TXwNC9LOAklehc2EA12zl0m4cvnq944IM1JVxqOFRbBJa/tawYg
         tXTrRgsM6oLxoEHH5mvUe+my6WnoGlAjIHqii5QR6pD0SFQRzD6wXzW912IHwqlwNL
         0LdztuL5PiU3m5A8j3UPfy6lskquOuhexb3R7eOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0201/1073] selftests/bpf: Add struct argument tests with fentry/fexit programs.
Date:   Wed, 28 Dec 2022 15:29:49 +0100
Message-Id: <20221228144333.476689080@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 1642a3945e223a922312fab2401ecdf58b3825b9 ]

Add various struct argument tests with fentry/fexit programs.
Also add one test with a kernel func which does not have any
argument to test BPF_PROG2 macro in such situation.

Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20220831152713.2080039-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 6e8280b958c5 ("selftests/bpf: Fix memory leak caused by not destroying skeleton")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  48 +++++++
 .../selftests/bpf/prog_tests/tracing_struct.c |  63 +++++++++
 .../selftests/bpf/progs/tracing_struct.c      | 120 ++++++++++++++++++
 3 files changed, 231 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tracing_struct.c
 create mode 100644 tools/testing/selftests/bpf/progs/tracing_struct.c

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index ac5d7c1396fb..5085fea3cac5 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -18,6 +18,46 @@ typedef int (*func_proto_typedef_nested1)(func_proto_typedef);
 typedef int (*func_proto_typedef_nested2)(func_proto_typedef_nested1);
 
 DEFINE_PER_CPU(int, bpf_testmod_ksym_percpu) = 123;
+long bpf_testmod_test_struct_arg_result;
+
+struct bpf_testmod_struct_arg_1 {
+	int a;
+};
+struct bpf_testmod_struct_arg_2 {
+	long a;
+	long b;
+};
+
+noinline int
+bpf_testmod_test_struct_arg_1(struct bpf_testmod_struct_arg_2 a, int b, int c) {
+	bpf_testmod_test_struct_arg_result = a.a + a.b  + b + c;
+	return bpf_testmod_test_struct_arg_result;
+}
+
+noinline int
+bpf_testmod_test_struct_arg_2(int a, struct bpf_testmod_struct_arg_2 b, int c) {
+	bpf_testmod_test_struct_arg_result = a + b.a + b.b + c;
+	return bpf_testmod_test_struct_arg_result;
+}
+
+noinline int
+bpf_testmod_test_struct_arg_3(int a, int b, struct bpf_testmod_struct_arg_2 c) {
+	bpf_testmod_test_struct_arg_result = a + b + c.a + c.b;
+	return bpf_testmod_test_struct_arg_result;
+}
+
+noinline int
+bpf_testmod_test_struct_arg_4(struct bpf_testmod_struct_arg_1 a, int b,
+			      int c, int d, struct bpf_testmod_struct_arg_2 e) {
+	bpf_testmod_test_struct_arg_result = a.a + b + c + d + e.a + e.b;
+	return bpf_testmod_test_struct_arg_result;
+}
+
+noinline int
+bpf_testmod_test_struct_arg_5(void) {
+	bpf_testmod_test_struct_arg_result = 1;
+	return bpf_testmod_test_struct_arg_result;
+}
 
 noinline void
 bpf_testmod_test_mod_kfunc(int i)
@@ -115,11 +155,19 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 		.off = off,
 		.len = len,
 	};
+	struct bpf_testmod_struct_arg_1 struct_arg1 = {10};
+	struct bpf_testmod_struct_arg_2 struct_arg2 = {2, 3};
 	int i = 1;
 
 	while (bpf_testmod_return_ptr(i))
 		i++;
 
+	(void)bpf_testmod_test_struct_arg_1(struct_arg2, 1, 4);
+	(void)bpf_testmod_test_struct_arg_2(1, struct_arg2, 4);
+	(void)bpf_testmod_test_struct_arg_3(1, 4, struct_arg2);
+	(void)bpf_testmod_test_struct_arg_4(struct_arg1, 1, 2, 3, struct_arg2);
+	(void)bpf_testmod_test_struct_arg_5();
+
 	/* This is always true. Use the check to make sure the compiler
 	 * doesn't remove bpf_testmod_loop_test.
 	 */
diff --git a/tools/testing/selftests/bpf/prog_tests/tracing_struct.c b/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
new file mode 100644
index 000000000000..d5022b91d1e4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Meta Platforms, Inc. and affiliates. */
+
+#include <test_progs.h>
+#include "tracing_struct.skel.h"
+
+static void test_fentry(void)
+{
+	struct tracing_struct *skel;
+	int err;
+
+	skel = tracing_struct__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "tracing_struct__open_and_load"))
+		return;
+
+	err = tracing_struct__attach(skel);
+	if (!ASSERT_OK(err, "tracing_struct__attach"))
+		return;
+
+	ASSERT_OK(trigger_module_test_read(256), "trigger_read");
+
+	ASSERT_EQ(skel->bss->t1_a_a, 2, "t1:a.a");
+	ASSERT_EQ(skel->bss->t1_a_b, 3, "t1:a.b");
+	ASSERT_EQ(skel->bss->t1_b, 1, "t1:b");
+	ASSERT_EQ(skel->bss->t1_c, 4, "t1:c");
+
+	ASSERT_EQ(skel->bss->t1_nregs, 4, "t1 nregs");
+	ASSERT_EQ(skel->bss->t1_reg0, 2, "t1 reg0");
+	ASSERT_EQ(skel->bss->t1_reg1, 3, "t1 reg1");
+	ASSERT_EQ(skel->bss->t1_reg2, 1, "t1 reg2");
+	ASSERT_EQ(skel->bss->t1_reg3, 4, "t1 reg3");
+	ASSERT_EQ(skel->bss->t1_ret, 10, "t1 ret");
+
+	ASSERT_EQ(skel->bss->t2_a, 1, "t2:a");
+	ASSERT_EQ(skel->bss->t2_b_a, 2, "t2:b.a");
+	ASSERT_EQ(skel->bss->t2_b_b, 3, "t2:b.b");
+	ASSERT_EQ(skel->bss->t2_c, 4, "t2:c");
+	ASSERT_EQ(skel->bss->t2_ret, 10, "t2 ret");
+
+	ASSERT_EQ(skel->bss->t3_a, 1, "t3:a");
+	ASSERT_EQ(skel->bss->t3_b, 4, "t3:b");
+	ASSERT_EQ(skel->bss->t3_c_a, 2, "t3:c.a");
+	ASSERT_EQ(skel->bss->t3_c_b, 3, "t3:c.b");
+	ASSERT_EQ(skel->bss->t3_ret, 10, "t3 ret");
+
+	ASSERT_EQ(skel->bss->t4_a_a, 10, "t4:a.a");
+	ASSERT_EQ(skel->bss->t4_b, 1, "t4:b");
+	ASSERT_EQ(skel->bss->t4_c, 2, "t4:c");
+	ASSERT_EQ(skel->bss->t4_d, 3, "t4:d");
+	ASSERT_EQ(skel->bss->t4_e_a, 2, "t4:e.a");
+	ASSERT_EQ(skel->bss->t4_e_b, 3, "t4:e.b");
+	ASSERT_EQ(skel->bss->t4_ret, 21, "t4 ret");
+
+	ASSERT_EQ(skel->bss->t5_ret, 1, "t5 ret");
+
+	tracing_struct__detach(skel);
+	tracing_struct__destroy(skel);
+}
+
+void test_tracing_struct(void)
+{
+	test_fentry();
+}
diff --git a/tools/testing/selftests/bpf/progs/tracing_struct.c b/tools/testing/selftests/bpf/progs/tracing_struct.c
new file mode 100644
index 000000000000..e718f0ebee7d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tracing_struct.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Meta Platforms, Inc. and affiliates. */
+
+#include <vmlinux.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_helpers.h>
+
+struct bpf_testmod_struct_arg_1 {
+	int a;
+};
+struct bpf_testmod_struct_arg_2 {
+	long a;
+	long b;
+};
+
+long t1_a_a, t1_a_b, t1_b, t1_c, t1_ret, t1_nregs;
+__u64 t1_reg0, t1_reg1, t1_reg2, t1_reg3;
+long t2_a, t2_b_a, t2_b_b, t2_c, t2_ret;
+long t3_a, t3_b, t3_c_a, t3_c_b, t3_ret;
+long t4_a_a, t4_b, t4_c, t4_d, t4_e_a, t4_e_b, t4_ret;
+long t5_ret;
+
+SEC("fentry/bpf_testmod_test_struct_arg_1")
+int BPF_PROG2(test_struct_arg_1, struct bpf_testmod_struct_arg_2, a, int, b, int, c)
+{
+	t1_a_a = a.a;
+	t1_a_b = a.b;
+	t1_b = b;
+	t1_c = c;
+	return 0;
+}
+
+SEC("fexit/bpf_testmod_test_struct_arg_1")
+int BPF_PROG2(test_struct_arg_2, struct bpf_testmod_struct_arg_2, a, int, b, int, c, int, ret)
+{
+	t1_nregs =  bpf_get_func_arg_cnt(ctx);
+	/* a.a */
+	bpf_get_func_arg(ctx, 0, &t1_reg0);
+	/* a.b */
+	bpf_get_func_arg(ctx, 1, &t1_reg1);
+	/* b */
+	bpf_get_func_arg(ctx, 2, &t1_reg2);
+	t1_reg2 = (int)t1_reg2;
+	/* c */
+	bpf_get_func_arg(ctx, 3, &t1_reg3);
+	t1_reg3 = (int)t1_reg3;
+
+	t1_ret = ret;
+	return 0;
+}
+
+SEC("fentry/bpf_testmod_test_struct_arg_2")
+int BPF_PROG2(test_struct_arg_3, int, a, struct bpf_testmod_struct_arg_2, b, int, c)
+{
+	t2_a = a;
+	t2_b_a = b.a;
+	t2_b_b = b.b;
+	t2_c = c;
+	return 0;
+}
+
+SEC("fexit/bpf_testmod_test_struct_arg_2")
+int BPF_PROG2(test_struct_arg_4, int, a, struct bpf_testmod_struct_arg_2, b, int, c, int, ret)
+{
+	t2_ret = ret;
+	return 0;
+}
+
+SEC("fentry/bpf_testmod_test_struct_arg_3")
+int BPF_PROG2(test_struct_arg_5, int, a, int, b, struct bpf_testmod_struct_arg_2, c)
+{
+	t3_a = a;
+	t3_b = b;
+	t3_c_a = c.a;
+	t3_c_b = c.b;
+	return 0;
+}
+
+SEC("fexit/bpf_testmod_test_struct_arg_3")
+int BPF_PROG2(test_struct_arg_6, int, a, int, b, struct bpf_testmod_struct_arg_2, c, int, ret)
+{
+	t3_ret = ret;
+	return 0;
+}
+
+SEC("fentry/bpf_testmod_test_struct_arg_4")
+int BPF_PROG2(test_struct_arg_7, struct bpf_testmod_struct_arg_1, a, int, b,
+	     int, c, int, d, struct bpf_testmod_struct_arg_2, e)
+{
+	t4_a_a = a.a;
+	t4_b = b;
+	t4_c = c;
+	t4_d = d;
+	t4_e_a = e.a;
+	t4_e_b = e.b;
+	return 0;
+}
+
+SEC("fexit/bpf_testmod_test_struct_arg_4")
+int BPF_PROG2(test_struct_arg_8, struct bpf_testmod_struct_arg_1, a, int, b,
+	     int, c, int, d, struct bpf_testmod_struct_arg_2, e, int, ret)
+{
+	t4_ret = ret;
+	return 0;
+}
+
+SEC("fentry/bpf_testmod_test_struct_arg_5")
+int BPF_PROG2(test_struct_arg_9)
+{
+	return 0;
+}
+
+SEC("fexit/bpf_testmod_test_struct_arg_5")
+int BPF_PROG2(test_struct_arg_10, int, ret)
+{
+	t5_ret = ret;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.35.1



