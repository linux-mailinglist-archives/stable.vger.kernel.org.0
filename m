Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2CD4FD05B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350573AbiDLGq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351374AbiDLGol (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:44:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD13A18E38;
        Mon, 11 Apr 2022 23:38:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DCF8B818C8;
        Tue, 12 Apr 2022 06:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CA7C385A8;
        Tue, 12 Apr 2022 06:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745492;
        bh=PvqHw+0KC2vdO+7Gim0lZNn47Tka9RPV+yruKI5WnG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1oTNgRqRdqjpcic1WtPMynoHoVkItbVYOi9q1R/YgitAqZvf6vzLMyoIvnJ5cegS
         DMM2EHDVQ00ObgjqNbcVip9Za2cg2sNt0y4QvRWXfoYzG+JKYFwZW3tX5qsiuNo1BE
         yf4pY7ju9sGx0jUayuq8DJPUVdE9G61P3sorgOoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/171] RDMA/mlx5: Dont remove cache MRs when a delay is needed
Date:   Tue, 12 Apr 2022 08:30:02 +0200
Message-Id: <20220412062931.096860920@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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
index 6cd0cbd4fc9f..d827a4e44c94 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -531,8 +531,10 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
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



