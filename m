Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4643B36AE96
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhDZHpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233864AbhDZHoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 155AF613E9;
        Mon, 26 Apr 2021 07:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422845;
        bh=mTbStHKHQf3xn3woi/gJl0Lw/9Nhl46iK1dq5p/g5GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPknOJM1nzItrwJOoaWGkc3a8HOkYxxqR5edcHT3hH3z3QTYZ+L97rTUe1grCWCqO
         N0o4+V/sHwNc2wyhzz2fcGlrPISXykTWYGT7rGjij5Lrq1wA+WFVxlr5tqezZ0YT7M
         Rw+LMd+2us4b8KDW4vrv59r2dZPAkakMbFGqU4Po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 15/41] bpf: Refactor and streamline bounds check into helper
Date:   Mon, 26 Apr 2021 09:30:02 +0200
Message-Id: <20210426072820.208159869@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 073815b756c51ba9d8384d924c5d1c03ca3d1ae4 ]

Move the bounds check in adjust_ptr_min_max_vals() into a small helper named
sanitize_check_bounds() in order to simplify the former a bit.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 49 +++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 59b8f06b437d..a543d929c348 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5938,6 +5938,37 @@ static int check_stack_access_for_ptr_arithmetic(
 	return 0;
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
+	if (env->bypass_spec_v1)
+		return 0;
+
+	switch (dst_reg->type) {
+	case PTR_TO_STACK:
+		if (check_stack_access_for_ptr_arithmetic(env, dst, dst_reg,
+					dst_reg->off + dst_reg->var_off.value))
+			return -EACCES;
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
 
 /* Handles arithmetic on a pointer and a scalar: computes new min/max and var_off.
  * Caller should also handle BPF_MOV case separately.
@@ -6163,22 +6194,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	__reg_deduce_bounds(dst_reg);
 	__reg_bound_offset(dst_reg);
 
-	/* For unprivileged we require that resulting offset must be in bounds
-	 * in order to be able to sanitize access later on.
-	 */
-	if (!env->bypass_spec_v1) {
-		if (dst_reg->type == PTR_TO_MAP_VALUE &&
-		    check_map_access(env, dst, dst_reg->off, 1, false)) {
-			verbose(env, "R%d pointer arithmetic of map value goes out of range, "
-				"prohibited for !root\n", dst);
-			return -EACCES;
-		} else if (dst_reg->type == PTR_TO_STACK &&
-			   check_stack_access_for_ptr_arithmetic(
-				   env, dst, dst_reg, dst_reg->off +
-				   dst_reg->var_off.value)) {
-			return -EACCES;
-		}
-	}
+	if (sanitize_check_bounds(env, insn, dst_reg) < 0)
+		return -EACCES;
 
 	return 0;
 }
-- 
2.30.2



