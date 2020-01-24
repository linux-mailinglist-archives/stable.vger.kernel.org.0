Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEDF31489CD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387630AbgAXOhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391222AbgAXOTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A55720838;
        Fri, 24 Jan 2020 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875539;
        bh=aQOpUWDKW8nzsv57PXVUcVKwFvdSssAFFA6dAs6Vs6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfPMwzjh0nj3wkOQ+YVInYSgYeTN1kMsY3wfXrkRRnzZabnFJjdIsGp0HL9K64vok
         ID7tvyy56FgVrA8NRwg5GJeZmLWb9SvwA7wP7tu6SXeJLha+IxyMdnWxbQcxILXW7J
         0b1leoCbR/Mh3p+280yIuCjC+DYM2TGvpQyHOWlg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 036/107] s390/zcrypt: move ap device reset from bus to driver code
Date:   Fri, 24 Jan 2020 09:17:06 -0500
Message-Id: <20200124141817.28793-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 0c874cd04292c7ee22d70eefc341fa2648f41f46 ]

This patch moves the reset invocation of an ap device when
fresh detected from the ap bus to the probe() function of
the driver responsible for this device.

The virtualisation of ap devices makes it necessary to
remove unconditioned resets on fresh appearing apqn devices.
It may be that such a device is already enabled for guest
usage. So there may be a race condition between host ap bus
and guest ap bus doing the reset. This patch moves the
reset from the ap bus to the zcrypt drivers. So if there
is no zcrypt driver bound to an ap device - for example
the ap device is bound to the vfio device driver - the
ap device is untouched passed to the vfio device driver.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c       | 2 --
 drivers/s390/crypto/ap_bus.h       | 2 +-
 drivers/s390/crypto/ap_queue.c     | 5 +++--
 drivers/s390/crypto/zcrypt_cex2a.c | 1 +
 drivers/s390/crypto/zcrypt_cex2c.c | 2 ++
 drivers/s390/crypto/zcrypt_cex4.c  | 1 +
 6 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index a1915061932eb..5256e3ce84e56 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -793,8 +793,6 @@ static int ap_device_probe(struct device *dev)
 		drvres = ap_drv->flags & AP_DRIVER_FLAG_DEFAULT;
 		if (!!devres != !!drvres)
 			return -ENODEV;
-		/* (re-)init queue's state machine */
-		ap_queue_reinit_state(to_ap_queue(dev));
 	}
 
 	/* Add queue/card to list of active queues/cards */
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 433b7b64368d6..bb35ba4a8d243 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -261,7 +261,7 @@ void ap_queue_prepare_remove(struct ap_queue *aq);
 void ap_queue_remove(struct ap_queue *aq);
 void ap_queue_suspend(struct ap_device *ap_dev);
 void ap_queue_resume(struct ap_device *ap_dev);
-void ap_queue_reinit_state(struct ap_queue *aq);
+void ap_queue_init_state(struct ap_queue *aq);
 
 struct ap_card *ap_card_create(int id, int queue_depth, int raw_device_type,
 			       int comp_device_type, unsigned int functions);
diff --git a/drivers/s390/crypto/ap_queue.c b/drivers/s390/crypto/ap_queue.c
index dad2be333d826..37c3bdc3642dc 100644
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -638,7 +638,7 @@ struct ap_queue *ap_queue_create(ap_qid_t qid, int device_type)
 	aq->ap_dev.device.type = &ap_queue_type;
 	aq->ap_dev.device_type = device_type;
 	aq->qid = qid;
-	aq->state = AP_STATE_RESET_START;
+	aq->state = AP_STATE_UNBOUND;
 	aq->interrupt = AP_INTR_DISABLED;
 	spin_lock_init(&aq->lock);
 	INIT_LIST_HEAD(&aq->list);
@@ -771,10 +771,11 @@ void ap_queue_remove(struct ap_queue *aq)
 	spin_unlock_bh(&aq->lock);
 }
 
-void ap_queue_reinit_state(struct ap_queue *aq)
+void ap_queue_init_state(struct ap_queue *aq)
 {
 	spin_lock_bh(&aq->lock);
 	aq->state = AP_STATE_RESET_START;
 	ap_wait(ap_sm_event(aq, AP_EVENT_POLL));
 	spin_unlock_bh(&aq->lock);
 }
+EXPORT_SYMBOL(ap_queue_init_state);
diff --git a/drivers/s390/crypto/zcrypt_cex2a.c b/drivers/s390/crypto/zcrypt_cex2a.c
index c50f3e86cc748..7cbb384ec5352 100644
--- a/drivers/s390/crypto/zcrypt_cex2a.c
+++ b/drivers/s390/crypto/zcrypt_cex2a.c
@@ -175,6 +175,7 @@ static int zcrypt_cex2a_queue_probe(struct ap_device *ap_dev)
 	zq->queue = aq;
 	zq->online = 1;
 	atomic_set(&zq->load, 0);
+	ap_queue_init_state(aq);
 	ap_queue_init_reply(aq, &zq->reply);
 	aq->request_timeout = CEX2A_CLEANUP_TIME,
 	aq->private = zq;
diff --git a/drivers/s390/crypto/zcrypt_cex2c.c b/drivers/s390/crypto/zcrypt_cex2c.c
index 35c7c6672713b..c78c0d119806f 100644
--- a/drivers/s390/crypto/zcrypt_cex2c.c
+++ b/drivers/s390/crypto/zcrypt_cex2c.c
@@ -220,6 +220,7 @@ static int zcrypt_cex2c_queue_probe(struct ap_device *ap_dev)
 	zq->queue = aq;
 	zq->online = 1;
 	atomic_set(&zq->load, 0);
+	ap_rapq(aq->qid);
 	rc = zcrypt_cex2c_rng_supported(aq);
 	if (rc < 0) {
 		zcrypt_queue_free(zq);
@@ -231,6 +232,7 @@ static int zcrypt_cex2c_queue_probe(struct ap_device *ap_dev)
 	else
 		zq->ops = zcrypt_msgtype(MSGTYPE06_NAME,
 					 MSGTYPE06_VARIANT_NORNG);
+	ap_queue_init_state(aq);
 	ap_queue_init_reply(aq, &zq->reply);
 	aq->request_timeout = CEX2C_CLEANUP_TIME;
 	aq->private = zq;
diff --git a/drivers/s390/crypto/zcrypt_cex4.c b/drivers/s390/crypto/zcrypt_cex4.c
index 442e3d6162f76..6fabc906114c0 100644
--- a/drivers/s390/crypto/zcrypt_cex4.c
+++ b/drivers/s390/crypto/zcrypt_cex4.c
@@ -381,6 +381,7 @@ static int zcrypt_cex4_queue_probe(struct ap_device *ap_dev)
 	zq->queue = aq;
 	zq->online = 1;
 	atomic_set(&zq->load, 0);
+	ap_queue_init_state(aq);
 	ap_queue_init_reply(aq, &zq->reply);
 	aq->request_timeout = CEX4_CLEANUP_TIME,
 	aq->private = zq;
-- 
2.20.1

