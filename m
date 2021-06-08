Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CADD39FFD1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhFHSgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234792AbhFHSfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:35:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64AC6613BF;
        Tue,  8 Jun 2021 18:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177118;
        bh=ygpkw/oNghGuNKHJYkEMrbxfUB6NMifsDKHSlRKO6MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dD3Fg6HZ2VqgGCUYWOcgOR2QLazx1E470cs8981VzBdndE4Nt8ClIUbPk8/oMbuZa
         XltAfl4TQHB/2d+JGVy3aqxG7g1wMQDP4t1Q0dV9U28DJ83Qodvwqfu/NevNA+pyaK
         l6AQQPqm7RxOxl7GToCIr27Aqg/+GtpysCR+Y7Ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 39/47] selftests/bpf: make dubious pointer arithmetic test useful
Date:   Tue,  8 Jun 2021 20:27:22 +0200
Message-Id: <20210608175931.760589513@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit 31e95b61e172144bb2b626a291db1bdc0769275b upstream.

mostly revert the previous workaround and make
'dubious pointer arithmetic' test useful again.
Use (ptr - ptr) << const instead of ptr << const to generate large scalar.
The rest stays as before commit 2b36047e7889.

Fixes: 2b36047e7889 ("selftests/bpf: fix test_align")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[fllinden@amazon.com: adjust for 4.14 (no liveness of regs in output)]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_align.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -446,11 +446,9 @@ static struct bpf_align_test tests[] = {
 		.insns = {
 			PREP_PKT_POINTERS,
 			BPF_MOV64_IMM(BPF_REG_0, 0),
-			/* ptr & const => unknown & const */
-			BPF_MOV64_REG(BPF_REG_5, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_AND, BPF_REG_5, 0x40),
-			/* ptr << const => unknown << const */
-			BPF_MOV64_REG(BPF_REG_5, BPF_REG_2),
+			/* (ptr - ptr) << 2 */
+			BPF_MOV64_REG(BPF_REG_5, BPF_REG_3),
+			BPF_ALU64_REG(BPF_SUB, BPF_REG_5, BPF_REG_2),
 			BPF_ALU64_IMM(BPF_LSH, BPF_REG_5, 2),
 			/* We have a (4n) value.  Let's make a packet offset
 			 * out of it.  First add 14, to make it a (4n+2)
@@ -473,8 +471,26 @@ static struct bpf_align_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.result = REJECT,
 		.matches = {
-			{4, "R5=pkt(id=0,off=0,r=0,imm=0)"},
-			/* R5 bitwise operator &= on pointer prohibited */
+			{4, "R5=pkt_end(id=0,off=0,imm=0)"},
+			/* (ptr - ptr) << 2 == unknown, (4n) */
+			{6, "R5=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))"},
+			/* (4n) + 14 == (4n+2).  We blow our bounds, because
+			 * the add could overflow.
+			 */
+			{7, "R5=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
+			/* Checked s>=0 */
+			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			/* packet pointer + nonnegative (4n+2) */
+			{11, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
+			 * We checked the bounds, but it might have been able
+			 * to overflow if the packet pointer started in the
+			 * upper half of the address space.
+			 * So we did not get a 'range' on R6, and the access
+			 * attempt will fail.
+			 */
+			{15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
 		}
 	},
 	{


