Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920F5419AF3
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhI0ROm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236781AbhI0RNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEA2A6128E;
        Mon, 27 Sep 2021 17:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762543;
        bh=D6Q6xfLaYguIUbrt0SSbY308tvuw42r6C1oE/q+6Whk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdkJDYrWHIbB0sOST5uyjHDsu8D+z0kAs2CVHQ+T/Bu9CA/XTWtEShshw5pZycEDT
         MeUAsR3hy5xIFgGm9liOy3FVCxddItfZsvtG9adiVeC22yDX6ldOmEBl82P07P24Hy
         bmY6e1guik2TCDZZJNxsdFxjHC/6crHHRLePvcGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Paul Fulghum <paulkf@microgate.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/103] tty: synclink_gt: rename a conflicting function name
Date:   Mon, 27 Sep 2021 19:02:28 +0200
Message-Id: <20210927170227.702353138@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 06e49073dfba24df4b1073a068631b13a0039c34 ]

'set_signals()' in synclink_gt.c conflicts with an exported symbol
in arch/um/, so change set_signals() to set_gtsignals(). Keep
the function names similar by also changing get_signals() to
get_gtsignals().

../drivers/tty/synclink_gt.c:442:13: error: conflicting types for ‘set_signals’
 static void set_signals(struct slgt_info *info);
             ^~~~~~~~~~~
In file included from ../include/linux/irqflags.h:16:0,
                 from ../include/linux/spinlock.h:58,
                 from ../include/linux/mm_types.h:9,
                 from ../include/linux/buildid.h:5,
                 from ../include/linux/module.h:14,
                 from ../drivers/tty/synclink_gt.c:46:
../arch/um/include/asm/irqflags.h:6:5: note: previous declaration of ‘set_signals’ was here
 int set_signals(int enable);
     ^~~~~~~~~~~

Fixes: 705b6c7b34f2 ("[PATCH] new driver synclink_gt")
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20210902003806.17054-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/synclink_gt.c | 44 +++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index d728876b43c4..1a0c7beec101 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -438,8 +438,8 @@ static void reset_tbufs(struct slgt_info *info);
 static void tdma_reset(struct slgt_info *info);
 static bool tx_load(struct slgt_info *info, const char *buf, unsigned int count);
 
-static void get_signals(struct slgt_info *info);
-static void set_signals(struct slgt_info *info);
+static void get_gtsignals(struct slgt_info *info);
+static void set_gtsignals(struct slgt_info *info);
 static void set_rate(struct slgt_info *info, u32 data_rate);
 
 static void bh_transmit(struct slgt_info *info);
@@ -721,7 +721,7 @@ static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	if ((old_termios->c_cflag & CBAUD) && !C_BAUD(tty)) {
 		info->signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 		spin_lock_irqsave(&info->lock,flags);
-		set_signals(info);
+		set_gtsignals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
 
@@ -731,7 +731,7 @@ static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 		if (!C_CRTSCTS(tty) || !tty_throttled(tty))
 			info->signals |= SerialSignal_RTS;
 		spin_lock_irqsave(&info->lock,flags);
-	 	set_signals(info);
+	 	set_gtsignals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
 
@@ -1182,7 +1182,7 @@ static inline void line_info(struct seq_file *m, struct slgt_info *info)
 
 	/* output current serial signal states */
 	spin_lock_irqsave(&info->lock,flags);
-	get_signals(info);
+	get_gtsignals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 
 	stat_buf[0] = 0;
@@ -1282,7 +1282,7 @@ static void throttle(struct tty_struct * tty)
 	if (C_CRTSCTS(tty)) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->signals &= ~SerialSignal_RTS;
-		set_signals(info);
+		set_gtsignals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
 }
@@ -1307,7 +1307,7 @@ static void unthrottle(struct tty_struct * tty)
 	if (C_CRTSCTS(tty)) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->signals |= SerialSignal_RTS;
-		set_signals(info);
+		set_gtsignals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
 }
@@ -1478,7 +1478,7 @@ static int hdlcdev_open(struct net_device *dev)
 
 	/* inform generic HDLC layer of current DCD status */
 	spin_lock_irqsave(&info->lock, flags);
-	get_signals(info);
+	get_gtsignals(info);
 	spin_unlock_irqrestore(&info->lock, flags);
 	if (info->signals & SerialSignal_DCD)
 		netif_carrier_on(dev);
