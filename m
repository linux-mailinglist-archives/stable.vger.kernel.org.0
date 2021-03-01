Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC689328EDF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbhCATjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:39:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241948AbhCATaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:30:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE62465011;
        Mon,  1 Mar 2021 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620957;
        bh=tHg2+MikqaDYNqnDZ5PJAXhsh+XyAi4vbJvxI0/c9EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZYXywb2pragNNGwOGNxHdHoBt/ZK1E2NgColKQE9YdostYvQmihoHBm9Ak9a6yWO
         N2Sc02qkuzNh1oIjNIZRUEiXP6j+pdeNVPOguwZBmCnWzuLN/5AB9WW+jG+jFBiaUK
         JCuK5r0EkgF5bgqu8C9ppQlBO/iPQr8rMNcKdU/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 342/775] RDMA/rtrs-srv: Jump to dereg_mr label if allocate iu fails
Date:   Mon,  1 Mar 2021 17:08:30 +0100
Message-Id: <20210301161218.521252985@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit f77c4839ee8f4612dcb6601602329096030bd813 ]

The rtrs_iu_free is called in rtrs_iu_alloc if memory is limited, so we
don't need to free the same iu again.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20201217141915.56989-7-jinpu.wang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Reviewed-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 341661f42add0..92a216ddd9fd3 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -651,7 +651,7 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 			if (!srv_mr->iu) {
 				err = -ENOMEM;
 				rtrs_err(ss, "rtrs_iu_alloc(), err: %d\n", err);
-				goto free_iu;
+				goto dereg_mr;
 			}
 		}
 		/* Eventually dma addr for each chunk can be cached */
@@ -667,7 +667,6 @@ err:
 			srv_mr = &sess->mrs[mri];
 			sgt = &srv_mr->sgt;
 			mr = srv_mr->mr;
-free_iu:
 			rtrs_iu_free(srv_mr->iu, sess->s.dev->ib_dev, 1);
 dereg_mr:
 			ib_dereg_mr(mr);
-- 
2.27.0



