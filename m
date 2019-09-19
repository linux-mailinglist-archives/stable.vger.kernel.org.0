Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDB7B86E9
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406011AbfISWM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406008AbfISWM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:12:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDB8721907;
        Thu, 19 Sep 2019 22:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931176;
        bh=3HAtcNX2DRMK1WORxo3LhucqMRLD9zKMpi4DblG6/Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smZ2lSfo9HpBZsyWdBsKYIT0RbLOoLRN/ULk/eGzU8uezr3WfF73ySWR1W00zKqd/
         VD7plGowq5SxpLg8dPUdRwpjnIm94IGl4mK849OFB+LvHrJUt6IRLklVORctn3KgMR
         raAf2XAdkAusmUmmH+iQ9FsPdGE1BDDfmCC+4IBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artemy Kovalyov <artemyko@mellanox.com>,
        Yossi Itigin <yosefe@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
Subject: [PATCH 4.19 03/79] RDMA/restrack: Release task struct which was hold by CM_ID object
Date:   Fri, 20 Sep 2019 00:02:48 +0200
Message-Id: <20190919214808.101726182@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

commit ed7a01fd3fd77f40b4ef2562b966a5decd8928d2 upstream.

Tracking CM_ID resource is performed in two stages: creation of cm_id
and connecting it to the cma_dev. It is needed because rdma-cm protocol
exports two separate user-visible calls rdma_create_id and rdma_accept.

At the time of CM_ID creation, the real owner of that object is unknown
yet and we need to grab task_struct. This task_struct is released or
reassigned in attach phase later on. but call to rdma_destroy_id left
this task_struct unreleased.

Such separation is unique to CM_ID and other restrack objects initialize
in one shot. It means that it is safe to use "res->valid" check to catch
unfinished CM_ID flow and release task_struct for that object.

Fixes: 00313983cda6 ("RDMA/nldev: provide detailed CM_ID information")
Reported-by: Artemy Kovalyov <artemyko@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Reviewed-by: Yossi Itigin <yosefe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/cma.c      |    7 +++----
 drivers/infiniband/core/restrack.c |    6 ++++--
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1723,8 +1723,8 @@ void rdma_destroy_id(struct rdma_cm_id *
 	mutex_lock(&id_priv->handler_mutex);
 	mutex_unlock(&id_priv->handler_mutex);
 
+	rdma_restrack_del(&id_priv->res);
 	if (id_priv->cma_dev) {
-		rdma_restrack_del(&id_priv->res);
 		if (rdma_cap_ib_cm(id_priv->id.device, 1)) {
 			if (id_priv->cm_id.ib)
 				ib_destroy_cm_id(id_priv->cm_id.ib);
@@ -3463,10 +3463,9 @@ int rdma_bind_addr(struct rdma_cm_id *id
 
 	return 0;
 err2:
-	if (id_priv->cma_dev) {
-		rdma_restrack_del(&id_priv->res);
+	rdma_restrack_del(&id_priv->res);
+	if (id_priv->cma_dev)
 		cma_release_dev(id_priv);
-	}
 err1:
 	cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_IDLE);
 	return ret;
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -209,7 +209,7 @@ void rdma_restrack_del(struct rdma_restr
 	struct ib_device *dev;
 
 	if (!res->valid)
-		return;
+		goto out;
 
 	dev = res_to_dev(res);
 	if (!dev)
@@ -222,8 +222,10 @@ void rdma_restrack_del(struct rdma_restr
 	down_write(&dev->res.rwsem);
 	hash_del(&res->node);
 	res->valid = false;
+	up_write(&dev->res.rwsem);
+
+out:
 	if (res->task)
 		put_task_struct(res->task);
-	up_write(&dev->res.rwsem);
 }
 EXPORT_SYMBOL(rdma_restrack_del);


