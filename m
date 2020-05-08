Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC4C1CB1CF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 16:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgEHO2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 10:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727896AbgEHO2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 10:28:24 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C3EC05BD09
        for <stable@vger.kernel.org>; Fri,  8 May 2020 07:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588948102;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ls1hjOtKcB17N3UepmBT6Tg0A724Wpp6lcXF+7k3UIM=;
        b=eWK6pSeo8E+y8hHyTrBKutoyRj8qLIElooenn30PqFRoacJgO2Gb7xqNJjTjLar8u4
        5pnXzabZilfm/69JTFjlqvz8U1Rs0sWPaWmvmg2vbiOB7YWqrYjfvb5PUQ6ueOJCb4dg
        sjE998kZi/evtg+VT65ip4TLOJH4JDGNXxLcIrnWbQqQRq8gITTmfRWyxUmmEmz4ngEL
        F8hUh3m5XejBmRzZdUXyZuQP/1K5jMzp7+vdswgjvwO/FgQC7mRa64D9/9pMQbBf5lUT
        xUCRydUi2yDXVDP+W8+XdH3T+tjmprkfWT3wyDChuR4rnYQ5IVcsWwllUjSlHhd/pliC
        gx0Q==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6HVy/jE8="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id R0acebw48ESL4Ml
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 8 May 2020 16:28:21 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     letux-kernel@openphoenux.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [PATCH 2/5] w1: omap-hdq: fix interrupt handling which did show spurious timeouts
Date:   Fri,  8 May 2020 16:28:17 +0200
Message-Id: <d0f153718e9a0b1c36a4bdda55492854c05847a4.1588948099.git.hns@goldelico.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1588948099.git.hns@goldelico.com>
References: <cover.1588948099.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

after

commit 27d13da8782a ("w1: omap-hdq: Simplify driver with PM runtime autosuspend")

was applied, we did see timeouts and wrong values when
reading a bq27000 connected to hdq of the omap3. This occurred
mainly after boot and sometimes settled down after several reads
indicating ignored interrupts.

root@letux:~# time cat /sys/class/power_supply/bq27000-battery/uevent
POWER_SUPPLY_NAME=bq27000-battery
POWER_SUPPLY_STATUS=Discharging
POWER_SUPPLY_PRESENT=1
POWER_SUPPLY_VOLTAGE_NOW=0
POWER_SUPPLY_CURRENT_NOW=0
POWER_SUPPLY_CAPACITY=0
POWER_SUPPLY_CAPACITY_LEVEL=Normal
POWER_SUPPLY_TEMP=-2731
POWER_SUPPLY_TIME_TO_EMPTY_NOW=0
POWER_SUPPLY_TIME_TO_EMPTY_AVG=0
POWER_SUPPLY_TIME_TO_FULL_NOW=0
POWER_SUPPLY_TECHNOLOGY=Li-ion
POWER_SUPPLY_CHARGE_FULL=0
POWER_SUPPLY_CHARGE_NOW=0
POWER_SUPPLY_CHARGE_FULL_DESIGN=0
POWER_SUPPLY_CYCLE_COUNT=0
POWER_SUPPLY_ENERGY_NOW=0
POWER_SUPPLY_POWER_AVG=0
POWER_SUPPLY_HEALTH=Good
POWER_SUPPLY_MANUFACTURER=Texas Instruments

real    0m15.761s
user    0m0.001s
sys     0m0.025s
root@letux:~#

Sometimes the effect did disappear after trying multiple
times and speed went up and results became correct.

Enabling debugging revealed that there were tx and
rx timeouts, i.e. the driver does not always respond
properly to interrupts.

This patch improves interrupt handling to avoid races
and loss of interrupt flags.

The ideas are:
* only the hdq_isr() sets bits in hdq_status
* and does wake_up()
* bits are only reset by the read/write/break functions
  if they were waited for
* rx/tx/timeout bits are completely decoupled from each
  other (and not reset all after waiting for one of them)
