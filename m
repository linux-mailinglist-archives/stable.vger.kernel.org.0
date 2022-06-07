Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF8E541E74
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355703AbiFGWcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382207AbiFGW3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:29:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEEB19C3B8;
        Tue,  7 Jun 2022 12:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDDD7B823D7;
        Tue,  7 Jun 2022 19:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B34CC385A2;
        Tue,  7 Jun 2022 19:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629816;
        bh=ku5YTNPMuHhIbMoZL86YvQrSbKQnLEi3PrYEdByeb9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F782440ib52djO4uKppH2smCPylSfMzap8XO1zATHhbWysGuRDb0AFtQng5kUsRXy
         AeCX0nyU/A8+J5domrpaX+NupFTZEDd+JIzJ1odxoTNi+k8RjmsnJAVi8GLRV4Gxmi
         JcvANbdM8CHFmbRr9XM00hBIvMorU2p1fkJqCg/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.18 827/879] kprobes: Fix build errors with CONFIG_KRETPROBES=n
Date:   Tue,  7 Jun 2022 19:05:45 +0200
Message-Id: <20220607165026.858589971@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 43994049180704fd1faf78623fabd9a5cd443708 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kprobes.h |    2 
 kernel/kprobes.c        |  144 +++++++++++++++++++++++-------------------------
 2 files changed, 72 insertions(+), 74 deletions(-)

--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -424,7 +424,7 @@ void unregister_kretprobe(struct kretpro
 int register_kretprobes(struct kretprobe **rps, int num);
 void unregister_kretprobes(struct kretprobe **rps, int num);
 
-#ifdef CONFIG_KRETPROBE_ON_RETHOOK
+#if defined(CONFIG_KRETPROBE_ON_RETHOOK) || !defined(CONFIG_KRETPROBES)
 #define kprobe_flush_task(tk)	do {} while (0)
 #else
 void kprobe_flush_task(struct task_struct *tk);
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
@@ -1928,6 +1855,77 @@ static struct notifier_block kprobe_exce
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


