Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E2167266
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbgBUIDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731411AbgBUIDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:03:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1061A24656;
        Fri, 21 Feb 2020 08:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272185;
        bh=Q9pSyhjWV5SvvtwmyDEdygB3KIBvvGPOyzL0yVRKwfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAn6P3jNmivHAlbFGHEStAobILN6OUMBTMvwmf+rFNEsN7I1rii4z9JqM9pL9RgqN
         ef0VXd4s3Jxr4+09V0k6KMsvgvWCuSp/duizkyxGxtHcGzaavaK6gWqBWGzLz98gNr
         OpaPEom7vReSt8djHfetJGV1s3jCBQGwszMOZgd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/344] IB/core: Let IB core distribute cache update events
Date:   Fri, 21 Feb 2020 08:37:27 +0100
Message-Id: <20200221072353.456223858@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 6b57cea9221b0247ad5111b348522625e489a8e4 ]

Currently when the low level driver notifies Pkey, GID, and port change
events they are notified to the registered handlers in the order they are
registered.

IB core and other ULPs such as IPoIB are interested in GID, LID, Pkey
change events.

Since all GID queries done by ULPs are serviced by IB core, and the IB
core deferes cache updates to a work queue, it is possible for other
clients to see stale cache data when they handle their own events.

For example, the below call tree shows how ipoib will call
rdma_query_gid() concurrently with the update to the cache sitting in the
WQ.

mlx5_ib_handle_event()
  ib_dispatch_event()
    ib_cache_event()
       queue_work() -> slow cache update

    [..]
    ipoib_event()
     queue_work()
       [..]
       work handler
         ipoib_ib_dev_flush_light()
           __ipoib_ib_dev_flush()
              ipoib_dev_addr_changed_valid()
                rdma_query_gid() <- Returns old GID, cache not updated.

Move all the event dispatch to a work queue so that the cache update is
always done before any clients are notified.

Fixes: f35faa4ba956 ("IB/core: Simplify ib_query_gid to always refer to cache")
Link: https://lore.kernel.org/r/20191212113024.336702-3-leon@kernel.org
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c     | 121 +++++++++++++++++-----------
 drivers/infiniband/core/core_priv.h |   1 +
 drivers/infiniband/core/device.c    |  33 +++-----
 include/rdma/ib_verbs.h             |   9 ++-
 4 files changed, 92 insertions(+), 72 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 00fb3eacda194..65b10efca2b8c 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -51,9 +51,8 @@ struct ib_pkey_cache {
 
 struct ib_update_work {
 	struct work_struct work;
-	struct ib_device  *device;
-	u8                 port_num;
-	bool		   enforce_security;
+	struct ib_event event;
+	bool enforce_security;
 };
 
 union ib_gid zgid;
@@ -130,7 +129,7 @@ static void dispatch_gid_change_event(struct ib_device *ib_dev, u8 port)
 	event.element.port_num	= port;
 	event.event		= IB_EVENT_GID_CHANGE;
 
-	ib_dispatch_event(&event);
+	ib_dispatch_event_clients(&event);
 }
 
 static const char * const gid_type_str[] = {
@@ -1387,9 +1386,8 @@ err:
 	return ret;
 }
 
