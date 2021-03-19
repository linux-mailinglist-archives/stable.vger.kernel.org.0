Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A891341C1D
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCSMTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229879AbhCSMSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:18:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F091364F65;
        Fri, 19 Mar 2021 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156321;
        bh=TcVpXYAJcQF9HYDO7N7iTD6pdsgo3VU8+9CAtuaP3xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3zoz6hPjTDC+B0qwq1RGz6VjKKaapXxWuv04hGXZMZPUq86GkfxfhlatDr6a0Pi4
         c3QuqbCrjxqqh2sVG71pgwQ5ZKFE3tl+cvH7JZW9Tuk7sy7uTtmfyd1HGcWIVi1ykY
         qufnwTXhm8S9knv377sFkq9AG7Fb/aUmqky/8NNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 3/8] bpf: Prohibit alu ops for pointer types not defining ptr_limit
Date:   Fri, 19 Mar 2021 13:18:22 +0100
Message-Id: <20210319121744.222261133@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121744.114946147@linuxfoundation.org>
References: <20210319121744.114946147@linuxfoundation.org>
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
@@ -2804,6 +2804,7 @@ static int sanitize_ptr_alu(struct bpf_v
 	u32 alu_state, alu_limit;
 	struct bpf_reg_state tmp;
 	bool ret;
+	int err;
 
 	if (can_skip_alu_sanitation(env, insn))
 		return 0;
@@ -2819,10 +2820,13 @@ static int sanitize_ptr_alu(struct bpf_v
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
@@ -2920,7 +2924,7 @@ static int adjust_ptr_min_max_vals(struc
 	case BPF_ADD:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
 		if (ret < 0) {
-			verbose(env, "R%d tried to add from different maps or paths\n", dst);
+			verbose(env, "R%d tried to add from different maps, paths, or prohibited types\n", dst);
 			return ret;
 		}
 		/* We can take a fixed offset as long as it doesn't overflow
@@ -2975,7 +2979,7 @@ static int adjust_ptr_min_max_vals(struc
 	case BPF_SUB:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
 		if (ret < 0) {
-			verbose(env, "R%d tried to sub from different maps or paths\n", dst);
+			verbose(env, "R%d tried to sub from different maps, paths, or prohibited types\n", dst);
 			return ret;
 		}
 		if (dst_reg == off_reg) {


