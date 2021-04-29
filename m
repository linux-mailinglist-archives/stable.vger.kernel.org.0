Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062D036F274
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 00:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhD2WJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 18:09:32 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:34365 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhD2WJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 18:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619734124; x=1651270124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2n6I3zSB+64zmVXDF1Nnwqj6rtCkGTSKaoKTEqAIm1o=;
  b=RyA7sTniywDeoZ/fyU9VTlz6Nn5f9kS60QtO5FbkqhVvEk8pFP2gZbK6
   N5213AELmB1aSPwUKA0HZPscKi7lY/lu1ZVnBDJh39D95sa2rJKo/SVk6
   XO26lYlUJcaswbA/ThF67cWu10ChVzbfr280U6fjGXPedeO3Cq4ozrJl4
   4=;
X-IronPort-AV: E=Sophos;i="5.82,260,1613433600"; 
   d="scan'208";a="122750294"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 29 Apr 2021 22:08:42 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 4F909A0112;
        Thu, 29 Apr 2021 22:08:40 +0000 (UTC)
Received: from EX13D23UEE001.ant.amazon.com (10.43.62.101) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D23UEE001.ant.amazon.com (10.43.62.101) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 22:08:40 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id D45B397D; Thu, 29 Apr 2021 22:08:39 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>
Subject: [PATCH 5.4 3/8] bpf: Rework ptr_limit into alu_limit and add common error path
Date:   Thu, 29 Apr 2021 22:08:34 +0000
Message-ID: <20210429220839.15667-4-fllinden@amazon.com>
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

commit b658bbb844e28f1862867f37e8ca11a8e2aa94a3 upstream.

Small refactor with no semantic changes in order to consolidate the max
ptr_limit boundary check.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6cb1be115928..a6ff4b26a462 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4265,12 +4265,12 @@ static struct bpf_insn_aux_data *cur_aux(struct bpf_verifier_env *env)
 
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 			      const struct bpf_reg_state *off_reg,
-			      u32 *ptr_limit, u8 opcode)
+			      u32 *alu_limit, u8 opcode)
 {
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
 			    (opcode == BPF_SUB && !off_is_neg);
-	u32 off, max;
+	u32 off, max = 0, ptr_limit = 0;
 
 	if (!tnum_is_const(off_reg->var_off) &&
 	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
@@ -4287,22 +4287,27 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 		 */
 		off = ptr_reg->off + ptr_reg->var_off.value;
 		if (mask_to_left)
-			*ptr_limit = MAX_BPF_STACK + off;
+			ptr_limit = MAX_BPF_STACK + off;
 		else
-			*ptr_limit = -off - 1;
-		return *ptr_limit >= max ? -ERANGE : 0;
+			ptr_limit = -off - 1;
+		break;
 	case PTR_TO_MAP_VALUE:
 		max = ptr_reg->map_ptr->value_size;
 		if (mask_to_left) {
-			*ptr_limit = ptr_reg->umax_value + ptr_reg->off;
+			ptr_limit = ptr_reg->umax_value + ptr_reg->off;
 		} else {
 			off = ptr_reg->smin_value + ptr_reg->off;
-			*ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
+			ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
 		}
-		return *ptr_limit >= max ? -ERANGE : 0;
+		break;
 	default:
 		return -EINVAL;
 	}
+
+	if (ptr_limit >= max)
+		return -ERANGE;
+	*alu_limit = ptr_limit;
+	return 0;
 }
 
 static bool can_skip_alu_sanitation(const struct bpf_verifier_env *env,
-- 
2.23.3

