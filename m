Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E65D53EAE4
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbiFFO7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240205AbiFFO7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:59:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4DD307A9B
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B878361490
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 14:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9795DC341C4;
        Mon,  6 Jun 2022 14:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654527568;
        bh=w2x/zYHZ7lrU7w5MPrxv4tlPFvQ6c6wYDX2GICDQxew=;
        h=Subject:To:Cc:From:Date:From;
        b=ifutrsmIAch52hHPdiAlOTLV00hGPdxPyYkPnYIY2n++8Mvf7vMmGwAfoJNZcO3zQ
         L3oicAeswB7LP3QvFOe1KW2CCKxiegGXm03FBSFaTtp1oJ4fjHDE94NWzYR52oFvpS
         IuTKSXEDMlCJvLR1BVneT9M73OX7Tt+8f6HbcrSM=
Subject: FAILED: patch "[PATCH] kprobes: Fix build errors with CONFIG_KRETPROBES=n" failed to apply to 5.17-stable tree
To:     mhiramat@kernel.org, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, jcmvbkbc@gmail.com,
        naveen.n.rao@linux.ibm.com, peterz@infradead.org,
        rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 16:59:12 +0200
Message-ID: <165452755218696@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 43994049180704fd1faf78623fabd9a5cd443708 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Wed, 4 May 2022 12:36:31 +0900
Subject: [PATCH] kprobes: Fix build errors with CONFIG_KRETPROBES=n
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Max Filippov reported:

When building kernel with CONFIG_KRETPROBES=n kernel/kprobes.c
compilation fails with the following messages:

  kernel/kprobes.c: In function ‘recycle_rp_inst’:
  kernel/kprobes.c:1273:32: error: implicit declaration of function
                                   ‘get_kretprobe’

  kernel/kprobes.c: In function ‘kprobe_flush_task’:
  kernel/kprobes.c:1299:35: error: ‘struct task_struct’ has no member
                                   named ‘kretprobe_instances’

This came from the commit d741bf41d7c7 ("kprobes: Remove
kretprobe hash") which introduced get_kretprobe() and
kretprobe_instances member in task_struct when CONFIG_KRETPROBES=y,
but did not make recycle_rp_inst() and kprobe_flush_task()
depending on CONFIG_KRETPORBES.

Since those functions are only used for kretprobe, move those
functions into #ifdef CONFIG_KRETPROBE area.

Link: https://lkml.kernel.org/r/165163539094.74407.3838114721073251225.stgit@devnote2

Reported-by: Max Filippov <jcmvbkbc@gmail.com>
Fixes: d741bf41d7c7 ("kprobes: Remove kretprobe hash")
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S . Miller" <davem@davemloft.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 157168769fc2..55041d2f884d 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -424,7 +424,7 @@ void unregister_kretprobe(struct kretprobe *rp);
 int register_kretprobes(struct kretprobe **rps, int num);
 void unregister_kretprobes(struct kretprobe **rps, int num);
 
-#ifdef CONFIG_KRETPROBE_ON_RETHOOK
+#if defined(CONFIG_KRETPROBE_ON_RETHOOK) || !defined(CONFIG_KRETPROBES)
 #define kprobe_flush_task(tk)	do {} while (0)
 #else
 void kprobe_flush_task(struct task_struct *tk);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index dbe57df2e199..172ba75a4a49 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1257,79 +1257,6 @@ void kprobe_busy_end(void)
 	preempt_enable();
 }
 
