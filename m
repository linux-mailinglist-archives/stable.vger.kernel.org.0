Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD53515556A
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 11:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgBGKQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 05:16:27 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41307 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726954AbgBGKQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 05:16:27 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 53FB421B2A;
        Fri,  7 Feb 2020 05:16:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 05:16:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6iAzkX
        yPaupQwf6LtE8L/hONT0oWfwygjKQ1PEUNlGE=; b=K9WwCrQoyoLlhoE3M0qPao
        BlOONSjGqBycIWZUtvZKziyVOPVAnID1HVGN0nEiFF/oP4fCgZm5KZUjA2kvIVjy
        xJQQcwoTAqno44ULS3PvQD0hrnULPWC/WPUGQEGWlymO3P97ZRbrm/yoO4OloTDM
        QsYc62dNTyP3lYAZ2nCwnA7b/pahq6AH85pYUg8oTieb3o0cHrbUUrLcy0hYPzBr
        IslkTM43jlH96bkncoiLe59RLmrnMZlIJIt3z73Oi7WzaQFaf8BssuNzWHhIGfkR
        eCtrbjJ3mhbCZfVEcv1tDnHJNH1IlLSaXu5vxlw6UyVrnK7UWFb9dSOMYwvDnh5w
        ==
X-ME-Sender: <xms:-jg9Xhz4oSNdEKcjlotJ2WMstH2FEWtL1CQOLPJmMaXJfK4vBayO0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-jg9XovDgWQheKScrorzYvqP0f6QLJNOLiBxVwZLCpvd1h3dZvAjdA>
    <xmx:-jg9XosskWMofbGko5bN0TX4RG4hPZ6uBU4wuTdBr2vq1NX_h9pX3w>
    <xmx:-jg9XtNcw1XGV9Bn_ri-dDU-i-dkC-6jYGt7v_J37et2eTnK9uWA4g>
    <xmx:-jg9Xk7k0NSgJ71zYwtvln71t80Yrud4PeNqSFzpyHccBZqcm-4grQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC5853060701;
        Fri,  7 Feb 2020 05:16:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] ftrace: Protect ftrace_graph_hash with ftrace_sync" failed to apply to 5.5-stable tree
To:     rostedt@goodmis.org, joel@joelfernandes.org, paulmck@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Feb 2020 11:16:16 +0100
Message-ID: <15810705761598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 54a16ff6f2e50775145b210bcd94d62c3c2af117 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Wed, 5 Feb 2020 09:20:32 -0500
Subject: [PATCH] ftrace: Protect ftrace_graph_hash with ftrace_sync

As function_graph tracer can run when RCU is not "watching", it can not be
protected by synchronize_rcu() it requires running a task on each CPU before
it can be freed. Calling schedule_on_each_cpu(ftrace_sync) needs to be used.

Link: https://lore.kernel.org/r/20200205131110.GT2935@paulmck-ThinkPad-P72

Cc: stable@vger.kernel.org
Fixes: b9b0c831bed26 ("ftrace: Convert graph filter to use hash tables")
Reported-by: "Paul E. McKenney" <paulmck@kernel.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 481ede3eac13..3f7ee102868a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5867,8 +5867,15 @@ ftrace_graph_release(struct inode *inode, struct file *file)
 
 		mutex_unlock(&graph_lock);
 
-		/* Wait till all users are no longer using the old hash */
-		synchronize_rcu();
+		/*
+		 * We need to do a hard force of sched synchronization.
+		 * This is because we use preempt_disable() to do RCU, but
+		 * the function tracers can be called where RCU is not watching
+		 * (like before user_exit()). We can not rely on the RCU
+		 * infrastructure to do the synchronization, thus we must do it
+		 * ourselves.
+		 */
+		schedule_on_each_cpu(ftrace_sync);
 
 		free_ftrace_hash(old_hash);
 	}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8c52f5de9384..3c75d29bd861 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -979,6 +979,7 @@ static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
 	 * Have to open code "rcu_dereference_sched()" because the
 	 * function graph tracer can be called when RCU is not
 	 * "watching".
+	 * Protected with schedule_on_each_cpu(ftrace_sync)
 	 */
 	hash = rcu_dereference_protected(ftrace_graph_hash, !preemptible());
 
@@ -1031,6 +1032,7 @@ static inline int ftrace_graph_notrace_addr(unsigned long addr)
 	 * Have to open code "rcu_dereference_sched()" because the
 	 * function graph tracer can be called when RCU is not
 	 * "watching".
+	 * Protected with schedule_on_each_cpu(ftrace_sync)
 	 */
 	notrace_hash = rcu_dereference_protected(ftrace_graph_notrace_hash,
 						 !preemptible());

