Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F6A37057C
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhEAEbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:31:08 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:64503 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhEAEbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843419; x=1651379419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oz/1ZDUqeRGURymibFOavk5JpPYC83WYKKh+dQ8/Xuw=;
  b=VqHkBJCcoE5DPf+1nF+Gmp/YlZh0XcaYkU4zipT+VoXeYAsM9D3QsfmH
   9MS7EhLrQM4xwDM/U5jlLYVAqmwaS/9HtcC9alAaA7cZCIOE5ruQCBNpD
   1KY2add05qn+QYZZ4sOQ6x38egNedHm5I9edDy1XwbDHG2Zz77NmS1HMQ
   s=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="109535118"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 01 May 2021 04:30:17 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 2A4E722033E;
        Sat,  1 May 2021 04:30:16 +0000 (UTC)
Received: from EX13D01UWA004.ant.amazon.com (10.43.160.99) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d01UWA004.ant.amazon.com (10.43.160.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:15 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 439E7DD9; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 04/15] bpf: Move off_reg into sanitize_ptr_alu
Date:   Sat, 1 May 2021 04:30:03 +0000
Message-ID: <20210501043014.33300-5-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501043014.33300-1-fllinden@amazon.com>
References: <20210501043014.33300-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

Upstream commit 6f55b2f2a1178856c19bbce2f71449926e731914

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
index 9e9b7c076bcb..ee199c928f3b 100644
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
2.23.3

