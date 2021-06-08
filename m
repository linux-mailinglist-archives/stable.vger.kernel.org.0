Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018F13A0068
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhFHSnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234931AbhFHSky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5797E6136D;
        Tue,  8 Jun 2021 18:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177298;
        bh=U9D0qkBO023buMI4PG4IeX2hoAsSIIZ9A5EMkG3YrvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYpz7PfsUCqq0tTHCHquw0mG5k22lwBGQoRi8QTLCuZituK5Uglm73gXzDm+5n1xH
         eMB/GUMATkrF8VXNeifQOvtb93Z9aP0yPiU5neDR82Epj6LcchjVcm8h4W/3Clw0pD
         mMsO7ozznxbe2e2X43O/6Zyc+y6Db00X6BKKAgDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 4.19 43/58] bpf: Add BPF_F_ANY_ALIGNMENT.
Date:   Tue,  8 Jun 2021 20:27:24 +0200
Message-Id: <20210608175933.690935367@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/bpf.h                    |   14 ++++++++++++++
 kernel/bpf/syscall.c                        |    7 ++++++-
 kernel/bpf/verifier.c                       |    3 +++
 tools/include/uapi/linux/bpf.h              |   14 ++++++++++++++
 tools/lib/bpf/bpf.c                         |    8 ++++----
 tools/lib/bpf/bpf.h                         |    2 +-
 tools/testing/selftests/bpf/test_align.c    |    4 ++--
 tools/testing/selftests/bpf/test_verifier.c |    3 ++-
 8 files changed, 46 insertions(+), 9 deletions(-)

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
 
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1367,9 +1367,14 @@ static int bpf_prog_load(union bpf_attr
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
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6440,6 +6440,9 @@ int bpf_check(struct bpf_prog **prog, un
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		env->strict_alignment = true;
 
+	if (attr->prog_flags & BPF_F_ANY_ALIGNMENT)
+		env->strict_alignment = false;
+
 	ret = replace_map_fd_with_map_ptr(env);
 	if (ret < 0)
 		goto skip_full_check;
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
 
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -261,9 +261,9 @@ int bpf_load_program(enum bpf_prog_type
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
 
@@ -277,7 +277,7 @@ int bpf_verify_program(enum bpf_prog_typ
 	attr.log_level = log_level;
 	log_buf[0] = 0;
 	attr.kern_version = kern_version;
-	attr.prog_flags = strict_alignment ? BPF_F_STRICT_ALIGNMENT : 0;
+	attr.prog_flags = prog_flags;
 
 	return sys_bpf_prog_load(&attr, sizeof(attr));
 }
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -79,7 +79,7 @@ int bpf_load_program(enum bpf_prog_type
 		     __u32 kern_version, char *log_buf,
 		     size_t log_buf_sz);
 int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
-		       size_t insns_cnt, int strict_alignment,
+		       size_t insns_cnt, __u32 prog_flags,
 		       const char *license, __u32 kern_version,
 		       char *log_buf, size_t log_buf_sz, int log_level);
 
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -620,8 +620,8 @@ static int do_test_single(struct bpf_ali
 
 	prog_len = probe_filter_length(prog);
 	fd_prog = bpf_verify_program(prog_type ? : BPF_PROG_TYPE_SOCKET_FILTER,
-				     prog, prog_len, 1, "GPL", 0,
-				     bpf_vlog, sizeof(bpf_vlog), 2);
+				     prog, prog_len, BPF_F_STRICT_ALIGNMENT,
+				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 2);
 	if (fd_prog < 0 && test->result != REJECT) {
 		printf("Failed to load program.\n");
 		printf("%s", bpf_vlog);
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -12862,7 +12862,8 @@ static void do_test_single(struct bpf_te
 	prog_len = probe_filter_length(prog);
 
 	fd_prog = bpf_verify_program(prog_type, prog, prog_len,
-				     test->flags & F_LOAD_WITH_STRICT_ALIGNMENT,
+				     test->flags & F_LOAD_WITH_STRICT_ALIGNMENT ?
+				     BPF_F_STRICT_ALIGNMENT : 0,
 				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 1);
 
 	expected_ret = unpriv && test->result_unpriv != UNDEF ?


