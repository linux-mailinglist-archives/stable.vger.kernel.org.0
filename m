Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBFCF670B
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfKJCkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfKJCkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E3B721019;
        Sun, 10 Nov 2019 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353615;
        bh=qb2GIUFEwa4pCictKGureubfmT4D4gr9I87skM+8uVM=;
        h=From:To:Cc:Subject:Date:From;
        b=tx4jZw2wzmSPL3zQb2HjD/XC6qUjh5bJp3GfTd4PzVX0nZKaeX4NXAu/KDFJRdrhK
         VrpC0iB8tLKZ75MMom4g/2FtRGwI/QLNgkeS31y87tHvkWYseOyJPwmfYYkZUh060i
         M6KQ3jGeFX4HQZAL9jx6v76Eswix+vVorDxPjlkY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 001/191] s390/qeth: uninstall IRQ handler on device removal
Date:   Sat,  9 Nov 2019 21:37:03 -0500
Message-Id: <20191110024013.29782-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 121ca39aa5585def682a2c8592983442438b84dc ]

When setting up, qeth installs its IRQ handler on the ccw devices. But
the IRQ handler is not cleared on removal - so even after qeth yields
control of the ccw devices, spurious interrupts would still be presented
to us.

Make (de-)installation of the IRQ handler part of the ccw channel
setup/removal helpers, and while at it also add the appropriate locking.
Shift around qeth_setup_channel() to avoid a forward declaration for
qeth_irq().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 102 ++++++++++++++++--------------
 1 file changed, 54 insertions(+), 48 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 461afc276db72..81e2c591acb0b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -901,44 +901,6 @@ static void qeth_send_control_data_cb(struct qeth_channel *channel,
 	qeth_release_buffer(channel, iob);
 }
 
