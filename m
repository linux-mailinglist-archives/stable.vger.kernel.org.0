Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16F23288B5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbhCARnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238094AbhCARh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:37:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E392650B1;
        Mon,  1 Mar 2021 16:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617694;
        bh=B3rBWenittZwXNPRwjHrwX34gUV1zcTMGFYMGe71RUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMBylgPSkn1b5xxtqKDOrpUBj78vbuyY/l1VDJ+8xVjDCqsltNUZ0FnQALSjO7Yza
         9gDg7Mdc9WDIk4LMXO8kOdsz3N7YGPxd6HmGfGKKdM9/ZEPqauSDFZFBjH72sfEz3L
         coHMqDTkLgizv4JiaWzED5rL43XZNth6ymmSo+rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/340] i2c: iproc: handle master read request
Date:   Mon,  1 Mar 2021 17:11:18 +0100
Message-Id: <20210301161054.903876493@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>

[ Upstream commit e21d79778768e4e187b2892d662c6aaa01e1d399 ]

Handle single or multi byte master read request with or without
repeated start.

Fixes: c245d94ed106 ("i2c: iproc: Add multi byte read-write support for slave mode")
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Acked-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c | 215 +++++++++++++++++++++++------
 1 file changed, 170 insertions(+), 45 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bcm-iproc.c b/drivers/i2c/busses/i2c-bcm-iproc.c
index 38a28bf6cfee4..70cd9fc7fb869 100644
--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -157,6 +157,11 @@
 
 #define IE_S_ALL_INTERRUPT_SHIFT     21
 #define IE_S_ALL_INTERRUPT_MASK      0x3f
