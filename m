Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0686C4050E6
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351775AbhIIMcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346787AbhIIM0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:26:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C45BA61211;
        Thu,  9 Sep 2021 11:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188305;
        bh=dcPoAMYlZs4qbJHXP5SYZCPtp3ohmedeLbQSCdktfmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulhU3d/H86KHsH4nBLhZPepCqk1b3PNaP/oj7o/yLfsNKebscyxa727lu9pD5+ylN
         YBtT6PToP6ZGZBx7dIivYS2Hrs4KGKr0QkkHh8NseF66m3r87KNIU+AS3kr4u9bP9i
         7T/s0QW1MH3wZslCjakgplUhv55L+QLG1vNsK1YW9AFYPr4uJ5zVNtVA8HkJTiZAYV
         8Ek0q9tOamajjTIxJViRGehvB4GOFlJV49UlEhoU+vFsFyDF7Bt5ra+34D654rdxW4
         OxIYSOO93AQmJajUrEDaupRz1z52vR5aEkjP6sk+52/QSKf1PFFUdFySqoYOFz0447
         9rxmNp91JoNAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 021/176] rcu: Fix macro name CONFIG_TASKS_RCU_TRACE
Date:   Thu,  9 Sep 2021 07:48:43 -0400
Message-Id: <20210909115118.146181-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 0d7013da818c..095b3b39bd03 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -163,7 +163,7 @@ void synchronize_rcu_tasks(void);
 # define synchronize_rcu_tasks synchronize_rcu
 # endif
 
-# ifdef CONFIG_TASKS_RCU_TRACE
+# ifdef CONFIG_TASKS_TRACE_RCU
 # define rcu_tasks_trace_qs(t)						\
 	do {								\
 		if (!likely(READ_ONCE((t)->trc_reader_checked)) &&	\
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7d4f78bf4057..8ea96a72c48e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2590,17 +2590,17 @@ static void noinstr rcu_dynticks_task_exit(void)
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

