Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A40D370596
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhEAEb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:31:59 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:19313 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbhEAEby (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843465; x=1651379465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hjaOmGp3kO1APk4SPbqe4A3++2TCYPWkaXZ9Nz2THV4=;
  b=u2yqdWRZ3hm2ri6HQDDhaHr/PvYYAczXdrMwCjN/RDNvXjB8fjXX/YTf
   GPpbDr+A+y2uNYamU6or9setV5Awj1DxKkG0Bi/+gC12OedEne1SeNipl
   hILqLWJsggt6RSrqrBbUnc6+9qxfV4k+k/JnN6PNwjbp0+RQ23amWB1i+
   o=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="123085041"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 01 May 2021 04:31:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 933BA28AAAA;
        Sat,  1 May 2021 04:31:03 +0000 (UTC)
Received: from EX13D01UWB003.ant.amazon.com (10.43.161.94) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:17 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13d01UWB003.ant.amazon.com (10.43.161.94) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:16 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:15 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 41AA4C0A; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 15/15] selftests/bpf: make 'dubious pointer arithmetic' test useful
Date:   Sat, 1 May 2021 04:30:14 +0000
Message-ID: <20210501043014.33300-16-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501043014.33300-1-fllinden@amazon.com>
References: <20210501043014.33300-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Upstream commit 31e95b61e172144bb2b626a291db1bdc0769275b

mostly revert the previous workaround and make
'dubious pointer arithmetic' test useful again.
Use (ptr - ptr) << const instead of ptr << const to generate large scalar.
The rest stays as before commit 2b36047e7889.

Fixes: 2b36047e7889 ("selftests/bpf: fix test_align")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[fllinden@amazon.com: adjust for 4.14 (no liveness of regs in output)]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 tools/testing/selftests/bpf/test_align.c | 30 ++++++++++++++++++------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 471bbbdb94db..5d530c90779e 100644
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
-- 
2.23.3

