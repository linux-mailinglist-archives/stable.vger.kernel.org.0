Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448361F2DCA
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgFHXNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729530AbgFHXNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1151320C09;
        Mon,  8 Jun 2020 23:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658018;
        bh=eQL/+0ePE1H1rx1MzZmNKPOckAY08l+N/zU64kPQEBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOWsZUlglupL7r1XrSwkAFWcOcdcTd/CpexrCDHc/j3RA+lOXAsR/NZqueRDUlc7p
         L1vPoM1nIT0wZNN74PaxIBPO8Qal+ySmOmIExF3gHD8nXEgXkFlQrS8ReXph6YilUN
         INcZJFPAKie5aneB5jC71Ex7wxCKQ0jMTDFnRVGc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 072/606] RDMA/uverbs: Move IB_EVENT_DEVICE_FATAL to destroy_uobj
Date:   Mon,  8 Jun 2020 19:03:17 -0400
Message-Id: <20200608231211.3363633-72-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/infiniband/core/uverbs.h                    |  3 +++
 drivers/infiniband/core/uverbs_main.c               | 10 +++-------
 drivers/infiniband/core/uverbs_std_types_async_fd.c |  4 ++++
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 2673cb1cd655..3d189c7ee59e 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -228,6 +228,9 @@ void ib_uverbs_release_ucq(struct ib_uverbs_completion_event_file *ev_file,
 			   struct ib_ucq_object *uobj);
 void ib_uverbs_release_uevent(struct ib_uevent_object *uobj);
 void ib_uverbs_release_file(struct kref *ref);
+void ib_uverbs_async_handler(struct ib_uverbs_async_event_file *async_file,
+			     __u64 element, __u64 event,
+			     struct list_head *obj_list, u32 *counter);
 
 void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context);
 void ib_uverbs_cq_event_handler(struct ib_event *event, void *context_ptr);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index cb5b59123d8f..1bab8de14757 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -386,10 +386,9 @@ void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context)
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
@@ -1187,9 +1186,6 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 		 */
 		mutex_unlock(&uverbs_dev->lists_mutex);
 
-		ib_uverbs_async_handler(READ_ONCE(file->async_file), 0,
-					IB_EVENT_DEVICE_FATAL, NULL, NULL);
-
 		uverbs_destroy_ufile_hw(file, RDMA_REMOVE_DRIVER_REMOVE);
 		kref_put(&file->ref, ib_uverbs_release_file);
 
diff --git a/drivers/infiniband/core/uverbs_std_types_async_fd.c b/drivers/infiniband/core/uverbs_std_types_async_fd.c
index 462deb506b16..61899eaf1f91 100644
--- a/drivers/infiniband/core/uverbs_std_types_async_fd.c
+++ b/drivers/infiniband/core/uverbs_std_types_async_fd.c
@@ -26,6 +26,10 @@ static int uverbs_async_event_destroy_uobj(struct ib_uobject *uobj,
 		container_of(uobj, struct ib_uverbs_async_event_file, uobj);
 
 	ib_unregister_event_handler(&event_file->event_handler);
+
+	if (why == RDMA_REMOVE_DRIVER_REMOVE)
+		ib_uverbs_async_handler(event_file, 0, IB_EVENT_DEVICE_FATAL,
+					NULL, NULL);
 	return 0;
 }
 
-- 
2.25.1

