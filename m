Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C8356B7F9
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 13:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbiGHLGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 07:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237402AbiGHLGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 07:06:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B996A7696D
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 04:06:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56BA162465
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A850C341C0;
        Fri,  8 Jul 2022 11:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657278362;
        bh=jT99TOiZjmcAzPdq3mVa2cPkkVoJx8Ex3myjJjmkrf8=;
        h=Subject:To:Cc:From:Date:From;
        b=b2UyC4thDib5OvXf9yBdB8lKyHi4RQ3DZ7/HNVjNe2CMP7dK4N5MOQ0RixSdaniR6
         n613i7aa1KRooajjot8aOpZOMgeXj/CZ75UAlm2JLBZhUk0RUpUkWIfbFEtUFEC8Gf
         T7wmc2zrJkoEx55iSlP2TDB6WXaUvU4yzY/4vt4E=
Subject: FAILED: patch "[PATCH] can: bcm: use call_rcu() instead of costly synchronize_rcu()" failed to apply to 4.9-stable tree
To:     socketcan@hartkopp.net, cascardo@canonical.com,
        edumazet@google.com, mkl@pengutronix.de, nslusarek@gmx.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 08 Jul 2022 13:05:52 +0200
Message-ID: <165727835213982@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f1b4e32aca0811aa011c76e5d6cf2fa19224b386 Mon Sep 17 00:00:00 2001
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Fri, 20 May 2022 20:32:39 +0200
Subject: [PATCH] can: bcm: use call_rcu() instead of costly synchronize_rcu()

In commit d5f9023fa61e ("can: bcm: delay release of struct bcm_op
after synchronize_rcu()") Thadeu Lima de Souza Cascardo introduced two
synchronize_rcu() calls in bcm_release() (only once at socket close)
and in bcm_delete_rx_op() (called on removal of each single bcm_op).

Unfortunately this slow removal of the bcm_op's affects user space
applications like cansniffer where the modification of a filter
removes 2048 bcm_op's which blocks the cansniffer application for
40(!) seconds.

In commit 181d4447905d ("can: gw: use call_rcu() instead of costly
synchronize_rcu()") Eric Dumazet replaced the synchronize_rcu() calls
with several call_rcu()'s to safely remove the data structures after
the removal of CAN ID subscriptions with can_rx_unregister() calls.

This patch adopts Erics approach for the can-bcm which should be
applicable since the removal of tasklet_kill() in bcm_remove_op() and
the introduction of the HRTIMER_MODE_SOFT timer handling in Linux 5.4.

Fixes: d5f9023fa61e ("can: bcm: delay release of struct bcm_op after synchronize_rcu()") # >= 5.4
Link: https://lore.kernel.org/all/20220520183239.19111-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>
Cc: Norbert Slusarek <nslusarek@gmx.net>
Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 65ee1b784a30..e60161bec850 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -100,6 +100,7 @@ static inline u64 get_u64(const struct canfd_frame *cp, int offset)
 
 struct bcm_op {
 	struct list_head list;
+	struct rcu_head rcu;
 	int ifindex;
 	canid_t can_id;
 	u32 flags;
@@ -718,10 +719,9 @@ static struct bcm_op *bcm_find_op(struct list_head *ops,
 	return NULL;
 }
 
-static void bcm_remove_op(struct bcm_op *op)
+static void bcm_free_op_rcu(struct rcu_head *rcu_head)
 {
-	hrtimer_cancel(&op->timer);
-	hrtimer_cancel(&op->thrtimer);
+	struct bcm_op *op = container_of(rcu_head, struct bcm_op, rcu);
 
 	if ((op->frames) && (op->frames != &op->sframe))
 		kfree(op->frames);
@@ -732,6 +732,14 @@ static void bcm_remove_op(struct bcm_op *op)
 	kfree(op);
 }
 
+static void bcm_remove_op(struct bcm_op *op)
+{
+	hrtimer_cancel(&op->timer);
+	hrtimer_cancel(&op->thrtimer);
+
+	call_rcu(&op->rcu, bcm_free_op_rcu);
+}
+
 static void bcm_rx_unreg(struct net_device *dev, struct bcm_op *op)
 {
 	if (op->rx_reg_dev == dev) {
@@ -757,6 +765,9 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 		if ((op->can_id == mh->can_id) && (op->ifindex == ifindex) &&
 		    (op->flags & CAN_FD_FRAME) == (mh->flags & CAN_FD_FRAME)) {
 
+			/* disable automatic timer on frame reception */
+			op->flags |= RX_NO_AUTOTIMER;
+
 			/*
 			 * Don't care if we're bound or not (due to netdev
 			 * problems) can_rx_unregister() is always a save
@@ -785,7 +796,6 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
-			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}

