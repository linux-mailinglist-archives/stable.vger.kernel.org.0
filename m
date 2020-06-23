Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9E1205D05
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387797AbgFWUH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388678AbgFWUHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:07:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68CE12082F;
        Tue, 23 Jun 2020 20:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942874;
        bh=X61rj44CRvPjMIclrt+UCbO0Ch259GU8VWfsCnwJ99c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oS1FVFbKruL9eX2W9sV05ToKmGHznyV9z1gwoKPx1fTkH5I9zc1q5/HKd/rAJwfJd
         kGeI8qjZXA91sr0lfX0AgL9Xa2HUecwbB+OPrTgXqb7LfCowJZ3JTEEtT1JyXJnwfj
         hqG6APRvfwKaCUm9Vj4GpkUcx+dONbPaW0NGsvC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 138/477] s390/qdio: consistently restore the IRQ handler
Date:   Tue, 23 Jun 2020 21:52:15 +0200
Message-Id: <20200623195414.129419213@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b8453b5946794..3cf223bc1d5f4 100644
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
index bcc3ab14e72df..da5a111380201 100644
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
index 3083edd61f0c9..d12f094db056e 100644
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



