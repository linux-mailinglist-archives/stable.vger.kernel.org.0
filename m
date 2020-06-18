Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738D01FDB46
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgFRBLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbgFRBLN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A661A21924;
        Thu, 18 Jun 2020 01:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442672;
        bh=YFTJa+HvpxMV4S42oT+hHR5+/K8PlVawtEBZhz5eoBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYcpGOLkXDGyieWWTNzyfXGu0L3ykyvl3+AbRS076ihHZguT64fgSsPyubLoXnocv
         9TEBBaNte76wPo+3GdjqJeoEgwFkk4jeCTZwfZ9tvF6M9lmxHUGAp2OXU38Zv79jeR
         DUGzZAPh8Ndf1zK5W5t8z7eZbvlXwr4Qcn6qtXjk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 141/388] s390/qdio: consistently restore the IRQ handler
Date:   Wed, 17 Jun 2020 21:03:58 -0400
Message-Id: <20200618010805.600873-141-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 7b942b4be971d49cb185ce4690d7fbf94636e88a ]

For rolling back after an error, qdio_establish() calls qdio_shutdown().
If the error occurs early enough, then the qdio_irq's state still is
QDIO_IRQ_STATE_INACTIVE and qdio_shutdown() does nothing.

But at _any_ point where qdio_establish() bails out in this way,
qdio_setup_irq() will have already replaced the IRQ handler. This then
won't be restored after an early error, and the device can end up being
returned to the device driver with qdio's IRQ handler still installed.

Slightly reorder qdio_setup_irq() so we can be 100% sure that the IRQ
handler was replaced. Then fix the bug in qdio_establish() by calling a
helper that rolls back only the IRQ handler modification.

Also use the new helper in qdio_shutdown() to keep things in sync, and
slightly clean up the locking while doing so.
This makes minor semantical changes, but holding setup_mutex gives us
sufficient leeway to eg. pull qdio_shutdown_thinint() outside of the
ccwdev lock's scope.

Fixes: 779e6e1c724d ("[S390] qdio: new qdio driver.")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/qdio.h       |  1 +
 drivers/s390/cio/qdio_main.c  | 18 +++++-------------
 drivers/s390/cio/qdio_setup.c | 20 ++++++++++++++++----
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index b8453b594679..3cf223bc1d5f 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -389,6 +389,7 @@ int qdio_setup_get_ssqd(struct qdio_irq *irq_ptr,
 			struct subchannel_id *schid,
 			struct qdio_ssqd_desc *data);
 int qdio_setup_irq(struct qdio_irq *irq_ptr, struct qdio_initialize *init_data);
+void qdio_shutdown_irq(struct qdio_irq *irq);
 void qdio_print_subchannel_info(struct qdio_irq *irq_ptr);
 void qdio_release_memory(struct qdio_irq *irq_ptr);
 int qdio_setup_init(void);
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index bcc3ab14e72d..da5a11138020 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1154,35 +1154,27 @@ int qdio_shutdown(struct ccw_device *cdev, int how)
 
 	/* cleanup subchannel */
 	spin_lock_irq(get_ccwdev_lock(cdev));
-
+	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_CLEANUP);
 	if (how & QDIO_FLAG_CLEANUP_USING_CLEAR)
 		rc = ccw_device_clear(cdev, QDIO_DOING_CLEANUP);
 	else
 		/* default behaviour is halt */
 		rc = ccw_device_halt(cdev, QDIO_DOING_CLEANUP);
+	spin_unlock_irq(get_ccwdev_lock(cdev));
 	if (rc) {
 		DBF_ERROR("%4x SHUTD ERR", irq_ptr->schid.sch_no);
 		DBF_ERROR("rc:%4d", rc);
 		goto no_cleanup;
 	}
 
-	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_CLEANUP);
-	spin_unlock_irq(get_ccwdev_lock(cdev));
 	wait_event_interruptible_timeout(cdev->private->wait_q,
 		irq_ptr->state == QDIO_IRQ_STATE_INACTIVE ||
 		irq_ptr->state == QDIO_IRQ_STATE_ERR,
 		10 * HZ);
-	spin_lock_irq(get_ccwdev_lock(cdev));
 
 no_cleanup:
 	qdio_shutdown_thinint(irq_ptr);
-
-	/* restore interrupt handler */
-	if ((void *)cdev->handler == (void *)qdio_int_handler) {
-		cdev->handler = irq_ptr->orig_handler;
-		cdev->private->intparm = 0;
-	}
-	spin_unlock_irq(get_ccwdev_lock(cdev));
+	qdio_shutdown_irq(irq_ptr);
 
 	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_INACTIVE);
 	mutex_unlock(&irq_ptr->setup_mutex);
@@ -1352,8 +1344,8 @@ int qdio_establish(struct ccw_device *cdev,
 
 	rc = qdio_establish_thinint(irq_ptr);
 	if (rc) {
+		qdio_shutdown_irq(irq_ptr);
 		mutex_unlock(&irq_ptr->setup_mutex);
-		qdio_shutdown(cdev, QDIO_FLAG_CLEANUP_USING_CLEAR);
 		return rc;
 	}
 
@@ -1371,8 +1363,8 @@ int qdio_establish(struct ccw_device *cdev,
 	if (rc) {
 		DBF_ERROR("%4x est IO ERR", irq_ptr->schid.sch_no);
 		DBF_ERROR("rc:%4x", rc);
+		qdio_shutdown_irq(irq_ptr);
 		mutex_unlock(&irq_ptr->setup_mutex);
-		qdio_shutdown(cdev, QDIO_FLAG_CLEANUP_USING_CLEAR);
 		return rc;
 	}
 
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index 3083edd61f0c..d12f094db056 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -491,6 +491,12 @@ int qdio_setup_irq(struct qdio_irq *irq_ptr, struct qdio_initialize *init_data)
 
 	/* qdr, qib, sls, slsbs, slibs, sbales are filled now */
 
+	/* set our IRQ handler */
+	spin_lock_irq(get_ccwdev_lock(cdev));
+	irq_ptr->orig_handler = cdev->handler;
+	cdev->handler = qdio_int_handler;
+	spin_unlock_irq(get_ccwdev_lock(cdev));
+
 	/* get qdio commands */
 	ciw = ccw_device_get_ciw(cdev, CIW_TYPE_EQUEUE);
 	if (!ciw) {
@@ -506,12 +512,18 @@ int qdio_setup_irq(struct qdio_irq *irq_ptr, struct qdio_initialize *init_data)
 	}
 	irq_ptr->aqueue = *ciw;
 
-	/* set new interrupt handler */
+	return 0;
+}
+
+void qdio_shutdown_irq(struct qdio_irq *irq)
+{
+	struct ccw_device *cdev = irq->cdev;
+
+	/* restore IRQ handler */
 	spin_lock_irq(get_ccwdev_lock(cdev));
-	irq_ptr->orig_handler = cdev->handler;
-	cdev->handler = qdio_int_handler;
+	cdev->handler = irq->orig_handler;
+	cdev->private->intparm = 0;
 	spin_unlock_irq(get_ccwdev_lock(cdev));
-	return 0;
 }
 
 void qdio_print_subchannel_info(struct qdio_irq *irq_ptr)
-- 
2.25.1

