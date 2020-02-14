Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380F315F2E6
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgBNPva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbgBNPva (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2416F2467E;
        Fri, 14 Feb 2020 15:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695489;
        bh=PujbNvqkvyrzZobB4pxyCIUog3O22ilzl8UACEUWRV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2yVdn8h2na2gMl4u4i4KnAPTBYK5n9gIfL4e4X3c0LJIdzM3F4lNUTputBqfb5vo
         og9v0Z06HRJ5Ez+p+Fyz+hnAm2nWWjp2GEIZdhIJ6fKuxBVhw4AlJ997wXunA2G9+2
         O3CQcfHnBU0CKC2XDc/A6VvjwVKW1tos2HifMqwE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 119/542] RDMA/cma: Fix unbalanced cm_id reference count during address resolve
Date:   Fri, 14 Feb 2020 10:41:51 -0500
Message-Id: <20200214154854.6746-119-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit b4fb4cc5ba83b20dae13cef116c33648e81d2f44 ]

Below commit missed the AF_IB and loopback code flow in
rdma_resolve_addr().  This leads to an unbalanced cm_id refcount in
cma_work_handler() which puts the refcount which was not incremented prior
to queuing the work.

A call trace is observed with such code flow:

 BUG: unable to handle kernel NULL pointer dereference at (null)
 [<ffffffff96b67e16>] __mutex_lock_slowpath+0x166/0x1d0
 [<ffffffff96b6715f>] mutex_lock+0x1f/0x2f
 [<ffffffffc0beabb5>] cma_work_handler+0x25/0xa0
 [<ffffffff964b9ebf>] process_one_work+0x17f/0x440
 [<ffffffff964baf56>] worker_thread+0x126/0x3c0

Hence, hold the cm_id reference when scheduling the resolve work item.

Fixes: 722c7b2bfead ("RDMA/{cma, core}: Avoid callback on rdma_addr_cancel()")
Link: https://lore.kernel.org/r/20200126142652.104803-2-leon@kernel.org
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 43a6f07e0afe2..af1afc17b8bdf 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3118,6 +3118,7 @@ static int cma_resolve_loopback(struct rdma_id_private *id_priv)
 	rdma_addr_get_sgid(&id_priv->id.route.addr.dev_addr, &gid);
 	rdma_addr_set_dgid(&id_priv->id.route.addr.dev_addr, &gid);
 
+	atomic_inc(&id_priv->refcount);
 	cma_init_resolve_addr_work(work, id_priv);
 	queue_work(cma_wq, &work->work);
 	return 0;
@@ -3144,6 +3145,7 @@ static int cma_resolve_ib_addr(struct rdma_id_private *id_priv)
 	rdma_addr_set_dgid(&id_priv->id.route.addr.dev_addr, (union ib_gid *)
 		&(((struct sockaddr_ib *) &id_priv->id.route.addr.dst_addr)->sib_addr));
 
+	atomic_inc(&id_priv->refcount);
 	cma_init_resolve_addr_work(work, id_priv);
 	queue_work(cma_wq, &work->work);
 	return 0;
-- 
2.20.1

