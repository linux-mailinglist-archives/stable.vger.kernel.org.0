Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7143A6E6D
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbfICQ0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730564AbfICQ0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3890023878;
        Tue,  3 Sep 2019 16:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527971;
        bh=7h0GwUcuFj8kFqDGbnXbHa4mZpakoW6rKf2uvV9vEos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNCqhBY5TwHKxVmb+ZrH2ZyTmdlK5+jfcvZMY8hzeH4qduhsh1Gb72PYawNOITIwd
         FFlbbU8JUxsEXlrSlVZ01ArHstGVa37673sczNCp0kMPXIpKdH8iEcUCIZMX1GYGV/
         kzsUaJVspc3v9r/e1CyRrPtAyumVHkNUnYc+utw0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 030/167] s390/zcrypt: reinit ap queue state machine during device probe
Date:   Tue,  3 Sep 2019 12:23:02 -0400
Message-Id: <20190903162519.7136-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 104f708fd1241b22f808bdf066ab67dc5a051de5 ]

Until the vfio-ap driver came into live there was a well known
agreement about the way how ap devices are initialized and their
states when the driver's probe function is called.

However, the vfio device driver when receiving an ap queue device does
additional resets thereby removing the registration for interrupts for
the ap device done by the ap bus core code. So when later the vfio
driver releases the device and one of the default zcrypt drivers takes
care of the device the interrupt registration needs to get
renewed. The current code does no renew and result is that requests
send into such a queue will never see a reply processed - the
application hangs.

This patch adds a function which resets the aq queue state machine for
the ap queue device and triggers the walk through the initial states
(which are reset and registration for interrupts). This function is
now called before the driver's probe function is invoked.

When the association between driver and device is released, the
driver's remove function is called. The current implementation calls a
ap queue function ap_queue_remove(). This invokation has been moved to
the ap bus function to make the probe / remove pair for ap bus and
drivers more symmetric.

Fixes: 7e0bdbe5c21c ("s390/zcrypt: AP bus support for alternate driver(s)")
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewd-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewd-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c        |  8 ++++----
 drivers/s390/crypto/ap_bus.h        |  1 +
 drivers/s390/crypto/ap_queue.c      | 15 +++++++++++++++
 drivers/s390/crypto/zcrypt_cex2a.c  |  1 -
 drivers/s390/crypto/zcrypt_cex4.c   |  1 -
 drivers/s390/crypto/zcrypt_pcixcc.c |  1 -
 6 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index a57b969b89733..3be54651698a3 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -777,6 +777,8 @@ static int ap_device_probe(struct device *dev)
 		drvres = ap_drv->flags & AP_DRIVER_FLAG_DEFAULT;
 		if (!!devres != !!drvres)
 			return -ENODEV;
+		/* (re-)init queue's state machine */
+		ap_queue_reinit_state(to_ap_queue(dev));
 	}
 
 	/* Add queue/card to list of active queues/cards */
@@ -809,6 +811,8 @@ static int ap_device_remove(struct device *dev)
 	struct ap_device *ap_dev = to_ap_dev(dev);
 	struct ap_driver *ap_drv = ap_dev->drv;
 
+	if (is_queue_dev(dev))
+		ap_queue_remove(to_ap_queue(dev));
 	if (ap_drv->remove)
 		ap_drv->remove(ap_dev);
 
@@ -1446,10 +1450,6 @@ static void ap_scan_bus(struct work_struct *unused)
 			aq->ap_dev.device.parent = &ac->ap_dev.device;
 			dev_set_name(&aq->ap_dev.device,
 				     "%02x.%04x", id, dom);
-			/* Start with a device reset */
-			spin_lock_bh(&aq->lock);
-			ap_wait(ap_sm_event(aq, AP_EVENT_POLL));
-			spin_unlock_bh(&aq->lock);
 			/* Register device */
 			rc = device_register(&aq->ap_dev.device);
 			if (rc) {
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 5246cd8c16a60..7e85d238767ba 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -253,6 +253,7 @@ struct ap_queue *ap_queue_create(ap_qid_t qid, int device_type);
 void ap_queue_remove(struct ap_queue *aq);
 void ap_queue_suspend(struct ap_device *ap_dev);
 void ap_queue_resume(struct ap_device *ap_dev);
+void ap_queue_reinit_state(struct ap_queue *aq);
 
 struct ap_card *ap_card_create(int id, int queue_depth, int raw_device_type,
 			       int comp_device_type, unsigned int functions);
diff --git a/drivers/s390/crypto/ap_queue.c b/drivers/s390/crypto/ap_queue.c
index 66f7334bcb032..0aa4b3ccc948c 100644
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -718,5 +718,20 @@ void ap_queue_remove(struct ap_queue *aq)
 {
 	ap_flush_queue(aq);
 	del_timer_sync(&aq->timeout);
+
+	/* reset with zero, also clears irq registration */
+	spin_lock_bh(&aq->lock);
+	ap_zapq(aq->qid);
+	aq->state = AP_STATE_BORKED;
+	spin_unlock_bh(&aq->lock);
 }
 EXPORT_SYMBOL(ap_queue_remove);
+
+void ap_queue_reinit_state(struct ap_queue *aq)
+{
+	spin_lock_bh(&aq->lock);
+	aq->state = AP_STATE_RESET_START;
+	ap_wait(ap_sm_event(aq, AP_EVENT_POLL));
+	spin_unlock_bh(&aq->lock);
+}
+EXPORT_SYMBOL(ap_queue_reinit_state);
diff --git a/drivers/s390/crypto/zcrypt_cex2a.c b/drivers/s390/crypto/zcrypt_cex2a.c
index f4ae5fa30ec97..ff17a00273f77 100644
--- a/drivers/s390/crypto/zcrypt_cex2a.c
+++ b/drivers/s390/crypto/zcrypt_cex2a.c
@@ -198,7 +198,6 @@ static void zcrypt_cex2a_queue_remove(struct ap_device *ap_dev)
 	struct ap_queue *aq = to_ap_queue(&ap_dev->device);
 	struct zcrypt_queue *zq = aq->private;
 
-	ap_queue_remove(aq);
 	if (zq)
 		zcrypt_queue_unregister(zq);
 }
diff --git a/drivers/s390/crypto/zcrypt_cex4.c b/drivers/s390/crypto/zcrypt_cex4.c
index 35d58dbbc4da3..2a42e5962317a 100644
--- a/drivers/s390/crypto/zcrypt_cex4.c
+++ b/drivers/s390/crypto/zcrypt_cex4.c
@@ -273,7 +273,6 @@ static void zcrypt_cex4_queue_remove(struct ap_device *ap_dev)
 	struct ap_queue *aq = to_ap_queue(&ap_dev->device);
 	struct zcrypt_queue *zq = aq->private;
 
-	ap_queue_remove(aq);
 	if (zq)
 		zcrypt_queue_unregister(zq);
 }
diff --git a/drivers/s390/crypto/zcrypt_pcixcc.c b/drivers/s390/crypto/zcrypt_pcixcc.c
index 94d9f7224aea3..baa683c3f5d30 100644
--- a/drivers/s390/crypto/zcrypt_pcixcc.c
+++ b/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -276,7 +276,6 @@ static void zcrypt_pcixcc_queue_remove(struct ap_device *ap_dev)
 	struct ap_queue *aq = to_ap_queue(&ap_dev->device);
 	struct zcrypt_queue *zq = aq->private;
 
-	ap_queue_remove(aq);
 	if (zq)
 		zcrypt_queue_unregister(zq);
 }
-- 
2.20.1

