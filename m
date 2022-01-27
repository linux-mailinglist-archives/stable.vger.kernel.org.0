Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9A749EA1F
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245404AbiA0SMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245420AbiA0SLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:11:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCFDC061757;
        Thu, 27 Jan 2022 10:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E0B061D32;
        Thu, 27 Jan 2022 18:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605ABC340E4;
        Thu, 27 Jan 2022 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307099;
        bh=qOC8bXU/VYWy1qLTPGBTA6QuSDRuybn742bkG6KUYn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJnDMj9hgFerUC1wQ6FZWpxDoAjI4STFh9YAddwUG666SLLSzRsVPSc1m83fwg1ZB
         BDE5gERThMjJfHqVBqpjygnlttl+8/kEEW1oHBOw/+rl3z57tmvUvPp6Az9BqyL0GM
         PswhvOpzVT1l/AqlcOqoQhNMbWx69ZhFZKomeeOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Morin <guillaume@morinfr.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.16 7/9] rcu: Tighten rcu_advance_cbs_nowake() checks
Date:   Thu, 27 Jan 2022 19:09:42 +0100
Message-Id: <20220127180259.126674802@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
References: <20220127180258.892788582@linuxfoundation.org>
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
@@ -1590,10 +1590,11 @@ static void __maybe_unused rcu_advance_c
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
 


