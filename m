Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987AC3DDA5E
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbhHBONm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237718AbhHBOE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AA676113E;
        Mon,  2 Aug 2021 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912694;
        bh=oP/XcNiv3NOmIDwV8f4ocC831rWaoUaAh7AmNKVW/xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KkAljKghOB30GjCglM6Hsl5rWD7b2gLqWHDJX2efTA1gq4M4kdCCxBiphtpCTJ7wt
         sU6Z5P4na9f/nw9gIavIuedi00XpXZ1Zl08NgszDlRk/KUc3LcIU7odXXBsJu7hV5G
         Yz++oUnt7jtlOQ2YiQlNoXi9zS5EnUePn18n3MEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH 5.13 094/104] bpf: verifier: Allocate idmap scratch in verifier env
Date:   Mon,  2 Aug 2021 15:45:31 +0200
Message-Id: <20210802134347.102414407@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

commit c9e73e3d2b1eb1ea7ff068e05007eec3bd8ef1c9 upstream.

func_states_equal makes a very short lived allocation for idmap,
probably because it's too large to fit on the stack. However the
function is called quite often, leading to a lot of alloc / free
churn. Replace the temporary allocation with dedicated scratch
space in struct bpf_verifier_env.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/bpf/20210429134656.122225-4-lmb@cloudflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_verifier.h |    8 +++++++
 kernel/bpf/verifier.c        |   46 ++++++++++++++-----------------------------
 2 files changed, 23 insertions(+), 31 deletions(-)

--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -215,6 +215,13 @@ struct bpf_idx_pair {
 	u32 idx;
 };
 
+struct bpf_id_pair {
+	u32 old;
+	u32 cur;
+};
+
+/* Maximum number of register states that can exist at once */
+#define BPF_ID_MAP_SIZE (MAX_BPF_REG + MAX_BPF_STACK / BPF_REG_SIZE)
 #define MAX_CALL_FRAMES 8
 struct bpf_verifier_state {
 	/* call stack tracking */
@@ -418,6 +425,7 @@ struct bpf_verifier_env {
 	const struct bpf_line_info *prev_linfo;
 	struct bpf_verifier_log log;
 	struct bpf_subprog_info subprog_info[BPF_MAX_SUBPROGS + 1];
+	struct bpf_id_pair idmap_scratch[BPF_ID_MAP_SIZE];
 	struct {
 		int *insn_state;
 		int *insn_stack;
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9779,13 +9779,6 @@ static bool range_within(struct bpf_reg_
 	       old->s32_max_value >= cur->s32_max_value;
 }
 
-/* Maximum number of register states that can exist at once */
-#define ID_MAP_SIZE	(MAX_BPF_REG + MAX_BPF_STACK / BPF_REG_SIZE)
-struct idpair {
-	u32 old;
-	u32 cur;
-};
-
 /* If in the old state two registers had the same id, then they need to have
  * the same id in the new state as well.  But that id could be different from
  * the old state, so we need to track the mapping from old to new ids.
@@ -9796,11 +9789,11 @@ struct idpair {
  * So we look through our idmap to see if this old id has been seen before.  If
  * so, we require the new id to match; otherwise, we add the id pair to the map.
  */
-static bool check_ids(u32 old_id, u32 cur_id, struct idpair *idmap)
+static bool check_ids(u32 old_id, u32 cur_id, struct bpf_id_pair *idmap)
 {
 	unsigned int i;
 
-	for (i = 0; i < ID_MAP_SIZE; i++) {
+	for (i = 0; i < BPF_ID_MAP_SIZE; i++) {
 		if (!idmap[i].old) {
 			/* Reached an empty slot; haven't seen this id before */
 			idmap[i].old = old_id;
@@ -9913,7 +9906,7 @@ next:
 
 /* Returns true if (rold safe implies rcur safe) */
 static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
-		    struct idpair *idmap)
+		    struct bpf_id_pair *idmap)
 {
 	bool equal;
 
@@ -10031,7 +10024,7 @@ static bool regsafe(struct bpf_reg_state
 
 static bool stacksafe(struct bpf_func_state *old,
 		      struct bpf_func_state *cur,
-		      struct idpair *idmap)
+		      struct bpf_id_pair *idmap)
 {
 	int i, spi;
 
@@ -10128,32 +10121,23 @@ static bool refsafe(struct bpf_func_stat
  * whereas register type in current state is meaningful, it means that
  * the current state will reach 'bpf_exit' instruction safely
  */
-static bool func_states_equal(struct bpf_func_state *old,
+static bool func_states_equal(struct bpf_verifier_env *env, struct bpf_func_state *old,
 			      struct bpf_func_state *cur)
 {
-	struct idpair *idmap;
-	bool ret = false;
 	int i;
 
-	idmap = kcalloc(ID_MAP_SIZE, sizeof(struct idpair), GFP_KERNEL);
-	/* If we failed to allocate the idmap, just say it's not safe */
-	if (!idmap)
-		return false;
-
-	for (i = 0; i < MAX_BPF_REG; i++) {
-		if (!regsafe(&old->regs[i], &cur->regs[i], idmap))
-			goto out_free;
-	}
+	memset(env->idmap_scratch, 0, sizeof(env->idmap_scratch));
+	for (i = 0; i < MAX_BPF_REG; i++)
+		if (!regsafe(&old->regs[i], &cur->regs[i], env->idmap_scratch))
+			return false;
 
-	if (!stacksafe(old, cur, idmap))
-		goto out_free;
+	if (!stacksafe(old, cur, env->idmap_scratch))
+		return false;
 
 	if (!refsafe(old, cur))
-		goto out_free;
-	ret = true;
-out_free:
-	kfree(idmap);
-	return ret;
+		return false;
+
+	return true;
 }
 
 static bool states_equal(struct bpf_verifier_env *env,
@@ -10180,7 +10164,7 @@ static bool states_equal(struct bpf_veri
 	for (i = 0; i <= old->curframe; i++) {
 		if (old->frame[i]->callsite != cur->frame[i]->callsite)
 			return false;
-		if (!func_states_equal(old->frame[i], cur->frame[i]))
+		if (!func_states_equal(env, old->frame[i], cur->frame[i]))
 			return false;
 	}
 	return true;


