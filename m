Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A41608C12
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJVK6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiJVK6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:58:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF2540BCA;
        Sat, 22 Oct 2022 03:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B95D3B82DEF;
        Sat, 22 Oct 2022 07:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9B7C433C1;
        Sat, 22 Oct 2022 07:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425564;
        bh=jWnmZB96YzuwtBqDfWonjmLe0fepcA22GyA5+Yn5wxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxMIuck9RQOhAZPkOqLk/0DMLiMqJZbHO81r59tN1SW1pN8829v6m0x2tGTdiPlgq
         dPmb3BSkBdRHHWkLKbxfzKGNpr5HAPvv8faOnlE+pR9pEK+R2Xr73YRH2VcsJ5sEYi
         2oGQN/odXYyX7kEwU6sn1o7UCHWXsmc/f7yj+bVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Michal Hocko <mhocko@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 542/717] rcu: Back off upon fill_page_cache_func() allocation failure
Date:   Sat, 22 Oct 2022 09:27:01 +0200
Message-Id: <20221022072522.317578067@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

[ Upstream commit 093590c16b447f53e66771c8579ae66c96f6ef61 ]

The fill_page_cache_func() function allocates couple of pages to store
kvfree_rcu_bulk_data structures. This is a lightweight (GFP_NORETRY)
allocation which can fail under memory pressure. The function will,
however keep retrying even when the previous attempt has failed.

This retrying is in theory correct, but in practice the allocation is
invoked from workqueue context, which means that if the memory reclaim
gets stuck, these retries can hog the worker for quite some time.
Although the workqueues subsystem automatically adjusts concurrency, such
adjustment is not guaranteed to happen until the worker context sleeps.
And the fill_page_cache_func() function's retry loop is not guaranteed
to sleep (see the should_reclaim_retry() function).

And we have seen this function cause workqueue lockups:

kernel: BUG: workqueue lockup - pool cpus=93 node=1 flags=0x1 nice=0 stuck for 32s!
[...]
kernel: pool 74: cpus=37 node=0 flags=0x1 nice=0 hung=32s workers=2 manager: 2146
kernel:   pwq 498: cpus=249 node=1 flags=0x1 nice=0 active=4/256 refcnt=5
kernel:     in-flight: 1917:fill_page_cache_func
kernel:     pending: dbs_work_handler, free_work, kfree_rcu_monitor

Originally, we thought that the root cause of this lockup was several
retries with direct reclaim, but this is not yet confirmed.  Furthermore,
we have seen similar lockups without any heavy memory pressure.  This
suggests that there are other factors contributing to these lockups.
However, it is not really clear that endless retries are desireable.

So let's make the fill_page_cache_func() function back off after
allocation failure.

Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index c25ba442044a..54a3a19c4c0b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3508,15 +3508,16 @@ static void fill_page_cache_func(struct work_struct *work)
 		bnode = (struct kvfree_rcu_bulk_data *)
 			__get_free_page(GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 
-		if (bnode) {
-			raw_spin_lock_irqsave(&krcp->lock, flags);
-			pushed = put_cached_bnode(krcp, bnode);
-			raw_spin_unlock_irqrestore(&krcp->lock, flags);
+		if (!bnode)
+			break;
 
-			if (!pushed) {
-				free_page((unsigned long) bnode);
-				break;
-			}
+		raw_spin_lock_irqsave(&krcp->lock, flags);
+		pushed = put_cached_bnode(krcp, bnode);
+		raw_spin_unlock_irqrestore(&krcp->lock, flags);
+
+		if (!pushed) {
+			free_page((unsigned long) bnode);
+			break;
 		}
 	}
 
-- 
2.35.1



