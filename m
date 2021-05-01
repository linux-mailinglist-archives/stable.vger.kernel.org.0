Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B5A370588
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhEAEb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:31:29 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:40757 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhEAEb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843441; x=1651379441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kNNJJSSd6K61oftW+z6W77QvbDWXihC7bR0XoyLjC0w=;
  b=P9+c8/tBivbVydI/AOBIYKuHJpalg53u7UzUhrm7i+Rx0+j9e0CI3KaQ
   EJzDN+bikeUajpj+B6Y8O+uHsG6RVWYLWGKD+lvfluE5P6/pUARavp/Dk
   /nkcNDmp6BIEV80HDTEJHt5aeT6aUBlJlmDQNpvDfC2gkIWdY7+Wzuzu+
   s=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="110970711"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-41350382.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 01 May 2021 04:30:39 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-41350382.us-west-2.amazon.com (Postfix) with ESMTPS id 473B4C0042;
        Sat,  1 May 2021 04:30:38 +0000 (UTC)
Received: from EX13D01UWA004.ant.amazon.com (10.43.160.99) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:23 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13d01UWA004.ant.amazon.com (10.43.160.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:22 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:14 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 403D0978; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 06/15] bpf: Rework ptr_limit into alu_limit and add common error path
Date:   Sat, 1 May 2021 04:30:05 +0000
Message-ID: <20210501043014.33300-7-fllinden@amazon.com>
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

Upstream commit b658bbb844e28f1862867f37e8ca11a8e2aa94a3

Small refactor with no semantic changes in order to consolidate the max
ptr_limit boundary check.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b06de3d8facf..ef1fe213cbce 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2026,12 +2026,12 @@ static struct bpf_insn_aux_data *cur_aux(struct bpf_verifier_env *env)
 
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
@@ -2045,22 +2045,27 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 		max = MAX_BPF_STACK + mask_to_left;
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

