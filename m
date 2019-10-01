Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7C0C387F
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 17:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389110AbfJAPEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 11:04:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:36704 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727185AbfJAPEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 11:04:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 291F6AF8E;
        Tue,  1 Oct 2019 15:04:38 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        James Dingwall <james@dingwall.me.uk>, stable@vger.kernel.org
Subject: [PATCH] xen/xenbus: fix self-deadlock after killing user process
Date:   Tue,  1 Oct 2019 17:03:55 +0200
Message-Id: <20191001150355.25365-1-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/xen/xenbus/xenbus_dev_frontend.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_dev_frontend.c b/drivers/xen/xenbus/xenbus_dev_frontend.c
index 08adc590f631..597af455a522 100644
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
@@ -300,14 +303,14 @@ static void watch_fired(struct xenbus_watch *watch,
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
@@ -333,6 +336,18 @@ static void xenbus_file_free(struct kref *kref)
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
@@ -650,6 +665,7 @@ static int xenbus_file_open(struct inode *inode, struct file *filp)
 	INIT_LIST_HEAD(&u->watches);
 	INIT_LIST_HEAD(&u->read_buffers);
 	init_waitqueue_head(&u->read_waitq);
+	INIT_WORK(&u->wq, xenbus_worker);
 
 	mutex_init(&u->reply_mutex);
 	mutex_init(&u->msgbuffer_mutex);
-- 
2.16.4

