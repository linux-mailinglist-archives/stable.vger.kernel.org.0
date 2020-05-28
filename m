Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAD81E5EF0
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 13:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389042AbgE1L5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 07:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389026AbgE1L5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:57:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63FCB2177B;
        Thu, 28 May 2020 11:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667050;
        bh=8su1/yDtzEiYTbiR3qLGi+y6W6cRci67Qbj9Nl2n2BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UV3c1Nc36a5QeFmHFYsyuBAltpWYVW1M2cdeJn5BRKCULutYpTSgaEjtTsQjQdfOh
         zHWESOFOPPoUYkCP7dq2+090NChO4zvgRZRfnMTyjXaOCzQhkMyYpSUY2+GzkM4xob
         iuzISY3SVu45IH1VUWiu746SzhnjSvIMKWat4cIU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atsushi Nemoto <atsushi.nemoto@sord.co.jp>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/17] i2c: altera: Fix race between xfer_msg and isr thread
Date:   Thu, 28 May 2020 07:57:11 -0400
Message-Id: <20200528115724.1406376-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115724.1406376-1-sashal@kernel.org>
References: <20200528115724.1406376-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>

[ Upstream commit 5d4c7977499a736f3f80826bdc9744344ad55589 ]

Use a mutex to protect access to idev->msg_len, idev->buf, etc. which
are modified by both altr_i2c_xfer_msg() and altr_i2c_isr().

This is the minimal fix for easy backporting. A cleanup to remove the
spinlock will be added later.

Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Acked-by: Thor Thayer <thor.thayer@linux.intel.com>
[wsa: updated commit message]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-altera.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-altera.c b/drivers/i2c/busses/i2c-altera.c
index 8915ee30a5b4..1d59eede537b 100644
--- a/drivers/i2c/busses/i2c-altera.c
+++ b/drivers/i2c/busses/i2c-altera.c
@@ -81,6 +81,7 @@
  * @isr_mask: cached copy of local ISR enables.
  * @isr_status: cached copy of local ISR status.
  * @lock: spinlock for IRQ synchronization.
+ * @isr_mutex: mutex for IRQ thread.
  */
 struct altr_i2c_dev {
 	void __iomem *base;
@@ -97,6 +98,7 @@ struct altr_i2c_dev {
 	u32 isr_mask;
 	u32 isr_status;
 	spinlock_t lock;	/* IRQ synchronization */
+	struct mutex isr_mutex;
 };
 
 static void
@@ -256,10 +258,11 @@ static irqreturn_t altr_i2c_isr(int irq, void *_dev)
 	struct altr_i2c_dev *idev = _dev;
 	u32 status = idev->isr_status;
 
+	mutex_lock(&idev->isr_mutex);
 	if (!idev->msg) {
 		dev_warn(idev->dev, "unexpected interrupt\n");
 		altr_i2c_int_clear(idev, ALTR_I2C_ALL_IRQ);
-		return IRQ_HANDLED;
+		goto out;
 	}
 	read = (idev->msg->flags & I2C_M_RD) != 0;
 
@@ -312,6 +315,8 @@ static irqreturn_t altr_i2c_isr(int irq, void *_dev)
 		complete(&idev->msg_complete);
 		dev_dbg(idev->dev, "Message Complete\n");
 	}
+out:
+	mutex_unlock(&idev->isr_mutex);
 
 	return IRQ_HANDLED;
 }
@@ -323,6 +328,7 @@ static int altr_i2c_xfer_msg(struct altr_i2c_dev *idev, struct i2c_msg *msg)
 	u32 value;
 	u8 addr = i2c_8bit_addr_from_msg(msg);
 
+	mutex_lock(&idev->isr_mutex);
 	idev->msg = msg;
 	idev->msg_len = msg->len;
 	idev->buf = msg->buf;
@@ -347,6 +353,7 @@ static int altr_i2c_xfer_msg(struct altr_i2c_dev *idev, struct i2c_msg *msg)
 		altr_i2c_int_enable(idev, imask, true);
 		altr_i2c_fill_tx_fifo(idev);
 	}
+	mutex_unlock(&idev->isr_mutex);
 
 	time_left = wait_for_completion_timeout(&idev->msg_complete,
 						ALTR_I2C_XFER_TIMEOUT);
@@ -420,6 +427,7 @@ static int altr_i2c_probe(struct platform_device *pdev)
 	idev->dev = &pdev->dev;
 	init_completion(&idev->msg_complete);
 	spin_lock_init(&idev->lock);
+	mutex_init(&idev->isr_mutex);
 
 	ret = device_property_read_u32(idev->dev, "fifo-size",
 				       &idev->fifo_size);
-- 
2.25.1

