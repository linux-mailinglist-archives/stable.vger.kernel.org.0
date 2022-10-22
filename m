Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4B06086BE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiJVHw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiJVHvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:51:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4677CAC28D;
        Sat, 22 Oct 2022 00:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B613860B9A;
        Sat, 22 Oct 2022 07:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E50C433D6;
        Sat, 22 Oct 2022 07:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424671;
        bh=5kUA82APk8VdKEjBwR4yCepGh5EvqYWfXL3WKCiPSwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnaZPnoY9I6z+n97felTw+4/vY8a7b6cZ6DW1B84U0LKqo3hYPzAYB6f6v2HKpR+8
         xAo4wCDmofN+nLIBVTA5VXR2YdwYqDlESG8IPhiq4sKeN4v4BIp9Nk9o9d4OBRmU+U
         oxPgW8CS/5DaMKcU4kUgFQ1TyYSZbgiGKkpv961c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 203/717] bpf: convert cgroup_bpf.progs to hlist
Date:   Sat, 22 Oct 2022 09:21:22 +0200
Message-Id: <20221022072451.265679285@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 00442143a2ab7f1da46fbf4d2a99c85df767d49a ]

This lets us reclaim some space to be used by new cgroup lsm slots.

Before:
struct cgroup_bpf {
	struct bpf_prog_array *    effective[23];        /*     0   184 */
	/* --- cacheline 2 boundary (128 bytes) was 56 bytes ago --- */
	struct list_head           progs[23];            /*   184   368 */
	/* --- cacheline 8 boundary (512 bytes) was 40 bytes ago --- */
	u32                        flags[23];            /*   552    92 */

	/* XXX 4 bytes hole, try to pack */

	/* --- cacheline 10 boundary (640 bytes) was 8 bytes ago --- */
	struct list_head           storages;             /*   648    16 */
	struct bpf_prog_array *    inactive;             /*   664     8 */
	struct percpu_ref          refcnt;               /*   672    16 */
	struct work_struct         release_work;         /*   688    32 */

	/* size: 720, cachelines: 12, members: 7 */
	/* sum members: 716, holes: 1, sum holes: 4 */
	/* last cacheline: 16 bytes */
};

After:
struct cgroup_bpf {
	struct bpf_prog_array *    effective[23];        /*     0   184 */
	/* --- cacheline 2 boundary (128 bytes) was 56 bytes ago --- */
	struct hlist_head          progs[23];            /*   184   184 */
	/* --- cacheline 5 boundary (320 bytes) was 48 bytes ago --- */
	u8                         flags[23];            /*   368    23 */

	/* XXX 1 byte hole, try to pack */

	/* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
	struct list_head           storages;             /*   392    16 */
	struct bpf_prog_array *    inactive;             /*   408     8 */
	struct percpu_ref          refcnt;               /*   416    16 */
	struct work_struct         release_work;         /*   432    72 */