@@ -2232,7 +2232,7 @@ static void isr_txeom(struct slgt_info *info, unsigned short status)
 		if (info->params.mode != MGSL_MODE_ASYNC && info->drop_rts_on_tx_done) {
 			info->signals &= ~SerialSignal_RTS;
 			info->drop_rts_on_tx_done = false;
-			set_signals(info);
+			set_gtsignals(info);
 		}
 
 #if SYNCLINK_GENERIC_HDLC
@@ -2397,7 +2397,7 @@ static void shutdown(struct slgt_info *info)
 
  	if (!info->port.tty || info->port.tty->termios.c_cflag & HUPCL) {
 		info->signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
-		set_signals(info);
+		set_gtsignals(info);
 	}
 
 	flush_cond_wait(&info->gpio_wait_q);
@@ -2425,7 +2425,7 @@ static void program_hw(struct slgt_info *info)
 	else
 		async_mode(info);
 
-	set_signals(info);
+	set_gtsignals(info);
 
 	info->dcd_chkcount = 0;
 	info->cts_chkcount = 0;
@@ -2433,7 +2433,7 @@ static void program_hw(struct slgt_info *info)
 	info->dsr_chkcount = 0;
 
 	slgt_irq_on(info, IRQ_DCD | IRQ_CTS | IRQ_DSR | IRQ_RI);
-	get_signals(info);
+	get_gtsignals(info);
 
 	if (info->netcount ||
 	    (info->port.tty && info->port.tty->termios.c_cflag & CREAD))
@@ -2677,7 +2677,7 @@ static int wait_mgsl_event(struct slgt_info *info, int __user *mask_ptr)
 	spin_lock_irqsave(&info->lock,flags);
 
 	/* return immediately if state matches requested events */
-	get_signals(info);
+	get_gtsignals(info);
 	s = info->signals;
 
 	events = mask &
@@ -3095,7 +3095,7 @@ static int tiocmget(struct tty_struct *tty)
  	unsigned long flags;
 
 	spin_lock_irqsave(&info->lock,flags);
- 	get_signals(info);
+ 	get_gtsignals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 
 	result = ((info->signals & SerialSignal_RTS) ? TIOCM_RTS:0) +
@@ -3134,7 +3134,7 @@ static int tiocmset(struct tty_struct *tty,
 		info->signals &= ~SerialSignal_DTR;
 
 	spin_lock_irqsave(&info->lock,flags);
-	set_signals(info);
+	set_gtsignals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 	return 0;
 }
@@ -3145,7 +3145,7 @@ static int carrier_raised(struct tty_port *port)
 	struct slgt_info *info = container_of(port, struct slgt_info, port);
 
 	spin_lock_irqsave(&info->lock,flags);
-	get_signals(info);
+	get_gtsignals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 	return (info->signals & SerialSignal_DCD) ? 1 : 0;
 }
@@ -3160,7 +3160,7 @@ static void dtr_rts(struct tty_port *port, int on)
 		info->signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
 		info->signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
-	set_signals(info);
+	set_gtsignals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 }
 
@@ -3963,10 +3963,10 @@ static void tx_start(struct slgt_info *info)
 
 		if (info->params.mode != MGSL_MODE_ASYNC) {
 			if (info->params.flags & HDLC_FLAG_AUTO_RTS) {
-				get_signals(info);
+				get_gtsignals(info);
 				if (!(info->signals & SerialSignal_RTS)) {
 					info->signals |= SerialSignal_RTS;
-					set_signals(info);
+					set_gtsignals(info);
 					info->drop_rts_on_tx_done = true;
 				}
 			}
@@ -4020,7 +4020,7 @@ static void reset_port(struct slgt_info *info)
 	rx_stop(info);
 
 	info->signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
-	set_signals(info);
+	set_gtsignals(info);
 
 	slgt_irq_off(info, IRQ_ALL | IRQ_MASTER);
 }
@@ -4442,7 +4442,7 @@ static void tx_set_idle(struct slgt_info *info)
 /*
  * get state of V24 status (input) signals
  */
-static void get_signals(struct slgt_info *info)
+static void get_gtsignals(struct slgt_info *info)
 {
 	unsigned short status = rd_reg16(info, SSR);
 
@@ -4504,7 +4504,7 @@ static void msc_set_vcr(struct slgt_info *info)
 /*
  * set state of V24 control (output) signals
  */
-static void set_signals(struct slgt_info *info)
+static void set_gtsignals(struct slgt_info *info)
 {
 	unsigned char val = rd_reg8(info, VCR);
 	if (info->signals & SerialSignal_DTR)
-- 
2.33.0



