Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC7139FFBB
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhFHSfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234327AbhFHSd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC72A61027;
        Tue,  8 Jun 2021 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177100;
        bh=swranWKbJfXXxA87ZrGrbZM4uxnWLlUQHpSNll+jfu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YRcpephlGCXBDB8HVNCnp3AROZr6I1BcwUIOJbSyq74YJkSUBpYKOTT8kcGXi52j
         hqktpSag3gdhfmy1tuMMgkPPQsEeYrcWbKRScgwrMntTvQeSodfgEiXC/zAmpQDEsk
         WeWjMbag48RiIXsuSGEoL1kdTN2ScvE/qF1YVzyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 32/47] bpf: Refactor and streamline bounds check into helper
Date:   Tue,  8 Jun 2021 20:27:15 +0200
Message-Id: <20210608175931.530429217@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
[fllinden@amazon.com: backport to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   54 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 17 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2206,6 +2206,41 @@ static int sanitize_err(struct bpf_verif
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
+			verbose("R%d stack pointer arithmetic goes out of range, "
+				"prohibited for !root\n", dst);
+			return -EACCES;
+		}
+		break;
+	case PTR_TO_MAP_VALUE:
+		if (check_map_access(env, dst, dst_reg->off, 1)) {
+			verbose("R%d pointer arithmetic of map value goes out of range, "
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
@@ -2421,23 +2456,8 @@ static int adjust_ptr_min_max_vals(struc
 	__reg_deduce_bounds(dst_reg);
 	__reg_bound_offset(dst_reg);
 
-	/* For unprivileged we require that resulting offset must be in bounds
-	 * in order to be able to sanitize access later on.
-	 */
-	if (!env->allow_ptr_leaks) {
-		if (dst_reg->type == PTR_TO_MAP_VALUE &&
-		    check_map_access(env, dst, dst_reg->off, 1)) {
-			verbose("R%d pointer arithmetic of map value goes out of range, "
-				"prohibited for !root\n", dst);
-			return -EACCES;
-		} else if (dst_reg->type == PTR_TO_STACK &&
-			   check_stack_access(env, dst_reg, dst_reg->off +
-					      dst_reg->var_off.value, 1)) {
-			verbose("R%d stack pointer arithmetic goes out of range, "
-				"prohibited for !root\n", dst);
-			return -EACCES;
-		}
-	}
+	if (sanitize_check_bounds(env, insn, dst_reg) < 0)
+		return -EACCES;
 
 	return 0;
 }


