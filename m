Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE843E2577
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244136AbhHFIUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241151AbhHFISu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7EB961220;
        Fri,  6 Aug 2021 08:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237901;
        bh=ECQJY4M4aufuxj5j0EWXm7QYorICMFUHTR53N99EfRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmlCaml66vXxDL+iK4my//HIjLl8sc2zp7nBiqewG+BEk/MHhk5MkWpGfz+u5UIKt
         xFLxPhS3zeCOWWoGUJS8NsKvUlnHuAI3lLdG7v3Ti7/bNEuNKjvF7hYfrCquWX0VXR
         MtuGehILYAJIgk4JRYWWIgrZi0KZBb1H0rp96VJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 21/23] bpf: Test_verifier, add alu32 bounds tracking tests
Date:   Fri,  6 Aug 2021 10:16:53 +0200
Message-Id: <20210806081112.866840862@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 41f70fe0649dddf02046315dc566e06da5a2dc91 upstream

Its possible to have divergent ALU32 and ALU64 bounds when using JMP32
instructins and ALU64 arithmatic operations. Sometimes the clang will
even generate this code. Because the case is a bit tricky lets add
a specific test for it.

Here is  pseudocode asm version to illustrate the idea,

 1 r0 = 0xffffffff00000001;
 2 if w0 > 1 goto %l[fail];
 3 r0 += 1
 5 if w0 > 2 goto %l[fail]
 6 exit

The intent here is the verifier will fail the load if the 32bit bounds
are not tracked correctly through ALU64 op. Similarly we can check the
64bit bounds are correctly zero extended after ALU32 ops.

 1 r0 = 0xffffffff00000001;
 2 w0 += 1
 2 if r0 > 3 goto %l[fail];
 6 exit

The above will fail if we do not correctly zero extend 64bit bounds
after 32bit op.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/158560430155.10843.514209255758200922.stgit@john-Precision-5820-Tower
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/bounds.c |   39 ++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -506,3 +506,42 @@
 	.errstr = "map_value pointer and 1000000000000",
 	.result = REJECT
 },
+{
+	"bounds check mixed 32bit and 64bit arithmatic. test1",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_1, -1),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_1, 32),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+	/* r1 = 0xffffFFFF00000001 */
+	BPF_JMP32_IMM(BPF_JGT, BPF_REG_1, 1, 3),
+	/* check ALU64 op keeps 32bit bounds */
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+	BPF_JMP32_IMM(BPF_JGT, BPF_REG_1, 2, 1),
+	BPF_JMP_A(1),
+	/* invalid ldx if bounds are lost above */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT
+},
+{
+	"bounds check mixed 32bit and 64bit arithmatic. test2",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_1, -1),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_1, 32),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+	/* r1 = 0xffffFFFF00000001 */
+	BPF_MOV64_IMM(BPF_REG_2, 3),
+	/* r1 = 0x2 */
+	BPF_ALU32_IMM(BPF_ADD, BPF_REG_1, 1),
+	/* check ALU32 op zero extends 64bit bounds */
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_2, 1),
+	BPF_JMP_A(1),
+	/* invalid ldx if bounds are lost above */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT
+},


