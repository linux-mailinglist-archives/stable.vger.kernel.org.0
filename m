Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D72B4FD3BD
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377252AbiDLHtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358147AbiDLHlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A324248D;
        Tue, 12 Apr 2022 00:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F5FDB81B7A;
        Tue, 12 Apr 2022 07:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF046C385A5;
        Tue, 12 Apr 2022 07:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747846;
        bh=ZQJTxnWwxn1l0rfByrfBEHx7Ho3mbw7y5PfeVOo104Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UblLsF/Vx7zWInNl+uOxT6mRh/vB1paZrXR3JjXVL4QVEpo0Hh7sf7l8uZgqW79Im
         OsWI8dx7NSEZlN0LUzW9lFhDDd5x6emBqHYGpHRaRv4scCpYUNTzIBc/mZlQ/FrCe3
         f4+4CJuypQvK9ZEzY5TB4CQf9kNhSuDIZVUXPTJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 226/343] RDMA/mlx5: Dont remove cache MRs when a delay is needed
Date:   Tue, 12 Apr 2022 08:30:44 +0200
Message-Id: <20220412062957.861565246@linuxfoundation.org>
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

[ Upstream commit 84c2362fb65d69c721fec0974556378cbb36a62b ]

Don't remove MRs from the cache if need to delay the removal.

Fixes: b9358bdbc713 ("RDMA/mlx5: Fix locking in MR cache work queue")
Link: https://lore.kernel.org/r/c3087a90ff362c8796c7eaa2715128743ce36722.1649062436.git.leonro@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 2910d7833313..d3b2d02a4872 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -541,8 +541,10 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 		spin_lock_irq(&ent->lock);
 		if (ent->disabled)
 			goto out;
-		if (need_delay)
+		if (need_delay) {
 			queue_delayed_work(cache->wq, &ent->dwork, 300 * HZ);
+			goto out;
+		}
 		remove_cache_mr_locked(ent);
 		queue_adjust_cache_locked(ent);
 	}
-- 
2.35.1



