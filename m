Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4580B3967D7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhEaS14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:27:56 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:65526 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbhEaS1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:27:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622485560; x=1654021560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GsmhFNa2nLqeN9+231ZLCZpuqp3bb65LqW6+ArtWKQc=;
  b=eoQijMFRoKI9ji7V0uurBH8fIBtOT08q/yXH6FS9iZyJcZP0BncMgsZn
   B7Yl1KezYHsCAnNZurEcMz/qgbRTbPZYeC1GR4tXNQfBz52goFteJzVMk
   VFwUmsfkSS5UCxQXTyxOFIj7SxiUwRHuj4IhqP0NdYcsrhA6Gk+g4F8y3
   g=;
X-IronPort-AV: E=Sophos;i="5.83,238,1616457600"; 
   d="scan'208";a="4116908"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 31 May 2021 18:25:59 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 8BB57A1D52;
        Mon, 31 May 2021 18:25:58 +0000 (UTC)
Received: from EX13D05UEB002.ant.amazon.com (10.43.60.76) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D05UEB002.ant.amazon.com (10.43.60.76) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Mon, 31 May 2021 18:25:57
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 8BD62FA1; Mon, 31 May 2021 18:25:57 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>
Subject: [PATCH v2 4.14 12/17] selftests/bpf: fix test_align
Date:   Mon, 31 May 2021 18:25:51 +0000
Message-ID: <20210531182556.25277-13-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210531182556.25277-1-fllinden@amazon.com>
References: <20210531182556.25277-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@fb.com>

commit 2b36047e7889b7efee22c11e17f035f721855731 upstream.

since commit 82abbf8d2fc4 the verifier rejects the bit-wise
arithmetic on pointers earlier.
The test 'dubious pointer arithmetic' now has less output to match on.
Adjust it.

Fixes: 82abbf8d2fc4 ("bpf: do not allow root to mangle valid pointers")
Reported-by: kernel test robot <xiaolong.ye@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/testing/selftests/bpf/test_align.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 8591c89c0828..471bbbdb94db 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -474,27 +474,7 @@ static struct bpf_align_test tests[] = {
 		.result = REJECT,
 		.matches = {
 			{4, "R5=pkt(id=0,off=0,r=0,imm=0)"},
-			/* ptr & 0x40 == either 0 or 0x40 */
-			{5, "R5=inv(id=0,umax_value=64,var_off=(0x0; 0x40))"},
-			/* ptr << 2 == unknown, (4n) */
-			{7, "R5=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))"},
-			/* (4n) + 14 == (4n+2).  We blow our bounds, because
-			 * the add could overflow.
-			 */
-			{8, "R5=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
-			/* Checked s>=0 */
-			{10, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
-			/* packet pointer + nonnegative (4n+2) */
-			{12, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
-			{14, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
-			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
-			 * We checked the bounds, but it might have been able
-			 * to overflow if the packet pointer started in the
-			 * upper half of the address space.
-			 * So we did not get a 'range' on R6, and the access
-			 * attempt will fail.
-			 */
-			{16, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			/* R5 bitwise operator &= on pointer prohibited */
 		}
 	},
 	{
-- 
2.23.4

