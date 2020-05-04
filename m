Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E511C4415
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbgEDSEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731609AbgEDSED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:04:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12F01206B8;
        Mon,  4 May 2020 18:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615442;
        bh=le726E5NPR5DJLKT2A0s7mKCI1Oa8lsc7twTHpZNr6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHhf9k0ZtOZGndjKj/PXTiaPTknDY2QwLt38aIWynbi/+5EuUnxGXfAnVA0ZjhGrA
         fa7vOjPfXEgM05DVLyqp0oQdQS+DlYW4gd/QLAYwDdagcEFTZ5Jvzubcw1wNjDXp3J
         7SWHlraHBoMhhXFgo9QXb/VPbDpXjJPMlYNvQ6y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 41/57] RDMA/cm: Fix ordering of xa_alloc_cyclic() in ib_create_cm_id()
Date:   Mon,  4 May 2020 19:57:45 +0200
Message-Id: <20200504165459.892946324@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit e8dc4e885c459343970b25acd9320fe9ee5492e7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/cm.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -597,18 +597,6 @@ static int cm_init_av_by_path(struct sa_
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
@@ -862,6 +850,7 @@ struct ib_cm_id *ib_create_cm_id(struct
 				 void *context)
 {
 	struct cm_id_private *cm_id_priv;
+	u32 id;
 	int ret;
 
 	cm_id_priv = kzalloc(sizeof *cm_id_priv, GFP_KERNEL);
@@ -873,9 +862,6 @@ struct ib_cm_id *ib_create_cm_id(struct
 	cm_id_priv->id.cm_handler = cm_handler;
 	cm_id_priv->id.context = context;
 	cm_id_priv->id.remote_cm_qpn = 1;
-	ret = cm_alloc_id(cm_id_priv);
-	if (ret)
-		goto error;
 
 	spin_lock_init(&cm_id_priv->lock);
 	init_completion(&cm_id_priv->comp);
@@ -884,11 +870,20 @@ struct ib_cm_id *ib_create_cm_id(struct
 	INIT_LIST_HEAD(&cm_id_priv->altr_list);
 	atomic_set(&cm_id_priv->work_count, -1);
 	atomic_set(&cm_id_priv->refcount, 1);
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
 


