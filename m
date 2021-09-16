Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C1140E1E3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbhIPQcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243183AbhIPQaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 209FA613AD;
        Thu, 16 Sep 2021 16:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809143;
        bh=ItDa3DZB83Wn4oaMui8ZmDfswbUzyvlWkCkK2LB/1z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9Z0MkQ5os0RNjRK/rtYI6QwRHgPvlmMAmSBtPnoeME5vMLBnY3wQYFnloO1THxBl
         0psfR4qe2rUpEoyMEliRthiG6cpFrkdqryDVTdBQQH2iZsmjn9bDMveAvhV51wVDFZ
         MkTokfDKmdmYAnk9JXJMMZekXUw84177zmoDIQH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.13 047/380] s390/qdio: fix roll-back after timeout on ESTABLISH ccw
Date:   Thu, 16 Sep 2021 17:56:44 +0200
Message-Id: <20210916155805.586635600@linuxfoundation.org>
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

commit 2c197870e4701610ec3b1143808d4e31152caf30 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/qdio_main.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1079,6 +1079,7 @@ int qdio_establish(struct ccw_device *cd
 {
 	struct qdio_irq *irq_ptr = cdev->private->qdio_data;
 	struct subchannel_id schid;
+	long timeout;
 	int rc;
 
 	ccw_device_get_schid(cdev, &schid);
@@ -1107,11 +1108,8 @@ int qdio_establish(struct ccw_device *cd
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
@@ -1127,15 +1125,16 @@ int qdio_establish(struct ccw_device *cd
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
@@ -1152,6 +1151,14 @@ int qdio_establish(struct ccw_device *cd
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
 


