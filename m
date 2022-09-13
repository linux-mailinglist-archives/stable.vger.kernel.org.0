Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E895B744F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbiIMPW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbiIMPVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:21:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B947B790;
        Tue, 13 Sep 2022 07:36:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EC1CB80FA7;
        Tue, 13 Sep 2022 14:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CCEC433C1;
        Tue, 13 Sep 2022 14:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078958;
        bh=va+HJBuGRZoCNsdPQ+63pbbXeFX0jMLuA3EAH7Q+Nc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2eDAXf9TTXKNv2zIPFHBkXqa8mGYLtVXq/9pYxXi98DFxrg1tjPekJLaEC90vmyp
         unke63qk07gmLI7m0stMtBlxGymiO8UKYYAI1U9Qh2pHL0BhK56L8MAS2ulPG5GauE
         zrIk1lu2pZVwztSCDUlWb/WCHWVHi5U0ZFLXF2Z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 5.10 04/79] tty: n_gsm: avoid call of sleeping functions from atomic context
Date:   Tue, 13 Sep 2022 16:04:09 +0200
Message-Id: <20220913140350.501815100@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 902e02ea9385373ce4b142576eef41c642703955 upstream.

Syzkaller reports the following problem:

BUG: sleeping function called from invalid context at kernel/printk/printk.c:2347
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1105, name: syz-executor423
3 locks held by syz-executor423/1105:
 #0: ffff8881468b9098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x90 drivers/tty/tty_ldisc.c:266
 #1: ffff8881468b9130 (&tty->atomic_write_lock){+.+.}-{3:3}, at: tty_write_lock drivers/tty/tty_io.c:952 [inline]
 #1: ffff8881468b9130 (&tty->atomic_write_lock){+.+.}-{3:3}, at: do_tty_write drivers/tty/tty_io.c:975 [inline]
 #1: ffff8881468b9130 (&tty->atomic_write_lock){+.+.}-{3:3}, at: file_tty_write.constprop.0+0x2a8/0x8e0 drivers/tty/tty_io.c:1118
 #2: ffff88801b06c398 (&gsm->tx_lock){....}-{2:2}, at: gsmld_write+0x5e/0x150 drivers/tty/n_gsm.c:2717
