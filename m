Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54D229B905
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802148AbgJ0Ppq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801074AbgJ0Pis (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11BDD207C3;
        Tue, 27 Oct 2020 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813126;
        bh=T5/RUqBE6wlgeKQhtKA2caKhCGS9xnh5Z1c0MZdQcI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZ7KSRdrXG7rGwZSUhq1bAk0hio29kL4Od8Z62IdNQjiegfzBrZAjrRAQdADls15z
         qTd1AxtYWJV4b8Ijv1UpVF4P5nFnuFWFPOAtr8SLawD2PyM9qTdwlhaoqHlkKZuqz7
         zqd+RWJdH4kcieg7yYKCwLy37PXgh3bUOvAZF4z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 406/757] RDMA/ucma: Fix locking for ctx->events_reported
Date:   Tue, 27 Oct 2020 14:50:56 +0100
Message-Id: <20201027135509.619435491@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 1d184ea05eba1..75ccc31cf0b15 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -586,6 +586,7 @@ static int ucma_free_ctx(struct ucma_context *ctx)
 			list_move_tail(&uevent->list, &list);
 	}
 	list_del(&ctx->list);
+	events_reported = ctx->events_reported;
 	mutex_unlock(&ctx->file->mut);
 
 	list_for_each_entry_safe(uevent, tmp, &list, list) {
@@ -595,7 +596,6 @@ static int ucma_free_ctx(struct ucma_context *ctx)
 		kfree(uevent);
 	}
 
-	events_reported = ctx->events_reported;
 	mutex_destroy(&ctx->mutex);
 	kfree(ctx);
 	return events_reported;
@@ -1678,7 +1678,9 @@ static ssize_t ucma_migrate_id(struct ucma_file *new_file,
 
 	cur_file = ctx->file;
 	if (cur_file == new_file) {
+		mutex_lock(&cur_file->mut);
 		resp.events_reported = ctx->events_reported;
+		mutex_unlock(&cur_file->mut);
 		goto response;
 	}
 
-- 
2.25.1



