Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D563AEECB
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhFUQcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232172AbhFUQaD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:30:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA1E76128A;
        Mon, 21 Jun 2021 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292698;
        bh=fyz4LlRTTGrbLQ1pR9fEG6T7zqGalpkxKdLx6x7nCpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwZ5A+vJpZXEE361eEnfsoa5/mIa2DRZP04DpZytR/8shmWMWv3ZE5uwOVkP368VC
         fXfyQuxwqBoqJTtDma8nqcYQw5A1D3w7hqlSxy//WxiLpcXX/hLnpfm3BQ4tlHD9T8
         aRVE5z7fhU58fkJqL0eiybV9PdHBujRhlunGX4Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Benedict Schlueter <benedict.schlueter@rub.de>,
        Piotr Krysiuk <piotras@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/146] bpf: Do not mark insn as seen under speculative path verification
Date:   Mon, 21 Jun 2021 18:15:27 +0200
Message-Id: <20210621154917.347582192@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit fe9a5ca7e370e613a9a75a13008a3845ea759d6e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 71ac1da127a6..e97724e36dfb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5851,6 +5851,19 @@ do_sim:
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
+		env->insn_aux_data[env->insn_idx].seen = env->pass_cnt;
+}
+
 static int sanitize_err(struct bpf_verifier_env *env,
 			const struct bpf_insn *insn, int reason,
 			const struct bpf_reg_state *off_reg,
@@ -9847,7 +9860,7 @@ static int do_check(struct bpf_verifier_env *env)
 		}
 
 		regs = cur_regs(env);
-		env->insn_aux_data[env->insn_idx].seen = env->pass_cnt;
+		sanitize_mark_insn_seen(env);
 		prev_insn_idx = env->insn_idx;
 
 		if (class == BPF_ALU || class == BPF_ALU64) {
@@ -10067,7 +10080,7 @@ process_bpf_exit:
 					return err;
 
 				env->insn_idx++;
-				env->insn_aux_data[env->insn_idx].seen = env->pass_cnt;
+				sanitize_mark_insn_seen(env);
 			} else {
 				verbose(env, "invalid BPF_LD mode\n");
 				return -EINVAL;
@@ -11741,6 +11754,9 @@ static void free_states(struct bpf_verifier_env *env)
  * insn_aux_data was touched. These variables are compared to clear temporary
  * data from failed pass. For testing and experiments do_check_common() can be
  * run multiple times even when prior attempt to verify is unsuccessful.
+ *
+ * Note that special handling is needed on !env->bypass_spec_v1 if this is
+ * ever called outside of error path with subsequent program rejection.
  */
 static void sanitize_insn_aux_data(struct bpf_verifier_env *env)
 {
-- 
2.30.2



