Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A8426E719
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 23:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgIQVHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 17:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgIQVHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 17:07:47 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 345FE2137B;
        Thu, 17 Sep 2020 21:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600376867;
        bh=YG58AqGwRC/b1zVwI1vspT5s6BpQVBYT61T44ZLacOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E57WJmZQduslOXz7AOIuGgMS6T5RNuKF9YBfPyKXp3v/LJbp8uVTXF9YYxYqD7+oo
         eKn/LV8O82n1rWn2vJCQlhN7hTCc9qih+c6m7h40k6S/xswfrqbADrkFuRjK9FrNyw
         leL3cUP1KRZ0ysdtwsB7YX32FUcJ3g0ncW4sE5Gg=
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        sfr@canb.auug.org.au, "Paul E. McKenney" <paulmck@kernel.org>,
        "# 5 . 8 . x" <stable@vger.kernel.org>
Subject: [PATCH tip/core/rcu 1/8] rcu-tasks: Prevent complaints of unused show_rcu_tasks_classic_gp_kthread()
Date:   Thu, 17 Sep 2020 14:07:37 -0700
Message-Id: <20200917210744.2995-1-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200917210652.GA31242@paulmck-ThinkPad-P72>
References: <20200917210652.GA31242@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

Commit 8344496e8b49 ("rcu-tasks: Conditionally compile
show_rcu_tasks_gp_kthreads()") introduced conditional
compilation of several functions, but forgot one occurrence of
show_rcu_tasks_classic_gp_kthread() that causes the compiler to warn of
an unused static function.  This commit uses "static inline" to avoid
these complaints and possibly also to avoid emitting an actual definition
of this function.

Fixes: 8344496e8b49 ("rcu-tasks: Conditionally compile show_rcu_tasks_gp_kthreads()")
Cc: <stable@vger.kernel.org> # 5.8.x
Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 kernel/rcu/tasks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 835e2df..05d3e13 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -590,7 +590,7 @@ void exit_tasks_rcu_finish(void) __releases(&tasks_rcu_exit_srcu)
 }
 
 #else /* #ifdef CONFIG_TASKS_RCU */
-static void show_rcu_tasks_classic_gp_kthread(void) { }
+static inline void show_rcu_tasks_classic_gp_kthread(void) { }
 void exit_tasks_rcu_start(void) { }
 void exit_tasks_rcu_finish(void) { exit_tasks_rcu_finish_trace(current); }
 #endif /* #else #ifdef CONFIG_TASKS_RCU */
-- 
2.9.5

