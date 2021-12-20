Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0415747ADBA
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbhLTOyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:54:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58500 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbhLTOwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:52:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7246AB80EE7;
        Mon, 20 Dec 2021 14:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FD1C36AE8;
        Mon, 20 Dec 2021 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011927;
        bh=dwnU07I5yg1G5kWJ0Po3J7gwDEbRTW4NopkTdNoynr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCd3516XBAA+82aE0N7fIJzxm8H7l45b8PrYWHI0ROyuIxlqaSWl7VjER0rIwu9Lu
         M1hDQgrNUCDTZjeibn7N2f8nzR+VCpM7I6JWe4pc14IDXYWU7tl86a+MxT222zWEup
         f3apujdd4yxyrko4Q2RyZlqroWKi2GUjKpwWMLgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Jackman <jackmanb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 019/177] bpf, selftests: Update test case for atomic cmpxchg on r0 with pointer
Date:   Mon, 20 Dec 2021 15:32:49 +0100
Message-Id: <20211220143040.727076057@linuxfoundation.org>
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

commit e523102cb719cbad1673b6aa2a4d5c1fa6f13799 upstream.

Fix up unprivileged test case results for 'Dest pointer in r0' verifier tests
given they now need to reject R0 containing a pointer value, and add a couple
of new related ones with 32bit cmpxchg as well.

  root@foo:~/bpf/tools/testing/selftests/bpf# ./test_verifier
  #0/u invalid and of negative number OK
  #0/p invalid and of negative number OK
  [...]
  #1268/p XDP pkt read, pkt_meta' <= pkt_data, bad access 1 OK
  #1269/p XDP pkt read, pkt_meta' <= pkt_data, bad access 2 OK
  #1270/p XDP pkt read, pkt_data <= pkt_meta', good access OK
  #1271/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
  #1272/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
  Summary: 1900 PASSED, 0 SKIPPED, 0 FAILED

Acked-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/atomic_cmpxchg.c |   67 +++++++++++++++++-
 1 file changed, 65 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/verifier/atomic_cmpxchg.c
+++ b/tools/testing/selftests/bpf/verifier/atomic_cmpxchg.c
@@ -71,6 +71,8 @@
 		BPF_EXIT_INSN(),
 	},
 	.result = ACCEPT,
+	.result_unpriv = REJECT,
+	.errstr_unpriv = "R0 leaks addr into mem",
 },
 {
 	"Can't use cmpxchg on uninit src reg",
@@ -119,7 +121,7 @@
 	},
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "leaking pointer from stack off -8",
+	.errstr_unpriv = "R0 leaks addr into mem",
 },
 {
 	"Dest pointer in r0 - succeed, check 2",
@@ -140,5 +142,66 @@
 	},
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R5 leaks addr into mem",
+	.errstr_unpriv = "R0 leaks addr into mem",
+},
+{
+	"Dest pointer in r0 - succeed, check 3",
+	.insns = {
+		/* r0 = &val */
+		BPF_MOV64_REG(BPF_REG_0, BPF_REG_10),
+		/* val = r0; */
+		BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8),
+		/* r5 = &val */
+		BPF_MOV64_REG(BPF_REG_5, BPF_REG_10),
+		/* r0 = atomic_cmpxchg(&val, r0, r5); */
+		BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, BPF_REG_10, BPF_REG_5, -8),
+		/* exit(0); */
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.errstr = "invalid size of register fill",
+	.errstr_unpriv = "R0 leaks addr into mem",
+},
+{
+	"Dest pointer in r0 - succeed, check 4",
+	.insns = {
+		/* r0 = &val */
+		BPF_MOV32_REG(BPF_REG_0, BPF_REG_10),
+		/* val = r0; */
+		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_0, -8),
+		/* r5 = &val */
+		BPF_MOV32_REG(BPF_REG_5, BPF_REG_10),
+		/* r0 = atomic_cmpxchg(&val, r0, r5); */
+		BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, BPF_REG_10, BPF_REG_5, -8),
+		/* r1 = *r10 */
+		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_10, -8),
+		/* exit(0); */
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.result_unpriv = REJECT,
+	.errstr_unpriv = "R10 partial copy of pointer",
+},
+{
+	"Dest pointer in r0 - succeed, check 5",
+	.insns = {
+		/* r0 = &val */
+		BPF_MOV32_REG(BPF_REG_0, BPF_REG_10),
+		/* val = r0; */
+		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_0, -8),
+		/* r5 = &val */
+		BPF_MOV32_REG(BPF_REG_5, BPF_REG_10),
+		/* r0 = atomic_cmpxchg(&val, r0, r5); */
+		BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, BPF_REG_10, BPF_REG_5, -8),
+		/* r1 = *r0 */
+		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, -8),
+		/* exit(0); */
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.errstr = "R0 invalid mem access",
+	.errstr_unpriv = "R10 partial copy of pointer",
 },


