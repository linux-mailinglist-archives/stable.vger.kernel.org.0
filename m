Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECD512205D
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfLQAyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:54:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35528 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727181AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003Mq-Dd; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0005dL-QD; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Joe Burmeister" <joe.burmeister@devtank.co.uk>,
        "Kurt Van Dijck" <dev.kurt@vandijck-laurijssen.be>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Wolfgang Grandegger" <wg@grandegger.com>
Date:   Tue, 17 Dec 2019 00:47:33 +0000
Message-ID: <lsq.1576543535.753539566@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 119/136] can: c_can: c_can_poll(): only read status
 register after status IRQ
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>

commit 3cb3eaac52c0f145d895f4b6c22834d5f02b8569 upstream.

When the status register is read without the status IRQ pending, the
chip may not raise the interrupt line for an upcoming status interrupt
and the driver may miss a status interrupt.

It is critical that the BUSOFF status interrupt is forwarded to the
higher layers, since no more interrupts will follow without
intervention.

Thanks to Wolfgang and Joe for bringing up the first idea.

Signed-off-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Joe Burmeister <joe.burmeister@devtank.co.uk>
Fixes: fa39b54ccf28 ("can: c_can: Get rid of pointless interrupts")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/c_can/c_can.c | 25 ++++++++++++++++++++-----
 drivers/net/can/c_can/c_can.h |  1 +
 2 files changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -96,6 +96,9 @@
 #define BTR_TSEG2_SHIFT		12
 #define BTR_TSEG2_MASK		(0x7 << BTR_TSEG2_SHIFT)
 
+/* interrupt register */
+#define INT_STS_PENDING		0x8000
+
 /* brp extension register */
 #define BRP_EXT_BRPE_MASK	0x0f
 #define BRP_EXT_BRPE_SHIFT	0
@@ -1021,10 +1024,16 @@ static int c_can_poll(struct napi_struct
 	u16 curr, last = priv->last_status;
 	int work_done = 0;
 
-	priv->last_status = curr = priv->read_reg(priv, C_CAN_STS_REG);
-	/* Ack status on C_CAN. D_CAN is self clearing */
-	if (priv->type != BOSCH_D_CAN)
-		priv->write_reg(priv, C_CAN_STS_REG, LEC_UNUSED);
+	/* Only read the status register if a status interrupt was pending */
+	if (atomic_xchg(&priv->sie_pending, 0)) {
+		priv->last_status = curr = priv->read_reg(priv, C_CAN_STS_REG);
+		/* Ack status on C_CAN. D_CAN is self clearing */
+		if (priv->type != BOSCH_D_CAN)
+			priv->write_reg(priv, C_CAN_STS_REG, LEC_UNUSED);
+	} else {
+		/* no change detected ... */
+		curr = last;
+	}
 
 	/* handle state changes */
 	if ((curr & STATUS_EWARN) && (!(last & STATUS_EWARN))) {
@@ -1075,10 +1084,16 @@ static irqreturn_t c_can_isr(int irq, vo
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct c_can_priv *priv = netdev_priv(dev);
+	int reg_int;
 
-	if (!priv->read_reg(priv, C_CAN_INT_REG))
+	reg_int = priv->read_reg(priv, C_CAN_INT_REG);
+	if (!reg_int)
 		return IRQ_NONE;
 
+	/* save for later use */
+	if (reg_int & INT_STS_PENDING)
+		atomic_set(&priv->sie_pending, 1);
+
 	/* disable all interrupts and schedule the NAPI */
 	c_can_irq_control(priv, false);
 	napi_schedule(&priv->napi);
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -176,6 +176,7 @@ struct c_can_priv {
 	struct net_device *dev;
 	struct device *device;
 	atomic_t tx_active;
+	atomic_t sie_pending;
 	unsigned long tx_dir;
 	int last_status;
 	u16 (*read_reg) (const struct c_can_priv *priv, enum reg index);

