Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC7D2C0817
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387398AbgKWMpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733010AbgKWMpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8561022201;
        Mon, 23 Nov 2020 12:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135534;
        bh=4qhzgZ9CRH/MbESz6eAGIJ7OjNG9NRnvg7449AtF8eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfzoGCiSw+SU9o0F68EbBHjCBc/ctW6Uac0RdlqfTp428hiyuJgweW+rKvDKXTJ5v
         zhdmjXtDG2NVss4NB7Xz6aEGUbN3JfsFVKLk4ixAc5tF4Rl+C2Di/J7PaaA2fTKjqj
         4eTMxxKFPtjf9+UFZ8YnQ2d5AFToah3yAyhWqOW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 102/252] tee: amdtee: fix memory leak due to reset of global shm list
Date:   Mon, 23 Nov 2020 13:20:52 +0100
Message-Id: <20201123121840.502774684@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rijo Thomas <Rijo-john.Thomas@amd.com>

[ Upstream commit ff1f855804cdbbb6db7b9b6df6cab783d1a40d66 ]

The driver maintains a list of shared memory buffers along with their
mapped buffer id's in a global linked list. These buffers need to be
unmapped after use by the user-space client.

The global shared memory list is initialized to zero entries in the
function amdtee_open(). This clearing of list entries can be a source
for memory leak on secure side if the global linked list previously
held some mapped buffer entries allocated from another TEE context.

Fix potential memory leak issue by moving global shared memory list
to AMD-TEE driver context data structure.

Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/amdtee/amdtee_private.h |  7 +++----
 drivers/tee/amdtee/core.c           | 18 +++++++++++-------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/tee/amdtee/amdtee_private.h b/drivers/tee/amdtee/amdtee_private.h
index d7f798c3394bc..97df16a17285a 100644
--- a/drivers/tee/amdtee/amdtee_private.h
+++ b/drivers/tee/amdtee/amdtee_private.h
@@ -64,9 +64,12 @@ struct amdtee_session {
 /**
  * struct amdtee_context_data - AMD-TEE driver context data
  * @sess_list:    Keeps track of sessions opened in current TEE context
+ * @shm_list:     Keeps track of buffers allocated and mapped in current TEE
+ *                context
  */
 struct amdtee_context_data {
 	struct list_head sess_list;
+	struct list_head shm_list;
 };
 
 struct amdtee_driver_data {
@@ -89,10 +92,6 @@ struct amdtee_shm_data {
 	u32     buf_id;
 };
 
-struct amdtee_shm_context {
-	struct list_head shmdata_list;
-};
-
 #define LOWER_TWO_BYTE_MASK	0x0000FFFF
 
 /**
diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index 27b4cd77d0db6..ce61c68ec58cb 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -20,7 +20,6 @@
 
 static struct amdtee_driver_data *drv_data;
 static DEFINE_MUTEX(session_list_mutex);
-static struct amdtee_shm_context shmctx;
 
 static void amdtee_get_version(struct tee_device *teedev,
 			       struct tee_ioctl_version_data *vers)
@@ -42,7 +41,7 @@ static int amdtee_open(struct tee_context *ctx)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&ctxdata->sess_list);
-	INIT_LIST_HEAD(&shmctx.shmdata_list);
+	INIT_LIST_HEAD(&ctxdata->shm_list);
 
 	ctx->data = ctxdata;
 	return 0;
@@ -152,10 +151,11 @@ static struct amdtee_session *find_session(struct amdtee_context_data *ctxdata,
 
 u32 get_buffer_id(struct tee_shm *shm)
 {
-	u32 buf_id = 0;
+	struct amdtee_context_data *ctxdata = shm->ctx->data;
 	struct amdtee_shm_data *shmdata;
+	u32 buf_id = 0;
 
-	list_for_each_entry(shmdata, &shmctx.shmdata_list, shm_node)
+	list_for_each_entry(shmdata, &ctxdata->shm_list, shm_node)
 		if (shmdata->kaddr == shm->kaddr) {
 			buf_id = shmdata->buf_id;
 			break;
@@ -333,8 +333,9 @@ int amdtee_close_session(struct tee_context *ctx, u32 session)
 
 int amdtee_map_shmem(struct tee_shm *shm)
 {
-	struct shmem_desc shmem;
+	struct amdtee_context_data *ctxdata;
 	struct amdtee_shm_data *shmnode;
+	struct shmem_desc shmem;
 	int rc, count;
 	u32 buf_id;
 
@@ -362,7 +363,8 @@ int amdtee_map_shmem(struct tee_shm *shm)
 
 	shmnode->kaddr = shm->kaddr;
 	shmnode->buf_id = buf_id;
-	list_add(&shmnode->shm_node, &shmctx.shmdata_list);
+	ctxdata = shm->ctx->data;
+	list_add(&shmnode->shm_node, &ctxdata->shm_list);
 
 	pr_debug("buf_id :[%x] kaddr[%p]\n", shmnode->buf_id, shmnode->kaddr);
 
@@ -371,6 +373,7 @@ int amdtee_map_shmem(struct tee_shm *shm)
 
 void amdtee_unmap_shmem(struct tee_shm *shm)
 {
+	struct amdtee_context_data *ctxdata;
 	struct amdtee_shm_data *shmnode;
 	u32 buf_id;
 
@@ -381,7 +384,8 @@ void amdtee_unmap_shmem(struct tee_shm *shm)
 	/* Unmap the shared memory from TEE */
 	handle_unmap_shmem(buf_id);
 
-	list_for_each_entry(shmnode, &shmctx.shmdata_list, shm_node)
+	ctxdata = shm->ctx->data;
+	list_for_each_entry(shmnode, &ctxdata->shm_list, shm_node)
 		if (buf_id == shmnode->buf_id) {
 			list_del(&shmnode->shm_node);
 			kfree(shmnode);
-- 
2.27.0



