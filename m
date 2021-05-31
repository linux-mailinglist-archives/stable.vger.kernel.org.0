Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB423967EC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhEaS2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:28:09 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:25787 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbhEaS1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:27:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622485568; x=1654021568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JCgJmnpQ17dd8Ik72a5OdbZpdwwXkpkPTSVdLE9RF5I=;
  b=jyoo0jCjEM+cuuw1BidSJJY/+7UoFnL4jgM11BCPPTBhpFvKkkDPoYqE
   cuor84GErlzUCAdi0080hfTzS8OIgGvvkoQpXsBhri/AoHCzE9jQYYXv0
   jAT7Xm5bxeILAQpm2u+slaCitmhKk+FJY3VDorLPYObJEkPK68IuTHrvG
   0=;
X-IronPort-AV: E=Sophos;i="5.83,238,1616457600"; 
   d="scan'208";a="935853354"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 31 May 2021 18:25:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS id 992AFC0072;
        Mon, 31 May 2021 18:25:58 +0000 (UTC)
Received: from EX13P01UWB004.ant.amazon.com (10.43.161.213) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13P01UWB004.ant.amazon.com (10.43.161.213) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Mon, 31 May 2021 18:25:57
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 9126C148A; Mon, 31 May 2021 18:25:57 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>
Subject: [PATCH v2 4.14 16/17] bpf: Fix mask direction swap upon off reg sign change
Date:   Mon, 31 May 2021 18:25:55 +0000
Message-ID: <20210531182556.25277-17-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210531182556.25277-1-fllinden@amazon.com>
References: <20210531182556.25277-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit bb01a1bba579b4b1c5566af24d95f1767859771e upstream.

Masking direction as indicated via mask_to_left is considered to be
calculated once and then used to derive pointer limits. Thus, this
needs to be placed into bpf_sanitize_info instead so we can pass it
to sanitize_ptr_alu() call after the pointer move. Piotr noticed a
corner case where the off reg causes masking direction change which
then results in an incorrect final aux->alu_limit.

Fixes: 7fedb63a8307 ("bpf: Tighten speculative pointer arithmetic mask")
Reported-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index db359b796442..f3f14519708d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2033,18 +2033,10 @@ enum {
 };
 
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
-			      const struct bpf_reg_state *off_reg,
-			      u32 *alu_limit, u8 opcode)
+			      u32 *alu_limit, bool mask_to_left)
 {
-	bool off_is_neg = off_reg->smin_value < 0;
-	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
-			    (opcode == BPF_SUB && !off_is_neg);
 	u32 max = 0, ptr_limit = 0;
 
-	if (!tnum_is_const(off_reg->var_off) &&
-	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
-		return REASON_BOUNDS;
-
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
 		/* Offset 0 is out-of-bounds, but acceptable start for the
@@ -2112,6 +2104,7 @@ static bool sanitize_needed(u8 opcode)
 
 struct bpf_sanitize_info {
 	struct bpf_insn_aux_data aux;
+	bool mask_to_left;
 };
 
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
@@ -2143,7 +2136,16 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	if (vstate->speculative)
 		goto do_sim;
 
-	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
+	if (!commit_window) {
+		if (!tnum_is_const(off_reg->var_off) &&
+		    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
+			return REASON_BOUNDS;
+
+		info->mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
+				     (opcode == BPF_SUB && !off_is_neg);
+	}
+
+	err = retrieve_ptr_limit(ptr_reg, &alu_limit, info->mask_to_left);
 	if (err < 0)
 		return err;
 
-- 
2.23.4

