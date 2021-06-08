Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEE93A0066
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhFHSnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234934AbhFHSky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 397E06144A;
        Tue,  8 Jun 2021 18:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177300;
        bh=UEsv5ddVqA4g+fv6DYkiOABsopuhGzjQhwUUAVWFk/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVzDo3O3Ds5K5baK3G3NY9XSrcKz3QG9MQ3fK3OczW1DfPHi8/qXvGZ0fA4NRSrQV
         zp4RkNONruCXs549SSBNvx+8124YWAQkbN9/p96je0qOD40nRgmqsKOq5B3FVr6XZj
         K/K8GbtoJBdGiqTQ5zATuTdvw1O00dRiQNkZ1CM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 4.19 44/58] bpf: Adjust F_NEEDS_EFFICIENT_UNALIGNED_ACCESS handling in test_verifier.c
Date:   Tue,  8 Jun 2021 20:27:25 +0200
Message-Id: <20210608175933.725742779@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   42 ++++++++++++++++------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -12844,13 +12844,14 @@ out:
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
@@ -12861,9 +12862,12 @@ static void do_test_single(struct bpf_te
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
@@ -12873,28 +12877,27 @@ static void do_test_single(struct bpf_te
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
@@ -12922,9 +12925,12 @@ static void do_test_single(struct bpf_te
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


