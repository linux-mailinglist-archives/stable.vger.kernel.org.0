Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0853659AB67
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 06:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243064AbiHTEf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 00:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiHTEf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 00:35:58 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0915DA3C2;
        Fri, 19 Aug 2022 21:35:55 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M8m364hr8znTbf;
        Sat, 20 Aug 2022 12:33:38 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 20 Aug 2022 12:35:53 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 20 Aug 2022 12:35:53 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>,
        <syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.10] bpf: Fix KASAN use-after-free Read in compute_effective_progs
Date:   Sat, 20 Aug 2022 13:05:18 +0800
Message-ID: <20220820050518.2118130-1-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@linaro.org>

commit 4c46091ee985ae84c60c5e95055d779fcd291d87 upstream.

Syzbot found a Use After Free bug in compute_effective_progs().
The reproducer creates a number of BPF links, and causes a fault
injected alloc to fail, while calling bpf_link_detach on them.
Link detach triggers the link to be freed by bpf_link_free(),
which calls __cgroup_bpf_detach() and update_effective_progs().
If the memory allocation in this function fails, the function restores
the pointer to the bpf_cgroup_link on the cgroup list, but the memory
gets freed just after it returns. After this, every subsequent call to
update_effective_progs() causes this already deallocated pointer to be
dereferenced in prog_list_length(), and triggers KASAN UAF error.

To fix this issue don't preserve the pointer to the prog or link in the
list, but remove it and replace it with a dummy prog without shrinking
the table. The subsequent call to __cgroup_bpf_detach() or
__cgroup_bpf_detach() will correct it.

Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
Reported-by: <syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://syzkaller.appspot.com/bug?id=8ebf179a95c2a2670f7cf1ba62429ec044369db4
Link: https://lore.kernel.org/bpf/20220517180420.87954-1-tadeusz.struk@linaro.org
Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 kernel/bpf/cgroup.c | 70 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 60 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 6aa9e10c6335..d154e52dd7ae 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -653,6 +653,60 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
 	return ERR_PTR(-ENOENT);
 }
 
+/**
+ * purge_effective_progs() - After compute_effective_progs fails to alloc new
+ *			     cgrp->bpf.inactive table we can recover by
+ *			     recomputing the array in place.
+ *
+ * @cgrp: The cgroup which descendants to travers
+ * @prog: A program to detach or NULL
+ * @link: A link to detach or NULL
+ * @type: Type of detach operation
+ */
+static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
+				  struct bpf_cgroup_link *link,
+				  enum bpf_attach_type type)
+{
+	struct cgroup_subsys_state *css;
+	struct bpf_prog_array *progs;
+	struct bpf_prog_list *pl;
+	struct list_head *head;
+	struct cgroup *cg;
+	int pos;
+
+	/* recompute effective prog array in place */
+	css_for_each_descendant_pre(css, &cgrp->self) {
+		struct cgroup *desc = container_of(css, struct cgroup, self);
+
+		if (percpu_ref_is_zero(&desc->bpf.refcnt))
+			continue;
+
+		/* find position of link or prog in effective progs array */
+		for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
+			if (pos && !(cg->bpf.flags[type] & BPF_F_ALLOW_MULTI))
+				continue;
+
+			head = &cg->bpf.progs[type];
+			list_for_each_entry(pl, head, node) {
+				if (!prog_list_prog(pl))
+					continue;
+				if (pl->prog == prog && pl->link == link)
+					goto found;
+				pos++;
+			}
+		}
+found:
+		BUG_ON(!cg);
+		progs = rcu_dereference_protected(
+				desc->bpf.effective[type],
+				lockdep_is_held(&cgroup_mutex));
+
+		/* Remove the program from the array */
+		WARN_ONCE(bpf_prog_array_delete_safe_at(progs, pos),
+			  "Failed to purge a prog from array at index %d", pos);
+	}
+}
+
 /**
  * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
  *                         propagate the change to descendants
@@ -671,7 +725,6 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	u32 flags = cgrp->bpf.flags[type];
 	struct bpf_prog_list *pl;
 	struct bpf_prog *old_prog;
-	int err;
 
 	if (prog && link)
 		/* only one of prog or link can be specified */
@@ -686,9 +739,12 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	pl->prog = NULL;
 	pl->link = NULL;
 
-	err = update_effective_progs(cgrp, type);
-	if (err)
-		goto cleanup;
+	if (update_effective_progs(cgrp, type)) {
+		/* if update effective array failed replace the prog with a dummy prog*/
+		pl->prog = old_prog;
+		pl->link = link;
+		purge_effective_progs(cgrp, old_prog, link, type);
+	}
 
 	/* now can actually delete it from this cgroup list */
 	list_del(&pl->node);
@@ -700,12 +756,6 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 		bpf_prog_put(old_prog);
 	static_branch_dec(&cgroup_bpf_enabled_key);
 	return 0;
-
-cleanup:
-	/* restore back prog or link */
-	pl->prog = old_prog;
-	pl->link = link;
-	return err;
 }
 
 /* Must be called with cgroup_mutex held to avoid races. */
-- 
2.25.1

