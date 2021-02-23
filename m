Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B9D3222FE
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhBWALp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:11:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhBWALl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3F2C64E57;
        Tue, 23 Feb 2021 00:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039037;
        bh=hLpo9aCjciafvBZhWV6d/wUuRD2Gf1+jtNs9nlgMp/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgu2dM49j9qyeb+5YKLl3ejcnMqJ+TCgkfS0Yr1cNXdxmMNhSAPn8TwXXRINtNlce
         xUWj3T1psJc03mTgYQhz3+yHeVTXerdicmTlooUBt4ZAPIcIhH56YRQzA2Q2nHjhnX
         cpI990ey599bmcfojIQONz94CnHdrJFdAWPu153PM7dVHWXyhjtEPcHSTQ0pLR/KMR
         mthvLRhfYgQr2epZGYchOAYleUK7rbD+E5L6+tXOap8phz5ItobdGI4cbWwcNKimwa
         ATCxmpB5f/23ZC9LIXDHT56vAPXupc3UzzMGbpcEe0QgmdaGfJkd5TO9cOwC5BpH4q
         Nz2pHZgSqDKbw==
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
Subject: [PATCH 08/13] rcu/nocb: Allow de-offloading rdp leader
Date:   Tue, 23 Feb 2021 01:10:06 +0100
Message-Id: <20210223001011.127063-9-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
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
index c80b214a86bb..0fdf0223f08f 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2500,10 +2500,6 @@ int rcu_nocb_cpu_deoffload(int cpu)
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

