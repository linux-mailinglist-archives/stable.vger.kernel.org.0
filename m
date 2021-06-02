Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E624397F81
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 05:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhFBDaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 23:30:01 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45830 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231213AbhFBDaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 23:30:01 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH0O6+rZgh7MIAA--.9496S6;
        Wed, 02 Jun 2021 11:28:08 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 4/9] bpf: Add BPF_F_ANY_ALIGNMENT.
Date:   Wed,  2 Jun 2021 11:27:48 +0800
Message-Id: <1622604473-781-5-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxH0O6+rZgh7MIAA--.9496S6
X-Coremail-Antispam: 1UD129KBjvJXoW3JF1rAFWfJFWDAw48AryxXwb_yoW3WFWfpa
        95GF9IkF4rJF43uwsrAw47ZrWFqanY9ayjkr45Cw15Zr4UX34xJr9FgF4avF9xWrW8Jr4F
        v342vrZ8W34rXrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBIb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
        jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI
        8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
        kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm
        72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xSY4AK67AK6r48MxAIw28Icx
        kI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2Iq
        xVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42
        IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY
        6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aV
        CY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU5WqcUUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

commit e9ee9efc0d176512cdce9d27ff8549d7ffa2bfcd upstream

Often we want to write tests cases that check things like bad context
offset accesses.  And one way to do this is to use an odd offset on,
for example, a 32-bit load.

This unfortunately triggers the alignment checks first on platforms
that do not set CONFIG_EFFICIENT_UNALIGNED_ACCESS.  So the test
case see the alignment failure rather than what it was testing for.

It is often not completely possible to respect the original intention
of the test, or even test the same exact thing, while solving the
alignment issue.

Another option could have been to check the alignment after the
context and other validations are performed by the verifier, but
that is a non-trivial change to the verifier.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 include/uapi/linux/bpf.h                    | 14 ++++++++++++++
 kernel/bpf/syscall.c                        |  7 ++++++-
 kernel/bpf/verifier.c                       |  3 +++
 tools/include/uapi/linux/bpf.h              | 14 ++++++++++++++
 tools/lib/bpf/bpf.c                         |  8 ++++----
 tools/lib/bpf/bpf.h                         |  2 +-
 tools/testing/selftests/bpf/test_align.c    |  4 ++--
 tools/testing/selftests/bpf/test_verifier.c |  3 ++-
 8 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 71ca8c4d..8481fc7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -228,6 +228,20 @@ enum bpf_attach_type {
  */
 #define BPF_F_STRICT_ALIGNMENT	(1U << 0)
 
+/* If BPF_F_ANY_ALIGNMENT is used in BPF_PROF_LOAD command, the
+ * verifier will allow any alignment whatsoever.  On platforms
+ * with strict alignment requirements for loads ands stores (such
+ * as sparc and mips) the verifier validates that all loads and
+ * stores provably follow this requirement.  This flag turns that
+ * checking and enforcement off.
+ *
+ * It is mostly used for testing when we want to validate the
+ * context and memory access aspects of the verifier, but because
+ * of an unaligned access the alignment check would trigger before
+ * the one we are interested in.
+ */
+#define BPF_F_ANY_ALIGNMENT	(1U << 1)
+
 /* when bpf_ldimm64->src_reg == BPF_PSEUDO_MAP_FD, bpf_ldimm64->imm == fd */
 #define BPF_PSEUDO_MAP_FD	1
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 21a366a..353a8d6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1367,9 +1367,14 @@ static int bpf_prog_load(union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_PROG_LOAD))
 		return -EINVAL;
 
-	if (attr->prog_flags & ~BPF_F_STRICT_ALIGNMENT)
+	if (attr->prog_flags & ~(BPF_F_STRICT_ALIGNMENT | BPF_F_ANY_ALIGNMENT))
 		return -EINVAL;
 
