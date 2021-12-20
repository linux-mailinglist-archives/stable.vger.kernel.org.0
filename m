Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED8F47ADA9
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbhLTOxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:53:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43080 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235630AbhLTOvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:51:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C4BB611A7;
        Mon, 20 Dec 2021 14:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61275C36AE7;
        Mon, 20 Dec 2021 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011897;
        bh=Plyd6OrvugmVCjWxktHb7GvXnPeTbcSkZgmym+oLiQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YotAJxMlweNlP1JJQ8zqbVdoQALYe7aRDuZv7y3QULMxjoUo1Ba+XObPEuB9+PO5T
         Yi4o6V7JduHpHYLmRvxzg2zrf1oND1o88LfWnyGHqAIOyvoqZGqQAwmCZXiZc4Xnag
         5uYi0yGZjVJCW3/g0PCyY+6QMHJdqbcgjXRE/qQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Jackman <jackmanb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 014/177] bpf, selftests: Add test case for atomic fetch on spilled pointer
Date:   Mon, 20 Dec 2021 15:32:44 +0100
Message-Id: <20211220143040.554980581@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 180486b430f4e22cc00a478163d942804baae4b5 upstream.

Test whether unprivileged would be able to leak the spilled pointer either
by exporting the returned value from the atomic{32,64} operation or by reading
and exporting the value from the stack after the atomic operation took place.

Note that for unprivileged, the below atomic cmpxchg test case named "Dest
pointer in r0 - succeed" is failing. The reason is that in the dst memory
location (r10 -8) there is the spilled register r10:

  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (bf) r0 = r10
  1: R0_w=fp0 R1=ctx(id=0,off=0,imm=0) R10=fp0
  1: (7b) *(u64 *)(r10 -8) = r0
  2: R0_w=fp0 R1=ctx(id=0,off=0,imm=0) R10=fp0 fp-8_w=fp
  2: (b7) r1 = 0
  3: R0_w=fp0 R1_w=invP0 R10=fp0 fp-8_w=fp
  3: (db) r0 = atomic64_cmpxchg((u64 *)(r10 -8), r0, r1)
  4: R0_w=fp0 R1_w=invP0 R10=fp0 fp-8_w=mmmmmmmm
  4: (79) r1 = *(u64 *)(r0 -8)
  5: R0_w=fp0 R1_w=invP(id=0) R10=fp0 fp-8_w=mmmmmmmm
  5: (b7) r0 = 0
  6: R0_w=invP0 R1_w=invP(id=0) R10=fp0 fp-8_w=mmmmmmmm
  6: (95) exit

However, allowing this case for unprivileged is a bit useless given an
update with a new pointer will fail anyway:

  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (bf) r0 = r10
  1: R0_w=fp0 R1=ctx(id=0,off=0,imm=0) R10=fp0
  1: (7b) *(u64 *)(r10 -8) = r0
  2: R0_w=fp0 R1=ctx(id=0,off=0,imm=0) R10=fp0 fp-8_w=fp
  2: (db) r0 = atomic64_cmpxchg((u64 *)(r10 -8), r0, r10)
  R10 leaks addr into mem

Acked-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[only backport one test for 5.15.y - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/atomic_cmpxchg.c |   23 ++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/tools/testing/selftests/bpf/verifier/atomic_cmpxchg.c
+++ b/tools/testing/selftests/bpf/verifier/atomic_cmpxchg.c
@@ -118,4 +118,27 @@
 		BPF_EXIT_INSN(),
 	},
 	.result = ACCEPT,
+	.result_unpriv = REJECT,
+	.errstr_unpriv = "leaking pointer from stack off -8",
+},
+{
+	"Dest pointer in r0 - succeed, check 2",
+	.insns = {
+		/* r0 = &val */
+		BPF_MOV64_REG(BPF_REG_0, BPF_REG_10),
+		/* val = r0; */
+		BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8),
+		/* r5 = &val */
+		BPF_MOV64_REG(BPF_REG_5, BPF_REG_10),
+		/* r0 = atomic_cmpxchg(&val, r0, r5); */
+		BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, BPF_REG_10, BPF_REG_5, -8),
+		/* r1 = *r0 */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
+		/* exit(0); */
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.result_unpriv = REJECT,
+	.errstr_unpriv = "R5 leaks addr into mem",
 },


