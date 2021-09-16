Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1C040DFBB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbhIPQNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238868AbhIPQLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:11:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE2416137A;
        Thu, 16 Sep 2021 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808544;
        bh=+fLK7laVA3H5s1F118MwcV8hwLjCEOdsVd9d0wNqu4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0uQiXA4fdHPQy3icHaoDdksqrxlV4MRtyNeWf2LwnUaFAlUA08tEsez1vZS8jNBv
         iLucDyMYYHDIlh/Ryms8AifbBDfbvqpAASpmtZ9FdTtCqwlxCLxcWZ/DlDbVh7Cbv4
         SSaYJkv32HI2bJJ53Y2Z0WUPQlhB393OrzbL9rwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhouyi Zhou <zhouzhouyi@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/306] rcu: Fix macro name CONFIG_TASKS_RCU_TRACE
Date:   Thu, 16 Sep 2021 17:57:55 +0200
Message-Id: <20210916155758.491314821@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 574aeaac9272..c5091aeaa37b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2591,17 +2591,17 @@ static void noinstr rcu_dynticks_task_exit(void)
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