+	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
+	    (attr->prog_flags & BPF_F_ANY_ALIGNMENT) &&
+	    !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	/* copy eBPF program license from user space */
 	if (strncpy_from_user(license, u64_to_user_ptr(attr->license),
 			      sizeof(license) - 1) < 0)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1f4c88c..4ce032c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6440,6 +6440,9 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr)
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		env->strict_alignment = true;
 
+	if (attr->prog_flags & BPF_F_ANY_ALIGNMENT)
+		env->strict_alignment = false;
+
 	ret = replace_map_fd_with_map_ptr(env);
 	if (ret < 0)
 		goto skip_full_check;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1394497..9e060c6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -226,6 +226,20 @@ enum bpf_attach_type {
  */
 #define BPF_F_STRICT_ALIGNMENT	(1U << 0)
 
+/* If BPF_F_ANY_ALIGNMENT is used in BPF_PROF_LOAD command, the
+ * verifier will allow any alignment whatsoever.  On platforms
+ * with strict alignment requirements for loads ands stores (such
+ * as sparc and mips) the verifier validates that all loads and
+ * stores provably follow this requirement.  This flag turns that
+ * checking and enforcement off.
+ *
+ * It is mostly used for testing when we want to validate the
+ * context and memory access aspects of the verifier, but because
+ * of an unaligned access the alignment check would trigger before
+ * the one we are interested in.
+ */
+#define BPF_F_ANY_ALIGNMENT	(1U << 1)
+
 /* when bpf_ldimm64->src_reg == BPF_PSEUDO_MAP_FD, bpf_ldimm64->imm == fd */
 #define BPF_PSEUDO_MAP_FD	1
 
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 482025b..f28ae6a 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -261,9 +261,9 @@ int bpf_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 }
 
 int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
-		       size_t insns_cnt, int strict_alignment,
-		       const char *license, __u32 kern_version,
-		       char *log_buf, size_t log_buf_sz, int log_level)
+		       size_t insns_cnt, __u32 prog_flags, const char *license,
+		       __u32 kern_version, char *log_buf, size_t log_buf_sz,
+		       int log_level)
 {
 	union bpf_attr attr;
 
@@ -277,7 +277,7 @@ int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 	attr.log_level = log_level;
 	log_buf[0] = 0;
 	attr.kern_version = kern_version;
-	attr.prog_flags = strict_alignment ? BPF_F_STRICT_ALIGNMENT : 0;
+	attr.prog_flags = prog_flags;
 
 	return sys_bpf_prog_load(&attr, sizeof(attr));
 }
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index c3145ab..7f2e947 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -79,7 +79,7 @@ int bpf_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 		     __u32 kern_version, char *log_buf,
 		     size_t log_buf_sz);
 int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
-		       size_t insns_cnt, int strict_alignment,
+		       size_t insns_cnt, __u32 prog_flags,
 		       const char *license, __u32 kern_version,
 		       char *log_buf, size_t log_buf_sz, int log_level);
 
diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 5f377ec..3c789d0 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -620,8 +620,8 @@ static int do_test_single(struct bpf_align_test *test)
 
 	prog_len = probe_filter_length(prog);
 	fd_prog = bpf_verify_program(prog_type ? : BPF_PROG_TYPE_SOCKET_FILTER,
-				     prog, prog_len, 1, "GPL", 0,
-				     bpf_vlog, sizeof(bpf_vlog), 2);
+				     prog, prog_len, BPF_F_STRICT_ALIGNMENT,
+				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 2);
 	if (fd_prog < 0 && test->result != REJECT) {
 		printf("Failed to load program.\n");
 		printf("%s", bpf_vlog);
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 809d8e9..919f97a 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -12862,7 +12862,8 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	prog_len = probe_filter_length(prog);
 
 	fd_prog = bpf_verify_program(prog_type, prog, prog_len,
-				     test->flags & F_LOAD_WITH_STRICT_ALIGNMENT,
+				     test->flags & F_LOAD_WITH_STRICT_ALIGNMENT ?
+				     BPF_F_STRICT_ALIGNMENT : 0,
 				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 1);
 
 	expected_ret = unpriv && test->result_unpriv != UNDEF ?
-- 
2.1.0