+/*
+ * It takes ~18us to reading 10bytes of data, hence to keep tasklet
+ * running for less time, max slave read per tasklet is set to 10 bytes.
+ */
+#define MAX_SLAVE_RX_PER_INT         10
 
 enum i2c_slave_read_status {
 	I2C_SLAVE_RX_FIFO_EMPTY = 0,
@@ -203,8 +208,18 @@ struct bcm_iproc_i2c_dev {
 	/* bytes that have been read */
 	unsigned int rx_bytes;
 	unsigned int thld_bytes;
+
+	bool slave_rx_only;
+	bool rx_start_rcvd;
+	bool slave_read_complete;
+	u32 tx_underrun;
+	u32 slave_int_mask;
+	struct tasklet_struct slave_rx_tasklet;
 };
 
+/* tasklet to process slave rx data */
+static void slave_rx_tasklet_fn(unsigned long);
+
 /*
  * Can be expanded in the future if more interrupt status bits are utilized
  */
@@ -258,6 +273,7 @@ static void bcm_iproc_i2c_slave_init(
 {
 	u32 val;
 
+	iproc_i2c->tx_underrun = 0;
 	if (need_reset) {
 		/* put controller in reset */
 		val = iproc_i2c_rd_reg(iproc_i2c, CFG_OFFSET);
@@ -294,8 +310,11 @@ static void bcm_iproc_i2c_slave_init(
 
 	/* Enable interrupt register to indicate a valid byte in receive fifo */
 	val = BIT(IE_S_RX_EVENT_SHIFT);
+	/* Enable interrupt register to indicate a Master read transaction */
+	val |= BIT(IE_S_RD_EVENT_SHIFT);
 	/* Enable interrupt register for the Slave BUSY command */
 	val |= BIT(IE_S_START_BUSY_SHIFT);
+	iproc_i2c->slave_int_mask = val;
 	iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET, val);
 }
 
@@ -320,76 +339,176 @@ static void bcm_iproc_i2c_check_slave_status(
 	}
 }
 
-static bool bcm_iproc_i2c_slave_isr(struct bcm_iproc_i2c_dev *iproc_i2c,
-				    u32 status)
+static void bcm_iproc_i2c_slave_read(struct bcm_iproc_i2c_dev *iproc_i2c)
 {
+	u8 rx_data, rx_status;
+	u32 rx_bytes = 0;
 	u32 val;
-	u8 value, rx_status;
 
-	/* Slave RX byte receive */
-	if (status & BIT(IS_S_RX_EVENT_SHIFT)) {
+	while (rx_bytes < MAX_SLAVE_RX_PER_INT) {
 		val = iproc_i2c_rd_reg(iproc_i2c, S_RX_OFFSET);
 		rx_status = (val >> S_RX_STATUS_SHIFT) & S_RX_STATUS_MASK;
-		if (rx_status == I2C_SLAVE_RX_START) {
-			/* Start of SMBUS for Master write */
-			i2c_slave_event(iproc_i2c->slave,
-					I2C_SLAVE_WRITE_REQUESTED, &value);
+		rx_data = ((val >> S_RX_DATA_SHIFT) & S_RX_DATA_MASK);
 
-			val = iproc_i2c_rd_reg(iproc_i2c, S_RX_OFFSET);
-			value = (u8)((val >> S_RX_DATA_SHIFT) & S_RX_DATA_MASK);
+		if (rx_status == I2C_SLAVE_RX_START) {
+			/* Start of SMBUS Master write */
 			i2c_slave_event(iproc_i2c->slave,
-					I2C_SLAVE_WRITE_RECEIVED, &value);
-		} else if (status & BIT(IS_S_RD_EVENT_SHIFT)) {
-			/* Start of SMBUS for Master Read */
+					I2C_SLAVE_WRITE_REQUESTED, &rx_data);
+			iproc_i2c->rx_start_rcvd = true;
+			iproc_i2c->slave_read_complete = false;
+		} else if (rx_status == I2C_SLAVE_RX_DATA &&
+			   iproc_i2c->rx_start_rcvd) {
+			/* Middle of SMBUS Master write */
 			i2c_slave_event(iproc_i2c->slave,
-					I2C_SLAVE_READ_REQUESTED, &value);
-			iproc_i2c_wr_reg(iproc_i2c, S_TX_OFFSET, value);
+					I2C_SLAVE_WRITE_RECEIVED, &rx_data);
+		} else if (rx_status == I2C_SLAVE_RX_END &&
+			   iproc_i2c->rx_start_rcvd) {
+			/* End of SMBUS Master write */
+			if (iproc_i2c->slave_rx_only)
+				i2c_slave_event(iproc_i2c->slave,
+						I2C_SLAVE_WRITE_RECEIVED,
+						&rx_data);
+
+			i2c_slave_event(iproc_i2c->slave, I2C_SLAVE_STOP,
+					&rx_data);
+		} else if (rx_status == I2C_SLAVE_RX_FIFO_EMPTY) {
+			iproc_i2c->rx_start_rcvd = false;
+			iproc_i2c->slave_read_complete = true;
+			break;
+		}
 
-			val = BIT(S_CMD_START_BUSY_SHIFT);
-			iproc_i2c_wr_reg(iproc_i2c, S_CMD_OFFSET, val);
+		rx_bytes++;
+	}
+}
 
-			/*
-			 * Enable interrupt for TX FIFO becomes empty and
-			 * less than PKT_LENGTH bytes were output on the SMBUS
-			 */
-			val = iproc_i2c_rd_reg(iproc_i2c, IE_OFFSET);
-			val |= BIT(IE_S_TX_UNDERRUN_SHIFT);
-			iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET, val);
-		} else {
-			/* Master write other than start */
-			value = (u8)((val >> S_RX_DATA_SHIFT) & S_RX_DATA_MASK);
+static void slave_rx_tasklet_fn(unsigned long data)
+{
+	struct bcm_iproc_i2c_dev *iproc_i2c = (struct bcm_iproc_i2c_dev *)data;
+	u32 int_clr;
+
+	bcm_iproc_i2c_slave_read(iproc_i2c);
+
+	/* clear pending IS_S_RX_EVENT_SHIFT interrupt */
+	int_clr = BIT(IS_S_RX_EVENT_SHIFT);
+
+	if (!iproc_i2c->slave_rx_only && iproc_i2c->slave_read_complete) {
+		/*
+		 * In case of single byte master-read request,
+		 * IS_S_TX_UNDERRUN_SHIFT event is generated before
+		 * IS_S_START_BUSY_SHIFT event. Hence start slave data send
+		 * from first IS_S_TX_UNDERRUN_SHIFT event.
+		 *
+		 * This means don't send any data from slave when
+		 * IS_S_RD_EVENT_SHIFT event is generated else it will increment
+		 * eeprom or other backend slave driver read pointer twice.
+		 */
+		iproc_i2c->tx_underrun = 0;
+		iproc_i2c->slave_int_mask |= BIT(IE_S_TX_UNDERRUN_SHIFT);
+
+		/* clear IS_S_RD_EVENT_SHIFT interrupt */
+		int_clr |= BIT(IS_S_RD_EVENT_SHIFT);
+	}
+
+	/* clear slave interrupt */
+	iproc_i2c_wr_reg(iproc_i2c, IS_OFFSET, int_clr);
+	/* enable slave interrupts */
+	iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET, iproc_i2c->slave_int_mask);
+}
+
+static bool bcm_iproc_i2c_slave_isr(struct bcm_iproc_i2c_dev *iproc_i2c,
+				    u32 status)
+{
+	u32 val;
+	u8 value;
+
+	/*
+	 * Slave events in case of master-write, master-write-read and,
+	 * master-read
+	 *
+	 * Master-write     : only IS_S_RX_EVENT_SHIFT event
+	 * Master-write-read: both IS_S_RX_EVENT_SHIFT and IS_S_RD_EVENT_SHIFT
+	 *                    events
+	 * Master-read      : both IS_S_RX_EVENT_SHIFT and IS_S_RD_EVENT_SHIFT
+	 *                    events or only IS_S_RD_EVENT_SHIFT
+	 */
+	if (status & BIT(IS_S_RX_EVENT_SHIFT) ||
+	    status & BIT(IS_S_RD_EVENT_SHIFT)) {
+		/* disable slave interrupts */
+		val = iproc_i2c_rd_reg(iproc_i2c, IE_OFFSET);
+		val &= ~iproc_i2c->slave_int_mask;
+		iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET, val);
+
+		if (status & BIT(IS_S_RD_EVENT_SHIFT))
+			/* Master-write-read request */
+			iproc_i2c->slave_rx_only = false;
+		else
+			/* Master-write request only */
+			iproc_i2c->slave_rx_only = true;
+
+		/* schedule tasklet to read data later */
+		tasklet_schedule(&iproc_i2c->slave_rx_tasklet);
+
+		/* clear only IS_S_RX_EVENT_SHIFT interrupt */
+		iproc_i2c_wr_reg(iproc_i2c, IS_OFFSET,
+				 BIT(IS_S_RX_EVENT_SHIFT));
+	}
+
+	if (status & BIT(IS_S_TX_UNDERRUN_SHIFT)) {
+		iproc_i2c->tx_underrun++;
+		if (iproc_i2c->tx_underrun == 1)
+			/* Start of SMBUS for Master Read */
 			i2c_slave_event(iproc_i2c->slave,
-					I2C_SLAVE_WRITE_RECEIVED, &value);
-			if (rx_status == I2C_SLAVE_RX_END)
-				i2c_slave_event(iproc_i2c->slave,
-						I2C_SLAVE_STOP, &value);
-		}
-	} else if (status & BIT(IS_S_TX_UNDERRUN_SHIFT)) {
-		/* Master read other than start */
-		i2c_slave_event(iproc_i2c->slave,
-				I2C_SLAVE_READ_PROCESSED, &value);
+					I2C_SLAVE_READ_REQUESTED,
+					&value);
+		else
+			/* Master read other than start */
+			i2c_slave_event(iproc_i2c->slave,
+					I2C_SLAVE_READ_PROCESSED,
+					&value);
 
 		iproc_i2c_wr_reg(iproc_i2c, S_TX_OFFSET, value);
