Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2EE49EA11
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245236AbiA0SMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245262AbiA0SLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:11:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D764C061760;
        Thu, 27 Jan 2022 10:11:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BBE7B818E1;
        Thu, 27 Jan 2022 18:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BDAC340E8;
        Thu, 27 Jan 2022 18:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307074;
        bh=AekgndfSdlG0v8aUKwB735dCuNWY291e4/xpxww/N4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJDjiqVvRrR6ELnemEZJyJmIQhp58nWQZilRd0YxHRlqMxCvmJfu9TWAFmrZJqLFc
         +zH1mkzNTJy4AVymU0Qm8YJ05anOcgAjERXakb4d5kdiw2rBQCU9OW3KM5hErpI2x4
         IkwgDzRH5uviJLVtdbs2dcZ9d6n6S1pqRarlPO2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Morin <guillaume@morinfr.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.15 09/12] rcu: Tighten rcu_advance_cbs_nowake() checks
Date:   Thu, 27 Jan 2022 19:09:33 +0100
Message-Id: <20220127180259.390018852@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
References: <20220127180259.078563735@linuxfoundation.org>
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
@@ -1594,10 +1594,11 @@ static void __maybe_unused rcu_advance_c
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
 


