Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338B029B8B8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1800000AbgJ0Pn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800994AbgJ0PhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 240262225E;
        Tue, 27 Oct 2020 15:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813031;
        bh=V2d8KGZeHWvFEX8pIC9cr8yTJvfJRmdeqZOMgGl2w1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c61xAlIp0zYBzKRi2X9CjthF70d5vETq5Wpx4b5K6IfWE9DkeOHlhPUqd+65lG9RB
         n2QeO50FMkSpnK/lkHHf0r0Ak0+PYFqFddlZsxz3rO2mvpeqmgdFrv6ts17dYDVMv0
         6ZGFHg31Vj59sEhLiPc1RLf7MC4bH2gbaQGSJRyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 407/757] RDMA/ucma: Add missing locking around rdma_leave_multicast()
Date:   Tue, 27 Oct 2020 14:50:57 +0100
Message-Id: <20201027135509.666453539@linuxfoundation.org>
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

[ Upstream commit 38e03d092699891c3237b5aee9e8029d4ede0956 ]

All entry points to the rdma_cm from a ULP must be single threaded,
even this error unwinds. Add the missing locking.

Fixes: 7c11910783a1 ("RDMA/ucma: Put a lock around every call to the rdma_cm layer")
Link: https://lore.kernel.org/r/20200818120526.702120-11-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/ucma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 75ccc31cf0b15..6f42ff8f2ec57 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1512,7 +1512,9 @@ static ssize_t ucma_process_join(struct ucma_file *file,
 	return 0;
 
 err3:
+	mutex_lock(&ctx->mutex);
 	rdma_leave_multicast(ctx->cm_id, (struct sockaddr *) &mc->addr);
+	mutex_unlock(&ctx->mutex);
 	ucma_cleanup_mc_events(mc);
 err2:
 	xa_erase(&multicast_table, mc->id);
-- 
2.25.1



