Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A75434425D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhCVMky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhCVMjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30D6C61990;
        Mon, 22 Mar 2021 12:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416698;
        bh=7dZcc6S4vby2si67XYpff5JV66YSx5XlIYra0L1b5h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfYPCYX6fSDC6Uon1Gmb99R5TgT2g9Zr00kc6QZfMe+SjRfg/yZzRZhmodY/tKAv0
         04sExNva9RUWiQfsp4xeCY6JAREdaxq+snjyVihkBTUItTm/S+Pwl+HDOngOlFqiDz
         Cm42zv6Q3fWJWD0MKguSQgTDfG+joYaDM8TwR8j4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/157] RDMA/rtrs-srv: Jump to dereg_mr label if allocate iu fails
Date:   Mon, 22 Mar 2021 13:27:06 +0100
Message-Id: <20210322121935.954714050@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
index 0fd2a7f8f9f2..43806180f85e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -671,7 +671,7 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 			if (!srv_mr->iu) {
 				err = -ENOMEM;
 				rtrs_err(ss, "rtrs_iu_alloc(), err: %d\n", err);
-				goto free_iu;
+				goto dereg_mr;
 			}
 		}
 		/* Eventually dma addr for each chunk can be cached */
@@ -687,7 +687,6 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 			srv_mr = &sess->mrs[mri];
 			sgt = &srv_mr->sgt;
 			mr = srv_mr->mr;
-free_iu:
 			rtrs_iu_free(srv_mr->iu, sess->s.dev->ib_dev, 1);
 dereg_mr:
 			ib_dereg_mr(mr);
-- 
2.30.1



