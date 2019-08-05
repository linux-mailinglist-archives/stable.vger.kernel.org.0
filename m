Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5194B81CC5
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbfHEN1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730716AbfHENZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 969CE20644;
        Mon,  5 Aug 2019 13:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011523;
        bh=q4cx6ERxCg35OXauZh1EdpLoel4i0GeKje0usDm2w3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkiy3Y5BfViM3KngXBMDVyFRW76mYC4E3AuEHE+ewlfc0E97TFTm3O4YcmXV4DYHF
         U/aeeOk9SzCr8kvKDhmHodMbUr/eEale/MDkRUPl+pY2gQ4IrihrLrE1Qt3KuGxbqL
         Aml3dJTQItzvc97+r6koudeX6C+OeZ9BY00K753c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.2 121/131] RDMA/devices: Do not deadlock during client removal
Date:   Mon,  5 Aug 2019 15:03:28 +0200
Message-Id: <20190805125000.066370950@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 621e55ff5b8e0ab5d1063f0eae0ef3960bef8f6e upstream.

lockdep reports:

   WARNING: possible circular locking dependency detected

   modprobe/302 is trying to acquire lock:
   0000000007c8919c ((wq_completion)ib_cm){+.+.}, at: flush_workqueue+0xdf/0x990

   but task is already holding lock:
   000000002d3d2ca9 (&device->client_data_rwsem){++++}, at: remove_client_context+0x79/0xd0 [ib_core]

   which lock already depends on the new lock.

   the existing dependency chain (in reverse order) is:

   -> #2 (&device->client_data_rwsem){++++}:
          down_read+0x3f/0x160
          ib_get_net_dev_by_params+0xd5/0x200 [ib_core]
          cma_ib_req_handler+0x5f6/0x2090 [rdma_cm]
          cm_process_work+0x29/0x110 [ib_cm]
          cm_req_handler+0x10f5/0x1c00 [ib_cm]
          cm_work_handler+0x54c/0x311d [ib_cm]
          process_one_work+0x4aa/0xa30
          worker_thread+0x62/0x5b0
          kthread+0x1ca/0x1f0
          ret_from_fork+0x24/0x30

   -> #1 ((work_completion)(&(&work->work)->work)){+.+.}:
          process_one_work+0x45f/0xa30
          worker_thread+0x62/0x5b0
          kthread+0x1ca/0x1f0
          ret_from_fork+0x24/0x30

   -> #0 ((wq_completion)ib_cm){+.+.}:
          lock_acquire+0xc8/0x1d0
          flush_workqueue+0x102/0x990
          cm_remove_one+0x30e/0x3c0 [ib_cm]
          remove_client_context+0x94/0xd0 [ib_core]
          disable_device+0x10a/0x1f0 [ib_core]
          __ib_unregister_device+0x5a/0xe0 [ib_core]
          ib_unregister_device+0x21/0x30 [ib_core]
          mlx5_ib_stage_ib_reg_cleanup+0x9/0x10 [mlx5_ib]
          __mlx5_ib_remove+0x3d/0x70 [mlx5_ib]
          mlx5_ib_remove+0x12e/0x140 [mlx5_ib]
          mlx5_remove_device+0x144/0x150 [mlx5_core]
          mlx5_unregister_interface+0x3f/0xf0 [mlx5_core]
          mlx5_ib_cleanup+0x10/0x3a [mlx5_ib]
          __x64_sys_delete_module+0x227/0x350
          do_syscall_64+0xc3/0x6a4
          entry_SYSCALL_64_after_hwframe+0x49/0xbe

Which is due to the read side of the client_data_rwsem being obtained
recursively through a work queue flush during cm client removal.

The lock is being held across the remove in remove_client_context() so
that the function is a fence, once it returns the client is removed. This
is required so that the two callers do not proceed with destruction until
the client completes removal.

Instead of using client_data_rwsem use the existing device unregistration
refcount and add a similar client unregistration (client->uses) refcount.

This will fence the two unregistration paths without holding any locks.

Cc: <stable@vger.kernel.org>
Fixes: 921eab1143aa ("RDMA/devices: Re-organize device.c locking")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20190731081841.32345-2-leon@kernel.org
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/device.c |   54 +++++++++++++++++++++++++++++----------
 include/rdma/ib_verbs.h          |    3 ++
 2 files changed, 44 insertions(+), 13 deletions(-)

