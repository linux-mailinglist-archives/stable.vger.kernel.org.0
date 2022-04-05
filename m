Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64584F305C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbiDEIlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237426AbiDEISB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E039B6D07;
        Tue,  5 Apr 2022 01:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD381617EF;
        Tue,  5 Apr 2022 08:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7A4C385A1;
        Tue,  5 Apr 2022 08:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145975;
        bh=CsXFAbQiXAE7EdhvgvZvfFnE7JeU66yXTWJIbyY8xH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RptIOb09fclr1OhdaGNDwBvRIf3lEDiVHlu7jIaNRCg8vgjCKBRvAaCFDtqGH/NIi
         NFMEW3Y2C3s8oP1ky0Jz4A7QPkDnz1vcMbHmE8b0aSvKsv95NIiLv8ZmG2H2RHQ4Wb
         cWwimsfo//17zs17gAVPYgsLV6UpqXtN+8kyqurU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0598/1126] RDMA/mlx5: Fix the flow of a miss in the allocation of a cache ODP MR
Date:   Tue,  5 Apr 2022 09:22:25 +0200
Message-Id: <20220405070425.187941527@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 157d862fb864..2910d7833313 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -585,6 +585,8 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
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



