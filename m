Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94416B48A9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbjCJPFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbjCJPE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:04:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B916F1B56A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:58:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73AA161A21
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAE5C433D2;
        Fri, 10 Mar 2023 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460289;
        bh=znvYm09pcS1JybYGeDu7voHYWiT5uCDIFWX1x02wdFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nqcOPzZI+tCFkHcM72S3tLGZ7ykpyr7hNXht91VL4hgCuIb2LYGgEtSJiYWRwMpg
         kPFpqSkNqjWzr1HUtMwSxCtGNwtQn4pU42oqokW/oB9zXhojDQZOkrSCIox6AqnZfZ
         gGdMyx6oCzLCmoCmajwGlAQNXq0eo1Z+lNubWZoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/529] rcu: Make RCU_LOCKDEP_WARN() avoid early lockdep checks
Date:   Fri, 10 Mar 2023 14:37:09 +0100
Message-Id: <20230310133818.207002244@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

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
index 1f46db38d6ec6..ef8d56b18da6b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -308,11 +308,18 @@ static inline int rcu_read_lock_any_held(void)
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
2.39.2



