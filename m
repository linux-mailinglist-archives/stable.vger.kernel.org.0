Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991DD156A59
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgBINCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:02:22 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41413 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:02:22 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 12AA821368;
        Sun,  9 Feb 2020 08:02:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:02:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0BRpxZ
        ulrD4RXV4w/9vJ+nWZacwuOMYx5Vi5OoytzWo=; b=1h+nIpZeKjs5y00+w9qk1K
        CpRpsDMk1DKyWRfuEikgw6QM9n8yt6tCq+2QUCodoK8j1GymmoygmLN7F5SR+kVz
        e603qMrBLxGF6ISoMD1WLctByrzUcykYrekOn/R3Ja6eOJEAXo6OZtRTsG4D1wSr
        RcXgGm9h4bWyRRJ6XCTiPgABHjj1XBBv7l7nkL/YtQVAGttev4T6Ux3j2KFEJq5V
        iN9iqFZ+1+Yz2MpWLq83SZPXZc3cC2ZAgy0B9aC+6KTz7qBGhmzZco8Gmhb4nxuz
        S3zQ3qXcdrElgv9Cd/ij0+37Qy3l/jyMbcoDkEaeL9s7NVJcaAcTdlv+crL2mncA
        ==
X-ME-Sender: <xms:3AJAXmDre3MGPnMsoF1H6mAKi2hpN0xEEI6Fwcd_57-AkFHKX8IXuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepuddune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3AJAXg3YB6CtzGnabvxbX1OxqenjVbUeGhP_vFH0FRmfkYLX1Nvcfw>
    <xmx:3AJAXlDMOotoev5-3rL0KNoZ5jW8HLcV8Zs59htwHK9DR6TCFnFaHA>
    <xmx:3AJAXvMHhLP7utnyA4-zQdT1Rre8zQ4vF2UaHmTyKaQphz5DVzXQew>
    <xmx:3QJAXjJmjawI8xqN9GUuTErAYUCeCJGEhV0g9pHBVy12wg1PAnPnrA>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8EFC53280064;
        Sun,  9 Feb 2020 08:02:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] platform/mellanox: fix potential deadlock in the tmfifo" failed to apply to 5.4-stable tree
To:     lsun@mellanox.com, andriy.shevchenko@linux.intel.com,
        dwoods@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:39:09 +0100
Message-ID: <1581248349222199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3454eeeebd115891f34aa2e76eccf08c9b0882bb Mon Sep 17 00:00:00 2001
From: Liming Sun <lsun@mellanox.com>
Date: Fri, 20 Dec 2019 12:04:33 -0500
Subject: [PATCH] platform/mellanox: fix potential deadlock in the tmfifo
 driver

This commit fixes the potential deadlock caused by the console Rx
and Tx processing at the same time. Rx and Tx both take the console
and tmfifo spinlock but in different order which causes potential
deadlock. The fix is to use different tmfifo spinlock for Rx and
Tx since they protect different resources and it's safe to split
the lock.

Below is the reported call trace when copying/pasting large string
in the console.

Rx:
    _raw_spin_lock_irqsave (hvc lock)
    __hvc_poll
    hvc_poll
    in_intr
    vring_interrupt
    mlxbf_tmfifo_rxtx_one_desc (tmfifo lock)
    mlxbf_tmfifo_rxtx
    mlxbf_tmfifo_work_rxtx
Tx:
    _raw_spin_lock_irqsave (tmfifo lock)
    mlxbf_tmfifo_virtio_notify
    virtqueue_notify
    virtqueue_kick
    put_chars
    hvc_push
    hvc_write (hvc lock)
    ...
    do_tty_write
    tty_write

