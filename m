Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504A14049ED
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbhIILoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236954AbhIILnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:43:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA2CB611CE;
        Thu,  9 Sep 2021 11:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187714;
        bh=2x7/CSbTysEkoXuTJRs3YjYmDB0FmJSXP4i7ZfdVy3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPN35eYf8HKSsBGVjY82PWGIdb0w3ncp+gnQEPDwW4FTEA497MOCPi8NUJ2EBOPx8
         0J1AL+lqDHLRZl++yAnoNNvPvFRngbPq1ycs96sJlKMowS+AIFJOZ4QmzLWKlNFyhr
         fSiOiA8umxaHT5PSqVmd+QJnLSCX1/rS+Bm4tuRI3jNhVyQkUvc6dzFx26dys+F2+6
         ocwSzyhpKCY29gDXoZ0HwDdA6oapN0l4Waqj7ea73dKQZuaH63XmS7QmrMEIhJED8R
         oM9TwkYgtB+s4nRCor+B1SSO8pavgBMlXP7Zx50AqcRKTFAGsdijkKspgvaozkIdFI
         aiWllXl2fQnyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 037/252] rcu: Fix macro name CONFIG_TASKS_RCU_TRACE
Date:   Thu,  9 Sep 2021 07:37:31 -0400
Message-Id: <20210909114106.141462-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index d9680b798b21..955c82b4737c 100644
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
index de1dc3bb7f70..6ce104242b23 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2982,17 +2982,17 @@ static void noinstr rcu_dynticks_task_exit(void)
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

