Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3D329C4BA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823047AbgJ0R5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901094AbgJ0OW2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:22:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C0D720727;
        Tue, 27 Oct 2020 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808548;
        bh=08Ap5+CQ+PwcSqQo1g5EJTDXaeEm0rGK0rR/KRrz96U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dwsU3QfrEn9IC9qFtsv+F1FGyGhrcgR0iuF6lwevRVkrpnfz9TFmtvcvrc4MDD2V
         5DElWhpblvNwdzlZa4mIKwKq/86aqhUsIwKxDyk6Vgb2fRnSuSKChoR3zWwN45WaBk
         5AID06Rs1Bz5iDi7qwUtgkmfADOKjqYgQCzikiKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/264] RDMA/ucma: Fix locking for ctx->events_reported
Date:   Tue, 27 Oct 2020 14:53:11 +0100
Message-Id: <20201027135436.933086906@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 98837c6c3d7285f6eca86480b6f7fac6880e27a8 ]

This value is locked under the file->mut, ensure it is held whenever
touching it.

The case in ucma_migrate_id() is a race, while in ucma_free_uctx() it is
already not possible for the write side to run, the movement is just for
clarity.

Fixes: 88314e4dda1e ("RDMA/cma: add support for rdma_migrate_id()")
Link: https://lore.kernel.org/r/20200818120526.702120-10-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/ucma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 2acc30c3d5b2d..0c095c8c0ac5b 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -588,6 +588,7 @@ static int ucma_free_ctx(struct ucma_context *ctx)
 			list_move_tail(&uevent->list, &list);
 	}
 	list_del(&ctx->list);
+	events_reported = ctx->events_reported;
 	mutex_unlock(&ctx->file->mut);
 
 	list_for_each_entry_safe(uevent, tmp, &list, list) {
@@ -597,7 +598,6 @@ static int ucma_free_ctx(struct ucma_context *ctx)
 		kfree(uevent);
 	}
 
-	events_reported = ctx->events_reported;
 	mutex_destroy(&ctx->mutex);
 	kfree(ctx);
 	return events_reported;
@@ -1644,7 +1644,9 @@ static ssize_t ucma_migrate_id(struct ucma_file *new_file,
 
 	cur_file = ctx->file;
 	if (cur_file == new_file) {
+		mutex_lock(&cur_file->mut);
 		resp.events_reported = ctx->events_reported;
+		mutex_unlock(&cur_file->mut);
 		goto response;
 	}
 
-- 
2.25.1



