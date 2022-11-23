Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20624635D37
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbiKWMmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbiKWMlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:41:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3BF6B389;
        Wed, 23 Nov 2022 04:41:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE26161C58;
        Wed, 23 Nov 2022 12:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53308C433C1;
        Wed, 23 Nov 2022 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207285;
        bh=tPDxb1jYP7VY9MJhkjofizKNkuClR2I2a2heNraH1Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKQDbzM26wA1OsU+8CA8BxhsmhDFSsUPPT9Tso8CySw8cuNFxA/m/2zBxbYFXizz6
         wQfMtY6tkleo9LD9pn9TowHadVvnrzHujr2ACtCWs/t4dMeF0Dhwe8mmxZn51O/0XG
         30+ajQN5mLyPFYOG+QQ0XjwK31QT1+qIRSUB5Q/RXh6v79HgODZ2eJx9d478jLpsiz
         E8pAJ6AuBnKurQsdcrOeE1CNyY+u6qSSnCN+j85TxTZ/s5FYsyRKSWnxLK4hm1C0yP
         rVHYd26WCOdoTNYe13r9WL7i6+3c2r2lOVCbE0aj4QW9s7na3HIbSigjh3n0onIEih
         1PPGZ7Q8eTH9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Daniel Starke <daniel.starke@siemens.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org
Subject: [PATCH AUTOSEL 6.0 10/44] Revert "tty: n_gsm: avoid call of sleeping functions from atomic context"
Date:   Wed, 23 Nov 2022 07:40:19 -0500
Message-Id: <20221123124057.264822-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit acdab4cb4ba7e5f94d2b422ebd7bf4bf68178fb2 ]

This reverts commit 902e02ea9385373ce4b142576eef41c642703955.