Fixes: 1357dfd7261f ("platform/mellanox: Add TmFifo driver for Mellanox BlueField Soc")
Cc: <stable@vger.kernel.org> # 5.4+
Reviewed-by: David Woods <dwoods@mellanox.com>
Signed-off-by: Liming Sun <lsun@mellanox.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index 9a5c9fd2dbc6..5739a9669b29 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -149,7 +149,7 @@ struct mlxbf_tmfifo_irq_info {
  * @work: work struct for deferred process
  * @timer: background timer
  * @vring: Tx/Rx ring
- * @spin_lock: spin lock
+ * @spin_lock: Tx/Rx spin lock
  * @is_ready: ready flag
  */
 struct mlxbf_tmfifo {
@@ -164,7 +164,7 @@ struct mlxbf_tmfifo {
 	struct work_struct work;
 	struct timer_list timer;
 	struct mlxbf_tmfifo_vring *vring[2];
-	spinlock_t spin_lock;		/* spin lock */
+	spinlock_t spin_lock[2];	/* spin lock */
 	bool is_ready;
 };
 
@@ -525,7 +525,7 @@ static void mlxbf_tmfifo_console_tx(struct mlxbf_tmfifo *fifo, int avail)
 	writeq(*(u64 *)&hdr, fifo->tx_base + MLXBF_TMFIFO_TX_DATA);
 
 	/* Use spin-lock to protect the 'cons->tx_buf'. */
-	spin_lock_irqsave(&fifo->spin_lock, flags);
+	spin_lock_irqsave(&fifo->spin_lock[0], flags);
 
 	while (size > 0) {
 		addr = cons->tx_buf.buf + cons->tx_buf.tail;
@@ -552,7 +552,7 @@ static void mlxbf_tmfifo_console_tx(struct mlxbf_tmfifo *fifo, int avail)
 		}
 	}
 
-	spin_unlock_irqrestore(&fifo->spin_lock, flags);
+	spin_unlock_irqrestore(&fifo->spin_lock[0], flags);
 }
 
 /* Rx/Tx one word in the descriptor buffer. */
@@ -731,9 +731,9 @@ static bool mlxbf_tmfifo_rxtx_one_desc(struct mlxbf_tmfifo_vring *vring,
 		fifo->vring[is_rx] = NULL;
 
 		/* Notify upper layer that packet is done. */
-		spin_lock_irqsave(&fifo->spin_lock, flags);
+		spin_lock_irqsave(&fifo->spin_lock[is_rx], flags);
 		vring_interrupt(0, vring->vq);
-		spin_unlock_irqrestore(&fifo->spin_lock, flags);
+		spin_unlock_irqrestore(&fifo->spin_lock[is_rx], flags);
 	}
 
 mlxbf_tmfifo_desc_done:
@@ -852,10 +852,10 @@ static bool mlxbf_tmfifo_virtio_notify(struct virtqueue *vq)
 		 * worker handler.
 		 */
 		if (vring->vdev_id == VIRTIO_ID_CONSOLE) {
-			spin_lock_irqsave(&fifo->spin_lock, flags);
+			spin_lock_irqsave(&fifo->spin_lock[0], flags);
 			tm_vdev = fifo->vdev[VIRTIO_ID_CONSOLE];
 			mlxbf_tmfifo_console_output(tm_vdev, vring);
-			spin_unlock_irqrestore(&fifo->spin_lock, flags);
+			spin_unlock_irqrestore(&fifo->spin_lock[0], flags);
 		} else if (test_and_set_bit(MLXBF_TM_TX_LWM_IRQ,
 					    &fifo->pend_events)) {
 			return true;
@@ -1189,7 +1189,8 @@ static int mlxbf_tmfifo_probe(struct platform_device *pdev)
 	if (!fifo)
 		return -ENOMEM;
 
-	spin_lock_init(&fifo->spin_lock);
+	spin_lock_init(&fifo->spin_lock[0]);
+	spin_lock_init(&fifo->spin_lock[1]);
 	INIT_WORK(&fifo->work, mlxbf_tmfifo_work_handler);
 	mutex_init(&fifo->lock);
 

