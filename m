Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129D5307C01
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhA1RP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232848AbhA1RNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6064964E14;
        Thu, 28 Jan 2021 17:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853958;
        bh=bJuKV1xF4+QN+4Ko8tkNbuBX1godBNZsyaQLdvK0tw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nn5QHM8vEW72Q4Y7GqQuWvsx3wTxvD/+fLR1v0gq6zfbN6NLehQ0mf8Gqz8CeUXaD
         ecJcVn3wuX0cwuCELniYjUz11eh4vHwJEra4L76SoSIYkJCE1aXIWPMDvpJIz2udUJ
         adRUie79uErTfq0ZsDxl12Bul06g/6ioF+uSv/rTEHd0AtKGEFSdcVxKyDG639FuHV
         IIY8jRwvyvqbsqsFX5s+gvoQkLbbfWy/dUEDJ+hyL+n5x7oSj8Ef+OrBLCTBR8VBR0
         x3ODwaOOS14eUS9azml573Ib250bLN/qV92PQq6h8xv2yiG8FJVmNAEM/Q9DRt2iQk
         AqjxbqV176Wyg==
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
Subject: [PATCH 04/16] rcu/nocb: Only (re-)initialize segcblist when needed on CPU up
Date:   Thu, 28 Jan 2021 18:12:10 +0100
Message-Id: <20210128171222.131380-5-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Simply checking if the segcblist is enabled is enough to know if we
need to initialize it or not. It's safe to check within hotplug
machine.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 4c5a1ac54fa6..f74a9ba62c12 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4066,14 +4066,13 @@ int rcutree_prepare_cpu(unsigned int cpu)
 	rdp->dynticks_nesting = 1;	/* CPU not up, no tearing. */
 	rcu_dynticks_eqs_online();
 	raw_spin_unlock_rcu_node(rnp);		/* irqs remain disabled. */
+
 	/*
-	 * Lock in case the CB/GP kthreads are still around handling
-	 * old callbacks.
+	 * Only non-NOCB CPUs that didn't have early-boot callbacks need to be
+	 * (re-)initialized.
 	 */
-	rcu_nocb_lock(rdp);
-	if (rcu_segcblist_empty(&rdp->cblist)) /* No early-boot CBs? */
+	if (!rcu_segcblist_is_enabled(&rdp->cblist))
 		rcu_segcblist_init(&rdp->cblist);  /* Re-enable callbacks. */
-	rcu_nocb_unlock(rdp);
 
 	/*
 	 * Add CPU to leaf rcu_node pending-online bitmask.  Any needed
-- 
2.25.1

