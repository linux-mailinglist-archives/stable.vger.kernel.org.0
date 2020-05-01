Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C001C15CD
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgEANe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbgEANe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:34:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE21824954;
        Fri,  1 May 2020 13:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340065;
        bh=PfmHYvVYYPHRR8l7nqz1iLpSdLhmCb4oaAshHsMMEv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltiVQM3cj0846heQDqQt8ZJ36E1KwEOyaAbD/u2/EICqxt5XedL8vNJuzdUVymNS+
         AQe9JZmfr6JqfGPUWf3RaY9kMFIDzg/NiHu7BJ9oWab1+t07oMqo3E6GDFDS1RXGaf
         34BUHbPNEDxGRj6ySPdROgij7AyEBtaGZ0ZG0/3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.14 080/117] UAS: fix deadlock in error handling and PM flushing work
Date:   Fri,  1 May 2020 15:21:56 +0200
Message-Id: <20200501131554.357982006@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit f6cc6093a729ede1ff5658b493237c42b82ba107 upstream.

A SCSI error handler and block runtime PM must not allocate
memory with GFP_KERNEL. Furthermore they must not wait for
tasks allocating memory with GFP_KERNEL.
That means that they cannot share a workqueue with arbitrary tasks.

Fix this for UAS using a private workqueue.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: f9dc024a2da1f ("uas: pre_reset and suspend: Fix a few races")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200415141750.811-2-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas.c |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -82,6 +82,19 @@ static void uas_free_streams(struct uas_
 static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *prefix,
 				int status);
 
+/*
+ * This driver needs its own workqueue, as we need to control memory allocation.
+ *
+ * In the course of error handling and power management uas_wait_for_pending_cmnds()
+ * needs to flush pending work items. In these contexts we cannot allocate memory
+ * by doing block IO as we would deadlock. For the same reason we cannot wait
+ * for anything allocating memory not heeding these constraints.
+ *
+ * So we have to control all work items that can be on the workqueue we flush.
+ * Hence we cannot share a queue and need our own.
+ */
+static struct workqueue_struct *workqueue;
+
 static void uas_do_work(struct work_struct *work)
 {
 	struct uas_dev_info *devinfo =
@@ -110,7 +123,7 @@ static void uas_do_work(struct work_stru
 		if (!err)
 			cmdinfo->state &= ~IS_IN_WORK_LIST;
 		else
-			schedule_work(&devinfo->work);
+			queue_work(workqueue, &devinfo->work);
 	}
 out:
 	spin_unlock_irqrestore(&devinfo->lock, flags);
@@ -135,7 +148,7 @@ static void uas_add_work(struct uas_cmd_
 
 	lockdep_assert_held(&devinfo->lock);
 	cmdinfo->state |= IS_IN_WORK_LIST;
-	schedule_work(&devinfo->work);
+	queue_work(workqueue, &devinfo->work);
 }
 
 static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
@@ -1236,7 +1249,31 @@ static struct usb_driver uas_driver = {
 	.id_table = uas_usb_ids,
 };
 
-module_usb_driver(uas_driver);
+static int __init uas_init(void)
+{
+	int rv;
+
+	workqueue = alloc_workqueue("uas", WQ_MEM_RECLAIM, 0);
+	if (!workqueue)
+		return -ENOMEM;
+
+	rv = usb_register(&uas_driver);
+	if (rv) {
+		destroy_workqueue(workqueue);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void __exit uas_exit(void)
+{
+	usb_deregister(&uas_driver);
+	destroy_workqueue(workqueue);
+}
+
+module_init(uas_init);
+module_exit(uas_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(


