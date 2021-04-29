Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E2936F271
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 00:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhD2WJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 18:09:32 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:24137 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhD2WJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 18:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619734123; x=1651270123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q5Wmy2rJXqFyd0X53V31VAHlYVqY4tXEyA9m3dfYAo4=;
  b=Uf0QC27jQT2DyGrpiUTlg0Q0zYP7+n5C7w5sg/eeDyr/pSivbL6vZVJ8
   41dil1FeMrvYWc58J2xbfo0ffXmsqie9oW9ZhL4fXpG+oYEEIWgcYA1KM
   BdqXcvhoVSohzfAFFxgBaf9g5RscVimhKCypOohk4Xqur+KQxoP4LIwir
   o=;
X-IronPort-AV: E=Sophos;i="5.82,260,1613433600"; 
   d="scan'208";a="106383182"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 29 Apr 2021 22:08:41 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id DEBACA1DC1;
        Thu, 29 Apr 2021 22:08:40 +0000 (UTC)
Received: from EX13D25UEB001.ant.amazon.com (10.43.60.30) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D25UEB001.ant.amazon.com (10.43.60.30) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 22:08:40 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id D2CAADE; Thu, 29 Apr 2021 22:08:39 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>
Subject: [PATCH 5.4 5/8] bpf: Refactor and streamline bounds check into helper
Date:   Thu, 29 Apr 2021 22:08:36 +0000
Message-ID: <20210429220839.15667-6-fllinden@amazon.com>
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

commit 073815b756c51ba9d8384d924c5d1c03ca3d1ae4 upstream.

Move the bounds check in adjust_ptr_min_max_vals() into a small helper named
sanitize_check_bounds() in order to simplify the former a bit.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backport to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 kernel/bpf/verifier.c | 54 +++++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 59718101fd04..fc33aed59333 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4448,6 +4448,41 @@ static int sanitize_err(struct bpf_verifier_env *env,
 	return -EACCES;
 }
 
+static int sanitize_check_bounds(struct bpf_verifier_env *env,
+				 const struct bpf_insn *insn,
+				 const struct bpf_reg_state *dst_reg)
+{
+	u32 dst = insn->dst_reg;
+
+	/* For unprivileged we require that resulting offset must be in bounds
+	 * in order to be able to sanitize access later on.
+	 */
+	if (env->allow_ptr_leaks)
+		return 0;
+
+	switch (dst_reg->type) {
+	case PTR_TO_STACK:
+		if (check_stack_access(env, dst_reg, dst_reg->off +
+				       dst_reg->var_off.value, 1)) {
+			verbose(env, "R%d stack pointer arithmetic goes out of range, "
+				"prohibited for !root\n", dst);
+			return -EACCES;
+		}
+		break;
+	case PTR_TO_MAP_VALUE:
+		if (check_map_access(env, dst, dst_reg->off, 1, false)) {
+			verbose(env, "R%d pointer arithmetic of map value goes out of range, "
+				"prohibited for !root\n", dst);
+			return -EACCES;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 /* Handles arithmetic on a pointer and a scalar: computes new min/max and var_off.
  * Caller should also handle BPF_MOV case separately.
  * If we return -EACCES, caller may want to try again treating pointer as a
@@ -4664,23 +4699,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	__reg_deduce_bounds(dst_reg);
 	__reg_bound_offset(dst_reg);
 
-	/* For unprivileged we require that resulting offset must be in bounds
-	 * in order to be able to sanitize access later on.
-	 */
-	if (!env->allow_ptr_leaks) {
-		if (dst_reg->type == PTR_TO_MAP_VALUE &&
-		    check_map_access(env, dst, dst_reg->off, 1, false)) {
-			verbose(env, "R%d pointer arithmetic of map value goes out of range, "
-				"prohibited for !root\n", dst);
-			return -EACCES;
-		} else if (dst_reg->type == PTR_TO_STACK &&
-			   check_stack_access(env, dst_reg, dst_reg->off +
-					      dst_reg->var_off.value, 1)) {
-			verbose(env, "R%d stack pointer arithmetic goes out of range, "
-				"prohibited for !root\n", dst);
-			return -EACCES;
-		}
-	}
+	if (sanitize_check_bounds(env, insn, dst_reg) < 0)
+		return -EACCES;
 
 	return 0;
 }
-- 
2.23.3