-#if !defined(CONFIG_KRETPROBE_ON_RETHOOK)
-static void free_rp_inst_rcu(struct rcu_head *head)
-{
-	struct kretprobe_instance *ri = container_of(head, struct kretprobe_instance, rcu);
-
-	if (refcount_dec_and_test(&ri->rph->ref))
-		kfree(ri->rph);
-	kfree(ri);
-}
-NOKPROBE_SYMBOL(free_rp_inst_rcu);
-
-static void recycle_rp_inst(struct kretprobe_instance *ri)
-{
-	struct kretprobe *rp = get_kretprobe(ri);
-
-	if (likely(rp))
-		freelist_add(&ri->freelist, &rp->freelist);
-	else
-		call_rcu(&ri->rcu, free_rp_inst_rcu);
-}
-NOKPROBE_SYMBOL(recycle_rp_inst);
-
-/*
- * This function is called from delayed_put_task_struct() when a task is
- * dead and cleaned up to recycle any kretprobe instances associated with
- * this task. These left over instances represent probed functions that
- * have been called but will never return.
- */
-void kprobe_flush_task(struct task_struct *tk)
-{
-	struct kretprobe_instance *ri;
-	struct llist_node *node;
-
-	/* Early boot, not yet initialized. */
-	if (unlikely(!kprobes_initialized))
-		return;
-
-	kprobe_busy_begin();
-
-	node = __llist_del_all(&tk->kretprobe_instances);
-	while (node) {
-		ri = container_of(node, struct kretprobe_instance, llist);
-		node = node->next;
-
-		recycle_rp_inst(ri);
-	}
-
-	kprobe_busy_end();
-}
-NOKPROBE_SYMBOL(kprobe_flush_task);
-
-static inline void free_rp_inst(struct kretprobe *rp)
-{
-	struct kretprobe_instance *ri;
-	struct freelist_node *node;
-	int count = 0;
-
-	node = rp->freelist.head;
-	while (node) {
-		ri = container_of(node, struct kretprobe_instance, freelist);
-		node = node->next;
-
-		kfree(ri);
-		count++;
-	}
-
-	if (refcount_sub_and_test(count, &rp->rph->ref)) {
-		kfree(rp->rph);
-		rp->rph = NULL;
-	}
-}
-#endif	/* !CONFIG_KRETPROBE_ON_RETHOOK */
-
 /* Add the new probe to 'ap->list'. */
 static int add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
@@ -1928,6 +1855,77 @@ static struct notifier_block kprobe_exceptions_nb = {
 #ifdef CONFIG_KRETPROBES
 
 #if !defined(CONFIG_KRETPROBE_ON_RETHOOK)
+static void free_rp_inst_rcu(struct rcu_head *head)
+{
+	struct kretprobe_instance *ri = container_of(head, struct kretprobe_instance, rcu);
+
+	if (refcount_dec_and_test(&ri->rph->ref))
+		kfree(ri->rph);
+	kfree(ri);
+}
+NOKPROBE_SYMBOL(free_rp_inst_rcu);
+
+static void recycle_rp_inst(struct kretprobe_instance *ri)
+{
+	struct kretprobe *rp = get_kretprobe(ri);
+
+	if (likely(rp))
+		freelist_add(&ri->freelist, &rp->freelist);
+	else
+		call_rcu(&ri->rcu, free_rp_inst_rcu);
+}
+NOKPROBE_SYMBOL(recycle_rp_inst);
+
+/*
+ * This function is called from delayed_put_task_struct() when a task is
+ * dead and cleaned up to recycle any kretprobe instances associated with
+ * this task. These left over instances represent probed functions that
+ * have been called but will never return.
+ */
+void kprobe_flush_task(struct task_struct *tk)
+{
+	struct kretprobe_instance *ri;
+	struct llist_node *node;
+
+	/* Early boot, not yet initialized. */
+	if (unlikely(!kprobes_initialized))
+		return;
+
+	kprobe_busy_begin();
+
+	node = __llist_del_all(&tk->kretprobe_instances);
+	while (node) {
+		ri = container_of(node, struct kretprobe_instance, llist);
+		node = node->next;
+
+		recycle_rp_inst(ri);
+	}
+
+	kprobe_busy_end();
+}
+NOKPROBE_SYMBOL(kprobe_flush_task);
+
+static inline void free_rp_inst(struct kretprobe *rp)
+{
+	struct kretprobe_instance *ri;
+	struct freelist_node *node;
+	int count = 0;
+
+	node = rp->freelist.head;
+	while (node) {
+		ri = container_of(node, struct kretprobe_instance, freelist);
+		node = node->next;
+
+		kfree(ri);
+		count++;
+	}
+
+	if (refcount_sub_and_test(count, &rp->rph->ref)) {
+		kfree(rp->rph);
+		rp->rph = NULL;
+	}
+}
+
 /* This assumes the 'tsk' is the current task or the is not running. */
 static kprobe_opcode_t *__kretprobe_find_ret_addr(struct task_struct *tsk,
 						  struct llist_node **cur)