The above commit is reverted as the usage of tx_mutex seems not to solve
the problem described in 902e02ea9385 ("tty: n_gsm: avoid call of sleeping
functions from atomic context") and just moves the bug to another place.

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20221008110221.13645-2-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 53 +++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 01c112e2e214..e23225aff5d9 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -248,7 +248,7 @@ struct gsm_mux {
 	bool constipated;		/* Asked by remote to shut up */
 	bool has_devices;		/* Devices were registered */
 
-	struct mutex tx_mutex;
+	spinlock_t tx_lock;
 	unsigned int tx_bytes;		/* TX data outstanding */
 #define TX_THRESH_HI		8192
 #define TX_THRESH_LO		2048
@@ -680,6 +680,7 @@ static int gsm_send(struct gsm_mux *gsm, int addr, int cr, int control)
 	struct gsm_msg *msg;
 	u8 *dp;
 	int ocr;
+	unsigned long flags;
 
 	msg = gsm_data_alloc(gsm, addr, 0, control);
 	if (!msg)
@@ -701,10 +702,10 @@ static int gsm_send(struct gsm_mux *gsm, int addr, int cr, int control)
 
 	gsm_print_packet("Q->", addr, cr, control, NULL, 0);
 
-	mutex_lock(&gsm->tx_mutex);
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	list_add_tail(&msg->list, &gsm->tx_ctrl_list);
 	gsm->tx_bytes += msg->len;
-	mutex_unlock(&gsm->tx_mutex);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 	gsmld_write_trigger(gsm);
 
 	return 0;
@@ -729,7 +730,7 @@ static void gsm_dlci_clear_queues(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 	spin_unlock_irqrestore(&dlci->lock, flags);
 
 	/* Clear data packets in MUX write queue */
-	mutex_lock(&gsm->tx_mutex);
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	list_for_each_entry_safe(msg, nmsg, &gsm->tx_data_list, list) {
 		if (msg->addr != addr)
 			continue;
@@ -737,7 +738,7 @@ static void gsm_dlci_clear_queues(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 		list_del(&msg->list);
 		kfree(msg);
 	}
-	mutex_unlock(&gsm->tx_mutex);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 }
 
 /**
@@ -1023,9 +1024,10 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 
 static void gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 {
-	mutex_lock(&dlci->gsm->tx_mutex);
+	unsigned long flags;
+	spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
 	__gsm_data_queue(dlci, msg);
-	mutex_unlock(&dlci->gsm->tx_mutex);
+	spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
 }
 
 /**
@@ -1037,7 +1039,7 @@ static void gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
  *	is data. Keep to the MRU of the mux. This path handles the usual tty
  *	interface which is a byte stream with optional modem data.
  *
- *	Caller must hold the tx_mutex of the mux.
+ *	Caller must hold the tx_lock of the mux.
  */
 
 static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
@@ -1097,7 +1099,7 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
  *	is data. Keep to the MRU of the mux. This path handles framed data
  *	queued as skbuffs to the DLCI.
  *
- *	Caller must hold the tx_mutex of the mux.
+ *	Caller must hold the tx_lock of the mux.
  */
 
 static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
@@ -1113,7 +1115,7 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 	if (dlci->adaption == 4)
 		overhead = 1;
 
-	/* dlci->skb is locked by tx_mutex */
+	/* dlci->skb is locked by tx_lock */
 	if (dlci->skb == NULL) {
 		dlci->skb = skb_dequeue_tail(&dlci->skb_list);
 		if (dlci->skb == NULL)
@@ -1167,7 +1169,7 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
  *	Push an empty frame in to the transmit queue to update the modem status
  *	bits and to transmit an optional break.
  *
- *	Caller must hold the tx_mutex of the mux.
+ *	Caller must hold the tx_lock of the mux.
  */
 
 static int gsm_dlci_modem_output(struct gsm_mux *gsm, struct gsm_dlci *dlci,
@@ -1281,12 +1283,13 @@ static int gsm_dlci_data_sweep(struct gsm_mux *gsm)
 
 static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
 {
+	unsigned long flags;
 	int sweep;
 
 	if (dlci->constipated)
 		return;
 
-	mutex_lock(&dlci->gsm->tx_mutex);
+	spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
 	/* If we have nothing running then we need to fire up */
 	sweep = (dlci->gsm->tx_bytes < TX_THRESH_LO);
 	if (dlci->gsm->tx_bytes == 0) {
@@ -1297,7 +1300,7 @@ static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
 	}
 	if (sweep)
 		gsm_dlci_data_sweep(dlci->gsm);
-	mutex_unlock(&dlci->gsm->tx_mutex);
+	spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
 }
 
 /*
@@ -1991,13 +1994,14 @@ static void gsm_dlci_command(struct gsm_dlci *dlci, const u8 *data, int len)
 static void gsm_kick_timeout(struct work_struct *work)
 {
 	struct gsm_mux *gsm = container_of(work, struct gsm_mux, kick_timeout.work);
+	unsigned long flags;
 	int sent = 0;
 
-	mutex_lock(&gsm->tx_mutex);
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	/* If we have nothing running then we need to fire up */
 	if (gsm->tx_bytes < TX_THRESH_LO)
 		sent = gsm_dlci_data_sweep(gsm);
-	mutex_unlock(&gsm->tx_mutex);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 
 	if (sent && debug & 4)
 		pr_info("%s TX queue stalled\n", __func__);
@@ -2527,7 +2531,6 @@ static void gsm_free_mux(struct gsm_mux *gsm)
 			break;
 		}
 	}
-	mutex_destroy(&gsm->tx_mutex);
 	mutex_destroy(&gsm->mutex);
 	kfree(gsm->txframe);
 	kfree(gsm->buf);
@@ -2599,7 +2602,6 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	}
 	spin_lock_init(&gsm->lock);
 	mutex_init(&gsm->mutex);
-	mutex_init(&gsm->tx_mutex);
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_ctrl_list);
 	INIT_LIST_HEAD(&gsm->tx_data_list);
@@ -2608,6 +2610,7 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	INIT_WORK(&gsm->tx_work, gsmld_write_task);
 	init_waitqueue_head(&gsm->event);
 	spin_lock_init(&gsm->control_lock);
+	spin_lock_init(&gsm->tx_lock);
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;
@@ -2632,7 +2635,6 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	}
 	spin_unlock(&gsm_mux_lock);
 	if (i == MAX_MUX) {
-		mutex_destroy(&gsm->tx_mutex);
 		mutex_destroy(&gsm->mutex);
 		kfree(gsm->txframe);
 		kfree(gsm->buf);
@@ -2788,16 +2790,17 @@ static void gsmld_write_trigger(struct gsm_mux *gsm)
 static void gsmld_write_task(struct work_struct *work)
 {
 	struct gsm_mux *gsm = container_of(work, struct gsm_mux, tx_work);
+	unsigned long flags;
 	int i, ret;
 
 	/* All outstanding control channel and control messages and one data
 	 * frame is sent.
 	 */
 	ret = -ENODEV;
-	mutex_lock(&gsm->tx_mutex);
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	if (gsm->tty)
 		ret = gsm_data_kick(gsm);
-	mutex_unlock(&gsm->tx_mutex);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 
 	if (ret >= 0)
 		for (i = 0; i < NUM_DLCI; i++)
@@ -3005,6 +3008,7 @@ static ssize_t gsmld_write(struct tty_struct *tty, struct file *file,
 			   const unsigned char *buf, size_t nr)
 {
 	struct gsm_mux *gsm = tty->disc_data;
+	unsigned long flags;
 	int space;
 	int ret;
 
@@ -3012,13 +3016,13 @@ static ssize_t gsmld_write(struct tty_struct *tty, struct file *file,
 		return -ENODEV;
 
 	ret = -ENOBUFS;
-	mutex_lock(&gsm->tx_mutex);
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	space = tty_write_room(tty);
 	if (space >= nr)
 		ret = tty->ops->write(tty, buf, nr);
 	else
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-	mutex_unlock(&gsm->tx_mutex);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 
 	return ret;
 }
@@ -3315,13 +3319,14 @@ static struct tty_ldisc_ops tty_ldisc_packet = {
 static void gsm_modem_upd_via_data(struct gsm_dlci *dlci, u8 brk)
 {
 	struct gsm_mux *gsm = dlci->gsm;
+	unsigned long flags;
 
 	if (dlci->state != DLCI_OPEN || dlci->adaption != 2)
 		return;
 
-	mutex_lock(&gsm->tx_mutex);
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	gsm_dlci_modem_output(gsm, dlci, brk);
-	mutex_unlock(&gsm->tx_mutex);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 }
 
 /**
-- 
2.35.1

