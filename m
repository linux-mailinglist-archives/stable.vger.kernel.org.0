Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8080C4F37DA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359599AbiDELUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349097AbiDEJtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF4EA997E;
        Tue,  5 Apr 2022 02:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE3F1615E5;
        Tue,  5 Apr 2022 09:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF164C385A2;
        Tue,  5 Apr 2022 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151648;
        bh=rxHQsFLtgiC6ynAr/G0LJGWLVUyFleSmT1QUVei06mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgKGn7O+sgGl9WUA54hx0LIKOPUc2Y5w7v3uxkmpGIO00GHjJPYsBniAYNJkhEKzM
         hy+w4d5DgRrcMaT4sKiUy0NwALqmzWO94r7/vqJjIAHz0p1pEzmF0Jg6F6gJ14Pt5j
         7NQwgD9ZtpOfICcHnNZH7HDPwYGuKzXnl3XQ8NBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 490/913] RDMA/mlx5: Fix the flow of a miss in the allocation of a cache ODP MR
Date:   Tue,  5 Apr 2022 09:25:52 +0200
Message-Id: <20220405070354.542717445@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

[ Upstream commit 2f0e60d5e9f96341a0c8a01be8878cdb3b29ff20 ]

When an ODP MR cache entry is empty and trying to allocate it, increment
the ent->miss counter and call to queue_adjust_cache_locked() to verify
the entry is balanced.

Fixes: aad719dcf379 ("RDMA/mlx5: Allow MRs to be created in the cache synchronously")
Link: https://lore.kernel.org/r/09503e295276dcacc92cb1d8aef1ad0961c99dc1.1644947594.git.leonro@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 22e2f4d79743..7bb1b9d0941c 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -580,6 +580,8 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 	ent = &cache->ent[entry];
 	spin_lock_irq(&ent->lock);
 	if (list_empty(&ent->head)) {
+		queue_adjust_cache_locked(ent);
+		ent->miss++;
 		spin_unlock_irq(&ent->lock);
 		mr = create_cache_mr(ent);
 		if (IS_ERR(mr))
-- 
2.34.1



