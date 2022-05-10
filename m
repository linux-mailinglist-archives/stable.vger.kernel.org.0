Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DA3521AA4
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241099AbiEJOCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244608AbiEJNz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:55:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7EB663FE;
        Tue, 10 May 2022 06:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC85FB81DC7;
        Tue, 10 May 2022 13:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BFEC385A6;
        Tue, 10 May 2022 13:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189914;
        bh=1g6coX2ecD6ja2I4HHiOaPhcem39u5y+T3mHAMQOf/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1iCz5Y0FgZKd/yj+yMb5uwjO2s1QEklzlmEz6MuJvCI/ydCF6feULgq8sq8eh5uS
         tjPHZNve/z4N2sADs2kTFBCYfsSuzTW9IvJ7+ZAOUA6KeCTHS/wbre49Ir/Lr/mJhX
         3OqAqM74aZMCm4si/SAQ1cZ3Bdr9Scjvx3IIvaZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.17 069/140] net/mlx5: Fix matching on inner TTC
Date:   Tue, 10 May 2022 15:07:39 +0200
Message-Id: <20220510130743.592071899@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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

From: Mark Bloch <mbloch@nvidia.com>

commit a042d7f5bb68c47f6e0e546ca367d14e1e4b25ba upstream.

The cited commits didn't use proper matching on inner TTC
as a result distribution of encapsulated packets wasn't symmetric
between the physical ports.

Fixes: 4c71ce50d2fe ("net/mlx5: Support partial TTC rules")
Fixes: 8e25a2bc6687 ("net/mlx5: Lag, add support to create TTC tables for LAG port selection")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c   | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index a6592f9c3c05..5be322528279 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -505,7 +505,7 @@ static int mlx5_lag_create_inner_ttc_table(struct mlx5_lag *ldev)
 	struct ttc_params ttc_params = {};
 
 	mlx5_lag_set_inner_ttc_params(ldev, &ttc_params);
-	port_sel->inner.ttc = mlx5_create_ttc_table(dev, &ttc_params);
+	port_sel->inner.ttc = mlx5_create_inner_ttc_table(dev, &ttc_params);
 	if (IS_ERR(port_sel->inner.ttc))
 		return PTR_ERR(port_sel->inner.ttc);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
index b63dec24747a..b78f2ba25c19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
@@ -408,6 +408,8 @@ static int mlx5_generate_inner_ttc_table_rules(struct mlx5_core_dev *dev,
 	for (tt = 0; tt < MLX5_NUM_TT; tt++) {
 		struct mlx5_ttc_rule *rule = &rules[tt];
 
+		if (test_bit(tt, params->ignore_dests))
+			continue;
 		rule->rule = mlx5_generate_inner_ttc_rule(dev, ft,
 							  &params->dests[tt],
 							  ttc_rules[tt].etype,
-- 
2.36.1



