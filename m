Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D7E3967E1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhEaS2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:28:02 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:14146 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhEaS1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:27:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622485561; x=1654021561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UHhp9BilqrY9CsByc75ekXbTIAME8T22piq9ukWVqeg=;
  b=TLUMOD928UhnpIfAvdxmZJ+Qyae8NSItED/JLJag2HrwY0QCZDLwWZyH
   55gBLu736STTXHjENFlCgxxaCpmXpSRljqA22bs6NuAfZ3HQGdKO2AsGw
   CixkKWUoLoQXW4E73NAywv6E4Y+IMO/Iia6DHHbc6iwvudWDqm7a+qn/j
   E=;
X-IronPort-AV: E=Sophos;i="5.83,238,1616457600"; 
   d="scan'208";a="111190628"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 31 May 2021 18:26:00 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id CF2B0A17B4;
        Mon, 31 May 2021 18:25:58 +0000 (UTC)
Received: from EX13D02UEB003.ant.amazon.com (10.43.60.126) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D02UEB003.ant.amazon.com (10.43.60.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:57 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Mon, 31 May 2021 18:25:57
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 8A481149D; Mon, 31 May 2021 18:25:57 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>
Subject: [PATCH v2 4.14 13/17] selftests/bpf: make 'dubious pointer arithmetic' test useful
Date:   Mon, 31 May 2021 18:25:52 +0000
Message-ID: <20210531182556.25277-14-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210531182556.25277-1-fllinden@amazon.com>
References: <20210531182556.25277-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
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
2.23.4

