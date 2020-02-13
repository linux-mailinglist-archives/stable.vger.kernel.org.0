Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B8915C486
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbgBMPsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:48:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbgBMP06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:58 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DD5E24676;
        Thu, 13 Feb 2020 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607617;
        bh=yrSeCG0uOthnJMH+3IwbUqpd3QyT4TGEU1r7Ewtx6oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zkePcH6oYtfy0D1FDTHHzLWuR+72Zm+maQHZszpyjZJaYASKK4AUz1rltUPhtdVkV
         pRJfAjrQqvUKlLhckQGPwJh8fHVaVtaUDQQHZm9qCyLp6UeWIZ/sHVnAtnl2sOgB0E
         Znao6EuEVjLQIiKdL3THzMSCwf25lgk26CKAGifo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 10/96] RDMA/cma: Fix unbalanced cm_id reference count during address resolve
Date:   Thu, 13 Feb 2020 07:20:17 -0800
Message-Id: <20200213151843.267090680@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

commit b4fb4cc5ba83b20dae13cef116c33648e81d2f44 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/cma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3091,6 +3091,7 @@ static int cma_resolve_loopback(struct r
 	rdma_addr_get_sgid(&id_priv->id.route.addr.dev_addr, &gid);
 	rdma_addr_set_dgid(&id_priv->id.route.addr.dev_addr, &gid);
 
+	atomic_inc(&id_priv->refcount);
 	cma_init_resolve_addr_work(work, id_priv);
 	queue_work(cma_wq, &work->work);
 	return 0;
@@ -3117,6 +3118,7 @@ static int cma_resolve_ib_addr(struct rd
 	rdma_addr_set_dgid(&id_priv->id.route.addr.dev_addr, (union ib_gid *)
 		&(((struct sockaddr_ib *) &id_priv->id.route.addr.dst_addr)->sib_addr));
 
+	atomic_inc(&id_priv->refcount);
 	cma_init_resolve_addr_work(work, id_priv);
 	queue_work(cma_wq, &work->work);
 	return 0;