-static int qeth_setup_channel(struct qeth_channel *channel, bool alloc_buffers)
-{
-	int cnt;
-
-	QETH_DBF_TEXT(SETUP, 2, "setupch");
-
-	channel->ccw = kmalloc(sizeof(struct ccw1), GFP_KERNEL | GFP_DMA);
-	if (!channel->ccw)
-		return -ENOMEM;
-	channel->state = CH_STATE_DOWN;
-	atomic_set(&channel->irq_pending, 0);
-	init_waitqueue_head(&channel->wait_q);
-
-	if (!alloc_buffers)
-		return 0;
-
-	for (cnt = 0; cnt < QETH_CMD_BUFFER_NO; cnt++) {
-		channel->iob[cnt].data =
-			kzalloc(QETH_BUFSIZE, GFP_DMA|GFP_KERNEL);
-		if (channel->iob[cnt].data == NULL)
-			break;
-		channel->iob[cnt].state = BUF_STATE_FREE;
-		channel->iob[cnt].channel = channel;
-		channel->iob[cnt].callback = qeth_send_control_data_cb;
-		channel->iob[cnt].rc = 0;
-	}
-	if (cnt < QETH_CMD_BUFFER_NO) {
-		kfree(channel->ccw);
-		while (cnt-- > 0)
-			kfree(channel->iob[cnt].data);
-		return -ENOMEM;
-	}
-	channel->io_buf_no = 0;
-	spin_lock_init(&channel->iob_lock);
-
-	return 0;
-}
-
 static int qeth_set_thread_start_bit(struct qeth_card *card,
 		unsigned long thread)
 {
@@ -1339,14 +1301,61 @@ static void qeth_free_buffer_pool(struct qeth_card *card)
 
 static void qeth_clean_channel(struct qeth_channel *channel)
 {
+	struct ccw_device *cdev = channel->ccwdev;
 	int cnt;
 
 	QETH_DBF_TEXT(SETUP, 2, "freech");
+
+	spin_lock_irq(get_ccwdev_lock(cdev));
+	cdev->handler = NULL;
+	spin_unlock_irq(get_ccwdev_lock(cdev));
+
 	for (cnt = 0; cnt < QETH_CMD_BUFFER_NO; cnt++)
 		kfree(channel->iob[cnt].data);
 	kfree(channel->ccw);
 }
 
+static int qeth_setup_channel(struct qeth_channel *channel, bool alloc_buffers)
+{
+	struct ccw_device *cdev = channel->ccwdev;
+	int cnt;
+
+	QETH_DBF_TEXT(SETUP, 2, "setupch");
+
+	channel->ccw = kmalloc(sizeof(struct ccw1), GFP_KERNEL | GFP_DMA);
+	if (!channel->ccw)
+		return -ENOMEM;
+	channel->state = CH_STATE_DOWN;
+	atomic_set(&channel->irq_pending, 0);
+	init_waitqueue_head(&channel->wait_q);
+
+	spin_lock_irq(get_ccwdev_lock(cdev));
+	cdev->handler = qeth_irq;
+	spin_unlock_irq(get_ccwdev_lock(cdev));
+
+	if (!alloc_buffers)
+		return 0;
+
+	for (cnt = 0; cnt < QETH_CMD_BUFFER_NO; cnt++) {
+		channel->iob[cnt].data =
+			kzalloc(QETH_BUFSIZE, GFP_DMA|GFP_KERNEL);
+		if (channel->iob[cnt].data == NULL)
+			break;
+		channel->iob[cnt].state = BUF_STATE_FREE;
+		channel->iob[cnt].channel = channel;
+		channel->iob[cnt].callback = qeth_send_control_data_cb;
+		channel->iob[cnt].rc = 0;
+	}
+	if (cnt < QETH_CMD_BUFFER_NO) {
+		qeth_clean_channel(channel);
+		return -ENOMEM;
+	}
+	channel->io_buf_no = 0;
+	spin_lock_init(&channel->iob_lock);
+
+	return 0;
+}
+
 static void qeth_set_single_write_queues(struct qeth_card *card)
 {
 	if ((atomic_read(&card->qdio.state) != QETH_QDIO_UNINITIALIZED) &&
@@ -1498,7 +1507,7 @@ static void qeth_core_sl_print(struct seq_file *m, struct service_level *slr)
 			CARD_BUS_ID(card), card->info.mcl_level);
 }
 
-static struct qeth_card *qeth_alloc_card(void)
+static struct qeth_card *qeth_alloc_card(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card;
 
@@ -1507,6 +1516,11 @@ static struct qeth_card *qeth_alloc_card(void)
 	if (!card)
 		goto out;
 	QETH_DBF_HEX(SETUP, 2, &card, sizeof(void *));
+
+	card->gdev = gdev;
+	CARD_RDEV(card) = gdev->cdev[0];
+	CARD_WDEV(card) = gdev->cdev[1];
+	CARD_DDEV(card) = gdev->cdev[2];
 	if (qeth_setup_channel(&card->read, true))
 		goto out_ip;
 	if (qeth_setup_channel(&card->write, true))
@@ -5745,7 +5759,7 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 
 	QETH_DBF_TEXT_(SETUP, 2, "%s", dev_name(&gdev->dev));
 
-	card = qeth_alloc_card();
+	card = qeth_alloc_card(gdev);
 	if (!card) {
 		QETH_DBF_TEXT_(SETUP, 2, "1err%d", -ENOMEM);
 		rc = -ENOMEM;
@@ -5761,15 +5775,7 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 			goto err_card;
 	}
 
-	card->read.ccwdev  = gdev->cdev[0];
-	card->write.ccwdev = gdev->cdev[1];
-	card->data.ccwdev  = gdev->cdev[2];
 	dev_set_drvdata(&gdev->dev, card);
-	card->gdev = gdev;
-	gdev->cdev[0]->handler = qeth_irq;
-	gdev->cdev[1]->handler = qeth_irq;
-	gdev->cdev[2]->handler = qeth_irq;
-
 	qeth_setup_card(card);
 	rc = qeth_update_from_chp_desc(card);
 	if (rc)
-- 
2.20.1

