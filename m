Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583A2307C03
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhA1RPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:15:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhA1RNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:13:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ED1F64E18;
        Thu, 28 Jan 2021 17:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853953;
        bh=c1G2wkbaXSdaflMGPDD24BHmwffEef+9SnNDPAANxEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCxtPw4lngaB7EITdNNQRP0tXHajdxcbSVUIIh4SKcakMnLvJf9KMtV5EqX6IsxrZ
         Pn/x4rCoCJF7Fvj/qfqpgsStyBx6WBkqsgNhkzzSy1KPP/RVZUNcTPI57zYP2NMstC
         wsChBOH3IjwqGNI6ly2X0ti/A86StcyTjNp+TWtPOnhN2K3CEPH7ecYC/KWznQwb8m
         bqbc8fK+FeJz7xS2iFzGibEElSK/p+6nyztzptGBhiAXPSrANQh5+Kv5f5kfm2Ntpy
         CgDLE1JuoMTcMEs/lmuQyskUOo9JUyQ6l5Q5LpmLrjNJLbkBmJ+934BVymlYjyhpqP
         hD/ptYn6cU5fg==
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
Subject: [PATCH 02/16] rcu/nocb: Comment the reason behind BH disablement on batch processing
Date:   Thu, 28 Jan 2021 18:12:08 +0100
Message-Id: <20210128171222.131380-3-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Explain why we need to disable softirqs while processing callbacks in
an offline fashion. The subtle reason doesn't want to be forgotten.

Reported-by: Boqun Feng <boqun.feng@gmail.com>
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/rcu/tree_plugin.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a44f80d7661b..dcfae03eb9e9 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2235,6 +2235,12 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 	local_irq_save(flags);
 	rcu_momentary_dyntick_idle();
 	local_irq_restore(flags);
+	/*
+	 * While transitioning to/from NOCB mode, a CPU might execute the same
+	 * callback concurrently if it requeues itself and the softirq interrupts
+	 * the offloaded callback processing. Make sure we disable BH to prevent
+	 * from that.
+	 */
 	local_bh_disable();
 	rcu_do_batch(rdp);
 	local_bh_enable();
-- 
2.25.1