+		/* start transfer */
 		val = BIT(S_CMD_START_BUSY_SHIFT);
 		iproc_i2c_wr_reg(iproc_i2c, S_CMD_OFFSET, val);
+
+		/* clear interrupt */
+		iproc_i2c_wr_reg(iproc_i2c, IS_OFFSET,
+				 BIT(IS_S_TX_UNDERRUN_SHIFT));
 	}
 
-	/* Stop */
+	/* Stop received from master in case of master read transaction */
 	if (status & BIT(IS_S_START_BUSY_SHIFT)) {
-		i2c_slave_event(iproc_i2c->slave, I2C_SLAVE_STOP, &value);
 		/*
 		 * Enable interrupt for TX FIFO becomes empty and
 		 * less than PKT_LENGTH bytes were output on the SMBUS
 		 */
-		val = iproc_i2c_rd_reg(iproc_i2c, IE_OFFSET);
-		val &= ~BIT(IE_S_TX_UNDERRUN_SHIFT);
-		iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET, val);
+		iproc_i2c->slave_int_mask &= ~BIT(IE_S_TX_UNDERRUN_SHIFT);
+		iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET,
+				 iproc_i2c->slave_int_mask);
+
+		/* End of SMBUS for Master Read */
+		val = BIT(S_TX_WR_STATUS_SHIFT);
+		iproc_i2c_wr_reg(iproc_i2c, S_TX_OFFSET, val);
+
+		val = BIT(S_CMD_START_BUSY_SHIFT);
+		iproc_i2c_wr_reg(iproc_i2c, S_CMD_OFFSET, val);
+
+		/* flush TX FIFOs */
+		val = iproc_i2c_rd_reg(iproc_i2c, S_FIFO_CTRL_OFFSET);
+		val |= (BIT(S_FIFO_TX_FLUSH_SHIFT));
+		iproc_i2c_wr_reg(iproc_i2c, S_FIFO_CTRL_OFFSET, val);
+
+		i2c_slave_event(iproc_i2c->slave, I2C_SLAVE_STOP, &value);
+
+		/* clear interrupt */
+		iproc_i2c_wr_reg(iproc_i2c, IS_OFFSET,
+				 BIT(IS_S_START_BUSY_SHIFT));
 	}
 
