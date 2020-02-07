Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B52155569
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 11:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgBGKQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 05:16:19 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41257 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbgBGKQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 05:16:19 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3F80421FF3;
        Fri,  7 Feb 2020 05:16:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 05:16:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=q52x0I
        PnRgKlDVXk/IauZ93moKTmsxLVJfgti5btGQA=; b=bkOmbEc5E+AW3Wy0LZtB2b
        MjJFfrfZr3Jy/bHEh9VM6RHYi/fXq4/Wrhj70vDpLioqQVHoURmvrEamrs85jLuq
        JD9ckSrovL+Uf/Gus2e4/+2wIRVT6UZUCIv0n0vQlfRWg1OeT2fhKHTpTnwBcPha
        3h/NIZx4LkKw8Filk/RaWGZvYr4IaUyBAx8ByJVaOYp2v1iycswCfAjeItQs69s/
        RNtAc/x3DSTIpCfeIfj0s8H0wRefzRaDdPRXOK4JOhNPrPNLz3d62wtj29AoKsy9
        BVTYpQTPvXdKvAd2RAYRdK12i251cZFrWjAF0B8Nvy7qQFcxAoQ4VcEHleLQVr+g
        ==
X-ME-Sender: <xms:8jg9XvbC4uaKKiXAuHuGPglW_EPw_YUszpUebjU4iTX_gSp8dWNFYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8jg9XvF0LaeHpfKHVc-_PZGtoyNR6G9Gw7LcBO3wXu7oexzZWhi32w>
    <xmx:8jg9XgIlTBm1Ql9N2Lklq1k0EBNSLh9zkba-YtYRTPIQKJowmZsraw>
    <xmx:8jg9XqPt0Fq1gKUyuG67YJ46DL3wP3I1dE-iLRAC7YpeDEkbnVG5MQ>
    <xmx:8jg9XlQov7u6no7ANIl-J1NkdeBU6tvOeswr1yImArNlPW2N40N45A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB77F3280059;
        Fri,  7 Feb 2020 05:16:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] ftrace: Protect ftrace_graph_hash with ftrace_sync" failed to apply to 5.4-stable tree
To:     rostedt@goodmis.org, joel@joelfernandes.org, paulmck@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Feb 2020 11:16:16 +0100
Message-ID: <1581070576208200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

