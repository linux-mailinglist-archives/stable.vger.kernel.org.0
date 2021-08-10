Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB413E2579
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243920AbhHFIUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244105AbhHFISw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:18:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75A9A61241;
        Fri,  6 Aug 2021 08:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237909;
        bh=8MgA3rxV71I99YDci/hPYfcfHV0ARvPGiCFPKZtAYLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bvgsCRXIJf7oYxwNGs8Xw9IugECDAX28ExbmNtM67/xQb80uMZmTRP+GKA3cdkBN
         X8ByGgDesKmeD0Zo1sRIvVM4TQPUMUnddoANNjcdm0Yem1cPo0fXX7VpS5ax+ipVGr
         B3JmV1BTtrpayHzpgPB2qpkkJldIWU++VkCuoWKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Benedict Schlueter <benedict.schlueter@rub.de>,
        Piotr Krysiuk <piotras@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 19/23] bpf: Do not mark insn as seen under speculative path verification
Date:   Fri,  6 Aug 2021 10:16:51 +0200
Message-Id: <20210806081112.802430319@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit fe9a5ca7e370e613a9a75a13008a3845ea759d6e upstream

... in such circumstances, we do not want to mark the instruction as seen given
the goal is still to jmp-1 rewrite/sanitize dead code, if it is not reachable
from the non-speculative path verification. We do however want to verify it for
safety regardless.

With the patch as-is all the insns that have been marked as seen before the
patch will also be marked as seen after the patch (just with a potentially
different non-zero count). An upcoming patch will also verify paths that are
unreachable in the non-speculative domain, hence this extension is needed.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Benedict Schlueter <benedict.schlueter@rub.de>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: - env->pass_cnt is not used in 5.4, so adjust sanitize_mark_insn_seen()
       to assign "true" instead
     - drop sanitize_insn_aux_data() comment changes, as the function is not
       present in 5.4]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4435,6 +4435,19 @@ do_sim:
 	return !ret ? REASON_STACK : 0;
 }
 
+static void sanitize_mark_insn_seen(struct bpf_verifier_env *env)
+{
+	struct bpf_verifier_state *vstate = env->cur_state;
+
+	/* If we simulate paths under speculation, we don't update the
+	 * insn as 'seen' such that when we verify unreachable paths in
+	 * the non-speculative domain, sanitize_dead_code() can still
+	 * rewrite/sanitize them.
+	 */
+	if (!vstate->speculative)
+		env->insn_aux_data[env->insn_idx].seen = true;
+}
+
 static int sanitize_err(struct bpf_verifier_env *env,
 			const struct bpf_insn *insn, int reason,
 			const struct bpf_reg_state *off_reg,
@@ -7790,7 +7803,7 @@ static int do_check(struct bpf_verifier_
 		}
 
 		regs = cur_regs(env);
-		env->insn_aux_data[env->insn_idx].seen = true;
+		sanitize_mark_insn_seen(env);
 		prev_insn_idx = env->insn_idx;
 
 		if (class == BPF_ALU || class == BPF_ALU64) {
@@ -8025,7 +8038,7 @@ process_bpf_exit:
 					return err;
 
 				env->insn_idx++;
-				env->insn_aux_data[env->insn_idx].seen = true;
+				sanitize_mark_insn_seen(env);
 			} else {
 				verbose(env, "invalid BPF_LD mode\n");
 				return -EINVAL;