-static void ib_cache_update(struct ib_device *device,
-			    u8                port,
-			    bool	      enforce_security)
+static int
+ib_cache_update(struct ib_device *device, u8 port, bool enforce_security)
 {
 	struct ib_port_attr       *tprops = NULL;
 	struct ib_pkey_cache      *pkey_cache = NULL, *old_pkey_cache;
@@ -1397,11 +1395,11 @@ static void ib_cache_update(struct ib_device *device,
 	int                        ret;
 
 	if (!rdma_is_port_valid(device, port))
-		return;
+		return -EINVAL;
 
 	tprops = kmalloc(sizeof *tprops, GFP_KERNEL);
 	if (!tprops)
-		return;
+		return -ENOMEM;
 
 	ret = ib_query_port(device, port, tprops);
 	if (ret) {
@@ -1419,8 +1417,10 @@ static void ib_cache_update(struct ib_device *device,
 	pkey_cache = kmalloc(struct_size(pkey_cache, table,
 					 tprops->pkey_tbl_len),
 			     GFP_KERNEL);
-	if (!pkey_cache)
+	if (!pkey_cache) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	pkey_cache->table_len = tprops->pkey_tbl_len;
 
@@ -1452,50 +1452,84 @@ static void ib_cache_update(struct ib_device *device,
 
 	kfree(old_pkey_cache);
 	kfree(tprops);
-	return;
+	return 0;
 
 err:
 	kfree(pkey_cache);
 	kfree(tprops);
+	return ret;
+}
+
+static void ib_cache_event_task(struct work_struct *_work)
+{
+	struct ib_update_work *work =
+		container_of(_work, struct ib_update_work, work);
+	int ret;
+
+	/* Before distributing the cache update event, first sync
+	 * the cache.
+	 */
+	ret = ib_cache_update(work->event.device, work->event.element.port_num,
+			      work->enforce_security);
+
+	/* GID event is notified already for individual GID entries by
+	 * dispatch_gid_change_event(). Hence, notifiy for rest of the
+	 * events.
+	 */
+	if (!ret && work->event.event != IB_EVENT_GID_CHANGE)
+		ib_dispatch_event_clients(&work->event);
+
+	kfree(work);
 }
 
-static void ib_cache_task(struct work_struct *_work)
+static void ib_generic_event_task(struct work_struct *_work)
 {
 	struct ib_update_work *work =
 		container_of(_work, struct ib_update_work, work);
 
-	ib_cache_update(work->device,
-			work->port_num,
-			work->enforce_security);
+	ib_dispatch_event_clients(&work->event);
 	kfree(work);
 }
 
-static void ib_cache_event(struct ib_event_handler *handler,
-			   struct ib_event *event)
+static bool is_cache_update_event(const struct ib_event *event)
+{
+	return (event->event == IB_EVENT_PORT_ERR    ||
+		event->event == IB_EVENT_PORT_ACTIVE ||
+		event->event == IB_EVENT_LID_CHANGE  ||
+		event->event == IB_EVENT_PKEY_CHANGE ||
+		event->event == IB_EVENT_CLIENT_REREGISTER ||
+		event->event == IB_EVENT_GID_CHANGE);
+}
+
+/**
+ * ib_dispatch_event - Dispatch an asynchronous event
+ * @event:Event to dispatch
+ *
+ * Low-level drivers must call ib_dispatch_event() to dispatch the
+ * event to all registered event handlers when an asynchronous event
+ * occurs.
+ */
+void ib_dispatch_event(const struct ib_event *event)
 {
 	struct ib_update_work *work;
 
-	if (event->event == IB_EVENT_PORT_ERR    ||
-	    event->event == IB_EVENT_PORT_ACTIVE ||
-	    event->event == IB_EVENT_LID_CHANGE  ||
-	    event->event == IB_EVENT_PKEY_CHANGE ||
-	    event->event == IB_EVENT_CLIENT_REREGISTER ||
-	    event->event == IB_EVENT_GID_CHANGE) {
-		work = kmalloc(sizeof *work, GFP_ATOMIC);
-		if (work) {
-			INIT_WORK(&work->work, ib_cache_task);
-			work->device   = event->device;
-			work->port_num = event->element.port_num;
-			if (event->event == IB_EVENT_PKEY_CHANGE ||
-			    event->event == IB_EVENT_GID_CHANGE)
-				work->enforce_security = true;
-			else
-				work->enforce_security = false;
-
-			queue_work(ib_wq, &work->work);
-		}
-	}
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return;
+
+	if (is_cache_update_event(event))
+		INIT_WORK(&work->work, ib_cache_event_task);
+	else
+		INIT_WORK(&work->work, ib_generic_event_task);
+
+	work->event = *event;
+	if (event->event == IB_EVENT_PKEY_CHANGE ||
+	    event->event == IB_EVENT_GID_CHANGE)
+		work->enforce_security = true;
+
+	queue_work(ib_wq, &work->work);
 }
+EXPORT_SYMBOL(ib_dispatch_event);
 
 int ib_cache_setup_one(struct ib_device *device)
 {
@@ -1511,9 +1545,6 @@ int ib_cache_setup_one(struct ib_device *device)
 	rdma_for_each_port (device, p)
 		ib_cache_update(device, p, true);
 
-	INIT_IB_EVENT_HANDLER(&device->cache.event_handler,
-			      device, ib_cache_event);
-	ib_register_event_handler(&device->cache.event_handler);
 	return 0;
 }
 
@@ -1535,14 +1566,12 @@ void ib_cache_release_one(struct ib_device *device)
 
 void ib_cache_cleanup_one(struct ib_device *device)
 {
-	/* The cleanup function unregisters the event handler,
-	 * waits for all in-progress workqueue elements and cleans
-	 * up the GID cache. This function should be called after
-	 * the device was removed from the devices list and all
-	 * clients were removed, so the cache exists but is
+	/* The cleanup function waits for all in-progress workqueue
+	 * elements and cleans up the GID cache. This function should be
+	 * called after the device was removed from the devices list and
+	 * all clients were removed, so the cache exists but is
 	 * non-functional and shouldn't be updated anymore.
 	 */
-	ib_unregister_event_handler(&device->cache.event_handler);
 	flush_workqueue(ib_wq);
 	gid_table_cleanup_one(device);
 
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 9d07378b5b423..9b30773f2da05 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -149,6 +149,7 @@ unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port);
 int ib_cache_setup_one(struct ib_device *device);
 void ib_cache_cleanup_one(struct ib_device *device);
 void ib_cache_release_one(struct ib_device *device);
+void ib_dispatch_event_clients(struct ib_event *event);
 
 #ifdef CONFIG_CGROUP_RDMA
 void ib_device_register_rdmacg(struct ib_device *device);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 2b5bd7206fc6e..2a770b8dca003 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -591,6 +591,7 @@ struct ib_device *_ib_alloc_device(size_t size)
 
 	INIT_LIST_HEAD(&device->event_handler_list);
 	spin_lock_init(&device->event_handler_lock);
+	init_rwsem(&device->event_handler_rwsem);
 	mutex_init(&device->unregistration_lock);
 	/*
 	 * client_data needs to be alloc because we don't want our mark to be
@@ -1932,17 +1933,15 @@ EXPORT_SYMBOL(ib_set_client_data);
  *
  * ib_register_event_handler() registers an event handler that will be
  * called back when asynchronous IB events occur (as defined in
- * chapter 11 of the InfiniBand Architecture Specification).  This
- * callback may occur in interrupt context.
+ * chapter 11 of the InfiniBand Architecture Specification). This
+ * callback occurs in workqueue context.
  */
 void ib_register_event_handler(struct ib_event_handler *event_handler)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&event_handler->device->event_handler_lock, flags);
+	down_write(&event_handler->device->event_handler_rwsem);
 	list_add_tail(&event_handler->list,
 		      &event_handler->device->event_handler_list);
-	spin_unlock_irqrestore(&event_handler->device->event_handler_lock, flags);
+	up_write(&event_handler->device->event_handler_rwsem);
 }
 EXPORT_SYMBOL(ib_register_event_handler);
 
@@ -1955,35 +1954,23 @@ EXPORT_SYMBOL(ib_register_event_handler);
  */
 void ib_unregister_event_handler(struct ib_event_handler *event_handler)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&event_handler->device->event_handler_lock, flags);
+	down_write(&event_handler->device->event_handler_rwsem);
 	list_del(&event_handler->list);
-	spin_unlock_irqrestore(&event_handler->device->event_handler_lock, flags);
+	up_write(&event_handler->device->event_handler_rwsem);
 }
 EXPORT_SYMBOL(ib_unregister_event_handler);
 
