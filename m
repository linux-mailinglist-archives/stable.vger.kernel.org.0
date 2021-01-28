Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C60307C10
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhA1RS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232992AbhA1RP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:15:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B48C64E0E;
        Thu, 28 Jan 2021 17:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853978;
        bh=extfcXAHPC3Ypdxg7UwlyDG1pwVXPryNDAH4Dz3j8H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVdes+PDPe0vhhrmcyMN0QpyLLR89i013OKnWojBTY4Fx+GK/4J0ZwaJfgYEGtERu
         KRc+044ps7VUNMncmOuDq1UlvQU5rT+6cdav63bMh+Z4EaTYe1cN+zvlwdBx2yHLw4
         CD4OMnX9Kwn+R/i7EsseaQn3aHanItZmvkalMiHN0jHbMnr7749tr3CkZ84IZXB4qp
         qD6mfws8dWj7tVKsX4pj8OWqcvsfggEbDU30hsCG8p6LXXHG3fwceGt5nBNVqYGPdk
         R1xH3TBugNIOak/MEQA7khTkg5ATyjGnCMCQuBHx6mtafBOarTacCJXvfI/DJTFjun
         CJbyU/NQd38zA==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 12/16] rcu/nocb: Cancel nocb_timer upon nocb_gp wakeup
Date:   Thu, 28 Jan 2021 18:12:18 +0100
Message-Id: <20210128171222.131380-13-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
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
index dae892ac570a..39fb792704ed 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2212,6 +2212,10 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
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

