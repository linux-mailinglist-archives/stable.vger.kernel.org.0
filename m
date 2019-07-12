Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FCF66E7D
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfGLM1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728557AbfGLM1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:27:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D26E216C4;
        Fri, 12 Jul 2019 12:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934434;
        bh=b44Im4yuvraejeHtjxj2xoFfQZtu0cWcfXBhkj1k270=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YknI4Je5Yq6u9CfzCSKu1kWbB1uMe1Vm2THJ4bAkw9MCKHd2z3qgCInBIsFFSeqIO
         oid+pRnxI3qrwwDC2UZv3JfaeP1lWYTBY6yDkd4p7oG9ajuNMRL3dAznb69YTk1sPY
         RqK0z+kyuoDs2+KHvpuSWpwZN1HaMljpKjZD/NNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 054/138] bpf: fix div64 overflow tests to properly detect errors
Date:   Fri, 12 Jul 2019 14:18:38 +0200
Message-Id: <20190712121630.742274478@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3e0682695199bad51dd898fe064d1564637ff77a ]

If the result of the division is LLONG_MIN, current tests do not detect
the error since the return value is truncated to a 32-bit value and ends
up being 0.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/verifier/div_overflow.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/div_overflow.c b/tools/testing/selftests/bpf/verifier/div_overflow.c
index bd3f38dbe796..acab4f00819f 100644
--- a/tools/testing/selftests/bpf/verifier/div_overflow.c
+++ b/tools/testing/selftests/bpf/verifier/div_overflow.c
@@ -29,8 +29,11 @@
 	"DIV64 overflow, check 1",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_1, -1),
-	BPF_LD_IMM64(BPF_REG_0, LLONG_MIN),
-	BPF_ALU64_REG(BPF_DIV, BPF_REG_0, BPF_REG_1),
+	BPF_LD_IMM64(BPF_REG_2, LLONG_MIN),
+	BPF_ALU64_REG(BPF_DIV, BPF_REG_2, BPF_REG_1),
+	BPF_MOV32_IMM(BPF_REG_0, 0),
+	BPF_JMP_REG(BPF_JEQ, BPF_REG_0, BPF_REG_2, 1),
+	BPF_MOV32_IMM(BPF_REG_0, 1),
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
@@ -40,8 +43,11 @@
 {
 	"DIV64 overflow, check 2",
 	.insns = {
-	BPF_LD_IMM64(BPF_REG_0, LLONG_MIN),
-	BPF_ALU64_IMM(BPF_DIV, BPF_REG_0, -1),
+	BPF_LD_IMM64(BPF_REG_1, LLONG_MIN),
+	BPF_ALU64_IMM(BPF_DIV, BPF_REG_1, -1),
+	BPF_MOV32_IMM(BPF_REG_0, 0),
+	BPF_JMP_REG(BPF_JEQ, BPF_REG_0, BPF_REG_1, 1),
+	BPF_MOV32_IMM(BPF_REG_0, 1),
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
-- 
2.20.1



