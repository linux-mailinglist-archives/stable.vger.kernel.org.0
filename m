Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD5A4AA446
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 00:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378130AbiBDXYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 18:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378131AbiBDXYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 18:24:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85FFDFC13FC;
        Fri,  4 Feb 2022 15:24:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 31C38CE24C5;
        Fri,  4 Feb 2022 23:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFB6C340FA;
        Fri,  4 Feb 2022 23:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644017048;
        bh=JV+QYVqegQ9o52kCXFiEB9n9SUhqCcXNcpjWqfXua+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6Qjk6ScEl/hJ3/TxQCYUyLdoPTGafyqax0qSGcvEQGAeErtwXX7A1Ca7j800prlo
         rWzlDkmo1osvzqQECSYmFrweK5t9xlSWykuGRGgHyrW2iOigJaUzYG7DPHLDeqZ6eW
         eUGlMCXUzBVlc59asHeZD+8l47SF4rZv14t0Cq/SF+r3GfIbkF98uqfH3OwQ0k/x05
         orZxGKndEskRpSBryalm3EqW82dKNeFSHMWYxZD5p68201fDAJbZ5KjS4zlWM2/jR7
         jD2puXGxQRqUzfUgrxXDq16BVjaDpTALRlmBaJhpxRVRhe4DQ7Iie0iixYWFsYclY6
         68s+1HnzAuJWA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id CF1DC5C0AEF; Fri,  4 Feb 2022 15:24:07 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com,
        rostedt@goodmis.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Tim Murray <timmurray@google.com>,
        Joel Fernandes <joelaf@google.com>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Todd Kjos <tkjos@google.com>,
        Sandeep Patil <sspatil@google.com>, stable@vger.kernel.org
Subject: [PATCH rcu 09/10] rcu: Don't deboost before reporting expedited quiescent state
Date:   Fri,  4 Feb 2022 15:24:05 -0800
Message-Id: <20220204232406.814-9-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20220204232355.GA728@paulmck-ThinkPad-P17-Gen-1>
References: <20220204232355.GA728@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently rcu_preempt_deferred_qs_irqrestore() releases rnp->boost_mtx
before reporting the expedited quiescent state.  Under heavy real-time
load, this can result in this function being preempted before the
quiescent state is reported, which can in turn prevent the expedited grace
period from completing.  Tim Murray reports that the resulting expedited
grace periods can take hundreds of milliseconds and even more than one
second, when they should normally complete in less than a millisecond.

This was fine given that there were no particular response-time
constraints for synchronize_rcu_expedited(), as it was designed
for throughput rather than latency.  However, some users now need
sub-100-millisecond response-time constratints.

This patch therefore follows Neeraj's suggestion (seconded by Tim and
by Uladzislau Rezki) of simply reversing the two operations.

Reported-by: Tim Murray <timmurray@google.com>
Reported-by: Joel Fernandes <joelaf@google.com>
Reported-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Reviewed-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Tested-by: Tim Murray <timmurray@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 kernel/rcu/tree_plugin.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 109429e70a642..02ac057ba3f83 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -556,16 +556,16 @@ rcu_preempt_deferred_qs_irqrestore(struct task_struct *t, unsigned long flags)
 			raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 		}
 
-		/* Unboost if we were boosted. */
-		if (IS_ENABLED(CONFIG_RCU_BOOST) && drop_boost_mutex)
-			rt_mutex_futex_unlock(&rnp->boost_mtx.rtmutex);
-
 		/*
 		 * If this was the last task on the expedited lists,
 		 * then we need to report up the rcu_node hierarchy.
 		 */
 		if (!empty_exp && empty_exp_now)
 			rcu_report_exp_rnp(rnp, true);
+
+		/* Unboost if we were boosted. */
+		if (IS_ENABLED(CONFIG_RCU_BOOST) && drop_boost_mutex)
+			rt_mutex_futex_unlock(&rnp->boost_mtx.rtmutex);
 	} else {
 		local_irq_restore(flags);
 	}
-- 
2.31.1.189.g2e36527f23

