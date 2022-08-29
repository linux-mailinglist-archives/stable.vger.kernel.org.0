Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3163B5A493F
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiH2LV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiH2LUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:20:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248D16F278;
        Mon, 29 Aug 2022 04:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90ADD6119C;
        Mon, 29 Aug 2022 11:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B484C433D6;
        Mon, 29 Aug 2022 11:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771462;
        bh=ZOpVESsKOlG8SKi0il5X7/jNZnN0hmU1v9JGkKYh1XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYyDV6FZBT9Npph5ZYl1joduzhSZneOYEnwa7O7eyvoXu05j7lW7vyNH4UhaRV3b8
         J0Mfv7pPQq78EimlxttPHk4sX1KNZ+LSLIsu9aQJAgs0R5/flb/Sz+j7ZHUebaREAp
         GpTPg5Eg6eCqkcZ0nq8qIGIwz/2oX7CYEAj9lBJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roy Novich <royno@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 033/158] net/mlx5: Fix cmd error logging for manage pages cmd
Date:   Mon, 29 Aug 2022 12:58:03 +0200
Message-Id: <20220829105810.176576667@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Roy Novich <royno@nvidia.com>

[ Upstream commit 090f3e4f4089ab8041ed7d632c7851c2a42fcc10 ]

When the driver unloads, give/reclaim_pages may fail as PF driver in
teardown flow, current code will lead to the following kernel log print
'failed reclaiming pages: err 0'.

Fix it to get same behavior as before the cited commits,
by calling mlx5_cmd_check before handling error state.
mlx5_cmd_check will verify if the returned error is an actual error
needed to be handled by the driver or not and will return an
appropriate value.

Fixes: 8d564292a166 ("net/mlx5: Remove redundant error on reclaim pages")
Fixes: 4dac2f10ada0 ("net/mlx5: Remove redundant notify fail on give pages")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index ec76a8b1acc1c..60596357bfc7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -376,8 +376,8 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 			goto out_dropped;
 		}
 	}
+	err = mlx5_cmd_check(dev, err, in, out);
 	if (err) {
-		err = mlx5_cmd_check(dev, err, in, out);
 		mlx5_core_warn(dev, "func_id 0x%x, npages %d, err %d\n",
 			       func_id, npages, err);
 		goto out_dropped;
@@ -524,10 +524,13 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 		dev->priv.reclaim_pages_discard += npages;
 	}
 	/* if triggered by FW event and failed by FW then ignore */
-	if (event && err == -EREMOTEIO)
+	if (event && err == -EREMOTEIO) {
 		err = 0;
+		goto out_free;
+	}
+
+	err = mlx5_cmd_check(dev, err, in, out);
 	if (err) {
-		err = mlx5_cmd_check(dev, err, in, out);
 		mlx5_core_err(dev, "failed reclaiming pages: err %d\n", err);
 		goto out_free;
 	}
-- 
2.35.1



