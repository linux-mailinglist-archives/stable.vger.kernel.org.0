Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD6D404E3C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbhIIMKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348907AbhIIMFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:05:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8072611CC;
        Thu,  9 Sep 2021 11:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188034;
        bh=thpL6AW9gfvM62P9aPozmTg4bDfzk4C3pcgMyurRBJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BjXysXZUnVMx3BvTse4euWb602aMDf8UImrz4ytc6IJVeV6CRCIKQfY+EsD8vJUOf
         G6ydAYU8iJ/iqMG/XoMBo25ksLR5nqo/blOuCqrN88bXQl2E29MDX0SQorUeKZQuJW
         0lTzZSl7I4JTYA+hm00ZmBBrm/rcL73fol0ojru8Sjy1DdEwN7K3bv+lu0k943vYBj
         0qEqCcthNBdc03a0QwjTOYMSy+9jYDunVRCzjWNIXvVjESKOoGJ0Kc+iIH/xcz4uRa
         Zi9GgHZmG0AoH3Hy8wPic0LQhWzIpxy4rykKPMifB+qAn+DeUe9v+anp2bLZXyUX47
         xvdL404628+zQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 030/219] rcu: Fix macro name CONFIG_TASKS_RCU_TRACE
Date:   Thu,  9 Sep 2021 07:43:26 -0400
Message-Id: <20210909114635.143983-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhouyi Zhou <zhouzhouyi@gmail.com>

[ Upstream commit fed31a4dd3adb5455df7c704de2abb639a1dc1c0 ]

This commit fixes several typos where CONFIG_TASKS_RCU_TRACE should
instead be CONFIG_TASKS_TRACE_RCU.  Among other things, these typos
could cause CONFIG_TASKS_TRACE_RCU_READ_MB=y kernels to suffer from
memory-ordering bugs that could result in false-positive quiescent
states and too-short grace periods.

Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 2 +-
 kernel/rcu/tree_plugin.h | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 1199ffd305d1..fcd8ec0b7408 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -167,7 +167,7 @@ void synchronize_rcu_tasks(void);
 # define synchronize_rcu_tasks synchronize_rcu
 # endif
 
-# ifdef CONFIG_TASKS_RCU_TRACE
+# ifdef CONFIG_TASKS_TRACE_RCU
 # define rcu_tasks_trace_qs(t)						\
 	do {								\
 		if (!likely(READ_ONCE((t)->trc_reader_checked)) &&	\
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index ad0156b86937..d14905051535 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2995,17 +2995,17 @@ static void noinstr rcu_dynticks_task_exit(void)
 /* Turn on heavyweight RCU tasks trace readers on idle/user entry. */
 static void rcu_dynticks_task_trace_enter(void)
 {
-#ifdef CONFIG_TASKS_RCU_TRACE
+#ifdef CONFIG_TASKS_TRACE_RCU
 	if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB))
 		current->trc_reader_special.b.need_mb = true;
-#endif /* #ifdef CONFIG_TASKS_RCU_TRACE */
+#endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
 }
 
 /* Turn off heavyweight RCU tasks trace readers on idle/user exit. */
 static void rcu_dynticks_task_trace_exit(void)
 {
-#ifdef CONFIG_TASKS_RCU_TRACE
+#ifdef CONFIG_TASKS_TRACE_RCU
 	if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB))
 		current->trc_reader_special.b.need_mb = false;
-#endif /* #ifdef CONFIG_TASKS_RCU_TRACE */
+#endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
 }
-- 
2.30.2

