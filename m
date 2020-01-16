Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B675F13FFC2
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733184AbgAPXpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387468AbgAPXXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B21222072E;
        Thu, 16 Jan 2020 23:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216991;
        bh=fXOCE1yOtwONWUSYdxePJX4u1v0PlpSLXi6wqCESEoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKMoZbfl6WLfTPaXfX2Qlzl+E9Akp+KJmEcUhUucXep4hh3ESM27EqdcF15jWrWQt
         h9g017rhC5faG/7hqimxe91HhZt4I1KvjwGY6cZXL+EpEiFDcMQj3Q5atP7yVTXsKa
         Ote0uErcq5QXYzZ68NMih97xOcZrCYGUpH3PVA74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woods <dwoods@mellanox.com>,
        Liming Sun <lsun@mellanox.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 087/203] platform/mellanox: fix potential deadlock in the tmfifo driver
Date:   Fri, 17 Jan 2020 00:16:44 +0100
Message-Id: <20200116231753.227083036@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liming Sun <lsun@mellanox.com>

commit 638bc4ca3d28c25986cce4cbad69d9b8abf1e434 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/mellanox/mlxbf-tmfifo.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

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
 
@@ -525,7 +525,7 @@ static void mlxbf_tmfifo_console_tx(stru
 	writeq(*(u64 *)&hdr, fifo->tx_base + MLXBF_TMFIFO_TX_DATA);
 
 	/* Use spin-lock to protect the 'cons->tx_buf'. */
-	spin_lock_irqsave(&fifo->spin_lock, flags);
+	spin_lock_irqsave(&fifo->spin_lock[0], flags);
 
 	while (size > 0) {
 		addr = cons->tx_buf.buf + cons->tx_buf.tail;
@@ -552,7 +552,7 @@ static void mlxbf_tmfifo_console_tx(stru
 		}
 	}
 
-	spin_unlock_irqrestore(&fifo->spin_lock, flags);
+	spin_unlock_irqrestore(&fifo->spin_lock[0], flags);
 }
 
 /* Rx/Tx one word in the descriptor buffer. */
@@ -731,9 +731,9 @@ static bool mlxbf_tmfifo_rxtx_one_desc(s
 		fifo->vring[is_rx] = NULL;
 
 		/* Notify upper layer that packet is done. */
-		spin_lock_irqsave(&fifo->spin_lock, flags);
+		spin_lock_irqsave(&fifo->spin_lock[is_rx], flags);
 		vring_interrupt(0, vring->vq);
-		spin_unlock_irqrestore(&fifo->spin_lock, flags);
+		spin_unlock_irqrestore(&fifo->spin_lock[is_rx], flags);
 	}
 
 mlxbf_tmfifo_desc_done:
@@ -852,10 +852,10 @@ static bool mlxbf_tmfifo_virtio_notify(s
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
@@ -1189,7 +1189,8 @@ static int mlxbf_tmfifo_probe(struct pla
 	if (!fifo)
 		return -ENOMEM;
 
-	spin_lock_init(&fifo->spin_lock);
+	spin_lock_init(&fifo->spin_lock[0]);
+	spin_lock_init(&fifo->spin_lock[1]);
 	INIT_WORK(&fifo->work, mlxbf_tmfifo_work_handler);
 	mutex_init(&fifo->lock);
 


