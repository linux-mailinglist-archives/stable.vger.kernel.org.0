Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2E84C7690
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbiB1SFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240247AbiB1SDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5B4B16F7;
        Mon, 28 Feb 2022 09:46:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B321F60BBF;
        Mon, 28 Feb 2022 17:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C48C340E7;
        Mon, 28 Feb 2022 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070399;
        bh=/hFzPLZdxNyr7sNhIlWRmhRcp4xlGHvWKKPXk1bmKxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDEqV8+TQD5/jEIq4KrqvsqwYaWaMbd4P2NhueKcrcxi5NydgJXSYTgYUzTcH4KeN
         scej+6bLNWjFL9X94Az4x4+rukO0WD8em1bBg7N1mq4WB1It4KQg9COh61tdSYIIUy
         BPbSgDe8srrJY00UVWssroxO6R4VMhx3Y3+TV5jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 093/164] net/mlx5: DR, Fix the threshold that defines when pool sync is initiated
Date:   Mon, 28 Feb 2022 18:24:15 +0100
Message-Id: <20220228172408.235458838@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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


