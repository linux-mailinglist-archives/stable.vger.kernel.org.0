Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554F06A3128
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjBZO4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjBZOxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:53:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FB91ADF0;
        Sun, 26 Feb 2023 06:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E50ABCE0E89;
        Sun, 26 Feb 2023 14:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C00C433D2;
        Sun, 26 Feb 2023 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422936;
        bh=YB+CXBd6ie4uIgEIRfxaUhKMSsOEBCCkGigUpgM3xFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzpMob3kDqKtWZyVFghHtf99J0HjCZg801Bv9xNcBfiOHqd0/4IHZ/md17v/OaRsA
         IYac2b+RGzTkTI8RrEpMHnEaw7PqJunApglrMk+C9G8+TVJAUiW51eBLz2F0eyiW1G
         DIpYwwcBXSrb3cd6WrSw/bMaCgZDfCre4Kc2v9rY5uxchwL+H0ItZJ3ur19A1VFiZN
         c78QlLmnEvIXNjQ39iCsAZr6f+MQTyrbQd14zATH4oGpzxpHCpdcib9a0v3c9XGv3l
         SsNKxXlvYGCJchVuitUMPl5guJOYX/UnrN/+EMPef6f68KhLRghVlhuYmC3lIh4Mks
         JAk3+PuOCniYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/36] rcu: Make RCU_LOCKDEP_WARN() avoid early lockdep checks
Date:   Sun, 26 Feb 2023 09:48:11 -0500
Message-Id: <20230226144845.827893-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144845.827893-1-sashal@kernel.org>
References: <20230226144845.827893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit 0cae5ded535c3a80aed94f119bbd4ee3ae284a65 ]

Currently, RCU_LOCKDEP_WARN() checks the condition before checking
to see if lockdep is still enabled.  This is necessary to avoid the
false-positive splats fixed by commit 3066820034b5dd ("rcu: Reject
RCU_LOCKDEP_WARN() false positives").  However, the current state can
result in false-positive splats during early boot before lockdep is fully
initialized.  This commit therefore checks debug_lockdep_rcu_enabled()
both before and after checking the condition, thus avoiding both sets
of false-positive error reports.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 434d12fe2d4f5..c8703fb3bfe44 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -311,11 +311,18 @@ static inline int rcu_read_lock_any_held(void)
  * RCU_LOCKDEP_WARN - emit lockdep splat if specified condition is met
  * @c: condition to check
  * @s: informative message
+ *
+ * This checks debug_lockdep_rcu_enabled() before checking (c) to
+ * prevent early boot splats due to lockdep not yet being initialized,
+ * and rechecks it after checking (c) to prevent false-positive splats
+ * due to races with lockdep being disabled.  See commit 3066820034b5dd
+ * ("rcu: Reject RCU_LOCKDEP_WARN() false positives") for more detail.
  */
 #define RCU_LOCKDEP_WARN(c, s)						\
 	do {								\
 		static bool __section(".data.unlikely") __warned;	\
-		if ((c) && debug_lockdep_rcu_enabled() && !__warned) {	\
+		if (debug_lockdep_rcu_enabled() && (c) &&		\
+		    debug_lockdep_rcu_enabled() && !__warned) {		\
 			__warned = true;				\
 			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\
 		}							\
-- 
2.39.0

