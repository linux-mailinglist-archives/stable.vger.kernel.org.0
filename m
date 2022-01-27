Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D87A49E9E8
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244933AbiA0SKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59200 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245045AbiA0SK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3470EB821B9;
        Thu, 27 Jan 2022 18:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8D5C340E4;
        Thu, 27 Jan 2022 18:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307025;
        bh=+4rfXOUddUEnmEEugWtPvn/EwrB7kCjCzy49CLtooMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G29KN9tUinqj7x5OSGgTtEwGWPvEZaj2xVNoeyF8xHavw/Wb51v7Y8zfDB0mBQAKl
         TRJjjCxeuyhur6KNZLi8q6QTMkkIiUUnrS4I/lKT1jf1rTCRAD3Vfp2K4DJwnDmXkI
         40w0VI+zZRb80P8ypg9PeeCToZJGQA4g2W9yvX9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Morin <guillaume@morinfr.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10 4/6] rcu: Tighten rcu_advance_cbs_nowake() checks
Date:   Thu, 27 Jan 2022 19:09:20 +0100
Message-Id: <20220127180258.275109635@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.131170405@linuxfoundation.org>
References: <20220127180258.131170405@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 614ddad17f22a22e035e2ea37a04815f50362017 upstream.

Currently, rcu_advance_cbs_nowake() checks that a grace period is in
progress, however, that grace period could end just after the check.
This commit rechecks that a grace period is still in progress while
holding the rcu_node structure's lock.  The grace period cannot end while
the current CPU's rcu_node structure's ->lock is held, thus avoiding
false positives from the WARN_ON_ONCE().

As Daniel Vacek noted, it is not necessary for the rcu_node structure
to have a CPU that has not yet passed through its quiescent state.

Tested-by: Guillaume Morin <guillaume@morinfr.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1581,10 +1581,11 @@ static void __maybe_unused rcu_advance_c
 						  struct rcu_data *rdp)
 {
 	rcu_lockdep_assert_cblist_protected(rdp);
-	if (!rcu_seq_state(rcu_seq_current(&rnp->gp_seq)) ||
-	    !raw_spin_trylock_rcu_node(rnp))
+	if (!rcu_seq_state(rcu_seq_current(&rnp->gp_seq)) || !raw_spin_trylock_rcu_node(rnp))
 		return;
-	WARN_ON_ONCE(rcu_advance_cbs(rnp, rdp));
+	// The grace period cannot end while we hold the rcu_node lock.
+	if (rcu_seq_state(rcu_seq_current(&rnp->gp_seq)))
+		WARN_ON_ONCE(rcu_advance_cbs(rnp, rdp));
 	raw_spin_unlock_rcu_node(rnp);
 }
 


