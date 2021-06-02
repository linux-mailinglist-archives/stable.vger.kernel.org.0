Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD0397F7B
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 05:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhFBD3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 23:29:51 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45746 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231210AbhFBD3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 23:29:51 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH0O6+rZgh7MIAA--.9496S4;
        Wed, 02 Jun 2021 11:28:02 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 2/9] bpf: test make sure to run unpriv test cases in test_verifier
Date:   Wed,  2 Jun 2021 11:27:46 +0800
Message-Id: <1622604473-781-3-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxH0O6+rZgh7MIAA--.9496S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4DAFy8CrWftFW5AF1UWrg_yoWrWFyUpa
        9xG3ZIkF4kKF1agw47ArZ5ZFsYkFn2q3s8GF12kw1xAa13AwsxtF4UCry8tF9xCrZ5XFy3
        Aa1qgFyY9FsrJFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBYb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv
        6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xSY4AK67AK6r48MxAIw28IcxkI7V
        AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
        r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6x
        IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU5E0PDUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 832c6f2c29ec519b766923937f4f93fb1008b47d upstream

Right now unprivileged tests are never executed as a BPF test run,
only loaded. Allow for running them as well so that we can check
the outcome and probe for regressions.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 tools/testing/selftests/bpf/test_verifier.c | 71 ++++++++++++++++-------------
 1 file changed, 40 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index d33d1d7..38dd129 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -70,7 +70,7 @@ struct bpf_test {
 	int fixup_cgroup_storage[MAX_FIXUPS];
 	const char *errstr;
 	const char *errstr_unpriv;
-	uint32_t retval;
+	uint32_t retval, retval_unpriv;
 	enum {
 		UNDEF,
 		ACCEPT,
@@ -2986,6 +2986,8 @@ static struct bpf_test tests[] = {
 		.fixup_prog1 = { 2 },
 		.result = ACCEPT,
 		.retval = 42,
+		/* Verifier rewrite for unpriv skips tail call here. */
+		.retval_unpriv = 2,
 	},
 	{
 		"stack pointer arithmetic",
@@ -12811,6 +12813,33 @@ static void do_test_fixup(struct bpf_test *test, struct bpf_insn *prog,
 	}
 }
 
+static int set_admin(bool admin)
+{
+	cap_t caps;
+	const cap_value_t cap_val = CAP_SYS_ADMIN;
+	int ret = -1;
+
+	caps = cap_get_proc();
+	if (!caps) {
+		perror("cap_get_proc");
+		return -1;
+	}
+	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_val,
+				admin ? CAP_SET : CAP_CLEAR)) {
+		perror("cap_set_flag");
+		goto out;
+	}
+	if (cap_set_proc(caps)) {
+		perror("cap_set_proc");
+		goto out;
+	}
+	ret = 0;
+out:
+	if (cap_free(caps))
+		perror("cap_free");
+	return ret;
+}
+
 static void do_test_single(struct bpf_test *test, bool unpriv,
 			   int *passes, int *errors)
 {
@@ -12819,6 +12848,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	struct bpf_insn *prog = test->insns;
 	int map_fds[MAX_NR_MAPS];
 	const char *expected_err;
+	uint32_t expected_val;
 	uint32_t retval;
 	int i, err;
 
@@ -12836,6 +12866,8 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		       test->result_unpriv : test->result;
 	expected_err = unpriv && test->errstr_unpriv ?
 		       test->errstr_unpriv : test->errstr;
+	expected_val = unpriv && test->retval_unpriv ?
+		       test->retval_unpriv : test->retval;
 
 	reject_from_alignment = fd_prog < 0 &&
 				(test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -12869,16 +12901,20 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		__u8 tmp[TEST_DATA_LEN << 2];
 		__u32 size_tmp = sizeof(tmp);
 
+		if (unpriv)
+			set_admin(true);
 		err = bpf_prog_test_run(fd_prog, 1, test->data,
 					sizeof(test->data), tmp, &size_tmp,
 					&retval, NULL);
+		if (unpriv)
+			set_admin(false);
 		if (err && errno != 524/*ENOTSUPP*/ && errno != EPERM) {
 			printf("Unexpected bpf_prog_test_run error\n");
 			goto fail_log;
 		}
-		if (!err && retval != test->retval &&
-		    test->retval != POINTER_VALUE) {
-			printf("FAIL retval %d != %d\n", retval, test->retval);
+		if (!err && retval != expected_val &&
+		    expected_val != POINTER_VALUE) {
+			printf("FAIL retval %d != %d\n", retval, expected_val);
 			goto fail_log;
 		}
 	}
@@ -12921,33 +12957,6 @@ static bool is_admin(void)
 	return (sysadmin == CAP_SET);
 }
 
-static int set_admin(bool admin)
-{
-	cap_t caps;
-	const cap_value_t cap_val = CAP_SYS_ADMIN;
-	int ret = -1;
-
-	caps = cap_get_proc();
-	if (!caps) {
-		perror("cap_get_proc");
-		return -1;
-	}
-	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_val,
-				admin ? CAP_SET : CAP_CLEAR)) {
-		perror("cap_set_flag");
-		goto out;
-	}
-	if (cap_set_proc(caps)) {
-		perror("cap_set_proc");
-		goto out;
-	}
-	ret = 0;
-out:
-	if (cap_free(caps))
-		perror("cap_free");
-	return ret;
-}
-
 static void get_unpriv_disabled()
 {
 	char buf[2];
-- 
2.1.0

