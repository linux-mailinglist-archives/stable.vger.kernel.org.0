Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225C1397F80
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 05:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhFBDaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 23:30:01 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45838 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231217AbhFBDaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 23:30:01 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH0O6+rZgh7MIAA--.9496S7;
        Wed, 02 Jun 2021 11:28:13 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 5/9] bpf: Adjust F_NEEDS_EFFICIENT_UNALIGNED_ACCESS handling in test_verifier.c
Date:   Wed,  2 Jun 2021 11:27:49 +0800
Message-Id: <1622604473-781-6-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxH0O6+rZgh7MIAA--.9496S7
X-Coremail-Antispam: 1UD129KBjvJXoWxXFyDGrykWFyfCFWUtFyfXrb_yoWrCrWrpF
        1ftF90kF48tF13K3y2y34kuFW0v3WvqryfCF10y347XF1kA34xKrW8WFyrXF95CrZ5X3WF
        9w17t3Z0kw13XaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBab7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
        jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI
        8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2
        z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
        AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1l
        Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8GwCF04k20x
        vY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I
        3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIx
        AIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAI
        cVCF04k26cxKx2IYs7xG6r1I6r4UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07brtxDUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

commit c7665702d3208b77b8e00f0699b6b88241b04360 upstream

Make it set the flag argument to bpf_verify_program() which will relax
the alignment restrictions.

Now all such test cases will go properly through the verifier even on
inefficient unaligned access architectures.

On inefficient unaligned access architectures do not try to run such
programs, instead mark the test case as passing but annotate the
result similarly to how it is done now in the presence of this flag.

So, we get complete full coverage for all REJECT test cases, and at
least verifier level coverage for ACCEPT test cases.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 tools/testing/selftests/bpf/test_verifier.c | 42 ++++++++++++++++-------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 919f97a..686f5d1 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -12844,13 +12844,14 @@ static int set_admin(bool admin)
 static void do_test_single(struct bpf_test *test, bool unpriv,
 			   int *passes, int *errors)
 {
-	int fd_prog, expected_ret, reject_from_alignment;
+	int fd_prog, expected_ret, alignment_prevented_execution;
 	int prog_len, prog_type = test->prog_type;
 	struct bpf_insn *prog = test->insns;
 	int map_fds[MAX_NR_MAPS];
 	const char *expected_err;
 	uint32_t expected_val;
 	uint32_t retval;
+	__u32 pflags;
 	int i, err;
 
 	for (i = 0; i < MAX_NR_MAPS; i++)
@@ -12861,9 +12862,12 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	do_test_fixup(test, prog_type, prog, map_fds);
 	prog_len = probe_filter_length(prog);
 
-	fd_prog = bpf_verify_program(prog_type, prog, prog_len,
-				     test->flags & F_LOAD_WITH_STRICT_ALIGNMENT ?
-				     BPF_F_STRICT_ALIGNMENT : 0,
+	pflags = 0;
+	if (test->flags & F_LOAD_WITH_STRICT_ALIGNMENT)
+		pflags |= BPF_F_STRICT_ALIGNMENT;
+	if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
+		pflags |= BPF_F_ANY_ALIGNMENT;
+	fd_prog = bpf_verify_program(prog_type, prog, prog_len, pflags,
 				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 1);
 
 	expected_ret = unpriv && test->result_unpriv != UNDEF ?
@@ -12873,28 +12877,27 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	expected_val = unpriv && test->retval_unpriv ?
 		       test->retval_unpriv : test->retval;
 
-	reject_from_alignment = fd_prog < 0 &&
-				(test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS) &&
-				strstr(bpf_vlog, "misaligned");
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-	if (reject_from_alignment) {
-		printf("FAIL\nFailed due to alignment despite having efficient unaligned access: '%s'!\n",
-		       strerror(errno));
-		goto fail_log;
-	}
-#endif
+	alignment_prevented_execution = 0;
+
 	if (expected_ret == ACCEPT) {
-		if (fd_prog < 0 && !reject_from_alignment) {
+		if (fd_prog < 0) {
 			printf("FAIL\nFailed to load prog '%s'!\n",
 			       strerror(errno));
 			goto fail_log;
 		}
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+		if (fd_prog >= 0 &&
+		    (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)) {
+			alignment_prevented_execution = 1;
+			goto test_ok;
+		}
+#endif
 	} else {
 		if (fd_prog >= 0) {
 			printf("FAIL\nUnexpected success to load!\n");
 			goto fail_log;
 		}
-		if (!strstr(bpf_vlog, expected_err) && !reject_from_alignment) {
+		if (!strstr(bpf_vlog, expected_err)) {
 			printf("FAIL\nUnexpected error message!\n\tEXP: %s\n\tRES: %s\n",
 			      expected_err, bpf_vlog);
 			goto fail_log;
@@ -12922,9 +12925,12 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 			goto fail_log;
 		}
 	}
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+test_ok:
+#endif
 	(*passes)++;
-	printf("OK%s\n", reject_from_alignment ?
-	       " (NOTE: reject due to unknown alignment)" : "");
+	printf("OK%s\n", alignment_prevented_execution ?
+	       " (NOTE: not executed due to unknown alignment)" : "");
 close_fds:
 	close(fd_prog);
 	for (i = 0; i < MAX_NR_MAPS; i++)
-- 
2.1.0

