Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9B2694981
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjBMO71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjBMO7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:59:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79381DBBC
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C6C26116D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21225C433EF;
        Mon, 13 Feb 2023 14:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300310;
        bh=wzZpU6F9WtJ94ygPICDTmIB0BOXU4zR+L00J7oAmH/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+7RKeZ5u3xgL1DSa2vTQq4jWDm0Zyb7yaeY+sC39QGxefe1OwCHdeJ0BSt14WzDo
         acd29DW4JWTrdFDBeuojd3xsmNqZ4EFoADOCAUsH4arXMjgG8+4pB3QWIoBFsmIiJd
         39vCgDx1qQTKpUrvL58WBO4RfuK+TvXWO3/51rmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/67] net/mlx5e: Move repeating clear_bit in mlx5e_rx_reporter_err_rq_cqe_recover
Date:   Mon, 13 Feb 2023 15:49:11 +0100
Message-Id: <20230213144733.813988522@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit e64d71d055ca01fa5054d25b99fb29b98e543a31 ]

The same clear_bit is called in both error and success flows. Move the
call to do it only once and remove the out label.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1e66220948df ("net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index e329158fdc555..0f1dbad7c9f1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -157,16 +157,13 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 	mlx5e_free_rx_descs(rq);
 
 	err = mlx5e_rq_to_ready(rq, MLX5_RQC_STATE_ERR);
+	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	if (err)
-		goto out;
+		return err;
 
-	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	mlx5e_activate_rq(rq);
 	rq->stats->recover++;
 	return 0;
-out:
-	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
-	return err;
 }
 
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
-- 
2.39.0



