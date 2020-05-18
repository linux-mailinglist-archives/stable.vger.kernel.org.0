Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1481D83F0
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732465AbgERSIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733310AbgERSH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:07:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1739120715;
        Mon, 18 May 2020 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825247;
        bh=TXn1DxUnCCGY0e3NUiN/TVaWKAGUJhkS+rd7I4nVpSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGfzC0RFTfyqUXlQ5ltS32OMd5kAviXjJ476M5AipQ7OduX8qJnsPA4DqmX/65iCo
         ANncy2plOCJRdr7N6uzEVfpIZgH6St+9WUwXLLGknHYM8fhX0KCLbYFoyeNMt4axTU
         KJKx2FxbdS6xKbLYMrcuEqgRToYpcW/Da4/FFMU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.6 188/194] RDMA/uverbs: Move IB_EVENT_DEVICE_FATAL to destroy_uobj
Date:   Mon, 18 May 2020 19:37:58 +0200
Message-Id: <20200518173547.096472428@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit ccfdbaa5cf4601b9b71601893029dcc9245c002b upstream.

When multiple async FDs were allowed to exist the idea was for all
broadcast events to be delivered to all async FDs, however
IB_EVENT_DEVICE_FATAL was missed.

Instead of having ib_uverbs_free_hw_resources() special case the global
async_fd, have it cause the event during the uobject destruction. Every
async fd is now a uobject so simply generate the IB_EVENT_DEVICE_FATAL
while destroying the async fd uobject. This ensures every async FD gets a
copy of the event.

Fixes: d680e88e2013 ("RDMA/core: Add UVERBS_METHOD_ASYNC_EVENT_ALLOC")
Link: https://lore.kernel.org/r/20200507063348.98713-3-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/uverbs.h                    |    3 +++
 drivers/infiniband/core/uverbs_main.c               |   10 +++-------
 drivers/infiniband/core/uverbs_std_types_async_fd.c |    4 ++++
 3 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -228,6 +228,9 @@ void ib_uverbs_release_ucq(struct ib_uve
 			   struct ib_ucq_object *uobj);
 void ib_uverbs_release_uevent(struct ib_uevent_object *uobj);
 void ib_uverbs_release_file(struct kref *ref);
+void ib_uverbs_async_handler(struct ib_uverbs_async_event_file *async_file,
+			     __u64 element, __u64 event,
+			     struct list_head *obj_list, u32 *counter);
 
 void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context);
 void ib_uverbs_cq_event_handler(struct ib_event *event, void *context_ptr);
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -386,10 +386,9 @@ void ib_uverbs_comp_handler(struct ib_cq
 	kill_fasync(&ev_queue->async_queue, SIGIO, POLL_IN);
 }
 
-static void
-ib_uverbs_async_handler(struct ib_uverbs_async_event_file *async_file,
-			__u64 element, __u64 event, struct list_head *obj_list,
-			u32 *counter)
+void ib_uverbs_async_handler(struct ib_uverbs_async_event_file *async_file,
+			     __u64 element, __u64 event,
+			     struct list_head *obj_list, u32 *counter)
 {
 	struct ib_uverbs_event *entry;
 	unsigned long flags;
@@ -1187,9 +1186,6 @@ static void ib_uverbs_free_hw_resources(
 		 */
 		mutex_unlock(&uverbs_dev->lists_mutex);
 
-		ib_uverbs_async_handler(READ_ONCE(file->async_file), 0,
-					IB_EVENT_DEVICE_FATAL, NULL, NULL);
-
 		uverbs_destroy_ufile_hw(file, RDMA_REMOVE_DRIVER_REMOVE);
 		kref_put(&file->ref, ib_uverbs_release_file);
 
--- a/drivers/infiniband/core/uverbs_std_types_async_fd.c
+++ b/drivers/infiniband/core/uverbs_std_types_async_fd.c
@@ -26,6 +26,10 @@ static int uverbs_async_event_destroy_uo
 		container_of(uobj, struct ib_uverbs_async_event_file, uobj);
 
 	ib_unregister_event_handler(&event_file->event_handler);
+
+	if (why == RDMA_REMOVE_DRIVER_REMOVE)
+		ib_uverbs_async_handler(event_file, 0, IB_EVENT_DEVICE_FATAL,
+					NULL, NULL);
 	return 0;
 }
 


