Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375CC1F2DF2
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgFIAhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:37:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgFHXNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8E2C20B80;
        Mon,  8 Jun 2020 23:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658017;
        bh=dJ1hCS/0idj37Jg+kplr64FvDLejwmC8xrXgcbyyO7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mq5w/Nzre5XkqQxl12nVgav4v+WlfgXAmgTWFb1N13JFQlUI/kDgQb0XATrPhwI/E
         76PT9G7Rre+oCweJ46oV/vsTjJt++uEKcTG/78K3oFUWjiC30iyoKnQom6ScXzL/eX
         n+cARVNm9tlW3x/vkQgXLhqM9KvaeB4HG2U/kGHs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 071/606] RDMA/uverbs: Do not discard the IB_EVENT_DEVICE_FATAL event
Date:   Mon,  8 Jun 2020 19:03:16 -0400
Message-Id: <20200608231211.3363633-71-sashal@kernel.org>
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
 drivers/infiniband/core/rdma_core.c           |  3 ++-
 drivers/infiniband/core/uverbs.h              |  1 +
 drivers/infiniband/core/uverbs_main.c         |  2 +-
 .../core/uverbs_std_types_async_fd.c          | 26 ++++++++++++++++++-
 4 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 177333d8bcda..bf8e149d3191 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -459,7 +459,8 @@ alloc_begin_fd_uobject(const struct uverbs_api_object *obj,
 	struct ib_uobject *uobj;
 	struct file *filp;
 
-	if (WARN_ON(fd_type->fops->release != &uverbs_uobject_fd_release))
+	if (WARN_ON(fd_type->fops->release != &uverbs_uobject_fd_release &&
+		    fd_type->fops->release != &uverbs_async_event_release))
 		return ERR_PTR(-EINVAL);
 
 	new_fd = get_unused_fd_flags(O_CLOEXEC);
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 7df71983212d..2673cb1cd655 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -219,6 +219,7 @@ void ib_uverbs_init_event_queue(struct ib_uverbs_event_queue *ev_queue);
 void ib_uverbs_init_async_event_file(struct ib_uverbs_async_event_file *ev_file);
 void ib_uverbs_free_event_queue(struct ib_uverbs_event_queue *event_queue);
 void ib_uverbs_flow_resources_free(struct ib_uflow_resources *uflow_res);
+int uverbs_async_event_release(struct inode *inode, struct file *filp);
 
 int ib_alloc_ucontext(struct uverbs_attr_bundle *attrs);
 int ib_init_ucontext(struct uverbs_attr_bundle *attrs);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 17fc25db0311..cb5b59123d8f 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -346,7 +346,7 @@ const struct file_operations uverbs_async_event_fops = {
 	.owner	 = THIS_MODULE,
 	.read	 = ib_uverbs_async_event_read,
 	.poll    = ib_uverbs_async_event_poll,
-	.release = uverbs_uobject_fd_release,
+	.release = uverbs_async_event_release,
 	.fasync  = ib_uverbs_async_event_fasync,
 	.llseek	 = no_llseek,
 };
diff --git a/drivers/infiniband/core/uverbs_std_types_async_fd.c b/drivers/infiniband/core/uverbs_std_types_async_fd.c
index 82ec0806b34b..462deb506b16 100644
--- a/drivers/infiniband/core/uverbs_std_types_async_fd.c
+++ b/drivers/infiniband/core/uverbs_std_types_async_fd.c
@@ -26,10 +26,34 @@ static int uverbs_async_event_destroy_uobj(struct ib_uobject *uobj,
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
-- 
2.25.1

