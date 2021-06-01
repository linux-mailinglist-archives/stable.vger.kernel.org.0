Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1709F3978A2
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 19:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhFAREY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 13:04:24 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:28010 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhFAREY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 13:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622566963; x=1654102963;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7+kZCsFwuBu/edPvbWH1wAHlRCkts6CSef6Sa19yVQ0=;
  b=htXH1ZFmP5T/0iDjgduXGU/f5m2nUCABqcgbxyZIPXSDGENmj+N3rw7s
   gaUBHBthmmSJ0Iv8fcnjH+x8QAUTs7DK8XZ6EEWdJ/y8NOMHzETsM/W1/
   tc9HP/pt5u2GCpSaSPYzpfp78ecbdq93ufuncchg71NcUdnr4iJm1j5QF
   M=;
X-IronPort-AV: E=Sophos;i="5.83,240,1616457600"; 
   d="scan'208";a="112958559"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 01 Jun 2021 17:02:42 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 1077DA184B
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 17:02:41 +0000 (UTC)
Received: from EX13D46UWC004.ant.amazon.com (10.43.162.173) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 1 Jun 2021 17:02:41 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D46UWC004.ant.amazon.com (10.43.162.173) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 1 Jun 2021 17:02:41 +0000
Received: from dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (172.22.152.76)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Tue, 1 Jun 2021 17:02:41 +0000
Received: by dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (Postfix, from userid 13116433)
        id 422DA4295B; Tue,  1 Jun 2021 17:02:41 +0000 (UTC)
Date:   Tue, 1 Jun 2021 17:02:41 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     <shaoyi@amazon.com>, <fllinden@amazon.com>
Subject: [PATCH 5.4] bpf, selftests: Adjust few selftest result_unpriv
 outcomes
Message-ID: <20210601170241.GA31268@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 1bad6fd52be4ce12d207e2820ceb0f29ab31fc53 upstream

Given we don't need to simulate the speculative domain for registers with
immediates anymore since the verifier uses direct imm-based rewrites instead
of having to mask, we can also lift a few cases that were previously rejected.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[shaoyi@amazon.com - backport to 5.4 with small contextual change]
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Cc: <stable@vger.kernel.org>
---
 tools/testing/selftests/bpf/verifier/stack_ptr.c       | 2 --
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 8 --------
 2 files changed, 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/stack_ptr.c b/tools/testing/selftests/bpf/verifier/stack_ptr.c
index 7276620ef242..53d2a5a5ec58 100644
--- a/tools/testing/selftests/bpf/verifier/stack_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/stack_ptr.c
@@ -291,8 +291,6 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1, 0),
 	BPF_EXIT_INSN(),
 	},
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "invalid stack off=0 size=1",
 	.result = ACCEPT,
 	.retval = 42,
 },
diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index 28d44e6aa0b7..f9c91b95080e 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -300,8 +300,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -371,8 +369,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -472,8 +468,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -766,8 +760,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
-- 
2.16.6

