Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6124F3F2D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352615AbiDEMIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358091AbiDEK16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6191F66C8C;
        Tue,  5 Apr 2022 03:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 011C7617AC;
        Tue,  5 Apr 2022 10:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D952C385A1;
        Tue,  5 Apr 2022 10:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153712;
        bh=do5Wi18Fah0j3dGa06fMFlms+yMjfqPHRKwBB8HgvdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bj33oiR0A/3U9oB6aw/mdcjk6e0+mJaONbeSV1N34tW1RLfz5QqVU5/LYzPRKg7Kz
         Wa0wQy3QAU0TSbSrQdztNP0nvFF83r000mEwimUKswByW00G5uLLfhx7N3lgBsJbyL
         GkRKbKMwJT0J8uJZJFwirqX1WrezXmezCNSJE14Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/599] RDMA/mlx5: Fix the flow of a miss in the allocation of a cache ODP MR
Date:   Tue,  5 Apr 2022 09:30:13 +0200
Message-Id: <20220405070308.325820580@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 19346693c1da..6cd0cbd4fc9f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -575,6 +575,8 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
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



