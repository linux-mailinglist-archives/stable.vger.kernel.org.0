Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F297440E1F0
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbhIPQdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:33:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242203AbhIPQav (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:30:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE52D613D1;
        Thu, 16 Sep 2021 16:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809146;
        bh=mVY6VDyoC/BMHMwwisXg4lZ6mAsEcjrgdmnT83LbBDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKzE76gzoN5iC2gW0UvUKfQ5ZiRGh8dgaqEyf9wtCwIhqHvmLt30/Rh/9Zhf0gp/m
         iGdwKEEiOz6hveGJ556R66Tqy1RodmtltaXSTm9NG5TKu23TpTsC6AV30g6ajyB/NM
         Tpb+WRFBYpg/2ecuupzx1h9KCWDjoF28LEPak2Iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.13 048/380] s390/qdio: cancel the ESTABLISH ccw after timeout
Date:   Thu, 16 Sep 2021 17:56:45 +0200
Message-Id: <20210916155805.619479643@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

commit 1c1dc8bda3a05c60877a6649775894db5343bdea upstream.

When the ESTABLISH ccw does not complete within the specified timeout,
try our best to cancel the ccw program that is still active on the
device. Otherwise the IO subsystem might be accessing it even after
the driver eg. called qdio_free().

Fixes: 779e6e1c724d ("[S390] qdio: new qdio driver.")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 2.6.27
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/qdio_main.c |   51 +++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -886,6 +886,33 @@ static void qdio_shutdown_queues(struct
 	}
 }
 
+static int qdio_cancel_ccw(struct qdio_irq *irq, int how)
+{
+	struct ccw_device *cdev = irq->cdev;
+	int rc;
+
+	spin_lock_irq(get_ccwdev_lock(cdev));
+	qdio_set_state(irq, QDIO_IRQ_STATE_CLEANUP);
+	if (how & QDIO_FLAG_CLEANUP_USING_CLEAR)
+		rc = ccw_device_clear(cdev, QDIO_DOING_CLEANUP);
+	else
+		/* default behaviour is halt */
+		rc = ccw_device_halt(cdev, QDIO_DOING_CLEANUP);
+	spin_unlock_irq(get_ccwdev_lock(cdev));
+	if (rc) {
+		DBF_ERROR("%4x SHUTD ERR", irq->schid.sch_no);
+		DBF_ERROR("rc:%4d", rc);
+		return rc;
+	}
+
+	wait_event_interruptible_timeout(cdev->private->wait_q,
+					 irq->state == QDIO_IRQ_STATE_INACTIVE ||
+					 irq->state == QDIO_IRQ_STATE_ERR,
+					 10 * HZ);
+
+	return 0;
+}
+
 /**
  * qdio_shutdown - shut down a qdio subchannel
  * @cdev: associated ccw device
@@ -923,27 +950,7 @@ int qdio_shutdown(struct ccw_device *cde
 	qdio_shutdown_queues(irq_ptr);
 	qdio_shutdown_debug_entries(irq_ptr);
 
-	/* cleanup subchannel */
-	spin_lock_irq(get_ccwdev_lock(cdev));
-	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_CLEANUP);
-	if (how & QDIO_FLAG_CLEANUP_USING_CLEAR)
-		rc = ccw_device_clear(cdev, QDIO_DOING_CLEANUP);
-	else
-		/* default behaviour is halt */
-		rc = ccw_device_halt(cdev, QDIO_DOING_CLEANUP);
-	spin_unlock_irq(get_ccwdev_lock(cdev));
-	if (rc) {
-		DBF_ERROR("%4x SHUTD ERR", irq_ptr->schid.sch_no);
-		DBF_ERROR("rc:%4d", rc);
-		goto no_cleanup;
-	}
-
-	wait_event_interruptible_timeout(cdev->private->wait_q,
-		irq_ptr->state == QDIO_IRQ_STATE_INACTIVE ||
-		irq_ptr->state == QDIO_IRQ_STATE_ERR,
-		10 * HZ);
-
-no_cleanup:
+	rc = qdio_cancel_ccw(irq_ptr, how);
 	qdio_shutdown_thinint(irq_ptr);
 	qdio_shutdown_irq(irq_ptr);
 
@@ -1153,10 +1160,12 @@ int qdio_establish(struct ccw_device *cd
 	return 0;
 
 err_ccw_timeout:
+	qdio_cancel_ccw(irq_ptr, QDIO_FLAG_CLEANUP_USING_CLEAR);
 err_ccw_start:
 	qdio_shutdown_thinint(irq_ptr);
 err_thinint:
 	qdio_shutdown_irq(irq_ptr);
+	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_INACTIVE);
 	mutex_unlock(&irq_ptr->setup_mutex);
 	return rc;
 }


