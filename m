Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D33229B97C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802518AbgJ0Ptz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757267AbgJ0PQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:16:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 669A820728;
        Tue, 27 Oct 2020 15:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811785;
        bh=MVcA8RairfrcRn+2/dlyy4yyOnFWH1hl4AupGXpwJkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ex4iFd2ViH8kbBuJa8uAFX/8KhvzbrF8w8H6ppQv9uCJauUBsebJJYOhOXR4uqosN
         rb/r9NTN6IUyBbRm6DGAUNNLbZiwlUrq0YqlwPhIAQ0RJRGObsl4a26LnKMjRiZVLB
         Db1LLQiHa79R9+QPkE1D1ODwOk1S3+Q5JLZSr9kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 584/633] bpf: Limit callers stack depth 256 for subprogs with tailcalls
Date:   Tue, 27 Oct 2020 14:55:27 +0100
Message-Id: <20201027135550.203241920@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 7f6e4312e15a5c370e84eaa685879b6bdcc717e4 ]

Protect against potential stack overflow that might happen when bpf2bpf
calls get combined with tailcalls. Limit the caller's stack depth for
such case down to 256 so that the worst case scenario would result in 8k
stack size (32 which is tailcall limit * 256 = 8k).

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/verifier.c        | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index ca08db4ffb5f7..ce3f5231aa698 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -358,6 +358,7 @@ struct bpf_subprog_info {
 	u32 start; /* insn idx of function entry point */
 	u32 linfo_idx; /* The idx to the main_prog->aux->linfo */
 	u16 stack_depth; /* max. stack depth used by this function */
+	bool has_tail_call;
 };
 
 /* single container for all structs
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c953dfbbaa6a9..12eb9e47d101c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1470,6 +1470,10 @@ static int check_subprogs(struct bpf_verifier_env *env)
 	for (i = 0; i < insn_cnt; i++) {
 		u8 code = insn[i].code;
 
+		if (code == (BPF_JMP | BPF_CALL) &&
+		    insn[i].imm == BPF_FUNC_tail_call &&
+		    insn[i].src_reg != BPF_PSEUDO_CALL)
+			subprog[cur_subprog].has_tail_call = true;
 		if (BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32)
 			goto next;
 		if (BPF_OP(code) == BPF_EXIT || BPF_OP(code) == BPF_CALL)
@@ -2951,6 +2955,31 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
 	int ret_prog[MAX_CALL_FRAMES];
 
 process_func:
+	/* protect against potential stack overflow that might happen when
+	 * bpf2bpf calls get combined with tailcalls. Limit the caller's stack
+	 * depth for such case down to 256 so that the worst case scenario
+	 * would result in 8k stack size (32 which is tailcall limit * 256 =
+	 * 8k).
+	 *
+	 * To get the idea what might happen, see an example:
+	 * func1 -> sub rsp, 128
+	 *  subfunc1 -> sub rsp, 256
+	 *  tailcall1 -> add rsp, 256
+	 *   func2 -> sub rsp, 192 (total stack size = 128 + 192 = 320)
+	 *   subfunc2 -> sub rsp, 64
+	 *   subfunc22 -> sub rsp, 128
+	 *   tailcall2 -> add rsp, 128
+	 *    func3 -> sub rsp, 32 (total stack size 128 + 192 + 64 + 32 = 416)
+	 *
+	 * tailcall will unwind the current stack frame but it will not get rid
+	 * of caller's stack as shown on the example above.
+	 */
+	if (idx && subprog[idx].has_tail_call && depth >= 256) {
+		verbose(env,
+			"tail_calls are not allowed when call stack of previous frames is %d bytes. Too large\n",
+			depth);
+		return -EACCES;
+	}
 	/* round up to 32-bytes, since this is granularity
 	 * of interpreter stack size
 	 */
-- 
2.25.1



