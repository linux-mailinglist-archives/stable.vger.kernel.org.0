Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A082D737DE
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387863AbfGXTXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387835AbfGXTXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:23:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9BC7229F4;
        Wed, 24 Jul 2019 19:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996225;
        bh=59oAdaqXgoANAtP6mRYrfJhHDP9x6DwuHpXTdgPNU6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZ8aLUvlKtOYH6kuIGUsgC1ezUDiCOBkQ7+7K2GZ1XNXmJ+hNwzNy/Nuijtl5lQnX
         zUbeGHYXZsFnexgEJGFZVCLYLBL++SWnve3nrEPCIEJdjrksQBvF0vA8b/wlLQcywe
         CYbOvh1KKkS6PbucaxWb5IXiZUWHfGkIBb5rJuZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 023/413] selftests/bpf: adjust verifier scale test
Date:   Wed, 24 Jul 2019 21:15:14 +0200
Message-Id: <20190724191737.107564997@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7c0c6095d48dcd0e67c917aa73cdbb2715aafc36 ]

Adjust scale tests to check for new jmp sequence limit.

BPF_JGT had to be changed to BPF_JEQ because the verifier was
too smart. It tracked the known safe range of R0 values
and pruned the search earlier before hitting exact 8192 limit.
bpf_semi_rand_get() was too (un)?lucky.

k = 0; was missing in bpf_fill_scale2.
It was testing a bit shorter sequence of jumps than intended.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c | 31 +++++++++++----------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 288cb740e005..6438d4dc8ae1 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -207,33 +207,35 @@ static void bpf_fill_rand_ld_dw(struct bpf_test *self)
 	self->retval = (uint32_t)res;
 }
 
-/* test the sequence of 1k jumps */
+#define MAX_JMP_SEQ 8192
+
+/* test the sequence of 8k jumps */
 static void bpf_fill_scale1(struct bpf_test *self)
 {
 	struct bpf_insn *insn = self->fill_insns;
 	int i = 0, k = 0;
 
 	insn[i++] = BPF_MOV64_REG(BPF_REG_6, BPF_REG_1);
-	/* test to check that the sequence of 1024 jumps is acceptable */
-	while (k++ < 1024) {
+	/* test to check that the long sequence of jumps is acceptable */
+	while (k++ < MAX_JMP_SEQ) {
 		insn[i++] = BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
 					 BPF_FUNC_get_prandom_u32);
-		insn[i++] = BPF_JMP_IMM(BPF_JGT, BPF_REG_0, bpf_semi_rand_get(), 2);
+		insn[i++] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, bpf_semi_rand_get(), 2);
 		insn[i++] = BPF_MOV64_REG(BPF_REG_1, BPF_REG_10);
 		insn[i++] = BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
 					-8 * (k % 64 + 1));
 	}
-	/* every jump adds 1024 steps to insn_processed, so to stay exactly
-	 * within 1m limit add MAX_TEST_INSNS - 1025 MOVs and 1 EXIT
+	/* every jump adds 1 step to insn_processed, so to stay exactly
+	 * within 1m limit add MAX_TEST_INSNS - MAX_JMP_SEQ - 1 MOVs and 1 EXIT
 	 */
-	while (i < MAX_TEST_INSNS - 1025)
+	while (i < MAX_TEST_INSNS - MAX_JMP_SEQ - 1)
 		insn[i++] = BPF_ALU32_IMM(BPF_MOV, BPF_REG_0, 42);
 	insn[i] = BPF_EXIT_INSN();
 	self->prog_len = i + 1;
 	self->retval = 42;
 }
 
-/* test the sequence of 1k jumps in inner most function (function depth 8)*/
+/* test the sequence of 8k jumps in inner most function (function depth 8)*/
 static void bpf_fill_scale2(struct bpf_test *self)
 {
 	struct bpf_insn *insn = self->fill_insns;
@@ -245,19 +247,20 @@ static void bpf_fill_scale2(struct bpf_test *self)
 		insn[i++] = BPF_EXIT_INSN();
 	}
 	insn[i++] = BPF_MOV64_REG(BPF_REG_6, BPF_REG_1);
-	/* test to check that the sequence of 1024 jumps is acceptable */
-	while (k++ < 1024) {
+	/* test to check that the long sequence of jumps is acceptable */
+	k = 0;
+	while (k++ < MAX_JMP_SEQ) {
 		insn[i++] = BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
 					 BPF_FUNC_get_prandom_u32);
-		insn[i++] = BPF_JMP_IMM(BPF_JGT, BPF_REG_0, bpf_semi_rand_get(), 2);
+		insn[i++] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, bpf_semi_rand_get(), 2);
 		insn[i++] = BPF_MOV64_REG(BPF_REG_1, BPF_REG_10);
 		insn[i++] = BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
 					-8 * (k % (64 - 4 * FUNC_NEST) + 1));
 	}
-	/* every jump adds 1024 steps to insn_processed, so to stay exactly
-	 * within 1m limit add MAX_TEST_INSNS - 1025 MOVs and 1 EXIT
+	/* every jump adds 1 step to insn_processed, so to stay exactly
+	 * within 1m limit add MAX_TEST_INSNS - MAX_JMP_SEQ - 1 MOVs and 1 EXIT
 	 */
-	while (i < MAX_TEST_INSNS - 1025)
+	while (i < MAX_TEST_INSNS - MAX_JMP_SEQ - 1)
 		insn[i++] = BPF_ALU32_IMM(BPF_MOV, BPF_REG_0, 42);
 	insn[i] = BPF_EXIT_INSN();
 	self->prog_len = i + 1;
-- 
2.20.1



