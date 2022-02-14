Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE04B48C3
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiBNJ6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:58:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344159AbiBNJ5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:57:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8105F60DA7;
        Mon, 14 Feb 2022 01:45:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DD14B80DC6;
        Mon, 14 Feb 2022 09:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F2EC340E9;
        Mon, 14 Feb 2022 09:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831949;
        bh=M6IFrLskbsvGTic0lO/SuMgtOr0QHBC9KNhy30mcHwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fikllPiYV71qZ9LTbRDlhFnZRZxJ7hBLh375O+Z+WTg0AZOgvTUh2YVFlhoUgqbh5
         6xNUwMJAaZgBehCSPGiKSf7ubzx/Ac464Kd0yJFJqxqV0YBMV1I39qRLNopBGsIaik
         3A0SR3sshlGxTsXFac7VbS/sBRH6yaBi4DwY8UvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 008/172] can: isotp: fix potential CAN frame reception race in isotp_rcv()
Date:   Mon, 14 Feb 2022 10:24:26 +0100
Message-Id: <20220214092506.643560070@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 7c759040c1dd03954f650f147ae7175476d51314 upstream.

When receiving a CAN frame the current code logic does not consider
concurrently receiving processes which do not show up in real world
usage.

Ziyang Xuan writes:

The following syz problem is one of the scenarios. so->rx.len is
changed by isotp_rcv_ff() during isotp_rcv_cf(), so->rx.len equals
0 before alloc_skb() and equals 4096 after alloc_skb(). That will
trigger skb_over_panic() in skb_put().

=======================================================
CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc8-syzkaller #0
RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:113
Call Trace:
 <TASK>
 skb_over_panic net/core/skbuff.c:118 [inline]
 skb_put.cold+0x24/0x24 net/core/skbuff.c:1990
 isotp_rcv_cf net/can/isotp.c:570 [inline]
 isotp_rcv+0xa38/0x1e30 net/can/isotp.c:668
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x445/0x8d0 net/can/af_can.c:635
 can_receive+0x31d/0x580 net/can/af_can.c:665
 can_rcv+0x120/0x1c0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5465
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5579

Therefore we make sure the state changes and data structures stay
consistent at CAN frame reception time by adding a spin_lock in
isotp_rcv(). This fixes the issue reported by syzkaller but does not
affect real world operation.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/linux-can/d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com/T/
Link: https://lore.kernel.org/all/20220208200026.13783-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Reported-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -56,6 +56,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/hrtimer.h>
 #include <linux/wait.h>
 #include <linux/uio.h>
@@ -145,6 +146,7 @@ struct isotp_sock {
 	struct tpcon rx, tx;
 	struct list_head notifier;
 	wait_queue_head_t wait;
+	spinlock_t rx_lock; /* protect single thread state machine */
 };
 
 static LIST_HEAD(isotp_notifier_list);
@@ -615,11 +617,17 @@ static void isotp_rcv(struct sk_buff *sk
 
 	n_pci_type = cf->data[ae] & 0xF0;
 
+	/* Make sure the state changes and data structures stay consistent at
+	 * CAN frame reception time. This locking is not needed in real world
+	 * use cases but the inconsistency can be triggered with syzkaller.
+	 */
+	spin_lock(&so->rx_lock);
+
 	if (so->opt.flags & CAN_ISOTP_HALF_DUPLEX) {
 		/* check rx/tx path half duplex expectations */
 		if ((so->tx.state != ISOTP_IDLE && n_pci_type != N_PCI_FC) ||
 		    (so->rx.state != ISOTP_IDLE && n_pci_type == N_PCI_FC))
-			return;
+			goto out_unlock;
 	}
 
 	switch (n_pci_type) {
@@ -668,6 +676,9 @@ static void isotp_rcv(struct sk_buff *sk
 		isotp_rcv_cf(sk, cf, ae, skb);
 		break;
 	}
+
+out_unlock:
+	spin_unlock(&so->rx_lock);
 }
 
 static void isotp_fill_dataframe(struct canfd_frame *cf, struct isotp_sock *so,
@@ -1444,6 +1455,7 @@ static int isotp_init(struct sock *sk)
 	so->txtimer.function = isotp_tx_timer_handler;
 
 	init_waitqueue_head(&so->wait);
+	spin_lock_init(&so->rx_lock);
 
 	spin_lock(&isotp_notifier_lock);
 	list_add_tail(&so->notifier, &isotp_notifier_list);