--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -98,6 +98,12 @@ static LIST_HEAD(client_list);
 static DEFINE_XARRAY_FLAGS(clients, XA_FLAGS_ALLOC);
 static DECLARE_RWSEM(clients_rwsem);
 
+static void ib_client_put(struct ib_client *client)
+{
+	if (refcount_dec_and_test(&client->uses))
+		complete(&client->uses_zero);
+}
+
 /*
  * If client_data is registered then the corresponding client must also still
  * be registered.
@@ -651,6 +657,14 @@ static int add_client_context(struct ib_
 
 	down_write(&device->client_data_rwsem);
 	/*
+	 * So long as the client is registered hold both the client and device
+	 * unregistration locks.
+	 */
+	if (!refcount_inc_not_zero(&client->uses))
+		goto out_unlock;
+	refcount_inc(&device->refcount);
+
+	/*
 	 * Another caller to add_client_context got here first and has already
 	 * completely initialized context.
 	 */
@@ -673,6 +687,9 @@ static int add_client_context(struct ib_
 	return 0;
 
 out:
+	ib_device_put(device);
+	ib_client_put(client);
+out_unlock:
 	up_write(&device->client_data_rwsem);
 	return ret;
 }
@@ -692,7 +709,7 @@ static void remove_client_context(struct
 	client_data = xa_load(&device->client_data, client_id);
 	xa_clear_mark(&device->client_data, client_id, CLIENT_DATA_REGISTERED);
 	client = xa_load(&clients, client_id);
-	downgrade_write(&device->client_data_rwsem);
+	up_write(&device->client_data_rwsem);
 
 	/*
 	 * Notice we cannot be holding any exclusive locks when calling the
@@ -702,17 +719,13 @@ static void remove_client_context(struct
 	 *
 	 * For this reason clients and drivers should not call the
 	 * unregistration functions will holdling any locks.
-	 *
-	 * It tempting to drop the client_data_rwsem too, but this is required
-	 * to ensure that unregister_client does not return until all clients
-	 * are completely unregistered, which is required to avoid module
-	 * unloading races.
 	 */
 	if (client->remove)
 		client->remove(device, client_data);
 
 	xa_erase(&device->client_data, client_id);
-	up_read(&device->client_data_rwsem);
+	ib_device_put(device);
+	ib_client_put(client);
 }
 
 static int alloc_port_data(struct ib_device *device)
@@ -1696,6 +1709,8 @@ int ib_register_client(struct ib_client
 	unsigned long index;
 	int ret;
 
+	refcount_set(&client->uses, 1);
+	init_completion(&client->uses_zero);
 	ret = assign_client_id(client);
 	if (ret)
 		return ret;
@@ -1731,16 +1746,29 @@ void ib_unregister_client(struct ib_clie
 	unsigned long index;
 
 	down_write(&clients_rwsem);
+	ib_client_put(client);
 	xa_clear_mark(&clients, client->client_id, CLIENT_REGISTERED);
 	up_write(&clients_rwsem);
+
+	/* We do not want to have locks while calling client->remove() */
+	rcu_read_lock();
+	xa_for_each (&devices, index, device) {
+		if (!ib_device_try_get(device))
+			continue;
+		rcu_read_unlock();
+
+		remove_client_context(device, client->client_id);
+
+		ib_device_put(device);
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+
 	/*
-	 * Every device still known must be serialized to make sure we are
-	 * done with the client callbacks before we return.
+	 * remove_client_context() is not a fence, it can return even though a
+	 * removal is ongoing. Wait until all removals are completed.
 	 */
-	down_read(&devices_rwsem);
-	xa_for_each (&devices, index, device)
-		remove_client_context(device, client->client_id);
-	up_read(&devices_rwsem);
+	wait_for_completion(&client->uses_zero);
 
 	down_write(&clients_rwsem);
 	list_del(&client->list);
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2722,6 +2722,9 @@ struct ib_client {
 			const union ib_gid *gid,
 			const struct sockaddr *addr,
 			void *client_data);
+
+	refcount_t uses;
+	struct completion uses_zero;
 	struct list_head list;
 	u32 client_id;
 


