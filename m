Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D301159A037
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352409AbiHSQWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352486AbiHSQVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:21:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF265120A7;
        Fri, 19 Aug 2022 09:02:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C51861644;
        Fri, 19 Aug 2022 16:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6793EC433C1;
        Fri, 19 Aug 2022 16:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924953;
        bh=sxmVWRTOBaw3goFJkJzZKUfT5tAmhHkbSfuWdgC1Fx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyRJvhZ9yYSA/q6DYg3hYomB6t7J7MqC04KJE/B/dikD/Y3GCdesOU5Kh3j2mgdD5
         vn/dkdeAJYQZdYYqBzZ+TqgcGJP0RlnkZ7MTwl/dSNeCJK2sAEnD7REePYsaSUNasT
         j2v5ILlQRuM9yKwIBrGoNd+T3F9QKnAb5EN84keQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shai Malin <smalin@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 335/545] RDMA/qedr: Improve error logs for rdma_alloc_tid error return
Date:   Fri, 19 Aug 2022 17:41:45 +0200
Message-Id: <20220819153844.379838929@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prabhakar Kushwaha <pkushwaha@marvell.com>

[ Upstream commit 0050a57638ca4d681ff92bee55246bf64a6afe54 ]

Use -EINVAL return type to identify whether error is returned because of
"Out of MR resources" or any other error types.

Link: https://lore.kernel.org/r/20210729151732.30995-2-pkushwaha@marvell.com
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index f7b97b8e81a4..bffacb47ea0e 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2989,7 +2989,11 @@ struct ib_mr *qedr_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 
 	rc = dev->ops->rdma_alloc_tid(dev->rdma_ctx, &mr->hw_mr.itid);
 	if (rc) {
-		DP_ERR(dev, "roce alloc tid returned an error %d\n", rc);
+		if (rc == -EINVAL)
+			DP_ERR(dev, "Out of MR resources\n");
+		else
+			DP_ERR(dev, "roce alloc tid returned error %d\n", rc);
+
 		goto err1;
 	}
 
@@ -3084,7 +3088,11 @@ static struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd,
 
 	rc = dev->ops->rdma_alloc_tid(dev->rdma_ctx, &mr->hw_mr.itid);
 	if (rc) {
-		DP_ERR(dev, "roce alloc tid returned an error %d\n", rc);
+		if (rc == -EINVAL)
+			DP_ERR(dev, "Out of MR resources\n");
+		else
+			DP_ERR(dev, "roce alloc tid returned error %d\n", rc);
+
 		goto err0;
 	}
 
@@ -3214,7 +3222,11 @@ struct ib_mr *qedr_get_dma_mr(struct ib_pd *ibpd, int acc)
 
 	rc = dev->ops->rdma_alloc_tid(dev->rdma_ctx, &mr->hw_mr.itid);
 	if (rc) {
-		DP_ERR(dev, "roce alloc tid returned an error %d\n", rc);
+		if (rc == -EINVAL)
+			DP_ERR(dev, "Out of MR resources\n");
+		else
+			DP_ERR(dev, "roce alloc tid returned error %d\n", rc);
+
 		goto err1;
 	}
 
-- 
2.35.1



