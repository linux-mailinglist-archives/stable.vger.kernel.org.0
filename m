Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD194156A5A
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBINCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:02:30 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58323 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:02:30 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0F06621B2C;
        Sun,  9 Feb 2020 08:02:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:02:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HihXDd
        H3KCGqJ7/dsJpZkXckx4P5a+qjzV+D5c8rhWE=; b=cfDrpunkxbSAU4A2X5AgOw
        z0Vn9gww4vzfkHU6qeZFv36da3PgyLN8JQBBc7Z7Pl/asaLFF+CNrJ0rkqWG0De8
        /ZLp3gvnkY0q2kRqcPAu6bICaCpqc6jteQY8vj17B440HGYzMNcBCGNUrjKrmvQd
        snuMluQ7r5TY19SA+PM5tAfZYPj9Yddkhb1OmmuspQ2H+yg8v3JOs1Zhl1SiwJNF
        BZT90EfPKZHFUsb1HWKjrY0RBntstCe8BjiH2JJyEiU8OtLlbc9egJZjV8xJbfRE
        Nb2NXcXhoWk3WBg9y+XFIEHQ6ZL9C/JTMnQ1PktzMt1QD2/avWO/jmWfcCl1VrVA
        ==
X-ME-Sender: <xms:5AJAXjH-1qMw10GiplsNFizeUC9i2CPE2TokYeIwo4Xir2uuPGRpjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepuddvne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:5AJAXkk2O1-bfdi1uzyvIzWQLQs_dIUfx_kqK9Btj-yjZNH8fI1uRw>
    <xmx:5AJAXgKg8tkMVMqMgMalFK9-e7DE6S13M5CUdFm3rkFh7nXI6_ICSA>
    <xmx:5AJAXlb25hQl60Hwvob340uFA2c9nTcEbzmYyQajdexX-iVR9hJUWQ>
    <xmx:5QJAXv0Pmq9DCCrQAuUxgELFzcz8OdWtPX7tC3Qx6x0bmbxY36KIpw>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB88A30600DC;
        Sun,  9 Feb 2020 08:02:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] platform/mellanox: fix potential deadlock in the tmfifo" failed to apply to 5.5-stable tree
To:     lsun@mellanox.com, andriy.shevchenko@linux.intel.com,
        dwoods@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:39:11 +0100
Message-ID: <1581248351144103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
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
 

