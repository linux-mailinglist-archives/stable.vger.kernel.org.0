Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EE634443D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhCVM7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231631AbhCVM41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DB97619DB;
        Mon, 22 Mar 2021 12:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417314;
        bh=m5kA/abdLW1cZgeUHA+IwCVIgm5Gqof0wPkfwUCERmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVOlpnw7FwIv0cxr6TFLxcLqh7Q399vMaBZ+3PlwEkMaN8VX4ru58+8fLy1R7gDzI
         vBGAQdA3LemPP9B5t5/lHaZit7tP6maCP0IUVMBtQHZIKyiP+AKEenbHWofl5zabJH
         rz5biW9ynOQujQsbWYciIV3Z9g20qhEMD2H/OWVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.14 08/43] bpf: Prohibit alu ops for pointer types not defining ptr_limit
Date:   Mon, 22 Mar 2021 13:28:49 +0100
Message-Id: <20210322121920.321935998@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Krysiuk <piotras@gmail.com>

commit f232326f6966cf2a1d1db7bc917a4ce5f9f55f76 upstream.

The purpose of this patch is to streamline error propagation and in particular
to propagate retrieve_ptr_limit() errors for pointer types that are not defining
a ptr_limit such that register-based alu ops against these types can be rejected.

The main rationale is that a gap has been identified by Piotr in the existing
protection against speculatively out-of-bounds loads, for example, in case of
ctx pointers, unprivileged programs can still perform pointer arithmetic. This
can be abused to execute speculatively out-of-bounds loads without restrictions
and thus extract contents of kernel memory.

Fix this by rejecting unprivileged programs that attempt any pointer arithmetic
on unprotected pointer types. The two affected ones are pointer to ctx as well
as pointer to map. Field access to a modified ctx' pointer is rejected at a
later point in time in the verifier, and 7c6967326267 ("bpf: Permit map_ptr
arithmetic with opcode add and offset 0") only relevant for root-only use cases.
Risk of unprivileged program breakage is considered very low.

Fixes: 7c6967326267 ("bpf: Permit map_ptr arithmetic with opcode add and offset 0")
Fixes: b2157399cc98 ("bpf: prevent out-of-bounds speculation")
Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/verifier.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2104,6 +2104,7 @@ static int sanitize_ptr_alu(struct bpf_v
 	u32 alu_state, alu_limit;
 	struct bpf_reg_state tmp;
 	bool ret;
+	int err;
 
 	if (can_skip_alu_sanitation(env, insn))
 		return 0;
@@ -2119,10 +2120,13 @@ static int sanitize_ptr_alu(struct bpf_v
 	alu_state |= ptr_is_dst_reg ?
 		     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
 
-	if (retrieve_ptr_limit(ptr_reg, &alu_limit, opcode, off_is_neg))
-		return 0;
-	if (update_alu_sanitation_state(aux, alu_state, alu_limit))
-		return -EACCES;
+	err = retrieve_ptr_limit(ptr_reg, &alu_limit, opcode, off_is_neg);
+	if (err < 0)
+		return err;
+
+	err = update_alu_sanitation_state(aux, alu_state, alu_limit);
+	if (err < 0)
+		return err;
 do_sim:
 	/* Simulate and find potential out-of-bounds access under
 	 * speculative execution from truncation as a result of
@@ -2215,7 +2219,7 @@ static int adjust_ptr_min_max_vals(struc
 	case BPF_ADD:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
 		if (ret < 0) {
-			verbose("R%d tried to add from different maps or paths\n", dst);
+			verbose("R%d tried to add from different maps, paths, or prohibited types\n", dst);
 			return ret;
 		}
 		/* We can take a fixed offset as long as it doesn't overflow
@@ -2270,7 +2274,7 @@ static int adjust_ptr_min_max_vals(struc
 	case BPF_SUB:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
 		if (ret < 0) {
-			verbose("R%d tried to sub from different maps or paths\n", dst);
+			verbose("R%d tried to sub from different maps, paths, or prohibited types\n", dst);
 			return ret;
 		}
 		if (dst_reg == off_reg) {


