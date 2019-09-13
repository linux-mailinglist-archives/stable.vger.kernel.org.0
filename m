Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878E8B1EE1
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389360AbfIMNNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388797AbfIMNNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:41 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4098F216F4;
        Fri, 13 Sep 2019 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380419;
        bh=gDr78yWoe/UpdNRH+Nh/v64JLpKyuS/LncTAU8/+6nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8Ig7ksQrvBVFQ2CJz2DcnMkDlnTCXgIOGOmtB/2FSwgUUXH5e0AszrERLz1mxG8T
         kYy/bqUGTbrUVxQe9chIpou2Y7U7mFGarCS4rkYUBdUtWIs1bIQ/FzeQhFluUun1hS
         B2eK8L7rV1hjjb1U9kYUki9h9x8U8j6nvAxAVjxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH 4.19 059/190] s390/zcrypt: reinit ap queue state machine during device probe
Date:   Fri, 13 Sep 2019 14:05:14 +0100
Message-Id: <20190913130604.471422381@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