* which bits to reset is specified by a new parameter
  to hdq_reset_irqstatus()
* hdq_reset_irqstatus() also returns the state before
  resetting so that we can encapsulate the spinlock
* this should now handle the case that the write and read
  are both already finished quickly before the hdq_write_byte()
  ends. Old code may have reset all status bits making
  the next hdq_read_byte() timeout
* the spinlock protects the reset of bits in function
  hdq_reset_irqstatus() which could be a read-write-modify
  problem if the interrupt handler tries to read-modify-write
  exactly at the same moment
* add mutex protection also for hdq_write_byte() just to
  be safe not to disturb a hdq_read_byte() triggered by
  some other thread/process.

This patch was tested on a gta04 and results in

root@letux:~# time cat /sys/class/power_supply/bq27000-battery/uevent
POWER_SUPPLY_NAME=bq27000-battery
POWER_SUPPLY_STATUS=Discharging
POWER_SUPPLY_PRESENT=1
POWER_SUPPLY_VOLTAGE_NOW=3970000
POWER_SUPPLY_CURRENT_NOW=354144
POWER_SUPPLY_CAPACITY=82
POWER_SUPPLY_CAPACITY_LEVEL=Normal
POWER_SUPPLY_TEMP=266
POWER_SUPPLY_TIME_TO_EMPTY_NOW=7680
POWER_SUPPLY_TIME_TO_EMPTY_AVG=7380
POWER_SUPPLY_TECHNOLOGY=Li-ion
POWER_SUPPLY_CHARGE_FULL=934856
POWER_SUPPLY_CHARGE_NOW=763976
POWER_SUPPLY_CHARGE_FULL_DESIGN=1233792
POWER_SUPPLY_CYCLE_COUNT=82
POWER_SUPPLY_ENERGY_NOW=2852840
POWER_SUPPLY_POWER_AVG=1392840
POWER_SUPPLY_HEALTH=Good
POWER_SUPPLY_MANUFACTURER=Texas Instruments

real    0m0.233s
user    0m0.000s
sys     0m0.025s
root@letux:~#

It was also tested with dev_dbg enabled and more
printk that all activities behave correctly, especially
hdq_write_byte(), hdq_read_byte(), omap_hdq_break().

Not tested is omap_w1_triplet().

Fixes: 27d13da8782a ("w1: omap-hdq: Simplify driver with PM runtime autosuspend")
Cc: stable@vger.kernel.org # v5.6+
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/w1/masters/omap_hdq.c | 56 ++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index d363e2a89fdfc..384dad0615a26 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -54,10 +54,10 @@ MODULE_PARM_DESC(w1_id, "1-wire id for the slave detection in HDQ mode");
 struct hdq_data {
 	struct device		*dev;
 	void __iomem		*hdq_base;
-	/* lock status update */
+	/* lock read/write/status update */
 	struct  mutex		hdq_mutex;
+	/* interrupt status and lock */
 	u8			hdq_irqstatus;
-	/* device lock */
 	spinlock_t		hdq_spinlock;
 	/* mode: 0-HDQ 1-W1 */
 	int                     mode;
@@ -120,13 +120,18 @@ static int hdq_wait_for_flag(struct hdq_data *hdq_data, u32 offset,
 }
 
 /* Clear saved irqstatus after using an interrupt */
-static void hdq_reset_irqstatus(struct hdq_data *hdq_data)
+static u8 hdq_reset_irqstatus(struct hdq_data *hdq_data, u8 bits)
 {
 	unsigned long irqflags;
+	u8 status;
 
 	spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
-	hdq_data->hdq_irqstatus = 0;
+	status = hdq_data->hdq_irqstatus;
+	/* this is a read-modify-write */
+	hdq_data->hdq_irqstatus &= ~bits;
 	spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);
+
+	return status;
 }
 
 /* write out a byte and fill *status with HDQ_INT_STATUS */
@@ -135,6 +140,12 @@ static int hdq_write_byte(struct hdq_data *hdq_data, u8 val, u8 *status)
 	int ret;
 	u8 tmp_status;
 
