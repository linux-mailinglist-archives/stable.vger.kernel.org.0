Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6B56CC2CB
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbjC1Osq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbjC1Os1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:48:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABE0D333
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2D4F61827
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58FDC433EF;
        Tue, 28 Mar 2023 14:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014848;
        bh=CNvbKjT3yoPQmhli+BKVfS4ylzB0dXwDLQESQJ4Q7Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnCWqpEdueKnMY+PIez3MlGXK2jIV2ilTq2wuyC8IjsUJI3HQTpIy6An3EiZ+tlm1
         p0ct1ZB+tiFzcO0SM5cLx/ADwUtoITh1cV6/eVbbawe2uVDf3Hlu6bXrmg0qeo07l4
         bNP1gvyhbMdz7rKbIyFcwJxLXTTqbU1nwkrMiids=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Emeel Hakim <ehakim@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 075/240] net/mlx5e: Overcome slow response for first macsec ASO WQE
Date:   Tue, 28 Mar 2023 16:40:38 +0200
Message-Id: <20230328142622.893970866@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

[ Upstream commit 7e3fce82d945cf6e7f99034b113ff2d250d7524d ]

First ASO WQE poll causes a cache miss in hardware hence the resut is
delayed. It causes to the situation where such WQE is polled earlier
than it is needed.

Add logic to retry ASO CQ polling operation.

Fixes: 739cfa34518e ("net/mlx5: Make ASO poll CQ usable in atomic context") 
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c    | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index f84f1cfcddb85..25202ceaa7d2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1412,6 +1412,7 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	struct mlx5e_macsec_aso *aso;
 	struct mlx5_aso_wqe *aso_wqe;
 	struct mlx5_aso *maso;
+	unsigned long expires;
 	int err;
 
 	aso = &macsec->aso;
@@ -1425,7 +1426,13 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	macsec_aso_build_wqe_ctrl_seg(aso, &aso_wqe->aso_ctrl, NULL);
 
 	mlx5_aso_post_wqe(maso, false, &aso_wqe->ctrl);
-	err = mlx5_aso_poll_cq(maso, false);
+	expires = jiffies + msecs_to_jiffies(10);
+	do {
+		err = mlx5_aso_poll_cq(maso, false);
+		if (err)
+			usleep_range(2, 10);
+	} while (err && time_is_after_jiffies(expires));
+
 	if (err)
 		goto err_out;
 
-- 
2.39.2



