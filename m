Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65350D2403
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388858AbfJJIsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389598AbfJJIsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:48:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB50D2064A;
        Thu, 10 Oct 2019 08:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697291;
        bh=96xU/UJbV7dJS5rO1/HhxRqUpWrLzRq1hWiaKmwL2lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSqtK31kyyN8WTLiyzRdbGa+s7YFdKxg/cFECCQwM1Gad+U8Xk6lshlzlZImkZouF
         0nVzwpYJox7x+v8T7iATg7VzS3z3bI1ubD7MQGIYOod2AVCOjIqRromd8dJ8qVSwuO
         quI+Hp0cDe22127QmUjJIOboEWybgH4VXrMOqmTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Dingwall <james@dingwall.me.uk>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.19 044/114] xen/xenbus: fix self-deadlock after killing user process
Date:   Thu, 10 Oct 2019 10:35:51 +0200
Message-Id: <20191010083607.168447531@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit a8fabb38525c51a094607768bac3ba46b3f4a9d5 upstream.

In case a user process using xenbus has open transactions and is killed
e.g. via ctrl-C the following cleanup of the allocated resources might
result in a deadlock due to trying to end a transaction in the xenbus
worker thread:

[ 2551.474706] INFO: task xenbus:37 blocked for more than 120 seconds.
[ 2551.492215]       Tainted: P           OE     5.0.0-29-generic #5
[ 2551.510263] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2551.528585] xenbus          D    0    37      2 0x80000080
[ 2551.528590] Call Trace:
[ 2551.528603]  __schedule+0x2c0/0x870
[ 2551.528606]  ? _cond_resched+0x19/0x40
[ 2551.528632]  schedule+0x2c/0x70
[ 2551.528637]  xs_talkv+0x1ec/0x2b0
[ 2551.528642]  ? wait_woken+0x80/0x80
[ 2551.528645]  xs_single+0x53/0x80
[ 2551.528648]  xenbus_transaction_end+0x3b/0x70
[ 2551.528651]  xenbus_file_free+0x5a/0x160
[ 2551.528654]  xenbus_dev_queue_reply+0xc4/0x220
[ 2551.528657]  xenbus_thread+0x7de/0x880
[ 2551.528660]  ? wait_woken+0x80/0x80
[ 2551.528665]  kthread+0x121/0x140
[ 2551.528667]  ? xb_read+0x1d0/0x1d0
[ 2551.528670]  ? kthread_park+0x90/0x90
[ 2551.528673]  ret_from_fork+0x35/0x40

Fix this by doing the cleanup via a workqueue instead.

Reported-by: James Dingwall <james@dingwall.me.uk>
Fixes: fd8aa9095a95c ("xen: optimize xenbus driver for multiple concurrent xenstore accesses")
Cc: <stable@vger.kernel.org> # 4.11
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xenbus/xenbus_dev_frontend.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/xen/xenbus/xenbus_dev_frontend.c
+++ b/drivers/xen/xenbus/xenbus_dev_frontend.c
@@ -55,6 +55,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/miscdevice.h>
+#include <linux/workqueue.h>
 
 #include <xen/xenbus.h>
 #include <xen/xen.h>
@@ -116,6 +117,8 @@ struct xenbus_file_priv {
 	wait_queue_head_t read_waitq;
 
 	struct kref kref;
+
+	struct work_struct wq;
 };
 
 /* Read out any raw xenbus messages queued up. */
@@ -300,14 +303,14 @@ static void watch_fired(struct xenbus_wa
 	mutex_unlock(&adap->dev_data->reply_mutex);
 }
 
-static void xenbus_file_free(struct kref *kref)
+static void xenbus_worker(struct work_struct *wq)
 {
 	struct xenbus_file_priv *u;
 	struct xenbus_transaction_holder *trans, *tmp;
 	struct watch_adapter *watch, *tmp_watch;
 	struct read_buffer *rb, *tmp_rb;
 
-	u = container_of(kref, struct xenbus_file_priv, kref);
+	u = container_of(wq, struct xenbus_file_priv, wq);
 
 	/*
 	 * No need for locking here because there are no other users,
@@ -333,6 +336,18 @@ static void xenbus_file_free(struct kref
 	kfree(u);
 }
 
+static void xenbus_file_free(struct kref *kref)
+{
+	struct xenbus_file_priv *u;
+
+	/*
+	 * We might be called in xenbus_thread().
+	 * Use workqueue to avoid deadlock.
+	 */
+	u = container_of(kref, struct xenbus_file_priv, kref);
+	schedule_work(&u->wq);
+}
+
 static struct xenbus_transaction_holder *xenbus_get_transaction(
 	struct xenbus_file_priv *u, uint32_t tx_id)
 {
@@ -652,6 +667,7 @@ static int xenbus_file_open(struct inode
 	INIT_LIST_HEAD(&u->watches);
 	INIT_LIST_HEAD(&u->read_buffers);
 	init_waitqueue_head(&u->read_waitq);
+	INIT_WORK(&u->wq, xenbus_worker);
 
 	mutex_init(&u->reply_mutex);
 	mutex_init(&u->msgbuffer_mutex);


