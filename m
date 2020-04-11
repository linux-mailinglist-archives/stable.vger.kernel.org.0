Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B41C1A59FF
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgDKXkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728647AbgDKXH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:07:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C116B20CC7;
        Sat, 11 Apr 2020 23:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646445;
        bh=glmim1U2Pn1aiJKmWgmH+Jnaz+lewHVnmLqSProYp6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKD2TMQDN1jP1tMr/q3FHHzd6KGnXHwXRMFYod5TbixQ66FdVTGkMYqqEBbp8iXli
         6aWYOxjq1dXbLrnuSfcyPN6HpmfMOrkJOEhXhwFgI/DZv4BN9pmtgB7LAk5/AKlj+R
         VbbaWbLF6h6cJ1+TRFHCjVT7fnFhmK+wWE6rNPtE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 016/121] RDMA/cm: Fix ordering of xa_alloc_cyclic() in ib_create_cm_id()
Date:   Sat, 11 Apr 2020 19:05:21 -0400
Message-Id: <20200411230706.23855-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit e8dc4e885c459343970b25acd9320fe9ee5492e7 ]

xa_alloc_cyclic() is a SMP release to be paired with some later acquire
during xa_load() as part of cm_acquire_id().

As such, xa_alloc_cyclic() must be done after the cm_id is fully
initialized, in particular, it absolutely must be after the
refcount_set(), otherwise the refcount_inc() in cm_acquire_id() may not
see the set.

As there are several cases where a reader will be able to use the
id.local_id after cm_acquire_id in the IB_CM_IDLE state there needs to be
an unfortunate split into a NULL allocate and a finalizing xa_store.

Fixes: a977049dacde ("[PATCH] IB: Add the kernel CM implementation")
Link: https://lore.kernel.org/r/20200310092545.251365-2-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 4decc1d4cc997..1c7984bae7ab2 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -571,18 +571,6 @@ static int cm_init_av_by_path(struct sa_path_rec *path,
 	return 0;
 }
 
-static int cm_alloc_id(struct cm_id_private *cm_id_priv)
-{
-	int err;
-	u32 id;
-
-	err = xa_alloc_cyclic_irq(&cm.local_id_table, &id, cm_id_priv,
-			xa_limit_32b, &cm.local_id_next, GFP_KERNEL);
-
-	cm_id_priv->id.local_id = (__force __be32)id ^ cm.random_id_operand;
-	return err;
-}
-
 static u32 cm_local_id(__be32 local_id)
 {
 	return (__force u32) (local_id ^ cm.random_id_operand);
@@ -836,6 +824,7 @@ struct ib_cm_id *ib_create_cm_id(struct ib_device *device,
 				 void *context)
 {
 	struct cm_id_private *cm_id_priv;
+	u32 id;
 	int ret;
 
 	cm_id_priv = kzalloc(sizeof *cm_id_priv, GFP_KERNEL);
@@ -847,9 +836,6 @@ struct ib_cm_id *ib_create_cm_id(struct ib_device *device,
 	cm_id_priv->id.cm_handler = cm_handler;
 	cm_id_priv->id.context = context;
 	cm_id_priv->id.remote_cm_qpn = 1;
-	ret = cm_alloc_id(cm_id_priv);
-	if (ret)
-		goto error;
 
 	spin_lock_init(&cm_id_priv->lock);
 	init_completion(&cm_id_priv->comp);
@@ -858,11 +844,20 @@ struct ib_cm_id *ib_create_cm_id(struct ib_device *device,
 	INIT_LIST_HEAD(&cm_id_priv->altr_list);
 	atomic_set(&cm_id_priv->work_count, -1);
 	refcount_set(&cm_id_priv->refcount, 1);
+
+	ret = xa_alloc_cyclic_irq(&cm.local_id_table, &id, NULL, xa_limit_32b,
+				  &cm.local_id_next, GFP_KERNEL);
+	if (ret)
+		goto error;
+	cm_id_priv->id.local_id = (__force __be32)id ^ cm.random_id_operand;
+	xa_store_irq(&cm.local_id_table, cm_local_id(cm_id_priv->id.local_id),
+		     cm_id_priv, GFP_KERNEL);
+
 	return &cm_id_priv->id;
 
 error:
 	kfree(cm_id_priv);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(ib_create_cm_id);
 
-- 
2.20.1

