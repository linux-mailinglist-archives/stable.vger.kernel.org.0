Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6F136FC05
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhD3OVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhD3OVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08F3B613EA;
        Fri, 30 Apr 2021 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792425;
        bh=wjNigdwfj4cbQY3t16dSb7YNrX4MQsXWANz9HVN7Vws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEI7AZD4KT/DR3rP43AS1TBwd5qaYb+tvS/doDM6fu5jbdnVOs/z90cqFJDGww4pW
         2PJoA0j/VMa1efub2gcjtgh2SIHa3ZOMJWiMuw90Rcz30v8Cx7QAhEhlpbsPf+t3m4
         U9S375yQ4sqvahKjX/vUhWZX+IvQAvTAkZEe+adU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 1/8] bpf: Move off_reg into sanitize_ptr_alu
Date:   Fri, 30 Apr 2021 16:20:15 +0200
Message-Id: <20210430141911.186718631@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210430141911.137473863@linuxfoundation.org>
References: <20210430141911.137473863@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4336,11 +4336,12 @@ static int sanitize_val_alu(struct bpf_v
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
@@ -4474,7 +4475,7 @@ static int adjust_ptr_min_max_vals(struc
 
 	switch (opcode) {
 	case BPF_ADD:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
 		if (ret < 0) {
 			verbose(env, "R%d tried to add from different maps, paths, or prohibited types\n", dst);
 			return ret;
@@ -4529,7 +4530,7 @@ static int adjust_ptr_min_max_vals(struc
 		}
 		break;
 	case BPF_SUB:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
 		if (ret < 0) {
 			verbose(env, "R%d tried to sub from different maps, paths, or prohibited types\n", dst);
 			return ret;


