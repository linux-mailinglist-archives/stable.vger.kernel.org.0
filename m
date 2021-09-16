Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7963240E2CC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245569AbhIPQlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244793AbhIPQjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9BF261A09;
        Thu, 16 Sep 2021 16:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809405;
        bh=KR40IZYrHh8b0Qe0F50d+uCZNuE9iqq88TBKH+LGqd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahKjbUyKMWnvfAL4YiDn39X/8x9jnXrI7Owe005U/dpt/1AOkW38KkdmNm5RArTE8
         DZd7qCwhoXkED7WQzXadG/PQRahtJfWDwoTJTQMCLLsfm6Xb1+Qn5neYh+ZoIySCEG
         pg4prr7uk6FvjFzX378vg++Sop9AN7AMAq7czuFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 110/380] RDMA/hns: Fix return in hns_roce_rereg_user_mr()
Date:   Thu, 16 Sep 2021 17:57:47 +0200
Message-Id: <20210916155807.774581553@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit c4c7d7a43246a42b0355692c3ed53dff7cbb29bb ]

If re-registering an MR in hns_roce_rereg_user_mr(), we should return NULL
instead of passing 0 to ERR_PTR for clarity.

Fixes: 4e9fc1dae2a9 ("RDMA/hns: Optimize the MR registration process")
Link: https://lore.kernel.org/r/20210804125939.20516-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index b8454dcb0318..39a085f8e605 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -361,7 +361,9 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 free_cmd_mbox:
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 
-	return ERR_PTR(ret);
+	if (ret)
+		return ERR_PTR(ret);
+	return NULL;
 }
 
 int hns_roce_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
-- 
2.30.2



