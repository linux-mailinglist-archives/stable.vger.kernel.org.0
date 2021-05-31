Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B720B3967DB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhEaS17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:27:59 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:64104 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbhEaS1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:27:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622485560; x=1654021560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l93EwFKQYf8DxYvKVkvqtrhNJPeAIb6G39YMsa425wc=;
  b=Jl+ZxDA6uxw8cWxTnzaajxKpxQsOrHOxR8+iI9YB9/oJbiiCjFbbfjcx
   uOivEi8ByV3ZIuyOvJYnyjokM1DGKw/7rzDmfeS69nFf8WQ+TVtJC8BWv
   DcVUoH1KCD1K/O0wMtEKFTEEqoQO918kaKGmiG2XPTNDmdALcqNp7BZkq
   I=;
X-IronPort-AV: E=Sophos;i="5.83,238,1616457600"; 
   d="scan'208";a="4141094"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 31 May 2021 18:26:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 73489A18E6;
        Mon, 31 May 2021 18:25:59 +0000 (UTC)
Received: from EX13P01UWB003.ant.amazon.com (10.43.161.209) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13P01UWB003.ant.amazon.com (10.43.161.209) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Mon, 31 May 2021 18:25:57
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 8FDDBB55; Mon, 31 May 2021 18:25:57 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>
Subject: [PATCH v2 4.14 02/17] bpf: Move off_reg into sanitize_ptr_alu
Date:   Mon, 31 May 2021 18:25:41 +0000
Message-ID: <20210531182556.25277-3-fllinden@amazon.com>
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

commit 6f55b2f2a1178856c19bbce2f71449926e731914 upstream.

Small refactor to drag off_reg into sanitize_ptr_alu(), so we later on can
use off_reg for generalizing some of the checks for all pointer types.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: fix minor contextual conflict for 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 kernel/bpf/verifier.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f28ba90a43a7..434829d4438b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2094,11 +2094,12 @@ static int sanitize_val_alu(struct bpf_verifier_env *env,
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
-			    struct bpf_reg_state *dst_reg,
-			    bool off_is_neg)
+			    const struct bpf_reg_state *off_reg,
+			    struct bpf_reg_state *dst_reg)
 {
 	struct bpf_verifier_state *vstate = env->cur_state;
 	struct bpf_insn_aux_data *aux = cur_aux(env);
+	bool off_is_neg = off_reg->smin_value < 0;
 	bool ptr_is_dst_reg = ptr_reg == dst_reg;
 	u8 opcode = BPF_OP(insn->code);
 	u32 alu_state, alu_limit;
@@ -2224,7 +2225,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	switch (opcode) {
 	case BPF_ADD:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
 		if (ret < 0) {
 			verbose("R%d tried to add from different maps, paths, or prohibited types\n", dst);
 			return ret;
@@ -2279,7 +2280,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		}
 		break;
 	case BPF_SUB:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
 		if (ret < 0) {
 			verbose("R%d tried to sub from different maps, paths, or prohibited types\n", dst);
 			return ret;
-- 
2.23.4

