Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59729322300
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhBWALt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231981AbhBWALo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 414F964E61;
        Tue, 23 Feb 2021 00:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039040;
        bh=HG1hILbC2BowBRPD75ktuA0oKeXFy45xWifOj7bRsC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1SXGKjZME2fDL3VfDjXStreD173F1EC9VfwTiXMrZFW6E2bs+hhYrcfMLSs/g6lc
         sqS3RKfOI1IxXrr/Jh5tGMvlvZFZKRfQ1D4Q2Vwazl/reFM5thJPDE1ZmHz09jip6n
         76EwLI89tuEo0sqYIot7VSfmF1A4ACGuuQRdA6AlV9vW2MAtDLj4mFTtLT0R4H8pdH
         7t+q9dymDBTmGBtQMJMNUj6DsQi9pYhYAipnZTsVo7qnCtfg/N/9whvsrIZoPVMnNb
         r53IYJyk+k7nytro18VqWywATOVeVBFpfXGssu6+gSJ5nliaZrY4dwMOUIK1ihA91d
         ZOcxG4tHchuLQ==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 09/13] rcu/nocb: Cancel nocb_timer upon nocb_gp wakeup
Date:   Tue, 23 Feb 2021 01:10:07 +0100
Message-Id: <20210223001011.127063-10-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As we wake up in nocb_gp_wait(), there is no need to keep the nocb_timer
around as we are going to go through the whole rdp list again. Any update
performed before the timer was armed will now be visible after the
nocb_gp_lock acquire.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree_plugin.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 0fdf0223f08f..b62ad79bbda5 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2221,6 +2221,10 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
 		raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
 		if (bypass)
 			del_timer(&my_rdp->nocb_bypass_timer);
+		if (my_rdp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
+			WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+			del_timer(&my_rdp->nocb_timer);
+		}
 		WRITE_ONCE(my_rdp->nocb_gp_sleep, true);
 		raw_spin_unlock_irqrestore(&my_rdp->nocb_gp_lock, flags);
 	}
-- 
2.25.1

