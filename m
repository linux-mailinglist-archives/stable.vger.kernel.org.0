Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F1C15C425
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387679AbgBMP1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728933AbgBMP1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:07 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCD26206DB;
        Thu, 13 Feb 2020 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607625;
        bh=BJPUC+Pua1rzB3+wAh4ZHva9Wdewqir9ahqmes+T8KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3Mu+nMyTUVt/9l9I6t7CeYHhG7iNcvrxwCzPsZk+Jczh7wmIU1G9zmtxqSBUb8+1
         kK6fgQCWyp4Xv87bqbaT7pRal/r1CPIANH7IBk1yq0xy/zthmleqNg5/LySDjX+gdq
         vAelUMOrK/Gty+aAngQ4J5pWPzOuwA8DDY8+XgOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 08/96] RDMA/core: Fix locking in ib_uverbs_event_read
Date:   Thu, 13 Feb 2020 07:20:15 -0800
Message-Id: <20200213151842.427279455@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 14e23bd6d22123f6f3b2747701fa6cd4c6d05873 upstream.

This should not be using ib_dev to test for disassociation, during
disassociation is_closed is set under lock and the waitq is triggered.

Instead check is_closed and be sure to re-obtain the lock to test the
value after the wait_event returns.

Fixes: 036b10635739 ("IB/uverbs: Enable device removal when there are active user space applications")
Link: https://lore.kernel.org/r/1578504126-9400-12-git-send-email-yishaih@mellanox.com
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/uverbs_main.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -220,7 +220,6 @@ void ib_uverbs_release_file(struct kref
 }
 
 static ssize_t ib_uverbs_event_read(struct ib_uverbs_event_queue *ev_queue,
-				    struct ib_uverbs_file *uverbs_file,
 				    struct file *filp, char __user *buf,
 				    size_t count, loff_t *pos,
 				    size_t eventsz)
@@ -238,19 +237,16 @@ static ssize_t ib_uverbs_event_read(stru
 
 		if (wait_event_interruptible(ev_queue->poll_wait,
 					     (!list_empty(&ev_queue->event_list) ||
-			/* The barriers built into wait_event_interruptible()
-			 * and wake_up() guarentee this will see the null set
-			 * without using RCU
-			 */
-					     !uverbs_file->device->ib_dev)))
+					      ev_queue->is_closed)))
 			return -ERESTARTSYS;
 
+		spin_lock_irq(&ev_queue->lock);
+
 		/* If device was disassociated and no event exists set an error */
-		if (list_empty(&ev_queue->event_list) &&
-		    !uverbs_file->device->ib_dev)
+		if (list_empty(&ev_queue->event_list) && ev_queue->is_closed) {
+			spin_unlock_irq(&ev_queue->lock);
 			return -EIO;
-
-		spin_lock_irq(&ev_queue->lock);
+		}
 	}
 
 	event = list_entry(ev_queue->event_list.next, struct ib_uverbs_event, list);
@@ -285,8 +281,7 @@ static ssize_t ib_uverbs_async_event_rea
 {
 	struct ib_uverbs_async_event_file *file = filp->private_data;
 
-	return ib_uverbs_event_read(&file->ev_queue, file->uverbs_file, filp,
-				    buf, count, pos,
+	return ib_uverbs_event_read(&file->ev_queue, filp, buf, count, pos,
 				    sizeof(struct ib_uverbs_async_event_desc));
 }
 
@@ -296,9 +291,8 @@ static ssize_t ib_uverbs_comp_event_read
 	struct ib_uverbs_completion_event_file *comp_ev_file =
 		filp->private_data;
 
-	return ib_uverbs_event_read(&comp_ev_file->ev_queue,
-				    comp_ev_file->uobj.ufile, filp,
-				    buf, count, pos,
+	return ib_uverbs_event_read(&comp_ev_file->ev_queue, filp, buf, count,
+				    pos,
 				    sizeof(struct ib_uverbs_comp_event_desc));
 }
 
@@ -321,7 +315,9 @@ static __poll_t ib_uverbs_event_poll(str
 static __poll_t ib_uverbs_async_event_poll(struct file *filp,
 					       struct poll_table_struct *wait)
 {
-	return ib_uverbs_event_poll(filp->private_data, filp, wait);
+	struct ib_uverbs_async_event_file *file = filp->private_data;
+
+	return ib_uverbs_event_poll(&file->ev_queue, filp, wait);
 }
 
 static __poll_t ib_uverbs_comp_event_poll(struct file *filp,
@@ -335,9 +331,9 @@ static __poll_t ib_uverbs_comp_event_pol
 
 static int ib_uverbs_async_event_fasync(int fd, struct file *filp, int on)
 {
-	struct ib_uverbs_event_queue *ev_queue = filp->private_data;
+	struct ib_uverbs_async_event_file *file = filp->private_data;
 
-	return fasync_helper(fd, filp, on, &ev_queue->async_queue);
+	return fasync_helper(fd, filp, on, &file->ev_queue.async_queue);
 }
 
 static int ib_uverbs_comp_event_fasync(int fd, struct file *filp, int on)


