Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51EF23A67D
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgHCMYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbgHCMYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:24:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA72207DF;
        Mon,  3 Aug 2020 12:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457473;
        bh=znP48UUrfcieyr9M3jiX+D1fLtyBGn+wiIUsxEKDWiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNKKvX7oNTqXxlR1Msi0MacyfMc4g/hboUlUW9MDJgpmG2bAbBtzJeTUQP/D0OWpK
         VJnG8K5L/710WIRyO9fUVDEydGN+IwJ/T42rtpBd0atrJGeOCaYfWJHG0YlR4smsrh
         Q70+75V7lyN/gJsXF5R4eZCtCyWdo2E90b6lzM5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 080/120] RDMA/core: Stop DIM before destroying CQ
Date:   Mon,  3 Aug 2020 14:18:58 +0200
Message-Id: <20200803121906.748055335@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 5d46b289d04b98eb992b2f8b67745cc0953e16b1 ]

HW destroy operation should be last operation after all possible CQ users
completed their work, so move DIM work cancellation before such destroy
call.

Fixes: da6629793aa6 ("RDMA/core: Provide RDMA DIM support for ULPs")
Link: https://lore.kernel.org/r/20200730082719.1582397-3-leon@kernel.org
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cq.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 4f25b24006945..c259f632f257f 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -68,6 +68,15 @@ static void rdma_dim_init(struct ib_cq *cq)
 	INIT_WORK(&dim->work, ib_cq_rdma_dim_work);
 }
 
+static void rdma_dim_destroy(struct ib_cq *cq)
+{
+	if (!cq->dim)
+		return;
+
+	cancel_work_sync(&cq->dim->work);
+	kfree(cq->dim);
+}
+
 static int __poll_cq(struct ib_cq *cq, int num_entries, struct ib_wc *wc)
 {
 	int rc;
@@ -324,12 +333,10 @@ void ib_free_cq_user(struct ib_cq *cq, struct ib_udata *udata)
 		WARN_ON_ONCE(1);
 	}
 
+	rdma_dim_destroy(cq);
 	trace_cq_free(cq);
 	rdma_restrack_del(&cq->res);
 	cq->device->ops.destroy_cq(cq, udata);
-	if (cq->dim)
-		cancel_work_sync(&cq->dim->work);
-	kfree(cq->dim);
 	kfree(cq->wc);
 	kfree(cq);
 }
-- 
2.25.1



