Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8C236F26D
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 00:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhD2WJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 18:09:31 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:24137 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhD2WJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 18:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619734122; x=1651270122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bj41Hniah88XAmhB33NNmctPpgRkHvdRoVif0YjQVN0=;
  b=fg43ID5+zo5LjtoOHwDtrRL/PIXF/owR7lak1irieL/7G0UhTwc/iFRa
   F8Kgw4LBKvwazZIQXqhDN71jVBkHaVeSxaR/ihBCMmoTQi0Bqj4M8GJFZ
   T6oKHuYtT37jrOkqGSdqMszevYhxLkVaIbFos0XOEDH1Hx3jeNdM72sje
   o=;
X-IronPort-AV: E=Sophos;i="5.82,260,1613433600"; 
   d="scan'208";a="106383180"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 29 Apr 2021 22:08:41 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 9F240A22F6;
        Thu, 29 Apr 2021 22:08:40 +0000 (UTC)
Received: from EX13D10UEA004.ant.amazon.com (10.43.61.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D10UEA004.ant.amazon.com (10.43.61.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 22:08:40 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id D252297E; Thu, 29 Apr 2021 22:08:39 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>
Subject: [PATCH 5.4 1/8] bpf: Move off_reg into sanitize_ptr_alu
Date:   Thu, 29 Apr 2021 22:08:32 +0000
Message-ID: <20210429220839.15667-2-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210429220839.15667-1-fllinden@amazon.com>
References: <20210429220839.15667-1-fllinden@amazon.com>
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
---
 kernel/bpf/verifier.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ab2a4b7dfca5..b776aa0d8864 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4336,11 +4336,12 @@ static int sanitize_val_alu(struct bpf_verifier_env *env,
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
@@ -4474,7 +4475,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	switch (opcode) {
 	case BPF_ADD:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
 		if (ret < 0) {
 			verbose(env, "R%d tried to add from different maps, paths, or prohibited types\n", dst);
 			return ret;
@@ -4529,7 +4530,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		}
 		break;
 	case BPF_SUB:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
 		if (ret < 0) {
 			verbose(env, "R%d tried to sub from different maps, paths, or prohibited types\n", dst);
 			return ret;
-- 
2.23.3

