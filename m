Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E037B4C755E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239200AbiB1Rwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbiB1Rwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:52:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89883A6441;
        Mon, 28 Feb 2022 09:39:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9C36153C;
        Mon, 28 Feb 2022 17:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CDCC340F0;
        Mon, 28 Feb 2022 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069981;
        bh=/hFzPLZdxNyr7sNhIlWRmhRcp4xlGHvWKKPXk1bmKxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwXkKCTOUsCUt7HyZhQWfGawH3Lj8TdtkXBThFg5PJ3FOQi9IqofpM4sFsKW8uX5H
         FPUDHusgxuRHtMd5tor2ErCsBK4OKjMj5leH/Ok0Jw+kzmdf0c+j6BuGYePCo89593
         YN26rztYdzC2HvTP0gL4KMDCci/jW9LeHEAIbJBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 081/139] net/mlx5: DR, Fix the threshold that defines when pool sync is initiated
Date:   Mon, 28 Feb 2022 18:24:15 +0100
Message-Id: <20220228172356.212832521@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

commit ecd9c5cd46e013659e2fad433057bad1ba66888e upstream.

When deciding whether to start syncing and actually free all the "hot"
ICM chunks, we need to consider the type of the ICM chunks that we're
dealing with. For instance, the amount of available ICM for MODIFY_ACTION
is significantly lower than the usual STE ICM, so the threshold should
account for that - otherwise we can deplete MODIFY_ACTION memory just by
creating and deleting the same modify header action in a continuous loop.

This patch replaces the hard-coded threshold with a dynamic value.

Fixes: 1c58651412bb ("net/mlx5: DR, ICM memory pools sync optimization")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c |   11 ++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -4,7 +4,6 @@
 #include "dr_types.h"
 
 #define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
-#define DR_ICM_SYNC_THRESHOLD_POOL (64 * 1024 * 1024)
 
 struct mlx5dr_icm_pool {
 	enum mlx5dr_icm_type icm_type;
@@ -324,10 +323,14 @@ dr_icm_chunk_create(struct mlx5dr_icm_po
 
 static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 {
-	if (pool->hot_memory_size > DR_ICM_SYNC_THRESHOLD_POOL)
-		return true;
+	int allow_hot_size;
 
-	return false;
+	/* sync when hot memory reaches half of the pool size */
+	allow_hot_size =
+		mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
+						   pool->icm_type) / 2;
+
+	return pool->hot_memory_size > allow_hot_size;
 }
 
 static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)


