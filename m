Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8537F59463B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347698AbiHOWNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350480AbiHOWMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:12:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2C011D52E;
        Mon, 15 Aug 2022 12:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A723CE12C4;
        Mon, 15 Aug 2022 19:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657D4C433D6;
        Mon, 15 Aug 2022 19:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592334;
        bh=Kq9vYClQ0CRhPQFVNPgn7FY33Bel/tQxS8a1mtclAKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWcWBdupeYQyguJ3wwuMMxlOiSCxVVgYmqsm96QMzQ8CL/0nY614FEPUjq5U+c52p
         W4/pCfdcuhCwgJtug4kuCnaDKxSJ64QSeQZllracNIvVFIlJo15JaByttoUv8/SRXv
         3VkMb3xSrqDPl2Gk1c9F/FPZf5WiCjGfEMoZCJVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.19 0095/1157] bpf: Fix KASAN use-after-free Read in compute_effective_progs
Date:   Mon, 15 Aug 2022 19:50:51 +0200
Message-Id: <20220815180443.405426101@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/cgroup.c |   70 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 10 deletions(-)

--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -721,6 +721,60 @@ static struct bpf_prog_list *find_detach
 }
 
 /**
+ * purge_effective_progs() - After compute_effective_progs fails to alloc new
+ *                           cgrp->bpf.inactive table we can recover by
+ *                           recomputing the array in place.
+ *
+ * @cgrp: The cgroup which descendants to travers
+ * @prog: A program to detach or NULL
+ * @link: A link to detach or NULL
+ * @atype: Type of detach operation
+ */
+static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
+				  struct bpf_cgroup_link *link,
+				  enum cgroup_bpf_attach_type atype)
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
+			if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
+				continue;
+
+			head = &cg->bpf.progs[atype];
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
+				desc->bpf.effective[atype],
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
@@ -739,7 +793,6 @@ static int __cgroup_bpf_detach(struct cg
 	struct bpf_prog_list *pl;
 	struct list_head *progs;
 	u32 flags;
-	int err;
 
 	atype = to_cgroup_bpf_attach_type(type);
 	if (atype < 0)
@@ -761,9 +814,12 @@ static int __cgroup_bpf_detach(struct cg
 	pl->prog = NULL;
 	pl->link = NULL;
 
-	err = update_effective_progs(cgrp, atype);
-	if (err)
-		goto cleanup;
+	if (update_effective_progs(cgrp, atype)) {
+		/* if update effective array failed replace the prog with a dummy prog*/
+		pl->prog = old_prog;
+		pl->link = link;
+		purge_effective_progs(cgrp, old_prog, link, atype);
+	}
 
 	/* now can actually delete it from this cgroup list */
 	list_del(&pl->node);
@@ -775,12 +831,6 @@ static int __cgroup_bpf_detach(struct cg
 		bpf_prog_put(old_prog);
 	static_branch_dec(&cgroup_bpf_enabled_key[atype]);
 	return 0;
-
-cleanup:
-	/* restore back prog or link */
-	pl->prog = old_prog;
-	pl->link = link;
-	return err;
 }
 
 static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,


