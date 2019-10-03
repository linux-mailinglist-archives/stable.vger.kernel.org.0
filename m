Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C748ECA68E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405454AbfJCQo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404806AbfJCQmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:42:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAC5D2054F;
        Thu,  3 Oct 2019 16:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120974;
        bh=Jr0wGQmS0muJUE7fHZrs67QdfVNAOhdhj82RmrQrEgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oI5P9mxyiyqe+PK4SHXWVAWvtsyQEEWsRj+Xti7r5mbzToNUhYpOJnrKcCnvsX8nr
         noWUyiWK43S9P+bo5DDi+23D9LAvlBmC1XK7srDPwpvyyTA8Zd/LhOn9sgmkggIk86
         j5RWswJnjwKozp9DuGj84dHLX6R8gq9uDZeRo/OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 071/344] rcu: Add destroy_work_on_stack() to match INIT_WORK_ONSTACK()
Date:   Thu,  3 Oct 2019 17:50:36 +0200
Message-Id: <20191003154547.138807171@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.ibm.com>

[ Upstream commit fbad01af8c3bb9618848abde8054ab7e0c2330fe ]

The synchronize_rcu_expedited() function has an INIT_WORK_ONSTACK(),
but lacks the corresponding destroy_work_on_stack().  This commit
therefore adds destroy_work_on_stack().

Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_exp.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index af7e7b9c86afa..513b403b683b7 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -792,6 +792,7 @@ static int rcu_print_task_exp_stall(struct rcu_node *rnp)
  */
 void synchronize_rcu_expedited(void)
 {
+	bool boottime = (rcu_scheduler_active == RCU_SCHEDULER_INIT);
 	struct rcu_exp_work rew;
 	struct rcu_node *rnp;
 	unsigned long s;
@@ -817,7 +818,7 @@ void synchronize_rcu_expedited(void)
 		return;  /* Someone else did our work for us. */
 
 	/* Ensure that load happens before action based on it. */
-	if (unlikely(rcu_scheduler_active == RCU_SCHEDULER_INIT)) {
+	if (unlikely(boottime)) {
 		/* Direct call during scheduler init and early_initcalls(). */
 		rcu_exp_sel_wait_wake(s);
 	} else {
@@ -835,5 +836,8 @@ void synchronize_rcu_expedited(void)
 
 	/* Let the next expedited grace period start. */
 	mutex_unlock(&rcu_state.exp_mutex);
+
+	if (likely(!boottime))
+		destroy_work_on_stack(&rew.rew_work);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
-- 
2.20.1



