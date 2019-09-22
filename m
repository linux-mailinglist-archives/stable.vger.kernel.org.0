Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3663DBA5BE
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389127AbfIVSpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389181AbfIVSpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97C182186A;
        Sun, 22 Sep 2019 18:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177923;
        bh=Khkr7SUx3By7seMEzLt/dW27p0v3MIpa+M+qZfVLF/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCyIMHiCljLKLtzhm81UA8D081Sx576IOEyWLmcdTBKDOWhFjAYaHG1cEt4BiMWs/
         TIBox6JWQZzEeJ3Cq6IE+Y9qEEU+xOyBb4PGoJXxXQQA4CXx4cjOHsAmr7L4xSyV4S
         4ea5kdvx58t5LOWAEF6ZryerMA2Lk6RBmBG0T9Rw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 035/203] rcu: Add destroy_work_on_stack() to match INIT_WORK_ONSTACK()
Date:   Sun, 22 Sep 2019 14:41:01 -0400
Message-Id: <20190922184350.30563-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.ibm.com>

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

