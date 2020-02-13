Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F078F15C63E
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgBMP6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbgBMPZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:04 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49EEC20848;
        Thu, 13 Feb 2020 15:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607504;
        bh=sV3ED1FNeSxFHSiNHHFaSzZXwtXmvQp1WCZUfFNtHww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ff7ZuiEVJkCqga68ctKTJ6RpVTrt+Clg2MsTVz3TcPcHYT+Ikxil2cE8qPS9WcJbl
         Vt3tYFpS42rhipc9BP4MAjdzqWOYvLEh9o7gQn9sS/m5YOjZTi0OWjF2J4fyZvqXhL
         FiE/KBK4avxEjHQwMKWfK1876TebGqSIAnEX0AqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 061/173] ftrace: Protect ftrace_graph_hash with ftrace_sync
Date:   Thu, 13 Feb 2020 07:19:24 -0800
Message-Id: <20200213151949.194902699@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 54a16ff6f2e50775145b210bcd94d62c3c2af117 ]

As function_graph tracer can run when RCU is not "watching", it can not be
protected by synchronize_rcu() it requires running a task on each CPU before
it can be freed. Calling schedule_on_each_cpu(ftrace_sync) needs to be used.

Link: https://lore.kernel.org/r/20200205131110.GT2935@paulmck-ThinkPad-P72

Cc: stable@vger.kernel.org
Fixes: b9b0c831bed26 ("ftrace: Convert graph filter to use hash tables")
Reported-by: "Paul E. McKenney" <paulmck@kernel.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 11 +++++++++--
 kernel/trace/trace.h  |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dd9fdb52e24ad..8974ecbcca3cb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5419,8 +5419,15 @@ ftrace_graph_release(struct inode *inode, struct file *file)
 
 		mutex_unlock(&graph_lock);
 
-		/* Wait till all users are no longer using the old hash */
-		synchronize_sched();
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
index 99af95e294d8d..c4c61ebb8d054 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -883,6 +883,7 @@ static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
 	 * Have to open code "rcu_dereference_sched()" because the
 	 * function graph tracer can be called when RCU is not
 	 * "watching".
+	 * Protected with schedule_on_each_cpu(ftrace_sync)
 	 */
 	hash = rcu_dereference_protected(ftrace_graph_hash, !preemptible());
 
@@ -935,6 +936,7 @@ static inline int ftrace_graph_notrace_addr(unsigned long addr)
 	 * Have to open code "rcu_dereference_sched()" because the
 	 * function graph tracer can be called when RCU is not
 	 * "watching".
+	 * Protected with schedule_on_each_cpu(ftrace_sync)
 	 */
 	notrace_hash = rcu_dereference_protected(ftrace_graph_notrace_hash,
 						 !preemptible());
-- 
2.20.1