-/**
- * ib_dispatch_event - Dispatch an asynchronous event
- * @event:Event to dispatch
- *
- * Low-level drivers must call ib_dispatch_event() to dispatch the
- * event to all registered event handlers when an asynchronous event
- * occurs.
- */
-void ib_dispatch_event(struct ib_event *event)
+void ib_dispatch_event_clients(struct ib_event *event)
 {
-	unsigned long flags;
 	struct ib_event_handler *handler;
 
-	spin_lock_irqsave(&event->device->event_handler_lock, flags);
+	down_read(&event->device->event_handler_rwsem);
 
 	list_for_each_entry(handler, &event->device->event_handler_list, list)
 		handler->handler(handler, event);
 
-	spin_unlock_irqrestore(&event->device->event_handler_lock, flags);
+	up_read(&event->device->event_handler_rwsem);
 }
-EXPORT_SYMBOL(ib_dispatch_event);
 
 static int iw_query_port(struct ib_device *device,
 			   u8 port_num,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 75c7b5ed53c59..30d50528d710e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2146,7 +2146,6 @@ struct ib_port_cache {
 
 struct ib_cache {
 	rwlock_t                lock;
-	struct ib_event_handler event_handler;
 };
 
 struct ib_port_immutable {
@@ -2590,7 +2589,11 @@ struct ib_device {
 	struct rcu_head rcu_head;
 
 	struct list_head              event_handler_list;
-	spinlock_t                    event_handler_lock;
+	/* Protects event_handler_list */
+	struct rw_semaphore event_handler_rwsem;
+
+	/* Protects QP's event_handler calls and open_qp list */
+	spinlock_t event_handler_lock;
 
 	struct rw_semaphore	      client_data_rwsem;
 	struct xarray                 client_data;
@@ -2897,7 +2900,7 @@ bool ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
 
 void ib_register_event_handler(struct ib_event_handler *event_handler);
 void ib_unregister_event_handler(struct ib_event_handler *event_handler);
-void ib_dispatch_event(struct ib_event *event);
+void ib_dispatch_event(const struct ib_event *event);
 
 int ib_query_port(struct ib_device *device,
 		  u8 port_num, struct ib_port_attr *port_attr);
-- 
2.20.1



