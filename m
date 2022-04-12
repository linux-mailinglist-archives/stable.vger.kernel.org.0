Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BBF4FD249
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349753AbiDLHJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353034AbiDLHGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:06:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC88F49915;
        Mon, 11 Apr 2022 23:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27E4561464;
        Tue, 12 Apr 2022 06:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351BDC385A1;
        Tue, 12 Apr 2022 06:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746146;
        bh=e3NcP0WQTUBNTnL50EsGpQnLN+HIvQDqCEHRACb0Kgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBs62zUY6SIGBiF4+BuBouu0RzxCGaWB4t4xM6KF+4GOeVjazHHHowxFN0Qy5dqfY
         IXbLeOiloddBWsi2FdHAsRh7znVt5Oz4L12sY+opQxQtMP2890ZS+QkHuEeKjOp4dZ
         iZUUAhEhzVBxP2reAj/Z0fEsg+kYV7SquKoVBvms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/277] RDMA/mlx5: Add a missing update of cache->last_add
Date:   Tue, 12 Apr 2022 08:29:39 +0200
Message-Id: <20220412062947.130685580@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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
index 85289fddc2ae..cf203f879d34 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -635,6 +635,7 @@ static void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	struct mlx5_cache_ent *ent = mr->cache_ent;
 
+	WRITE_ONCE(dev->cache.last_add, jiffies);
 	spin_lock_irq(&ent->lock);
 	list_add_tail(&mr->list, &ent->head);
 	ent->available_mrs++;
-- 
2.35.1



