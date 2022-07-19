Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED6C579AA8
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbiGSMRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239089AbiGSMP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:15:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DD854C88;
        Tue, 19 Jul 2022 05:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72449CE1BE6;
        Tue, 19 Jul 2022 12:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B98C341C6;
        Tue, 19 Jul 2022 12:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232359;
        bh=Ei5OpdfzeLsXv6I8F7TTEkawWi+25j66vjp+az5qjh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzNq2/IuPPwVudwJ/DN8hFRajKIwgP/OCmW1W8JfQsPwxjveK/fhPoD+dEOgWEwkD
         vVRSVEc9+d4gqpFgHL0CMVHHpJoP8m2L1FFTvhl16Vs7Yb2mhQIB1SNidRnu1P1N6I
         6EhIzLM2g9mlIZJrlivfoAN3PUtmqXZuCYq6SfWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/112] net/mlx5e: Fix capability check for updating vnic env counters
Date:   Tue, 19 Jul 2022 13:53:24 +0200
Message-Id: <20220719114629.120968574@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 452133dd580811f184e76b1402983182ee425298 ]

The existing capability check for vnic env counters only checks for
receive steering discards, although we need the counters update for the
exposed internal queue oob counter as well. This could result in the
latter counter not being updated correctly when the receive steering
discards counter is not supported.
Fix that by checking whether any counter is supported instead of only
the steering counter capability.

Fixes: 0cfafd4b4ddf ("net/mlx5e: Add device out of buffer counter")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 78f6a6f0a7e0..ff4f10d0f090 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -536,7 +536,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vnic_env)
 	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (!MLX5_CAP_GEN(priv->mdev, nic_receive_steering_discard))
+	if (!mlx5e_stats_grp_vnic_env_num_stats(priv))
 		return;
 
 	MLX5_SET(query_vnic_env_in, in, opcode, MLX5_CMD_OP_QUERY_VNIC_ENV);
-- 
2.35.1



