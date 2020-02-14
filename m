Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E955715E944
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391774AbgBNRF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392403AbgBNQOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:14:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAEDD246D2;
        Fri, 14 Feb 2020 16:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696892;
        bh=P1SJ9+iynCjlWWkLQ7A0vrCv0viYjd1MsT8k53BOelw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTeo7oHmfkje5Y0l6NoGHsSBRsvwK1FIEf0kp2MSBIuLhNYSpc0IIB2Ei3PBm/7UV
         XAIcbvU057M55xGBNVku5uhlnxSV7XrBh7Wm6axJZ595UTbZsjJtfy1QbPsM27ZAdV
         sNzlHy54A5KaP6FxMB1G3jYcUqL64QKrYfvrbwbY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 145/252] RDMA/core: Fix locking in ib_uverbs_event_read
Date:   Fri, 14 Feb 2020 11:10:00 -0500
Message-Id: <20200214161147.15842-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 14e23bd6d22123f6f3b2747701fa6cd4c6d05873 ]

This should not be using ib_dev to test for disassociation, during
disassociation is_closed is set under lock and the waitq is triggered.

Instead check is_closed and be sure to re-obtain the lock to test the
value after the wait_event returns.

Fixes: 036b10635739 ("IB/uverbs: Enable device removal when there are active user space applications")
Link: https://lore.kernel.org/r/1578504126-9400-12-git-send-email-yishaih@mellanox.com
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_main.c | 32 ++++++++++++---------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 357de3b4fdddf..5404717998b07 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -273,7 +273,6 @@ void ib_uverbs_release_file(struct kref *ref)
 }
 
 static ssize_t ib_uverbs_event_read(struct ib_uverbs_event_queue *ev_queue,
-				    struct ib_uverbs_file *uverbs_file,
 				    struct file *filp, char __user *buf,
 				    size_t count, loff_t *pos,
 				    size_t eventsz)
@@ -291,19 +290,16 @@ static ssize_t ib_uverbs_event_read(struct ib_uverbs_event_queue *ev_queue,
 
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
@@ -338,8 +334,7 @@ static ssize_t ib_uverbs_async_event_read(struct file *filp, char __user *buf,
 {
 	struct ib_uverbs_async_event_file *file = filp->private_data;
 
-	return ib_uverbs_event_read(&file->ev_queue, file->uverbs_file, filp,
-				    buf, count, pos,
+	return ib_uverbs_event_read(&file->ev_queue, filp, buf, count, pos,
 				    sizeof(struct ib_uverbs_async_event_desc));
 }
 
@@ -349,9 +344,8 @@ static ssize_t ib_uverbs_comp_event_read(struct file *filp, char __user *buf,
 	struct ib_uverbs_completion_event_file *comp_ev_file =
 		filp->private_data;
 
-	return ib_uverbs_event_read(&comp_ev_file->ev_queue,
-				    comp_ev_file->uobj.ufile, filp,
-				    buf, count, pos,
+	return ib_uverbs_event_read(&comp_ev_file->ev_queue, filp, buf, count,
+				    pos,
 				    sizeof(struct ib_uverbs_comp_event_desc));
 }
 
@@ -374,7 +368,9 @@ static __poll_t ib_uverbs_event_poll(struct ib_uverbs_event_queue *ev_queue,
 static __poll_t ib_uverbs_async_event_poll(struct file *filp,
 					       struct poll_table_struct *wait)
 {
-	return ib_uverbs_event_poll(filp->private_data, filp, wait);
+	struct ib_uverbs_async_event_file *file = filp->private_data;
+
+	return ib_uverbs_event_poll(&file->ev_queue, filp, wait);
 }
 
 static __poll_t ib_uverbs_comp_event_poll(struct file *filp,
@@ -388,9 +384,9 @@ static __poll_t ib_uverbs_comp_event_poll(struct file *filp,
 
 static int ib_uverbs_async_event_fasync(int fd, struct file *filp, int on)
 {
-	struct ib_uverbs_event_queue *ev_queue = filp->private_data;
+	struct ib_uverbs_async_event_file *file = filp->private_data;
 
-	return fasync_helper(fd, filp, on, &ev_queue->async_queue);
+	return fasync_helper(fd, filp, on, &file->ev_queue.async_queue);
 }
 
 static int ib_uverbs_comp_event_fasync(int fd, struct file *filp, int on)
-- 
2.20.1

