Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74882307C0F
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhA1RSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:18:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232991AbhA1RP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:15:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE03764E1C;
        Thu, 28 Jan 2021 17:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853975;
        bh=2kiiEpXF9QFOpaYiC4twXUdyqdvzYnunECcbe7mR4O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jk7OIpd3xoGgygCoIYqGicgMKqY4+L8TlMn5ZxByYgEhZNLvJKqBIuEsUay5cp588
         SLjwzLNux5Yq9ksEF/Cu78GVjcDpuAG4Z3slWHWxkG6mnJHQku5PJIw88h08Jl4mnS
         ImVr3kpBykibJgMjmw3WqB3TG17aS6wC9Hj+tSqmXwTlrJHc/fgXJ1/UAMVa6JMFOz
         JMbRQy/suWHd6EtHday1Ux7aoZTewk2GDzANyjM4LYLDvzsq2HnQ7E+2ZHn3UmQrYV
         QxgZKF1XJcn1kKkq/0VyqM0emD09PKwevxp9ZZscZhwIYrKbkusXAlInnvpwSIP46t
         /e/EhCperz6DQ==
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
Subject: [PATCH 11/16] rcu/nocb: Allow de-offloading rdp leader
Date:   Thu, 28 Jan 2021 18:12:17 +0100
Message-Id: <20210128171222.131380-12-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The only thing that prevented an rdp leader from being de-offloaded was
the nocb_bypass_timer that used to lock the nocb_lock of the rdp leader.

If an rdp gets de-offloaded, it will subtely ignore rcu_nocb_lock()
calls and do its job in the timer unsafely. Worse yet: if it gets
re-offloaded in the middle of the timer, rcu_nocb_unlock() would try to
unlock, leaving it imbalanced.

Now that the nocb_bypass_timer doesn't use the nocb_lock anymore, we can
safely allow rdp leader to be de-offloaded.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/rcu/tree_plugin.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 28ace1ae83d6..dae892ac570a 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2481,10 +2481,6 @@ int rcu_nocb_cpu_deoffload(int cpu)
 	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
 	int ret = 0;
 
-	if (rdp == rdp->nocb_gp_rdp) {
-		pr_info("Can't deoffload an rdp GP leader (yet)\n");
-		return -EINVAL;
-	}
 	mutex_lock(&rcu_state.barrier_mutex);
 	cpus_read_lock();
 	if (rcu_rdp_is_offloaded(rdp)) {
-- 
2.25.1

