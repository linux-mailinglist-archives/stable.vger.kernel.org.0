Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B186AF0B7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCGSel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjCGSeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:34:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459E6AD01E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:26:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C1C4614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EA2C4339C;
        Tue,  7 Mar 2023 18:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213566;
        bh=ukXK6qdxSuOIP5YHLlswAEw65me9P5ZPlSlWWvqypB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUnOv+9Oc3sey3H6hqvPrYQIt8vtlu11jKNJJkMlM7z18IsIkRrWOS08vpMSqP3+z
         sj7gNnjVD73NzrAgoUfJpPxUTVQ1fXv3BiCetDO0VSpCy8ToXZfpKxVKaFs3xOn9hS
         nOmO05Dm2psR57BhUmASJq8MsW9wwE0dVP/5YQ10=
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
Subject: [PATCH 6.1 548/885] rcu: Make RCU_LOCKDEP_WARN() avoid early lockdep checks
Date:   Tue,  7 Mar 2023 17:58:02 +0100
Message-Id: <20230307170026.301650195@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index 4a3fd3404ad0c..e9e61cd27ef63 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -350,11 +350,18 @@ static inline int rcu_read_lock_any_held(void)
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



