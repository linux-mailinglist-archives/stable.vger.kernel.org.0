Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BA45F2BD1
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJCIaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiJCI36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:29:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB126613B;
        Mon,  3 Oct 2022 01:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA3CD60F9F;
        Mon,  3 Oct 2022 07:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B31BC433D6;
        Mon,  3 Oct 2022 07:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781346;
        bh=yRBQe6PMJ2ERLuGkK9OKR07cUYELkHgG6mBeiC+z6fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3qUD4nsLDwFokZ0BC72jEGtrklI9V8NTBqCtjhyRZAnWibOH8Eqf2cGhiLvxU1n/
         paC6pGfvGk+6wADZdrVhxTcbvl4mBPasxi38rOgcbtDLrSBGFsjQ1xHVqvkyDvma/P
         s5Yt3PSvkgYt+QIsx5NZHLh2vpmhbIgb7fklUiKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 088/101] vdpa/mlx5: Fix MQ to support non power of two num queues
Date:   Mon,  3 Oct 2022 09:11:24 +0200
Message-Id: <20221003070726.634609733@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit a43ae8057cc154fd26a3a23c0e8643bef104d995 ]

RQT objects require that a power of two value be configured for both
rqt_max_size and rqt_actual size.

For create_rqt, make sure to round up to the power of two the value of
given by the user who created the vdpa device and given by
ndev->rqt_size. The actual size is also rounded up to the power of two
using the current number of VQs given by ndev->cur_num_vqs.

Same goes with modify_rqt where we need to make sure act size is power
of two based on the new number of QPs.

Without this patch, attempt to create a device with non power of two QPs
would result in error from firmware.

Fixes: 52893733f2c5 ("vdpa/mlx5: Add multiqueue support")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Message-Id: <20220912125019.833708-1-elic@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index e85c1d71f4ed..f527cbeb1169 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1297,6 +1297,8 @@ static void teardown_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *
 
 static int create_rqt(struct mlx5_vdpa_net *ndev)
 {
+	int rqt_table_size = roundup_pow_of_two(ndev->rqt_size);
+	int act_sz = roundup_pow_of_two(ndev->cur_num_vqs / 2);
 	__be32 *list;
 	void *rqtc;
 	int inlen;
@@ -1304,7 +1306,7 @@ static int create_rqt(struct mlx5_vdpa_net *ndev)
 	int i, j;
 	int err;
 
-	inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + ndev->rqt_size * MLX5_ST_SZ_BYTES(rq_num);
+	inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + rqt_table_size * MLX5_ST_SZ_BYTES(rq_num);
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
@@ -1313,12 +1315,12 @@ static int create_rqt(struct mlx5_vdpa_net *ndev)
 	rqtc = MLX5_ADDR_OF(create_rqt_in, in, rqt_context);
 
 	MLX5_SET(rqtc, rqtc, list_q_type, MLX5_RQTC_LIST_Q_TYPE_VIRTIO_NET_Q);
-	MLX5_SET(rqtc, rqtc, rqt_max_size, ndev->rqt_size);
+	MLX5_SET(rqtc, rqtc, rqt_max_size, rqt_table_size);
 	list = MLX5_ADDR_OF(rqtc, rqtc, rq_num[0]);
-	for (i = 0, j = 0; i < ndev->rqt_size; i++, j += 2)
+	for (i = 0, j = 0; i < act_sz; i++, j += 2)
 		list[i] = cpu_to_be32(ndev->vqs[j % ndev->cur_num_vqs].virtq_id);
 
-	MLX5_SET(rqtc, rqtc, rqt_actual_size, ndev->rqt_size);
+	MLX5_SET(rqtc, rqtc, rqt_actual_size, act_sz);
 	err = mlx5_vdpa_create_rqt(&ndev->mvdev, in, inlen, &ndev->res.rqtn);
 	kfree(in);
 	if (err)
@@ -1331,6 +1333,7 @@ static int create_rqt(struct mlx5_vdpa_net *ndev)
 
 static int modify_rqt(struct mlx5_vdpa_net *ndev, int num)
 {
+	int act_sz = roundup_pow_of_two(num / 2);
 	__be32 *list;
 	void *rqtc;
 	int inlen;
@@ -1338,7 +1341,7 @@ static int modify_rqt(struct mlx5_vdpa_net *ndev, int num)
 	int i, j;
 	int err;
 
-	inlen = MLX5_ST_SZ_BYTES(modify_rqt_in) + ndev->rqt_size * MLX5_ST_SZ_BYTES(rq_num);
+	inlen = MLX5_ST_SZ_BYTES(modify_rqt_in) + act_sz * MLX5_ST_SZ_BYTES(rq_num);
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
@@ -1349,10 +1352,10 @@ static int modify_rqt(struct mlx5_vdpa_net *ndev, int num)
 	MLX5_SET(rqtc, rqtc, list_q_type, MLX5_RQTC_LIST_Q_TYPE_VIRTIO_NET_Q);
 
 	list = MLX5_ADDR_OF(rqtc, rqtc, rq_num[0]);
-	for (i = 0, j = 0; i < ndev->rqt_size; i++, j += 2)
+	for (i = 0, j = 0; i < act_sz; i++, j = j + 2)
 		list[i] = cpu_to_be32(ndev->vqs[j % num].virtq_id);
 
-	MLX5_SET(rqtc, rqtc, rqt_actual_size, ndev->rqt_size);
+	MLX5_SET(rqtc, rqtc, rqt_actual_size, act_sz);
 	err = mlx5_vdpa_modify_rqt(&ndev->mvdev, in, inlen, ndev->res.rqtn);
 	kfree(in);
 	if (err)
-- 
2.35.1



