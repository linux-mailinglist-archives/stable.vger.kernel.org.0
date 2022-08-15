Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369FF59385C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiHOS6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245249AbiHOS5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:57:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93BB32ED8;
        Mon, 15 Aug 2022 11:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFC9760EEB;
        Mon, 15 Aug 2022 18:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A09C433C1;
        Mon, 15 Aug 2022 18:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588334;
        bh=2uZLLptTm77IE4uWUceIMXb7uuydT0vGoKCyD9yiZkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvRpEUOZQSgnNNpEdPENH8OZma+pDwiHYtzvslt/3hy1tDzj8zXeaVJ0tP9v5NooZ
         IpoGqdzl+YWZznCSppbD8XXW9PojukQOoh7vf1YotO5FyauKaKNrm8wGs07YMWCGll
         64bG/ZMvWPmvMRhTZ3kPpdwChcZFCpHo9iovgedo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 370/779] net/mlx5: Adjust log_max_qp to be 18 at most
Date:   Mon, 15 Aug 2022 20:00:14 +0200
Message-Id: <20220815180353.077646240@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit a6e9085d791f8306084fd5bc44dd3fdd4e1ac27b ]

The cited commit limited log_max_qp to be 17 due to FW capabilities.
Recently, it turned out that there are old FW versions that supported
more than 17, so the cited commit caused a degradation.

Thus, set the maximum log_max_qp back to 18 as it was before the
cited commit.

Fixes: 7f839965b2d7 ("net/mlx5: Update log_max_qp value to be 17 at most")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 4ed740994279..5a6606c843ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -516,7 +516,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 
 	/* Check log_max_qp from HCA caps to set in current profile */
 	if (prof->log_max_qp == LOG_MAX_SUPPORTED_QPS) {
-		prof->log_max_qp = min_t(u8, 17, MLX5_CAP_GEN_MAX(dev, log_max_qp));
+		prof->log_max_qp = min_t(u8, 18, MLX5_CAP_GEN_MAX(dev, log_max_qp));
 	} else if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < prof->log_max_qp) {
 		mlx5_core_warn(dev, "log_max_qp value in current profile is %d, changing it to HCA capability limit (%d)\n",
 			       prof->log_max_qp,
-- 
2.35.1



