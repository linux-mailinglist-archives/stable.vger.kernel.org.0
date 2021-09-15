Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B480B40C5A1
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 14:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhIOMwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 08:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233060AbhIOMwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 08:52:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C95D611C1;
        Wed, 15 Sep 2021 12:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631710249;
        bh=LneLWTIh8SootRLNqOPVpYGodmXYqGk6kdzCHm1g1B0=;
        h=Subject:To:Cc:From:Date:From;
        b=RxNqMg1n8vHmfOXNNZmH5VaK4CycfuaoMHKSzzlNl9uX+e+iV7hRUeJiYLqXiz1Vg
         og2V/W7gDJQlUW1G7jN7PXOrL9+5Th3IjMK3aq74KJiNDhxZ8kZYR94G/oANcL2ikY
         O2UbSQcIEhVbYlTplcbQbfmTB/CF8cp3Qh7vuy6w=
Subject: FAILED: patch "[PATCH] s390/qdio: fix roll-back after timeout on ESTABLISH ccw" failed to apply to 5.4-stable tree
To:     jwi@linux.ibm.com, bblock@linux.ibm.com, hca@linux.ibm.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 14:50:41 +0200
Message-ID: <163171024116722@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2c197870e4701610ec3b1143808d4e31152caf30 Mon Sep 17 00:00:00 2001
From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Mon, 31 May 2021 18:40:06 +0300
Subject: [PATCH] s390/qdio: fix roll-back after timeout on ESTABLISH ccw

When qdio_establish() times out while waiting for the ESTABLISH ccw to
complete, it calls qdio_shutdown() to roll back all of its previous
actions. But at this point the qdio_irq's state is still
QDIO_IRQ_STATE_INACTIVE, so qdio_shutdown() will exit immediately
without doing any actual work.

Which means that eg. the qdio_irq's thinint-indicator stays registered,
and cdev->handler isn't restored to its old value. And since
commit 954d6235be41 ("s390/qdio: make thinint registration symmetric")
the qdio_irq also stays on the tiq_list, so on the next qdio_establish()
we might get a helpful BUG from the list-debugging code:

...
[ 4633.512591] list_add double add: new=00000000005a4110, prev=00000001b357db78, next=00000000005a4110.
[ 4633.512621] ------------[ cut here ]------------
[ 4633.512623] kernel BUG at lib/list_debug.c:29!
...
[ 4633.512796]  [<00000001b2c6ee9a>] __list_add_valid+0x82/0xa0
[ 4633.512798] ([<00000001b2c6ee96>] __list_add_valid+0x7e/0xa0)
[ 4633.512800]  [<00000001b2fcecce>] qdio_establish_thinint+0x116/0x190
[ 4633.512805]  [<00000001b2fcbe58>] qdio_establish+0x128/0x498
...

Fix this by extracting a goto-chain from the existing error exits in
qdio_establish(), and check the return value of the wait_event_...()
to detect the timeout condition.

Fixes: 779e6e1c724d ("[S390] qdio: new qdio driver.")
Root-caused-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 2.6.27
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 3052fab00597..32c8c46b19b6 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1083,6 +1083,7 @@ int qdio_establish(struct ccw_device *cdev,
 {
 	struct qdio_irq *irq_ptr = cdev->private->qdio_data;
 	struct subchannel_id schid;
+	long timeout;
 	int rc;
 
 	ccw_device_get_schid(cdev, &schid);
@@ -1111,11 +1112,8 @@ int qdio_establish(struct ccw_device *cdev,
 	qdio_setup_irq(irq_ptr, init_data);
 
 	rc = qdio_establish_thinint(irq_ptr);
-	if (rc) {
-		qdio_shutdown_irq(irq_ptr);
-		mutex_unlock(&irq_ptr->setup_mutex);
-		return rc;
-	}
+	if (rc)
+		goto err_thinint;
 
 	/* establish q */
 	irq_ptr->ccw.cmd_code = irq_ptr->equeue.cmd;
@@ -1131,15 +1129,16 @@ int qdio_establish(struct ccw_device *cdev,
 	if (rc) {
 		DBF_ERROR("%4x est IO ERR", irq_ptr->schid.sch_no);
 		DBF_ERROR("rc:%4x", rc);
-		qdio_shutdown_thinint(irq_ptr);
-		qdio_shutdown_irq(irq_ptr);
-		mutex_unlock(&irq_ptr->setup_mutex);
-		return rc;
+		goto err_ccw_start;
 	}
 
-	wait_event_interruptible_timeout(cdev->private->wait_q,
-		irq_ptr->state == QDIO_IRQ_STATE_ESTABLISHED ||
-		irq_ptr->state == QDIO_IRQ_STATE_ERR, HZ);
+	timeout = wait_event_interruptible_timeout(cdev->private->wait_q,
+						   irq_ptr->state == QDIO_IRQ_STATE_ESTABLISHED ||
+						   irq_ptr->state == QDIO_IRQ_STATE_ERR, HZ);
+	if (timeout <= 0) {
+		rc = (timeout == -ERESTARTSYS) ? -EINTR : -ETIME;
+		goto err_ccw_timeout;
+	}
 
 	if (irq_ptr->state != QDIO_IRQ_STATE_ESTABLISHED) {
 		mutex_unlock(&irq_ptr->setup_mutex);
@@ -1156,6 +1155,14 @@ int qdio_establish(struct ccw_device *cdev,
 	qdio_print_subchannel_info(irq_ptr);
 	qdio_setup_debug_entries(irq_ptr);
 	return 0;
+
+err_ccw_timeout:
+err_ccw_start:
+	qdio_shutdown_thinint(irq_ptr);
+err_thinint:
+	qdio_shutdown_irq(irq_ptr);
+	mutex_unlock(&irq_ptr->setup_mutex);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(qdio_establish);
 

