Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24166641950
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 22:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiLCVz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 16:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiLCVzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 16:55:52 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE72819C07;
        Sat,  3 Dec 2022 13:55:50 -0800 (PST)
Received: from localhost.localdomain (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 0934240D4004;
        Sat,  3 Dec 2022 21:55:47 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 0934240D4004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1670104547;
        bh=fVJBaF1dCpZRburXtIqCzkusY3iGw92NB1GHXkxGjBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WeD3MZ5qnAp+7hPSGCamxpYLmNBVa0lYUKsre0TkjsyfQnjbcsEkoCODogo90iOt1
         mVznm5LO0IhLQs+Qb/cpm5g5Bxl28xxXHQCPvDN4Lma7UcS1/KOvbq8ruxB1BXkCVV
         uQVBf8E62rAh1GDNqoyrTgujpm8PvUWKg1gZQiCA=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, linux-kernel@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>,
        jirislaby@kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, Pavel Machek <pavel@denx.de>
Subject: [PATCH v2 5.10] Revert "tty: n_gsm: avoid call of sleeping functions from atomic context"
Date:   Sun,  4 Dec 2022 00:55:18 +0300
Message-Id: <20221203215518.8150-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <Y4tRUPNnbgGm0/Ts@kroah.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit acdab4cb4ba7e5f94d2b422ebd7bf4bf68178fb2 ]

This reverts commit eb75efdec8dd0f01ac85c88feafa6e63b34a2521.

The above commit is reverted as the usage of tx_mutex seems not to solve
the problem described in eb75efdec8dd ("tty: n_gsm: avoid call of sleeping
functions from atomic context") and just moves the bug to another place.

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20221008110221.13645-2-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Pavel Machek <pavel@denx.de>
---
v1->v2: added signed-off-by and reviewed-by

 drivers/tty/n_gsm.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c91a3004931f..c2212f52a603 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -235,7 +235,7 @@ struct gsm_mux {
 	int old_c_iflag;		/* termios c_iflag value before attach */
 	bool constipated;		/* Asked by remote to shut up */
 
-	struct mutex tx_mutex;
+	spinlock_t tx_lock;
 	unsigned int tx_bytes;		/* TX data outstanding */
 #define TX_THRESH_HI		8192
 #define TX_THRESH_LO		2048
@@ -820,14 +820,15 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
  *
  *	Add data to the transmit queue and try and get stuff moving
  *	out of the mux tty if not already doing so. Take the
- *	the gsm tx mutex and dlci lock.
+ *	the gsm tx lock and dlci lock.
  */
 
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
@@ -839,7 +840,7 @@ static void gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
  *	is data. Keep to the MRU of the mux. This path handles the usual tty
  *	interface which is a byte stream with optional modem data.
  *
- *	Caller must hold the tx_mutex of the mux.
+ *	Caller must hold the tx_lock of the mux.
  */
 
 static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
@@ -902,7 +903,7 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
  *	is data. Keep to the MRU of the mux. This path handles framed data
  *	queued as skbuffs to the DLCI.
  *
- *	Caller must hold the tx_mutex of the mux.
+ *	Caller must hold the tx_lock of the mux.
  */
 
 static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
@@ -918,7 +919,7 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 	if (dlci->adaption == 4)
 		overhead = 1;
 
-	/* dlci->skb is locked by tx_mutex */
+	/* dlci->skb is locked by tx_lock */
 	if (dlci->skb == NULL) {
 		dlci->skb = skb_dequeue_tail(&dlci->skb_list);
 		if (dlci->skb == NULL)
@@ -1018,12 +1019,13 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 
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
@@ -1034,7 +1036,7 @@ static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
 	}
 	if (sweep)
 		gsm_dlci_data_sweep(dlci->gsm);
-	mutex_unlock(&dlci->gsm->tx_mutex);
+	spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
 }
 
 /*
@@ -1256,6 +1258,7 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 						const u8 *data, int clen)
 {
 	u8 buf[1];
+	unsigned long flags;
 
 	switch (command) {
 	case CMD_CLD: {
@@ -1277,9 +1280,9 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 		gsm->constipated = false;
 		gsm_control_reply(gsm, CMD_FCON, NULL, 0);
 		/* Kick the link in case it is idling */
-		mutex_lock(&gsm->tx_mutex);
+		spin_lock_irqsave(&gsm->tx_lock, flags);
 		gsm_data_kick(gsm, NULL);
-		mutex_unlock(&gsm->tx_mutex);
+		spin_unlock_irqrestore(&gsm->tx_lock, flags);
 		break;
 	case CMD_FCOFF:
 		/* Modem wants us to STFU */
@@ -2225,7 +2228,6 @@ static void gsm_free_mux(struct gsm_mux *gsm)
 			break;
 		}
 	}
-	mutex_destroy(&gsm->tx_mutex);
 	mutex_destroy(&gsm->mutex);
 	kfree(gsm->txframe);
 	kfree(gsm->buf);
@@ -2297,12 +2299,12 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	}
 	spin_lock_init(&gsm->lock);
 	mutex_init(&gsm->mutex);
-	mutex_init(&gsm->tx_mutex);
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_list);
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	init_waitqueue_head(&gsm->event);
 	spin_lock_init(&gsm->control_lock);
+	spin_lock_init(&gsm->tx_lock);
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;
@@ -2327,7 +2329,6 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	}
 	spin_unlock(&gsm_mux_lock);
 	if (i == MAX_MUX) {
-		mutex_destroy(&gsm->tx_mutex);
 		mutex_destroy(&gsm->mutex);
 		kfree(gsm->txframe);
 		kfree(gsm->buf);
@@ -2652,15 +2653,16 @@ static int gsmld_open(struct tty_struct *tty)
 static void gsmld_write_wakeup(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm = tty->disc_data;
+	unsigned long flags;
 
 	/* Queue poll */
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-	mutex_lock(&gsm->tx_mutex);
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	gsm_data_kick(gsm, NULL);
 	if (gsm->tx_bytes < TX_THRESH_LO) {
 		gsm_dlci_data_sweep(gsm);
 	}
-	mutex_unlock(&gsm->tx_mutex);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 }
 
 /**
@@ -2703,6 +2705,7 @@ static ssize_t gsmld_write(struct tty_struct *tty, struct file *file,
 			   const unsigned char *buf, size_t nr)
 {
 	struct gsm_mux *gsm = tty->disc_data;
+	unsigned long flags;
 	int space;
 	int ret;
 
@@ -2710,13 +2713,13 @@ static ssize_t gsmld_write(struct tty_struct *tty, struct file *file,
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
-- 
2.38.1