+	ret = mutex_lock_interruptible(&hdq_data->hdq_mutex);
+	if (ret < 0) {
+		ret = -EINTR;
+		goto rtn;
+	}
+
 	*status = 0;
 
 	hdq_reg_out(hdq_data, OMAP_HDQ_TX_DATA, val);
@@ -144,14 +155,15 @@ static int hdq_write_byte(struct hdq_data *hdq_data, u8 val, u8 *status)
 		OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO);
 	/* wait for the TXCOMPLETE bit */
 	ret = wait_event_timeout(hdq_wait_queue,
-		hdq_data->hdq_irqstatus, OMAP_HDQ_TIMEOUT);
+		(hdq_data->hdq_irqstatus & OMAP_HDQ_INT_STATUS_TXCOMPLETE),
+		OMAP_HDQ_TIMEOUT);
+	*status = hdq_reset_irqstatus(hdq_data, OMAP_HDQ_INT_STATUS_TXCOMPLETE);
 	if (ret == 0) {
 		dev_dbg(hdq_data->dev, "TX wait elapsed\n");
 		ret = -ETIMEDOUT;
 		goto out;
 	}
 
-	*status = hdq_data->hdq_irqstatus;
 	/* check irqstatus */
 	if (!(*status & OMAP_HDQ_INT_STATUS_TXCOMPLETE)) {
 		dev_dbg(hdq_data->dev, "timeout waiting for"
@@ -170,7 +182,8 @@ static int hdq_write_byte(struct hdq_data *hdq_data, u8 val, u8 *status)
 	}
 
 out:
-	hdq_reset_irqstatus(hdq_data);
+	mutex_unlock(&hdq_data->hdq_mutex);
+rtn:
 	return ret;
 }
 
@@ -181,7 +194,7 @@ static irqreturn_t hdq_isr(int irq, void *_hdq)
 	unsigned long irqflags;
 
 	spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
-	hdq_data->hdq_irqstatus = hdq_reg_in(hdq_data, OMAP_HDQ_INT_STATUS);
+	hdq_data->hdq_irqstatus |= hdq_reg_in(hdq_data, OMAP_HDQ_INT_STATUS);
 	spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);
 	dev_dbg(hdq_data->dev, "hdq_isr: %x\n", hdq_data->hdq_irqstatus);
 
@@ -238,14 +251,15 @@ static int omap_hdq_break(struct hdq_data *hdq_data)
 
 	/* wait for the TIMEOUT bit */
 	ret = wait_event_timeout(hdq_wait_queue,
-		hdq_data->hdq_irqstatus, OMAP_HDQ_TIMEOUT);
+		(hdq_data->hdq_irqstatus & OMAP_HDQ_INT_STATUS_TIMEOUT),
+		OMAP_HDQ_TIMEOUT);
+	tmp_status = hdq_reset_irqstatus(hdq_data, OMAP_HDQ_INT_STATUS_TIMEOUT);
 	if (ret == 0) {
 		dev_dbg(hdq_data->dev, "break wait elapsed\n");
 		ret = -EINTR;
 		goto out;
 	}
 
-	tmp_status = hdq_data->hdq_irqstatus;
 	/* check irqstatus */
 	if (!(tmp_status & OMAP_HDQ_INT_STATUS_TIMEOUT)) {
 		dev_dbg(hdq_data->dev, "timeout waiting for TIMEOUT, %x\n",
@@ -278,7 +292,6 @@ static int omap_hdq_break(struct hdq_data *hdq_data)
 			" return to zero, %x\n", tmp_status);
 
 out:
-	hdq_reset_irqstatus(hdq_data);
 	mutex_unlock(&hdq_data->hdq_mutex);
 rtn:
 	return ret;
@@ -311,10 +324,11 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u8 *val)
 				   (hdq_data->hdq_irqstatus
 				    & OMAP_HDQ_INT_STATUS_RXCOMPLETE),
 				   OMAP_HDQ_TIMEOUT);
