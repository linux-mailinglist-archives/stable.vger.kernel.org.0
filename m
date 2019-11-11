Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41259F7ADD
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKKSaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726949AbfKKSaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:30:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5030B21872;
        Mon, 11 Nov 2019 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497020;
        bh=MegO0AW1S5ijek+lrnxfYqx5M+fzH8XtDZcN2iYagM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LowKHiSZD8KmweMKpsKjnMyLcUozEZLtZaRLktWqoHrHDVMYCUKBiNyMi70lN58Du
         2siHjSB68Ofr+dcWZz8yEhl/e11UV5wkyJFN3y9yroKVr78aNMpjNpklF28+GfTHLN
         36WK6JN6u9MViheNZK/1U7AS9XXtCZcqOe7gDOPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Joe Burmeister <joe.burmeister@devtank.co.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 19/43] can: c_can: c_can_poll(): only read status register after status IRQ
Date:   Mon, 11 Nov 2019 19:28:33 +0100
Message-Id: <20191111181309.592648424@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
References: <20191111181246.772983347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/c_can/c_can.c |   25 ++++++++++++++++++++-----
 drivers/net/can/c_can/c_can.h |    1 +
 2 files changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -97,6 +97,9 @@
 #define BTR_TSEG2_SHIFT		12
 #define BTR_TSEG2_MASK		(0x7 << BTR_TSEG2_SHIFT)
 
+/* interrupt register */
+#define INT_STS_PENDING		0x8000
+
 /* brp extension register */
 #define BRP_EXT_BRPE_MASK	0x0f
 #define BRP_EXT_BRPE_SHIFT	0
@@ -1029,10 +1032,16 @@ static int c_can_poll(struct napi_struct
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
@@ -1083,10 +1092,16 @@ static irqreturn_t c_can_isr(int irq, vo
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
@@ -198,6 +198,7 @@ struct c_can_priv {
 	struct net_device *dev;
 	struct device *device;
 	atomic_t tx_active;
+	atomic_t sie_pending;
 	unsigned long tx_dir;
 	int last_status;
 	u16 (*read_reg) (const struct c_can_priv *priv, enum reg index);


