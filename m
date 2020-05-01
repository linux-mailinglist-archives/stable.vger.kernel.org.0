Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2401C130C
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgEAN0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729278AbgEAN0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:26:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0804020757;
        Fri,  1 May 2020 13:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339593;
        bh=a1+FXtok+TTkSt4b7dyUP5VrL5ZhVpYgHALlc/p/cAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUEbaB1i06itJecqmXBPo67wiIoAzBWTPPAmdQjq3bY85lWvqQG8rzrBjRH0lkM1F
         atqagX5wKDQlJrNWnEDBg+4LvEtp+zvpA8bq0Sos+C+OBLUrq/ywQg6Mulu6+45Tir
         G7c6RMRGYFTTHt6LrJi1ZdOd5NyM1VV8MKu9O97E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.4 52/70] UAS: fix deadlock in error handling and PM flushing work
Date:   Fri,  1 May 2020 15:21:40 +0200
Message-Id: <20200501131529.454780848@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
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
@@ -1176,7 +1189,31 @@ static struct usb_driver uas_driver = {
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


