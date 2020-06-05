Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719B41EFAFF
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgFEOWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728729AbgFEOSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:18:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82CC6208A7;
        Fri,  5 Jun 2020 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366724;
        bh=5EMxD/AfSpLyjuXNqb5ixny+nHiT+Kx9uhypSmTttzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bhtSuvfK/u1JdD0JaaTwSY8So3ONDSiiVgxHaJrBEZwOdr8uoWFYhSKkKlh3N5Ut
         XHrQ4WrEjUOO719Xcfb1LqX5jb6DPNjdApirZH+MFffNf+t3UEHturiqIfvaRZfzbF
         ED2zjd3bP7RT69D7JNtiz+j+26T80ysXerZKxjqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atsushi Nemoto <atsushi.nemoto@sord.co.jp>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/38] i2c: altera: Fix race between xfer_msg and isr thread
Date:   Fri,  5 Jun 2020 16:15:11 +0200
Message-Id: <20200605140254.249867969@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 92d2c706c2a7..a60042431370 100644
--- a/drivers/i2c/busses/i2c-altera.c
+++ b/drivers/i2c/busses/i2c-altera.c
@@ -70,6 +70,7 @@
  * @isr_mask: cached copy of local ISR enables.
  * @isr_status: cached copy of local ISR status.
  * @lock: spinlock for IRQ synchronization.
+ * @isr_mutex: mutex for IRQ thread.
  */
 struct altr_i2c_dev {
 	void __iomem *base;
@@ -86,6 +87,7 @@ struct altr_i2c_dev {
 	u32 isr_mask;
 	u32 isr_status;
 	spinlock_t lock;	/* IRQ synchronization */
+	struct mutex isr_mutex;
 };
 
 static void
@@ -245,10 +247,11 @@ static irqreturn_t altr_i2c_isr(int irq, void *_dev)
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
 
@@ -301,6 +304,8 @@ static irqreturn_t altr_i2c_isr(int irq, void *_dev)
 		complete(&idev->msg_complete);
 		dev_dbg(idev->dev, "Message Complete\n");
 	}
+out:
+	mutex_unlock(&idev->isr_mutex);
 
 	return IRQ_HANDLED;
 }
@@ -312,6 +317,7 @@ static int altr_i2c_xfer_msg(struct altr_i2c_dev *idev, struct i2c_msg *msg)
 	u32 value;
 	u8 addr = i2c_8bit_addr_from_msg(msg);
 
+	mutex_lock(&idev->isr_mutex);
 	idev->msg = msg;
 	idev->msg_len = msg->len;
 	idev->buf = msg->buf;
@@ -336,6 +342,7 @@ static int altr_i2c_xfer_msg(struct altr_i2c_dev *idev, struct i2c_msg *msg)
 		altr_i2c_int_enable(idev, imask, true);
 		altr_i2c_fill_tx_fifo(idev);
 	}
+	mutex_unlock(&idev->isr_mutex);
 
 	time_left = wait_for_completion_timeout(&idev->msg_complete,
 						ALTR_I2C_XFER_TIMEOUT);
@@ -409,6 +416,7 @@ static int altr_i2c_probe(struct platform_device *pdev)
 	idev->dev = &pdev->dev;
 	init_completion(&idev->msg_complete);
 	spin_lock_init(&idev->lock);
+	mutex_init(&idev->isr_mutex);
 
 	ret = device_property_read_u32(idev->dev, "fifo-size",
 				       &idev->fifo_size);
-- 
2.25.1



