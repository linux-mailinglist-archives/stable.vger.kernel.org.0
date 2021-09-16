Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD13440E54D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344854AbhIPRKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349988AbhIPRIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:08:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F3226138D;
        Thu, 16 Sep 2021 16:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810208;
        bh=1N9u0hH3YUIgCGrBypF7a9d4IO7AmLIUTd4bbjnuavQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQ4TWsIOD4u8/vGYCENFfWBH8n97oBOOcThN+0qSZqGvpyzITUonJHoyya6wr3K4b
         bVFiVkGzHcU87Tf6WBitW0In5d3Do0cdKvYePSOQ1aAFyQNHkezyAAC9eY9tIJa6hM
         PTeiRkTE/DXSoXA7Nav+TFDtj3JgjlyBeah/y+9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.14 055/432] s390/qdio: cancel the ESTABLISH ccw after timeout
Date:   Thu, 16 Sep 2021 17:56:44 +0200
Message-Id: <20210916155812.663328141@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
@@ -890,6 +890,33 @@ static void qdio_shutdown_queues(struct
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
@@ -927,27 +954,7 @@ int qdio_shutdown(struct ccw_device *cde
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
 
@@ -1157,10 +1164,12 @@ int qdio_establish(struct ccw_device *cd
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


