Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA525219C9
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244780AbiEJNvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244919AbiEJNrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1253205257;
        Tue, 10 May 2022 06:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 688D261763;
        Tue, 10 May 2022 13:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744DAC385A6;
        Tue, 10 May 2022 13:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189560;
        bh=vLBoovPnxDJ2FrdCK4ySKFcu1U2r0SBTTDc2ZSENcHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPlmIpPEduicnYGOpkL68baXh3YA/v/vi2utjHNXChWhrsAjYRmsSI94NexvB7vW3
         0sBOR8SlSV1psOUXgq/QWuA96nhKhqUPaRv8h+k6ieJJmBxQ5tLI2YSRsEgzQ6hD+q
         JZMNsHo6UTKY2s7JSFF0/4YBbnNtpDhekkrtCqYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/135] net/mlx5e: Lag, Fix fib_info pointer assignment
Date:   Tue, 10 May 2022 15:07:53 +0200
Message-Id: <20220510130743.021810602@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit a6589155ec9847918e00e7279b8aa6d4c272bea7 ]

Referenced change incorrectly sets single path fib_info even when LAG is
not active. Fix it by moving call to mlx5_lag_fib_set() into conditional
that verifies LAG state.

Fixes: ad11c4f1d8fd ("net/mlx5e: Lag, Only handle events from highest priority multipath entry")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 8d278c45e7cc..9d50b9c2db5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -149,9 +149,9 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 
 			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
+			mlx5_lag_fib_set(mp, fi);
 		}
 
-		mlx5_lag_fib_set(mp, fi);
 		return;
 	}
 
-- 
2.35.1



