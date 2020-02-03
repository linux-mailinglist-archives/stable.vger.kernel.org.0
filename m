Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A897E150D0E
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbgBCQfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730922AbgBCQfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:35:11 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B1F92087E;
        Mon,  3 Feb 2020 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747710;
        bh=aQOpUWDKW8nzsv57PXVUcVKwFvdSssAFFA6dAs6Vs6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mplHI/pZPj+Pi/Yu2F8ecdYfLuQLTZk9TmExbvzOH1lyv1olb6gAxtlV/1LB+vFkS
         6Mpho68L9lK4TiczwrQZN55cIDwS2po2QfvIg/hHvnD/+O+LIjgal8YrNobjUURZm2
         qdEpg5OcM87GI5jwYqQeAYDqM+azvfCudeP1tb64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/90] s390/zcrypt: move ap device reset from bus to driver code
Date:   Mon,  3 Feb 2020 16:19:40 +0000
Message-Id: <20200203161922.565075558@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



