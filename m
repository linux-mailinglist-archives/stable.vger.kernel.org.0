Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB974FD654
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353730AbiDLIKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358192AbiDLHlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA98424B8;
        Tue, 12 Apr 2022 00:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34920B81B60;
        Tue, 12 Apr 2022 07:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47F4C385A1;
        Tue, 12 Apr 2022 07:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747849;
        bh=CYdSPQWbDPzISEWdJ44T/uOqTRiv53C+ON7DnWkJjF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwYe9ufFGFVsAbjDXw2+MG6JR1uT5xGQz1zyQjq26eejVXXNNqjGYWowmtiXDEzB6
         XpyWUuXZu+bf9STpV5J6vOkkwM5hq0TTYdXPoHA4B30R9MrmucNyWJm0SZj0kObzog
         3XJTo1O2RYeUIfgGOnPhe0KpGeDVMRSxZn8oufxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 227/343] RDMA/mlx5: Add a missing update of cache->last_add
Date:   Tue, 12 Apr 2022 08:30:45 +0200
Message-Id: <20220412062957.890059764@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit 1d735eeee63a0beb65180ca0224f239cc0c9f804 ]

Update cache->last_add when returning an MR to the cache so that the cache
work won't remove it.

Fixes: b9358bdbc713 ("RDMA/mlx5: Fix locking in MR cache work queue")
Link: https://lore.kernel.org/r/c99f076fce4b44829d434936bbcd3b5fc4c95020.1649062436.git.leonro@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index d3b2d02a4872..d40a1460ef97 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -632,6 +632,7 @@ static void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	struct mlx5_cache_ent *ent = mr->cache_ent;
 
+	WRITE_ONCE(dev->cache.last_add, jiffies);
 	spin_lock_irq(&ent->lock);
 	list_add_tail(&mr->list, &ent->head);
 	ent->available_mrs++;
-- 
2.35.1