irq event stamp: 3482
hardirqs last  enabled at (3481): [<ffffffff81d13343>] __get_reqs_available+0x143/0x2f0 fs/aio.c:946
hardirqs last disabled at (3482): [<ffffffff87d39722>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (3482): [<ffffffff87d39722>] _raw_spin_lock_irqsave+0x52/0x60 kernel/locking/spinlock.c:159
softirqs last  enabled at (3408): [<ffffffff87e01002>] asm_call_irq_on_stack+0x12/0x20
softirqs last disabled at (3401): [<ffffffff87e01002>] asm_call_irq_on_stack+0x12/0x20
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 2 PID: 1105 Comm: syz-executor423 Not tainted 5.10.137-syzkaller #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x167 lib/dump_stack.c:118
 ___might_sleep.cold+0x1e8/0x22e kernel/sched/core.c:7304
 console_lock+0x19/0x80 kernel/printk/printk.c:2347
 do_con_write+0x113/0x1de0 drivers/tty/vt/vt.c:2909
 con_write+0x22/0xc0 drivers/tty/vt/vt.c:3296
 gsmld_write+0xd0/0x150 drivers/tty/n_gsm.c:2720
 do_tty_write drivers/tty/tty_io.c:1028 [inline]
 file_tty_write.constprop.0+0x502/0x8e0 drivers/tty/tty_io.c:1118
 call_write_iter include/linux/fs.h:1903 [inline]
 aio_write+0x355/0x7b0 fs/aio.c:1580
 __io_submit_one fs/aio.c:1952 [inline]
 io_submit_one+0xf45/0x1a90 fs/aio.c:1999
 __do_sys_io_submit fs/aio.c:2058 [inline]
 __se_sys_io_submit fs/aio.c:2028 [inline]
 __x64_sys_io_submit+0x18c/0x2f0 fs/aio.c:2028
 do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x61/0xc6

The problem happens in the following control flow:

gsmld_write(...)
spin_lock_irqsave(&gsm->tx_lock, flags) // taken a spinlock on TX data
 con_write(...)
  do_con_write(...)
   console_lock()
    might_sleep() // -> bug

As far as console_lock() might sleep it should not be called with
spinlock held.

The patch replaces tx_lock spinlock with mutex in order to avoid the
problem.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 32dd59f ("tty: n_gsm: fix race condition in gsmld_write()")
Cc: stable <stable@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Link: https://lore.kernel.org/r/20220829131640.69254-3-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -235,7 +235,7 @@ struct gsm_mux {
 	int old_c_iflag;		/* termios c_iflag value before attach */
 	bool constipated;		/* Asked by remote to shut up */
 
-	spinlock_t tx_lock;
+	struct mutex tx_mutex;
 	unsigned int tx_bytes;		/* TX data outstanding */
 #define TX_THRESH_HI		8192
 #define TX_THRESH_LO		2048
@@ -820,15 +820,14 @@ static void __gsm_data_queue(struct gsm_
  *
  *	Add data to the transmit queue and try and get stuff moving
  *	out of the mux tty if not already doing so. Take the
- *	the gsm tx lock and dlci lock.
+ *	the gsm tx mutex and dlci lock.
  */
 
 static void gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 {
-	unsigned long flags;
-	spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
+	mutex_lock(&dlci->gsm->tx_mutex);
 	__gsm_data_queue(dlci, msg);
-	spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
+	mutex_unlock(&dlci->gsm->tx_mutex);
 }
 
 /**
@@ -840,7 +839,7 @@ static void gsm_data_queue(struct gsm_dl
  *	is data. Keep to the MRU of the mux. This path handles the usual tty
  *	interface which is a byte stream with optional modem data.
  *
- *	Caller must hold the tx_lock of the mux.
+ *	Caller must hold the tx_mutex of the mux.
  */
 
 static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
@@ -903,7 +902,7 @@ static int gsm_dlci_data_output(struct g
  *	is data. Keep to the MRU of the mux. This path handles framed data
  *	queued as skbuffs to the DLCI.
  *
- *	Caller must hold the tx_lock of the mux.
+ *	Caller must hold the tx_mutex of the mux.
  */
 
 static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
@@ -919,7 +918,7 @@ static int gsm_dlci_data_output_framed(s
 	if (dlci->adaption == 4)
 		overhead = 1;
 
-	/* dlci->skb is locked by tx_lock */
+	/* dlci->skb is locked by tx_mutex */
 	if (dlci->skb == NULL) {
 		dlci->skb = skb_dequeue_tail(&dlci->skb_list);
 		if (dlci->skb == NULL)
@@ -1019,13 +1018,12 @@ static void gsm_dlci_data_sweep(struct g
 
 static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
 {
-	unsigned long flags;
 	int sweep;
 
 	if (dlci->constipated)
 		return;
 
-	spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
+	mutex_lock(&dlci->gsm->tx_mutex);
 	/* If we have nothing running then we need to fire up */
 	sweep = (dlci->gsm->tx_bytes < TX_THRESH_LO);
 	if (dlci->gsm->tx_bytes == 0) {
@@ -1036,7 +1034,7 @@ static void gsm_dlci_data_kick(struct gs
 	}
 	if (sweep)
 		gsm_dlci_data_sweep(dlci->gsm);
-	spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
+	mutex_unlock(&dlci->gsm->tx_mutex);
 }
 
 /*
@@ -1258,7 +1256,6 @@ static void gsm_control_message(struct g
 						const u8 *data, int clen)
 {
 	u8 buf[1];
-	unsigned long flags;
 
 	switch (command) {
 	case CMD_CLD: {
@@ -1280,9 +1277,9 @@ static void gsm_control_message(struct g
 		gsm->constipated = false;
 		gsm_control_reply(gsm, CMD_FCON, NULL, 0);
 		/* Kick the link in case it is idling */
-		spin_lock_irqsave(&gsm->tx_lock, flags);
+		mutex_lock(&gsm->tx_mutex);
 		gsm_data_kick(gsm, NULL);
-		spin_unlock_irqrestore(&gsm->tx_lock, flags);
+		mutex_unlock(&gsm->tx_mutex);
 		break;
 	case CMD_FCOFF:
 		/* Modem wants us to STFU */
@@ -2228,6 +2225,7 @@ static void gsm_free_mux(struct gsm_mux
 			break;
 		}
 	}
+	mutex_destroy(&gsm->tx_mutex);
 	mutex_destroy(&gsm->mutex);
 	kfree(gsm->txframe);
 	kfree(gsm->buf);
@@ -2299,12 +2297,12 @@ static struct gsm_mux *gsm_alloc_mux(voi
 	}
 	spin_lock_init(&gsm->lock);
 	mutex_init(&gsm->mutex);
+	mutex_init(&gsm->tx_mutex);
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_list);
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	init_waitqueue_head(&gsm->event);
 	spin_lock_init(&gsm->control_lock);
-	spin_lock_init(&gsm->tx_lock);
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;
@@ -2329,6 +2327,7 @@ static struct gsm_mux *gsm_alloc_mux(voi
 	}
 	spin_unlock(&gsm_mux_lock);
 	if (i == MAX_MUX) {
+		mutex_destroy(&gsm->tx_mutex);
 		mutex_destroy(&gsm->mutex);
 		kfree(gsm->txframe);
 		kfree(gsm->buf);
@@ -2653,16 +2652,15 @@ static int gsmld_open(struct tty_struct
 static void gsmld_write_wakeup(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm = tty->disc_data;
-	unsigned long flags;
 
 	/* Queue poll */
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-	spin_lock_irqsave(&gsm->tx_lock, flags);
+	mutex_lock(&gsm->tx_mutex);
 	gsm_data_kick(gsm, NULL);
 	if (gsm->tx_bytes < TX_THRESH_LO) {
 		gsm_dlci_data_sweep(gsm);
 	}
-	spin_unlock_irqrestore(&gsm->tx_lock, flags);
+	mutex_unlock(&gsm->tx_mutex);
 }
 
 /**
@@ -2705,7 +2703,6 @@ static ssize_t gsmld_write(struct tty_st
 			   const unsigned char *buf, size_t nr)
 {
 	struct gsm_mux *gsm = tty->disc_data;
-	unsigned long flags;
 	int space;
 	int ret;
 
@@ -2713,13 +2710,13 @@ static ssize_t gsmld_write(struct tty_st
 		return -ENODEV;
 
 	ret = -ENOBUFS;
-	spin_lock_irqsave(&gsm->tx_lock, flags);
+	mutex_lock(&gsm->tx_mutex);
 	space = tty_write_room(tty);
 	if (space >= nr)
 		ret = tty->ops->write(tty, buf, nr);
 	else
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-	spin_unlock_irqrestore(&gsm->tx_lock, flags);
+	mutex_unlock(&gsm->tx_mutex);
 
 	return ret;
 }


