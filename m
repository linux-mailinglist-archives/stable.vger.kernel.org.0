Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635AD615877
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiKBCwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiKBCwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:52:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD50221E30
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FA63B8206C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358EEC433D6;
        Wed,  2 Nov 2022 02:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357537;
        bh=qTuhh6w2GuHxwC6h8CE8WHHd7HSimeGONur4tYkalF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPyVo5t9bbMr0sSE9swMiqyDvZ6Qex+hbJFLPJjrL7lzjy0fppY/xgGRdidzNqVaz
         Nq+c9ZXCrXktq1ItFS2fgsKSS1f5JGT0QRTo2RU0ce8bqctg8Gg0Or6OZrUr5QLlaF
         kC7ZHGcubZdmEODxeU7nJM0YOOt2GFL/jPmAsLf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 159/240] rcu: Keep synchronize_rcu() from enabling irqs in early boot
Date:   Wed,  2 Nov 2022 03:32:14 +0100
Message-Id: <20221102022114.977693894@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 31d8aaa87fcef1be5932f3813ea369e21bd3b11d ]

Making polled RCU grace periods account for expedited grace periods
required acquiring the leaf rcu_node structure's lock during early boot,
but after rcu_init() was called.  This lock is irq-disabled, but the
code incorrectly assumes that irqs are always disabled when invoking
synchronize_rcu().  The exception is early boot before the scheduler has
started, which means that upon return from synchronize_rcu(), irqs will
be incorrectly enabled.

This commit fixes this bug by using irqsave/irqrestore locking primitives.

Fixes: bf95b2bc3e42 ("rcu: Switch polled grace-period APIs to ->gp_seq_polled")

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index eb435941e92f..5b52727dcc1c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1402,30 +1402,32 @@ static void rcu_poll_gp_seq_end(unsigned long *snap)
 // where caller does not hold the root rcu_node structure's lock.
 static void rcu_poll_gp_seq_start_unlocked(unsigned long *snap)
 {
+	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root();
 
 	if (rcu_init_invoked()) {
 		lockdep_assert_irqs_enabled();
-		raw_spin_lock_irq_rcu_node(rnp);
+		raw_spin_lock_irqsave_rcu_node(rnp, flags);
 	}
 	rcu_poll_gp_seq_start(snap);
 	if (rcu_init_invoked())
-		raw_spin_unlock_irq_rcu_node(rnp);
+		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 }
 
 // Make the polled API aware of the end of a grace period, but where
 // caller does not hold the root rcu_node structure's lock.
 static void rcu_poll_gp_seq_end_unlocked(unsigned long *snap)
 {
+	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root();
 
 	if (rcu_init_invoked()) {
 		lockdep_assert_irqs_enabled();
-		raw_spin_lock_irq_rcu_node(rnp);
+		raw_spin_lock_irqsave_rcu_node(rnp, flags);
 	}
 	rcu_poll_gp_seq_end(snap);
 	if (rcu_init_invoked())
-		raw_spin_unlock_irq_rcu_node(rnp);
+		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 }
 
 /*
-- 
2.35.1



