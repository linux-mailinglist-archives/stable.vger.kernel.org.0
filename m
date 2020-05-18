Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698BE1D82B3
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731432AbgERR6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731922AbgERR6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:58:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02FB520715;
        Mon, 18 May 2020 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824714;
        bh=wjNCLJm8je2dfTo3Dnvetm+uHr8DjiIVmachTBfbvW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsEeXzGMFvxKkYstGbRnUHKak6BA2vucTO+769vgqHKCREPblHrgJC+sIkMqh2xR3
         lggPlX0vFYiEAHfpKfUQ1JHrD85gpCm/PAMh6Wl13pTGsxG8+tK8tY9V+0iL99+9K6
         BrOXqo8nasGy/4IHcIpQlZ2DANLIaxKsfdpzjl1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/147] RDMA/rxe: Always return ERR_PTR from rxe_create_mmap_info()
Date:   Mon, 18 May 2020 19:36:47 +0200
Message-Id: <20200518173524.083777446@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

[ Upstream commit bb43c8e382e5da0ee253e3105d4099820ff4d922 ]

The commit below modified rxe_create_mmap_info() to return ERR_PTR's but
didn't update the callers to handle them. Modify rxe_create_mmap_info() to
only return ERR_PTR and fix all error checking after
rxe_create_mmap_info() is called.

Ensure that all other exit paths properly set the error return.

Fixes: ff23dfa13457 ("IB: Pass only ib_udata in function prototypes")
Link: https://lore.kernel.org/r/20200425233545.17210-1-sudipm.mukherjee@gmail.com
Link: https://lore.kernel.org/r/20200511183742.GB225608@mwanda
Cc: stable@vger.kernel.org [5.4+]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mmap.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_queue.c | 11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mmap.c b/drivers/infiniband/sw/rxe/rxe_mmap.c
index 48f48122ddcb8..6a413d73b95dd 100644
--- a/drivers/infiniband/sw/rxe/rxe_mmap.c
+++ b/drivers/infiniband/sw/rxe/rxe_mmap.c
@@ -151,7 +151,7 @@ struct rxe_mmap_info *rxe_create_mmap_info(struct rxe_dev *rxe, u32 size,
 
 	ip = kmalloc(sizeof(*ip), GFP_KERNEL);
 	if (!ip)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	size = PAGE_ALIGN(size);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_queue.c b/drivers/infiniband/sw/rxe/rxe_queue.c
index ff92704de32ff..245040c3a35d0 100644
--- a/drivers/infiniband/sw/rxe/rxe_queue.c
+++ b/drivers/infiniband/sw/rxe/rxe_queue.c
@@ -45,12 +45,15 @@ int do_mmap_info(struct rxe_dev *rxe, struct mminfo __user *outbuf,
 
 	if (outbuf) {
 		ip = rxe_create_mmap_info(rxe, buf_size, udata, buf);
-		if (!ip)
+		if (IS_ERR(ip)) {
+			err = PTR_ERR(ip);
 			goto err1;
+		}
 
-		err = copy_to_user(outbuf, &ip->info, sizeof(ip->info));
-		if (err)
+		if (copy_to_user(outbuf, &ip->info, sizeof(ip->info))) {
+			err = -EFAULT;
 			goto err2;
+		}
 
 		spin_lock_bh(&rxe->pending_lock);
 		list_add(&ip->pending_mmaps, &rxe->pending_mmaps);
@@ -64,7 +67,7 @@ int do_mmap_info(struct rxe_dev *rxe, struct mminfo __user *outbuf,
 err2:
 	kfree(ip);
 err1:
-	return -EINVAL;
+	return err;
 }
 
 inline void rxe_queue_reset(struct rxe_queue *q)
-- 
2.20.1



