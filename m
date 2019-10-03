Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02D5CA8E2
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392109AbfJCQeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392104AbfJCQeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:34:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33E4321A4C;
        Thu,  3 Oct 2019 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120451;
        bh=QClqtPxb64q0UWSVUfcPO9zkNVeRgt5dt0wiCLmm0X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mThRL0GJi3Uqi+/CHQFCppF8iNNJJYzZPUhNsonERIb+XkkcYqYzgCB5dDW19y5cs
         9+7hNS27Jw3yANRtkMAbcTv0x0qv5p8l/BcpG9/rkaj2wePQiwGtHYo+/OHP+lPmp0
         T/0Te4KPIiWsMxIQBeFmnSojCcu2A+uH+euNNQqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 227/313] rcu/tree: Fix SCHED_FIFO params
Date:   Thu,  3 Oct 2019 17:53:25 +0200
Message-Id: <20191003154555.383362319@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 130d9c331bc59a8733b47c58ef197a2b1fa3ed43 ]

A rather embarrasing mistake had us call sched_setscheduler() before
initializing the parameters passed to it.

Fixes: 1a763fd7c633 ("rcu/tree: Call setschedule() gp ktread to SCHED_FIFO outside of atomic region")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 32ea75acba144..affa7aae758f3 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3123,13 +3123,13 @@ static int __init rcu_spawn_gp_kthread(void)
 	t = kthread_create(rcu_gp_kthread, NULL, "%s", rcu_state.name);
 	if (WARN_ONCE(IS_ERR(t), "%s: Could not start grace-period kthread, OOM is now expected behavior\n", __func__))
 		return 0;
-	if (kthread_prio)
+	if (kthread_prio) {
+		sp.sched_priority = kthread_prio;
 		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	}
 	rnp = rcu_get_root();
 	raw_spin_lock_irqsave_rcu_node(rnp, flags);
 	rcu_state.gp_kthread = t;
-	if (kthread_prio)
-		sp.sched_priority = kthread_prio;
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 	wake_up_process(t);
 	rcu_spawn_nocb_kthreads();
-- 
2.20.1



