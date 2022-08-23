Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30D659E3C5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbiHWMdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239948AbiHWM3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:29:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B53FF23B;
        Tue, 23 Aug 2022 02:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C7C61460;
        Tue, 23 Aug 2022 09:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E89FC433D6;
        Tue, 23 Aug 2022 09:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247823;
        bh=2VOmINhtwVs8S7ohVL5zW1PZbgbAd7L5U0vEmUztB+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIS4D6hVG1Her7XUc9xLwiTmDds4zRXex1NLLD3UryD2SdbldQ12iUlHSC3rDSBl4
         uGSEvSFHr5T4JyO/0LcdEg4wpM1QHeb6XI5nLTaZOibSxcfDqYcNpwHTybopSCYOzB
         TBgftPatXbBPV1phB8m8S/RKclNKsZpfqkXNvVPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.10 158/158] bpf: Fix KASAN use-after-free Read in compute_effective_progs
Date:   Tue, 23 Aug 2022 10:28:10 +0200
Message-Id: <20220823080052.131071844@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/cgroup.c |   70 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 10 deletions(-)

--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -654,6 +654,60 @@ static struct bpf_prog_list *find_detach
 }
 
 /**
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
+/**
  * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
  *                         propagate the change to descendants
  * @cgrp: The cgroup which descendants to traverse
@@ -671,7 +725,6 @@ int __cgroup_bpf_detach(struct cgroup *c
 	u32 flags = cgrp->bpf.flags[type];
 	struct bpf_prog_list *pl;
 	struct bpf_prog *old_prog;
-	int err;
 
 	if (prog && link)
 		/* only one of prog or link can be specified */
@@ -686,9 +739,12 @@ int __cgroup_bpf_detach(struct cgroup *c
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
@@ -700,12 +756,6 @@ int __cgroup_bpf_detach(struct cgroup *c
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


