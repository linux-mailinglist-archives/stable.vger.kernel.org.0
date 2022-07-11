Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F6256FA39
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiGKJPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiGKJOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:14:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5D729CBB;
        Mon, 11 Jul 2022 02:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE059B80D2C;
        Mon, 11 Jul 2022 09:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528F4C34115;
        Mon, 11 Jul 2022 09:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530624;
        bh=SuR4s/jIkmb3L9Rd7RydHeU0F19C3tQ8whTRanpApLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1kqlJTwKBg6gVqNgI0V4MUzXYfE9bBsmBpFvI5Z3PIE89lbhHOE8+kNHrv4hjRf/
         hDmTjrw/qi3GdplQZcImV8ur00d9wCRv+h2pBBHFP6ZTNxXc7Zlowz9jGEilgQ3jrj
         4jiJlsun1+iIvGYhZkk80JRQZrHMq314FrYAwMLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 03/38] can: bcm: use call_rcu() instead of costly synchronize_rcu()
Date:   Mon, 11 Jul 2022 11:06:45 +0200
Message-Id: <20220711090538.827305118@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit f1b4e32aca0811aa011c76e5d6cf2fa19224b386 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -102,6 +102,7 @@ static inline u64 get_u64(const struct c
 
 struct bcm_op {
 	struct list_head list;
+	struct rcu_head rcu;
 	int ifindex;
 	canid_t can_id;
 	u32 flags;
@@ -720,10 +721,9 @@ static struct bcm_op *bcm_find_op(struct
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
@@ -734,6 +734,14 @@ static void bcm_remove_op(struct bcm_op
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
@@ -759,6 +767,9 @@ static int bcm_delete_rx_op(struct list_
 		if ((op->can_id == mh->can_id) && (op->ifindex == ifindex) &&
 		    (op->flags & CAN_FD_FRAME) == (mh->flags & CAN_FD_FRAME)) {
 
+			/* disable automatic timer on frame reception */
+			op->flags |= RX_NO_AUTOTIMER;
+
 			/*
 			 * Don't care if we're bound or not (due to netdev
 			 * problems) can_rx_unregister() is always a save
@@ -787,7 +798,6 @@ static int bcm_delete_rx_op(struct list_
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
-			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}


