Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F8829C1E0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761021AbgJ0Ohi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761017AbgJ0Ohg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0969522258;
        Tue, 27 Oct 2020 14:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809456;
        bh=rFj323p6y/le7OOmaPAOudmPKkwOptT+du5QG8/VqaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eh+8mQTs83KPDTs4V7/3GIBPkR8qXKAMMqInVKvaJQz2TaYEgZ3KahSe9RhiQZTkm
         foK3vo6Kihb+fCWYyj3o5fiICpBIsWB6jz0fHL9Ga3xlkVQ+/O2HfhhkGSKk8YnAQC
         TEVgcn/Fj057LCIik3CTVKsT2x57RKdHSF2KJvFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/408] RDMA/ucma: Add missing locking around rdma_leave_multicast()
Date:   Tue, 27 Oct 2020 14:52:20 +0100
Message-Id: <20201027135504.471189432@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index d7c74f095805a..ef4be14af3bb9 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1473,7 +1473,9 @@ static ssize_t ucma_process_join(struct ucma_file *file,
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



