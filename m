Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D39F562B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390236AbfKHTHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:07:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731795AbfKHTHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:07:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DD6521D7B;
        Fri,  8 Nov 2019 19:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240025;
        bh=2kUUZAC+wtzg7AMNOy1KGj2017jVYF+ynzXc66sbHiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1n0Copp5qLqBXq71/FyCg9CT1rW52v6S/4qBkfAT4ke4NOwXYq79h9dKJneTv70a
         k7ekhl1+CD/q8jhhIbD2AOOV8vAeFruu2dF9Z1wiNR2Zp60p6SEAbLV/Zxfsc2nKPl
         h1pzFi4PnBY/m3JIxbUbaXng1nFJOn5xj23NYM5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Joel Stanley <joel@jms.id.au>, Tao Ren <taoren@fb.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 062/140] i2c: aspeed: fix master pending state handling
Date:   Fri,  8 Nov 2019 19:49:50 +0100
Message-Id: <20191108174909.150827860@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>

[ Upstream commit 1f0d9cbeec9bb0a1c2013342836f2c9754d6502b ]

In case of master pending state, it should not trigger a master
command, otherwise data could be corrupted because this H/W shares
the same data buffer for slave and master operations. It also means
that H/W command queue handling is unreliable because of the buffer
sharing issue. To fix this issue, it clears command queue if a
master command is queued in pending state to use S/W solution
instead of H/W command queue handling. Also, it refines restarting
mechanism of the pending master command.

Fixes: 2e57b7cebb98 ("i2c: aspeed: Add multi-master use case support")
Signed-off-by: Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Acked-by: Joel Stanley <joel@jms.id.au>
Tested-by: Tao Ren <taoren@fb.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-aspeed.c | 54 +++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/i2c/busses/i2c-aspeed.c b/drivers/i2c/busses/i2c-aspeed.c
index fa66951b05d06..7b098ff5f5dd3 100644
--- a/drivers/i2c/busses/i2c-aspeed.c
+++ b/drivers/i2c/busses/i2c-aspeed.c
@@ -108,6 +108,12 @@
 #define ASPEED_I2CD_S_TX_CMD				BIT(2)
 #define ASPEED_I2CD_M_TX_CMD				BIT(1)
 #define ASPEED_I2CD_M_START_CMD				BIT(0)
+#define ASPEED_I2CD_MASTER_CMDS_MASK					       \
+		(ASPEED_I2CD_M_STOP_CMD |				       \
+		 ASPEED_I2CD_M_S_RX_CMD_LAST |				       \
+		 ASPEED_I2CD_M_RX_CMD |					       \
+		 ASPEED_I2CD_M_TX_CMD |					       \
+		 ASPEED_I2CD_M_START_CMD)
 
 /* 0x18 : I2CD Slave Device Address Register   */
 #define ASPEED_I2CD_DEV_ADDR_MASK			GENMASK(6, 0)
@@ -336,18 +342,19 @@ static void aspeed_i2c_do_start(struct aspeed_i2c_bus *bus)
 	struct i2c_msg *msg = &bus->msgs[bus->msgs_index];
 	u8 slave_addr = i2c_8bit_addr_from_msg(msg);
 
-	bus->master_state = ASPEED_I2C_MASTER_START;
-
 #if IS_ENABLED(CONFIG_I2C_SLAVE)
 	/*
 	 * If it's requested in the middle of a slave session, set the master
 	 * state to 'pending' then H/W will continue handling this master
 	 * command when the bus comes back to the idle state.
 	 */
-	if (bus->slave_state != ASPEED_I2C_SLAVE_INACTIVE)
+	if (bus->slave_state != ASPEED_I2C_SLAVE_INACTIVE) {
 		bus->master_state = ASPEED_I2C_MASTER_PENDING;
+		return;
+	}
 #endif /* CONFIG_I2C_SLAVE */
 
+	bus->master_state = ASPEED_I2C_MASTER_START;
 	bus->buf_index = 0;
 
 	if (msg->flags & I2C_M_RD) {
@@ -422,20 +429,6 @@ static u32 aspeed_i2c_master_irq(struct aspeed_i2c_bus *bus, u32 irq_status)
 		}
 	}
 
-#if IS_ENABLED(CONFIG_I2C_SLAVE)
-	/*
-	 * A pending master command will be started by H/W when the bus comes
-	 * back to idle state after completing a slave operation so change the
-	 * master state from 'pending' to 'start' at here if slave is inactive.
-	 */
-	if (bus->master_state == ASPEED_I2C_MASTER_PENDING) {
-		if (bus->slave_state != ASPEED_I2C_SLAVE_INACTIVE)
-			goto out_no_complete;
-
-		bus->master_state = ASPEED_I2C_MASTER_START;
-	}
-#endif /* CONFIG_I2C_SLAVE */
-
 	/* Master is not currently active, irq was for someone else. */
 	if (bus->master_state == ASPEED_I2C_MASTER_INACTIVE ||
 	    bus->master_state == ASPEED_I2C_MASTER_PENDING)
@@ -462,11 +455,15 @@ static u32 aspeed_i2c_master_irq(struct aspeed_i2c_bus *bus, u32 irq_status)
 #if IS_ENABLED(CONFIG_I2C_SLAVE)
 		/*
 		 * If a peer master starts a xfer immediately after it queues a
-		 * master command, change its state to 'pending' then H/W will
-		 * continue the queued master xfer just after completing the
-		 * slave mode session.
+		 * master command, clear the queued master command and change
+		 * its state to 'pending'. To simplify handling of pending
+		 * cases, it uses S/W solution instead of H/W command queue
+		 * handling.
 		 */
 		if (unlikely(irq_status & ASPEED_I2CD_INTR_SLAVE_MATCH)) {
+			writel(readl(bus->base + ASPEED_I2C_CMD_REG) &
+				~ASPEED_I2CD_MASTER_CMDS_MASK,
+			       bus->base + ASPEED_I2C_CMD_REG);
 			bus->master_state = ASPEED_I2C_MASTER_PENDING;
 			dev_dbg(bus->dev,
 				"master goes pending due to a slave start\n");
@@ -629,6 +626,14 @@ static irqreturn_t aspeed_i2c_bus_irq(int irq, void *dev_id)
 			irq_handled |= aspeed_i2c_master_irq(bus,
 							     irq_remaining);
 	}
+
+	/*
+	 * Start a pending master command at here if a slave operation is
+	 * completed.
+	 */
+	if (bus->master_state == ASPEED_I2C_MASTER_PENDING &&
+	    bus->slave_state == ASPEED_I2C_SLAVE_INACTIVE)
+		aspeed_i2c_do_start(bus);
 #else
 	irq_handled = aspeed_i2c_master_irq(bus, irq_remaining);
 #endif /* CONFIG_I2C_SLAVE */
@@ -691,6 +696,15 @@ static int aspeed_i2c_master_xfer(struct i2c_adapter *adap,
 		     ASPEED_I2CD_BUS_BUSY_STS))
 			aspeed_i2c_recover_bus(bus);
 
+		/*
+		 * If timed out and the state is still pending, drop the pending
+		 * master command.
+		 */
+		spin_lock_irqsave(&bus->lock, flags);
+		if (bus->master_state == ASPEED_I2C_MASTER_PENDING)
+			bus->master_state = ASPEED_I2C_MASTER_INACTIVE;
+		spin_unlock_irqrestore(&bus->lock, flags);
+
 		return -ETIMEDOUT;
 	}
 
-- 
2.20.1



