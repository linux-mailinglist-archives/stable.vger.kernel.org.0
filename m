Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233051D83C3
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733311AbgERSH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733292AbgERSHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:07:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5066620853;
        Mon, 18 May 2020 18:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825244;
        bh=GnCW7mSOCGz0pmBLR1C3H7STub9TUkxiDKSawdq/atY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXGRpvKHVQTHlz1uIt3nSJkRM5WbqKEF4zhFqobf+hSla+tQb/jPQ1CcCNiH+V8a6
         EDDV4bl/BGpCK7wf2WtzzPAMInn63QRYL1xUl9w/QTCAJDorE/ZsXrGH8dSyS+dYt8
         G9nvsj1o8f6CanV6CLvsNfq3psVqVgc5wwWovOzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.6 187/194] RDMA/uverbs: Do not discard the IB_EVENT_DEVICE_FATAL event
Date:   Mon, 18 May 2020 19:37:57 +0200
Message-Id: <20200518173547.023218812@linuxfoundation.org>
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

commit c485b19d52c4ba269dfd027945dee81755fdd530 upstream.

The commit below moved all of the destruction to the disassociate step and
cleaned up the event channel during destroy_uobj.

However, when ib_uverbs_free_hw_resources() pushes IB_EVENT_DEVICE_FATAL
and then immediately goes to destroy all uobjects this causes
ib_uverbs_free_event_queue() to discard the queued event if userspace
hasn't already read() it.

Unlike all other event queues async FD needs to defer the
ib_uverbs_free_event_queue() until FD release. This still unregisters the
handler from the IB device during disassociation.

Fixes: 3e032c0e92aa ("RDMA/core: Make ib_uverbs_async_event_file into a uobject")
Link: https://lore.kernel.org/r/20200507063348.98713-2-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/rdma_core.c                 |    3 +-
 drivers/infiniband/core/uverbs.h                    |    1 
 drivers/infiniband/core/uverbs_main.c               |    2 -
 drivers/infiniband/core/uverbs_std_types_async_fd.c |   26 +++++++++++++++++++-
 4 files changed, 29 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -459,7 +459,8 @@ alloc_begin_fd_uobject(const struct uver
 	struct ib_uobject *uobj;
 	struct file *filp;
 
-	if (WARN_ON(fd_type->fops->release != &uverbs_uobject_fd_release))
+	if (WARN_ON(fd_type->fops->release != &uverbs_uobject_fd_release &&
+		    fd_type->fops->release != &uverbs_async_event_release))
 		return ERR_PTR(-EINVAL);
 
 	new_fd = get_unused_fd_flags(O_CLOEXEC);
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -219,6 +219,7 @@ void ib_uverbs_init_event_queue(struct i
 void ib_uverbs_init_async_event_file(struct ib_uverbs_async_event_file *ev_file);
 void ib_uverbs_free_event_queue(struct ib_uverbs_event_queue *event_queue);
 void ib_uverbs_flow_resources_free(struct ib_uflow_resources *uflow_res);
+int uverbs_async_event_release(struct inode *inode, struct file *filp);
 
 int ib_alloc_ucontext(struct uverbs_attr_bundle *attrs);
 int ib_init_ucontext(struct uverbs_attr_bundle *attrs);
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -346,7 +346,7 @@ const struct file_operations uverbs_asyn
 	.owner	 = THIS_MODULE,
 	.read	 = ib_uverbs_async_event_read,
 	.poll    = ib_uverbs_async_event_poll,
-	.release = uverbs_uobject_fd_release,
+	.release = uverbs_async_event_release,
 	.fasync  = ib_uverbs_async_event_fasync,
 	.llseek	 = no_llseek,
 };
--- a/drivers/infiniband/core/uverbs_std_types_async_fd.c
+++ b/drivers/infiniband/core/uverbs_std_types_async_fd.c
@@ -26,10 +26,34 @@ static int uverbs_async_event_destroy_uo
 		container_of(uobj, struct ib_uverbs_async_event_file, uobj);
 
 	ib_unregister_event_handler(&event_file->event_handler);
-	ib_uverbs_free_event_queue(&event_file->ev_queue);
 	return 0;
 }
 
+int uverbs_async_event_release(struct inode *inode, struct file *filp)
+{
+	struct ib_uverbs_async_event_file *event_file;
+	struct ib_uobject *uobj = filp->private_data;
+	int ret;
+
+	if (!uobj)
+		return uverbs_uobject_fd_release(inode, filp);
+
+	event_file =
+		container_of(uobj, struct ib_uverbs_async_event_file, uobj);
+
+	/*
+	 * The async event FD has to deliver IB_EVENT_DEVICE_FATAL even after
+	 * disassociation, so cleaning the event list must only happen after
+	 * release. The user knows it has reached the end of the event stream
+	 * when it sees IB_EVENT_DEVICE_FATAL.
+	 */
+	uverbs_uobject_get(uobj);
+	ret = uverbs_uobject_fd_release(inode, filp);
+	ib_uverbs_free_event_queue(&event_file->ev_queue);
+	uverbs_uobject_put(uobj);
+	return ret;
+}
+
 DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_METHOD_ASYNC_EVENT_ALLOC,
 	UVERBS_ATTR_FD(UVERBS_ATTR_ASYNC_EVENT_ALLOC_FD_HANDLE,


