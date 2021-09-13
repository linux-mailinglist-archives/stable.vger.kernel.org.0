Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C36F408DB2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242045AbhIMN2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241593AbhIMN0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:26:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 573DA610A5;
        Mon, 13 Sep 2021 13:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539374;
        bh=XT4FgexFVWl5drqXh36TINGqFVaRLW9dfNgWFMC4KW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a62JXFoaGPchDnnXa6JTNsijxBxusZBRmcEQXYWwcWwdKBcK8Wj+aJmgjXEw6aKzO
         f9r5C5Vpzir4fWmxqr832w3ygXVFa3zlPKP88rxRwNIYTdoRENE9hqqULYfkGD07WR
         F0cffOTNK+rfZzlzABkqFc0yIumsMaJnFMPA/Mwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 129/144] bpf: verifier: Allocate idmap scratch in verifier env
Date:   Mon, 13 Sep 2021 15:15:10 +0200
Message-Id: <20210913131052.238781850@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
[OP: adjusted context for 5.4]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_verifier.h |    8 +++++++
 kernel/bpf/verifier.c        |   46 ++++++++++++++-----------------------------
 2 files changed, 23 insertions(+), 31 deletions(-)

--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -194,6 +194,13 @@ struct bpf_idx_pair {
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
@@ -370,6 +377,7 @@ struct bpf_verifier_env {
 	const struct bpf_line_info *prev_linfo;
 	struct bpf_verifier_log log;
 	struct bpf_subprog_info subprog_info[BPF_MAX_SUBPROGS + 1];
+	struct bpf_id_pair idmap_scratch[BPF_ID_MAP_SIZE];
 	struct {
 		int *insn_state;
 		int *insn_stack;
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6976,13 +6976,6 @@ static bool range_within(struct bpf_reg_
 	       old->smax_value >= cur->smax_value;
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
@@ -6993,11 +6986,11 @@ struct idpair {
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
@@ -7110,7 +7103,7 @@ next:
 
 /* Returns true if (rold safe implies rcur safe) */
 static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
-		    struct idpair *idmap)
+		    struct bpf_id_pair *idmap)
 {
 	bool equal;
 
@@ -7227,7 +7220,7 @@ static bool regsafe(struct bpf_reg_state
 
 static bool stacksafe(struct bpf_func_state *old,
 		      struct bpf_func_state *cur,
-		      struct idpair *idmap)
+		      struct bpf_id_pair *idmap)
 {
 	int i, spi;
 
@@ -7324,32 +7317,23 @@ static bool refsafe(struct bpf_func_stat
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
@@ -7376,7 +7360,7 @@ static bool states_equal(struct bpf_veri
 	for (i = 0; i <= old->curframe; i++) {
 		if (old->frame[i]->callsite != cur->frame[i]->callsite)
 			return false;
-		if (!func_states_equal(old->frame[i], cur->frame[i]))
+		if (!func_states_equal(env, old->frame[i], cur->frame[i]))
 			return false;
 	}
 	return true;