-	/* clear interrupt status */
-	iproc_i2c_wr_reg(iproc_i2c, IS_OFFSET, status);
+	/* check slave transmit status only if slave is transmitting */
+	if (!iproc_i2c->slave_rx_only)
+		bcm_iproc_i2c_check_slave_status(iproc_i2c);
 
-	bcm_iproc_i2c_check_slave_status(iproc_i2c);
 	return true;
 }
 
@@ -1031,6 +1150,10 @@ static int bcm_iproc_i2c_reg_slave(struct i2c_client *slave)
 		return -EAFNOSUPPORT;
 
 	iproc_i2c->slave = slave;
+
+	tasklet_init(&iproc_i2c->slave_rx_tasklet, slave_rx_tasklet_fn,
+		     (unsigned long)iproc_i2c);
+
 	bcm_iproc_i2c_slave_init(iproc_i2c, false);
 	return 0;
 }
@@ -1051,6 +1174,8 @@ static int bcm_iproc_i2c_unreg_slave(struct i2c_client *slave)
 			IE_S_ALL_INTERRUPT_SHIFT);
 	iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET, tmp);
 
+	tasklet_kill(&iproc_i2c->slave_rx_tasklet);
+
 	/* Erase the slave address programmed */
 	tmp = iproc_i2c_rd_reg(iproc_i2c, S_CFG_SMBUS_ADDR_OFFSET);
 	tmp &= ~BIT(S_CFG_EN_NIC_SMB_ADDR3_SHIFT);
-- 
2.27.0