-
+		status = hdq_reset_irqstatus(hdq_data,
+					     OMAP_HDQ_INT_STATUS_RXCOMPLETE);
 		hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS, 0,
 			OMAP_HDQ_CTRL_STATUS_DIR);
-		status = hdq_data->hdq_irqstatus;
+
 		/* check irqstatus */
 		if (!(status & OMAP_HDQ_INT_STATUS_RXCOMPLETE)) {
 			dev_dbg(hdq_data->dev, "timeout waiting for"
@@ -322,11 +336,12 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u8 *val)
 			ret = -ETIMEDOUT;
 			goto out;
 		}
+	} else { /* interrupt had occurred before hdq_read_byte was called */
+		hdq_reset_irqstatus(hdq_data, OMAP_HDQ_INT_STATUS_RXCOMPLETE);
 	}
 	/* the data is ready. Read it in! */
 	*val = hdq_reg_in(hdq_data, OMAP_HDQ_RX_DATA);
 out:
-	hdq_reset_irqstatus(hdq_data);
 	mutex_unlock(&hdq_data->hdq_mutex);
 rtn:
 	return ret;
@@ -367,15 +382,15 @@ static u8 omap_w1_triplet(void *_hdq, u8 bdir)
 				 (hdq_data->hdq_irqstatus
 				  & OMAP_HDQ_INT_STATUS_RXCOMPLETE),
 				 OMAP_HDQ_TIMEOUT);
+	/* Must clear irqstatus for another RXCOMPLETE interrupt */
+	hdq_reset_irqstatus(hdq_data, OMAP_HDQ_INT_STATUS_RXCOMPLETE);
+
 	if (err == 0) {
 		dev_dbg(hdq_data->dev, "RX wait elapsed\n");
 		goto out;
 	}
 	id_bit = (hdq_reg_in(_hdq, OMAP_HDQ_RX_DATA) & 0x01);
 
-	/* Must clear irqstatus for another RXCOMPLETE interrupt */
-	hdq_reset_irqstatus(hdq_data);
-
 	/* read comp_bit */
 	hdq_reg_merge(_hdq, OMAP_HDQ_CTRL_STATUS,
 		      ctrl | OMAP_HDQ_CTRL_STATUS_DIR, mask);
@@ -383,6 +398,9 @@ static u8 omap_w1_triplet(void *_hdq, u8 bdir)
 				 (hdq_data->hdq_irqstatus
 				  & OMAP_HDQ_INT_STATUS_RXCOMPLETE),
 				 OMAP_HDQ_TIMEOUT);
+	/* Must clear irqstatus for another RXCOMPLETE interrupt */
+	hdq_reset_irqstatus(hdq_data, OMAP_HDQ_INT_STATUS_RXCOMPLETE);
+
 	if (err == 0) {
 		dev_dbg(hdq_data->dev, "RX wait elapsed\n");
 		goto out;
@@ -409,6 +427,9 @@ static u8 omap_w1_triplet(void *_hdq, u8 bdir)
 				 (hdq_data->hdq_irqstatus
 				  & OMAP_HDQ_INT_STATUS_TXCOMPLETE),
 				 OMAP_HDQ_TIMEOUT);
+	/* Must clear irqstatus for another TXCOMPLETE interrupt */
+	hdq_reset_irqstatus(hdq_data, OMAP_HDQ_INT_STATUS_TXCOMPLETE);
+
 	if (err == 0) {
 		dev_dbg(hdq_data->dev, "TX wait elapsed\n");
 		goto out;
@@ -418,7 +439,6 @@ static u8 omap_w1_triplet(void *_hdq, u8 bdir)
 		      OMAP_HDQ_CTRL_STATUS_SINGLE);
 
 out:
-	hdq_reset_irqstatus(hdq_data);
 	mutex_unlock(&hdq_data->hdq_mutex);
 rtn:
 	pm_runtime_mark_last_busy(hdq_data->dev);
-- 
2.26.2

