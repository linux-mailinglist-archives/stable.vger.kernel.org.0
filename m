Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFED12C09E0
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388564AbgKWNNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387401AbgKWMph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 683B120857;
        Mon, 23 Nov 2020 12:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135537;
        bh=0UjlspOM4wX4GRF9pIcGfzuEMO3CfwluMZvvPYqcIUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRjyBQdqiS6b+8EVx1MbpVwAZV3bWPcGNh9PYdi9mNVzwAKXuGnDTPCsbPbrDdJci
         UyvElnlCgzYEj8i2dSXkjl8RxAhjMO1nS3zLWavC3hsW3CVoTrTv63JyQcCVb2nYSw
         VUHQkceuT6bbeMypaXme3UdYg9atiy589YYOLdjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 103/252] tee: amdtee: synchronize access to shm list
Date:   Mon, 23 Nov 2020 13:20:53 +0100
Message-Id: <20201123121840.550845780@linuxfoundation.org>
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

[ Upstream commit be353be27874f40837327d9a39e3ad2149ab66d3 ]

Synchronize access to shm or shared memory buffer list to prevent
race conditions due to concurrent updates to shared shm list by
multiple threads.

Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/amdtee/amdtee_private.h | 1 +
 drivers/tee/amdtee/core.c           | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/tee/amdtee/amdtee_private.h b/drivers/tee/amdtee/amdtee_private.h
index 97df16a17285a..337c8d82f74eb 100644
--- a/drivers/tee/amdtee/amdtee_private.h
+++ b/drivers/tee/amdtee/amdtee_private.h
@@ -70,6 +70,7 @@ struct amdtee_session {
 struct amdtee_context_data {
 	struct list_head sess_list;
 	struct list_head shm_list;
+	struct mutex shm_mutex;   /* synchronizes access to @shm_list */
 };
 
 struct amdtee_driver_data {
diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index ce61c68ec58cb..8a6a8f30bb427 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -42,6 +42,7 @@ static int amdtee_open(struct tee_context *ctx)
 
 	INIT_LIST_HEAD(&ctxdata->sess_list);
 	INIT_LIST_HEAD(&ctxdata->shm_list);
+	mutex_init(&ctxdata->shm_mutex);
 
 	ctx->data = ctxdata;
 	return 0;
@@ -85,6 +86,7 @@ static void amdtee_release(struct tee_context *ctx)
 		list_del(&sess->list_node);
 		release_session(sess);
 	}
+	mutex_destroy(&ctxdata->shm_mutex);
 	kfree(ctxdata);
 
 	ctx->data = NULL;
@@ -155,11 +157,13 @@ u32 get_buffer_id(struct tee_shm *shm)
 	struct amdtee_shm_data *shmdata;
 	u32 buf_id = 0;
 
+	mutex_lock(&ctxdata->shm_mutex);
 	list_for_each_entry(shmdata, &ctxdata->shm_list, shm_node)
 		if (shmdata->kaddr == shm->kaddr) {
 			buf_id = shmdata->buf_id;
 			break;
 		}
+	mutex_unlock(&ctxdata->shm_mutex);
 
 	return buf_id;
 }
@@ -364,7 +368,9 @@ int amdtee_map_shmem(struct tee_shm *shm)
 	shmnode->kaddr = shm->kaddr;
 	shmnode->buf_id = buf_id;
 	ctxdata = shm->ctx->data;
+	mutex_lock(&ctxdata->shm_mutex);
 	list_add(&shmnode->shm_node, &ctxdata->shm_list);
+	mutex_unlock(&ctxdata->shm_mutex);
 
 	pr_debug("buf_id :[%x] kaddr[%p]\n", shmnode->buf_id, shmnode->kaddr);
 
@@ -385,12 +391,14 @@ void amdtee_unmap_shmem(struct tee_shm *shm)
 	handle_unmap_shmem(buf_id);
 
 	ctxdata = shm->ctx->data;
+	mutex_lock(&ctxdata->shm_mutex);
 	list_for_each_entry(shmnode, &ctxdata->shm_list, shm_node)
 		if (buf_id == shmnode->buf_id) {
 			list_del(&shmnode->shm_node);
 			kfree(shmnode);
 			break;
 		}
+	mutex_unlock(&ctxdata->shm_mutex);
 }
 
 int amdtee_invoke_func(struct tee_context *ctx,
-- 
2.27.0