	/* size: 504, cachelines: 8, members: 7 */
	/* sum members: 503, holes: 1, sum holes: 1 */
	/* last cacheline: 56 bytes */
};

Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20220628174314.1216643-3-sdf@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 883743422ced ("bpf: Fix ref_obj_id for dynptr data slices in verifier")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf-cgroup-defs.h |  4 +-
 include/linux/bpf-cgroup.h      |  2 +-
 kernel/bpf/cgroup.c             | 76 +++++++++++++++++++--------------
 3 files changed, 47 insertions(+), 35 deletions(-)

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 695d1224a71b..5d268e76d8e6 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -47,8 +47,8 @@ struct cgroup_bpf {
 	 * have either zero or one element
 	 * when BPF_F_ALLOW_MULTI the list can have up to BPF_CGROUP_MAX_PROGS
 	 */
-	struct list_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
-	u32 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
+	struct hlist_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
+	u8 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
 
 	/* list of cgroup shared storages */
 	struct list_head storages;
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 669d96d074ad..6673acfbf2ef 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -95,7 +95,7 @@ struct bpf_cgroup_link {
 };
 
 struct bpf_prog_list {
-	struct list_head node;
+	struct hlist_node node;
 	struct bpf_prog *prog;
 	struct bpf_cgroup_link *link;
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE];
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 34dfa45ef4f3..13526b01f1fd 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -157,11 +157,12 @@ static void cgroup_bpf_release(struct work_struct *work)
 	mutex_lock(&cgroup_mutex);
 
 	for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
-		struct list_head *progs = &cgrp->bpf.progs[atype];
-		struct bpf_prog_list *pl, *pltmp;
+		struct hlist_head *progs = &cgrp->bpf.progs[atype];
+		struct bpf_prog_list *pl;
+		struct hlist_node *pltmp;
 
-		list_for_each_entry_safe(pl, pltmp, progs, node) {
-			list_del(&pl->node);
+		hlist_for_each_entry_safe(pl, pltmp, progs, node) {
+			hlist_del(&pl->node);
 			if (pl->prog)
 				bpf_prog_put(pl->prog);
 			if (pl->link)
@@ -217,12 +218,12 @@ static struct bpf_prog *prog_list_prog(struct bpf_prog_list *pl)
 /* count number of elements in the list.
  * it's slow but the list cannot be long
  */
-static u32 prog_list_length(struct list_head *head)
+static u32 prog_list_length(struct hlist_head *head)
 {
 	struct bpf_prog_list *pl;
 	u32 cnt = 0;
 
-	list_for_each_entry(pl, head, node) {
+	hlist_for_each_entry(pl, head, node) {
 		if (!prog_list_prog(pl))
 			continue;
 		cnt++;
@@ -291,7 +292,7 @@ static int compute_effective_progs(struct cgroup *cgrp,
 		if (cnt > 0 && !(p->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
 			continue;
 
-		list_for_each_entry(pl, &p->bpf.progs[atype], node) {
+		hlist_for_each_entry(pl, &p->bpf.progs[atype], node) {
 			if (!prog_list_prog(pl))
 				continue;
 
@@ -342,7 +343,7 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
 		cgroup_bpf_get(p);
 
 	for (i = 0; i < NR; i++)
-		INIT_LIST_HEAD(&cgrp->bpf.progs[i]);
+		INIT_HLIST_HEAD(&cgrp->bpf.progs[i]);
 
 	INIT_LIST_HEAD(&cgrp->bpf.storages);
 
@@ -418,7 +419,7 @@ static int update_effective_progs(struct cgroup *cgrp,
 
 #define BPF_CGROUP_MAX_PROGS 64
 
-static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
+static struct bpf_prog_list *find_attach_entry(struct hlist_head *progs,
 					       struct bpf_prog *prog,
 					       struct bpf_cgroup_link *link,
 					       struct bpf_prog *replace_prog,
@@ -428,12 +429,12 @@ static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
 
 	/* single-attach case */
 	if (!allow_multi) {
-		if (list_empty(progs))
+		if (hlist_empty(progs))
 			return NULL;
-		return list_first_entry(progs, typeof(*pl), node);
+		return hlist_entry(progs->first, typeof(*pl), node);
 	}
 
-	list_for_each_entry(pl, progs, node) {
+	hlist_for_each_entry(pl, progs, node) {
 		if (prog && pl->prog == prog && prog != replace_prog)
 			/* disallow attaching the same prog twice */
 			return ERR_PTR(-EINVAL);
@@ -444,7 +445,7 @@ static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
 
 	/* direct prog multi-attach w/ replacement case */
 	if (replace_prog) {
-		list_for_each_entry(pl, progs, node) {
+		hlist_for_each_entry(pl, progs, node) {
 			if (pl->prog == replace_prog)
 				/* a match found */
 				return pl;
@@ -480,7 +481,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog_list *pl;
-	struct list_head *progs;
+	struct hlist_head *progs;
 	int err;
 
 	if (((flags & BPF_F_ALLOW_OVERRIDE) && (flags & BPF_F_ALLOW_MULTI)) ||
@@ -503,7 +504,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (!hierarchy_allows_attach(cgrp, atype))
 		return -EPERM;
 
-	if (!list_empty(progs) && cgrp->bpf.flags[atype] != saved_flags)
+	if (!hlist_empty(progs) && cgrp->bpf.flags[atype] != saved_flags)
 		/* Disallow attaching non-overridable on top
 		 * of existing overridable in this cgroup.
 		 * Disallow attaching multi-prog if overridable or none
@@ -525,12 +526,22 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (pl) {
 		old_prog = pl->prog;
 	} else {
+		struct hlist_node *last = NULL;
+
 		pl = kmalloc(sizeof(*pl), GFP_KERNEL);
 		if (!pl) {
 			bpf_cgroup_storages_free(new_storage);
 			return -ENOMEM;
 		}
-		list_add_tail(&pl->node, progs);
+		if (hlist_empty(progs))
+			hlist_add_head(&pl->node, progs);
+		else
+			hlist_for_each(last, progs) {
+				if (last->next)
+					continue;
+				hlist_add_behind(&pl->node, last);
+				break;
+			}
 	}
 
 	pl->prog = prog;
@@ -556,7 +567,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	}
 	bpf_cgroup_storages_free(new_storage);
 	if (!old_prog) {
-		list_del(&pl->node);
+		hlist_del(&pl->node);
 		kfree(pl);
 	}
 	return err;
@@ -587,7 +598,7 @@ static void replace_effective_prog(struct cgroup *cgrp,
 	struct cgroup_subsys_state *css;
 	struct bpf_prog_array *progs;
 	struct bpf_prog_list *pl;
-	struct list_head *head;
+	struct hlist_head *head;
 	struct cgroup *cg;
 	int pos;
 
@@ -603,7 +614,7 @@ static void replace_effective_prog(struct cgroup *cgrp,
 				continue;
 
 			head = &cg->bpf.progs[atype];
-			list_for_each_entry(pl, head, node) {
+			hlist_for_each_entry(pl, head, node) {
 				if (!prog_list_prog(pl))
 					continue;
 				if (pl->link == link)
@@ -637,7 +648,7 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog *old_prog;
 	struct bpf_prog_list *pl;
-	struct list_head *progs;
+	struct hlist_head *progs;
 	bool found = false;
 
 	atype = to_cgroup_bpf_attach_type(link->type);
@@ -649,7 +660,7 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	if (link->link.prog->type != new_prog->type)
 		return -EINVAL;
 
-	list_for_each_entry(pl, progs, node) {
+	hlist_for_each_entry(pl, progs, node) {
 		if (pl->link == link) {
 			found = true;
 			break;
@@ -688,7 +699,7 @@ static int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *new_prog,
 	return ret;
 }
 
-static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
+static struct bpf_prog_list *find_detach_entry(struct hlist_head *progs,
 					       struct bpf_prog *prog,
 					       struct bpf_cgroup_link *link,
 					       bool allow_multi)
@@ -696,14 +707,14 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
 	struct bpf_prog_list *pl;
 
 	if (!allow_multi) {
-		if (list_empty(progs))
+		if (hlist_empty(progs))
 			/* report error when trying to detach and nothing is attached */
 			return ERR_PTR(-ENOENT);
 
 		/* to maintain backward compatibility NONE and OVERRIDE cgroups
 		 * allow detaching with invalid FD (prog==NULL) in legacy mode
 		 */
-		return list_first_entry(progs, typeof(*pl), node);
+		return hlist_entry(progs->first, typeof(*pl), node);
 	}
 
 	if (!prog && !link)
@@ -713,7 +724,7 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
 		return ERR_PTR(-EINVAL);
 
 	/* find the prog or link and detach it */
-	list_for_each_entry(pl, progs, node) {
+	hlist_for_each_entry(pl, progs, node) {
 		if (pl->prog == prog && pl->link == link)
 			return pl;
 	}
@@ -737,7 +748,7 @@ static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
 	struct cgroup_subsys_state *css;
 	struct bpf_prog_array *progs;
 	struct bpf_prog_list *pl;
-	struct list_head *head;
+	struct hlist_head *head;
 	struct cgroup *cg;
 	int pos;
 
@@ -754,7 +765,7 @@ static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
 				continue;
 
 			head = &cg->bpf.progs[atype];
-			list_for_each_entry(pl, head, node) {
+			hlist_for_each_entry(pl, head, node) {
 				if (!prog_list_prog(pl))
 					continue;
 				if (pl->prog == prog && pl->link == link)
@@ -793,7 +804,7 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog *old_prog;
 	struct bpf_prog_list *pl;
-	struct list_head *progs;
+	struct hlist_head *progs;
 	u32 flags;
 
 	atype = to_cgroup_bpf_attach_type(type);
@@ -824,9 +835,10 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	}
 
 	/* now can actually delete it from this cgroup list */
-	list_del(&pl->node);
+	hlist_del(&pl->node);
+
 	kfree(pl);
-	if (list_empty(progs))
+	if (hlist_empty(progs))
 		/* last program was detached, reset flags to zero */
 		cgrp->bpf.flags[atype] = 0;
 	if (old_prog)
@@ -854,7 +866,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	enum bpf_attach_type type = attr->query.attach_type;
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog_array *effective;
-	struct list_head *progs;
+	struct hlist_head *progs;
 	struct bpf_prog *prog;
 	int cnt, ret = 0, i;
 	u32 flags;
@@ -893,7 +905,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		u32 id;
 
 		i = 0;
-		list_for_each_entry(pl, progs, node) {
+		hlist_for_each_entry(pl, progs, node) {
 			prog = prog_list_prog(pl);
 			id = prog->aux->id;
 			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
-- 
2.35.1



