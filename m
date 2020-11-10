Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B802ACDA6
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgKJEEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:04:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732718AbgKJDyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E06A207BC;
        Tue, 10 Nov 2020 03:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980472;
        bh=jdFjeQLXwz1AUXH3/IhR2QxGsaJzL6/2z11GV+zJXeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGe6V6CoLC4jrpyhK16k3buJg3iVfsjl+ib7jZV/q3AKuA8HgqtDeydKjpRDcOmin
         dGdCLm6ynGCou7L78uhNdDJh0ssblm4Nghi6/dfYdbR22vdPRWihCExMoepMIHGCBl
         u8r+sEuAcicndo8xPxV6L47PmqKukFUzFT7HQen4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Wu <michael.wu@vatics.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 51/55] i2c: designware: slave should do WRITE_REQUESTED before WRITE_RECEIVED
Date:   Mon,  9 Nov 2020 22:53:14 -0500
Message-Id: <20201110035318.423757-51-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Wu <michael.wu@vatics.com>

[ Upstream commit 3b5f7f10ff6e6b66f553e12cc50d9bb751ce60ad ]

Sometimes we would get the following flow when doing an i2cset:

0x1 STATUS SLAVE_ACTIVITY=0x1 : RAW_INTR_STAT=0x514 : INTR_STAT=0x4
I2C_SLAVE_WRITE_RECEIVED
0x1 STATUS SLAVE_ACTIVITY=0x0 : RAW_INTR_STAT=0x714 : INTR_STAT=0x204
I2C_SLAVE_WRITE_REQUESTED
I2C_SLAVE_WRITE_RECEIVED

Documentation/i2c/slave-interface.rst says that I2C_SLAVE_WRITE_REQUESTED,
which is mandatory, should be sent while the data did not arrive yet. It
means in a write-request I2C_SLAVE_WRITE_REQUESTED should be reported
before any I2C_SLAVE_WRITE_RECEIVED.

By the way, I2C_SLAVE_STOP didn't be reported in the above case because
DW_IC_INTR_STAT was not 0x200.

dev->status can be used to record the current state, especially Designware
I2C controller has no interrupts to identify a write-request. This patch
makes not only I2C_SLAVE_WRITE_REQUESTED been reported first when
IC_INTR_RX_FULL is rising and dev->status isn't STATUS_WRITE_IN_PROGRESS
but also I2C_SLAVE_STOP been reported when a STOP condition is received.

Signed-off-by: Michael Wu <michael.wu@vatics.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-slave.c | 45 +++++++++--------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-slave.c b/drivers/i2c/busses/i2c-designware-slave.c
index 13de01a0f75f0..0d15f4c1e9f7e 100644
--- a/drivers/i2c/busses/i2c-designware-slave.c
+++ b/drivers/i2c/busses/i2c-designware-slave.c
@@ -172,26 +172,25 @@ static int i2c_dw_irq_handler_slave(struct dw_i2c_dev *dev)
 		"%#x STATUS SLAVE_ACTIVITY=%#x : RAW_INTR_STAT=%#x : INTR_STAT=%#x\n",
 		enabled, slave_activity, raw_stat, stat);
 
-	if ((stat & DW_IC_INTR_RX_FULL) && (stat & DW_IC_INTR_STOP_DET))
-		i2c_slave_event(dev->slave, I2C_SLAVE_WRITE_REQUESTED, &val);
+	if (stat & DW_IC_INTR_RX_FULL) {
+		if (dev->status != STATUS_WRITE_IN_PROGRESS) {
+			dev->status = STATUS_WRITE_IN_PROGRESS;
+			i2c_slave_event(dev->slave, I2C_SLAVE_WRITE_REQUESTED,
+					&val);
+		}
+
+		regmap_read(dev->map, DW_IC_DATA_CMD, &tmp);
+		val = tmp;
+		if (!i2c_slave_event(dev->slave, I2C_SLAVE_WRITE_RECEIVED,
+				     &val))
+			dev_vdbg(dev->dev, "Byte %X acked!", val);
+	}
 
 	if (stat & DW_IC_INTR_RD_REQ) {
 		if (slave_activity) {
-			if (stat & DW_IC_INTR_RX_FULL) {
-				regmap_read(dev->map, DW_IC_DATA_CMD, &tmp);
-				val = tmp;
-
-				if (!i2c_slave_event(dev->slave,
-						     I2C_SLAVE_WRITE_RECEIVED,
-						     &val)) {
-					dev_vdbg(dev->dev, "Byte %X acked!",
-						 val);
-				}
-				regmap_read(dev->map, DW_IC_CLR_RD_REQ, &tmp);
-			} else {
-				regmap_read(dev->map, DW_IC_CLR_RD_REQ, &tmp);
-				regmap_read(dev->map, DW_IC_CLR_RX_UNDER, &tmp);
-			}
+			regmap_read(dev->map, DW_IC_CLR_RD_REQ, &tmp);
+
+			dev->status = STATUS_READ_IN_PROGRESS;
 			if (!i2c_slave_event(dev->slave,
 					     I2C_SLAVE_READ_REQUESTED,
 					     &val))
@@ -203,18 +202,10 @@ static int i2c_dw_irq_handler_slave(struct dw_i2c_dev *dev)
 		if (!i2c_slave_event(dev->slave, I2C_SLAVE_READ_PROCESSED,
 				     &val))
 			regmap_read(dev->map, DW_IC_CLR_RX_DONE, &tmp);
-
-		i2c_slave_event(dev->slave, I2C_SLAVE_STOP, &val);
-		return 1;
 	}
 
-	if (stat & DW_IC_INTR_RX_FULL) {
-		regmap_read(dev->map, DW_IC_DATA_CMD, &tmp);
-		val = tmp;
-		if (!i2c_slave_event(dev->slave, I2C_SLAVE_WRITE_RECEIVED,
-				     &val))
-			dev_vdbg(dev->dev, "Byte %X acked!", val);
-	} else {
+	if (stat & DW_IC_INTR_STOP_DET) {
+		dev->status = STATUS_IDLE;
 		i2c_slave_event(dev->slave, I2C_SLAVE_STOP, &val);
 	}
 
-- 
2.27.0

