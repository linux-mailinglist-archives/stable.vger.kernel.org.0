Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6FE531D0A
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241610AbiEWRjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241858AbiEWRgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:36:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4526191579;
        Mon, 23 May 2022 10:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDAF160AB8;
        Mon, 23 May 2022 17:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5670C385A9;
        Mon, 23 May 2022 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326985;
        bh=q397SqOxgwTvP4betPRapKBfjpqHdQtGoq/IFQzfvWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6jX647fItpXaJCf3EREhWMwCMZmWmuWstrFtJuvIawgoNUyga9U4egenkXfyxWJv
         x6OriRS08+ivXSXip3eix8O8rEJRVrFtY66cK0/2ubacqaS+vZ+lBDQwBn6mrT8mcy
         LBym8qPI9Vn/83QiwrzAU4fd1v6y0sE2B0MICHFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 120/158] vdpa/mlx5: Use consistent RQT size
Date:   Mon, 23 May 2022 19:04:37 +0200
Message-Id: <20220523165850.697295863@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit acde3929492bcb9ceb0df1270230c422b1013798 ]

The current code evaluates RQT size based on the configured number of
virtqueues. This can raise an issue in the following scenario:

Assume MQ was negotiated.
1. mlx5_vdpa_set_map() gets called.
2. handle_ctrl_mq() is called setting cur_num_vqs to some value, lower
   than the configured max VQs.
3. A second set_map gets called, but now a smaller number of VQs is used
   to evaluate the size of the RQT.
4. handle_ctrl_mq() is called with a value larger than what the RQT can
   hold. This will emit errors and the driver state is compromised.

To fix this, we use a new field in struct mlx5_vdpa_net to hold the
required number of entries in the RQT. This value is evaluated in
mlx5_vdpa_set_driver_features() where we have the negotiated features
all set up.

In addition to that, we take into consideration the max capability of RQT
entries early when the device is added so we don't need to take consider
it when creating the RQT.

Last, we remove the use of mlx5_vdpa_max_qps() which just returns the
max_vas / 2 and make the code clearer.

Fixes: 52893733f2c5 ("vdpa/mlx5: Add multiqueue support")
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 61 +++++++++++--------------------
 1 file changed, 21 insertions(+), 40 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 1b5de3af1a62..9c45be8ab178 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -161,6 +161,7 @@ struct mlx5_vdpa_net {
 	struct mlx5_flow_handle *rx_rule_mcast;
 	bool setup;
 	u32 cur_num_vqs;
+	u32 rqt_size;
 	struct notifier_block nb;
 	struct vdpa_callback config_cb;
 	struct mlx5_vdpa_wq_ent cvq_ent;
@@ -204,17 +205,12 @@ static __virtio16 cpu_to_mlx5vdpa16(struct mlx5_vdpa_dev *mvdev, u16 val)
 	return __cpu_to_virtio16(mlx5_vdpa_is_little_endian(mvdev), val);
 }
 
-static inline u32 mlx5_vdpa_max_qps(int max_vqs)
-{
-	return max_vqs / 2;
-}
-
 static u16 ctrl_vq_idx(struct mlx5_vdpa_dev *mvdev)
 {
 	if (!(mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_MQ)))
 		return 2;
 
-	return 2 * mlx5_vdpa_max_qps(mvdev->max_vqs);
+	return mvdev->max_vqs;
 }
 
 static bool is_ctrl_vq_idx(struct mlx5_vdpa_dev *mvdev, u16 idx)
@@ -1236,25 +1232,13 @@ static void teardown_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *
 static int create_rqt(struct mlx5_vdpa_net *ndev)
 {
 	__be32 *list;
-	int max_rqt;
 	void *rqtc;
 	int inlen;
 	void *in;
 	int i, j;
 	int err;
-	int num;
-
-	if (!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_NET_F_MQ)))
-		num = 1;
-	else
-		num = ndev->cur_num_vqs / 2;
 
-	max_rqt = min_t(int, roundup_pow_of_two(num),
-			1 << MLX5_CAP_GEN(ndev->mvdev.mdev, log_max_rqt_size));
-	if (max_rqt < 1)
-		return -EOPNOTSUPP;
-
-	inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + max_rqt * MLX5_ST_SZ_BYTES(rq_num);
+	inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + ndev->rqt_size * MLX5_ST_SZ_BYTES(rq_num);
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
@@ -1263,12 +1247,12 @@ static int create_rqt(struct mlx5_vdpa_net *ndev)
 	rqtc = MLX5_ADDR_OF(create_rqt_in, in, rqt_context);
 
 	MLX5_SET(rqtc, rqtc, list_q_type, MLX5_RQTC_LIST_Q_TYPE_VIRTIO_NET_Q);
-	MLX5_SET(rqtc, rqtc, rqt_max_size, max_rqt);
+	MLX5_SET(rqtc, rqtc, rqt_max_size, ndev->rqt_size);
 	list = MLX5_ADDR_OF(rqtc, rqtc, rq_num[0]);
-	for (i = 0, j = 0; i < max_rqt; i++, j += 2)
-		list[i] = cpu_to_be32(ndev->vqs[j % (2 * num)].virtq_id);
+	for (i = 0, j = 0; i < ndev->rqt_size; i++, j += 2)
+		list[i] = cpu_to_be32(ndev->vqs[j % ndev->cur_num_vqs].virtq_id);
 
-	MLX5_SET(rqtc, rqtc, rqt_actual_size, max_rqt);
+	MLX5_SET(rqtc, rqtc, rqt_actual_size, ndev->rqt_size);
 	err = mlx5_vdpa_create_rqt(&ndev->mvdev, in, inlen, &ndev->res.rqtn);
 	kfree(in);
 	if (err)
@@ -1282,19 +1266,13 @@ static int create_rqt(struct mlx5_vdpa_net *ndev)
 static int modify_rqt(struct mlx5_vdpa_net *ndev, int num)
 {
 	__be32 *list;
-	int max_rqt;
 	void *rqtc;
 	int inlen;
 	void *in;
 	int i, j;
 	int err;
 
-	max_rqt = min_t(int, roundup_pow_of_two(ndev->cur_num_vqs / 2),
-			1 << MLX5_CAP_GEN(ndev->mvdev.mdev, log_max_rqt_size));
-	if (max_rqt < 1)
-		return -EOPNOTSUPP;
-
-	inlen = MLX5_ST_SZ_BYTES(modify_rqt_in) + max_rqt * MLX5_ST_SZ_BYTES(rq_num);
+	inlen = MLX5_ST_SZ_BYTES(modify_rqt_in) + ndev->rqt_size * MLX5_ST_SZ_BYTES(rq_num);
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
@@ -1305,10 +1283,10 @@ static int modify_rqt(struct mlx5_vdpa_net *ndev, int num)
 	MLX5_SET(rqtc, rqtc, list_q_type, MLX5_RQTC_LIST_Q_TYPE_VIRTIO_NET_Q);
 
 	list = MLX5_ADDR_OF(rqtc, rqtc, rq_num[0]);
-	for (i = 0, j = 0; i < max_rqt; i++, j += 2)
+	for (i = 0, j = 0; i < ndev->rqt_size; i++, j += 2)
 		list[i] = cpu_to_be32(ndev->vqs[j % num].virtq_id);
 
-	MLX5_SET(rqtc, rqtc, rqt_actual_size, max_rqt);
+	MLX5_SET(rqtc, rqtc, rqt_actual_size, ndev->rqt_size);
 	err = mlx5_vdpa_modify_rqt(&ndev->mvdev, in, inlen, ndev->res.rqtn);
 	kfree(in);
 	if (err)
@@ -1582,7 +1560,7 @@ static virtio_net_ctrl_ack handle_ctrl_mq(struct mlx5_vdpa_dev *mvdev, u8 cmd)
 
 		newqps = mlx5vdpa16_to_cpu(mvdev, mq.virtqueue_pairs);
 		if (newqps < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
-		    newqps > mlx5_vdpa_max_qps(mvdev->max_vqs))
+		    newqps > ndev->rqt_size)
 			break;
 
 		if (ndev->cur_num_vqs == 2 * newqps) {
@@ -1937,7 +1915,7 @@ static int setup_virtqueues(struct mlx5_vdpa_dev *mvdev)
 	int err;
 	int i;
 
-	for (i = 0; i < 2 * mlx5_vdpa_max_qps(mvdev->max_vqs); i++) {
+	for (i = 0; i < mvdev->max_vqs; i++) {
 		err = setup_vq(ndev, &ndev->vqs[i]);
 		if (err)
 			goto err_vq;
@@ -2008,9 +1986,11 @@ static int mlx5_vdpa_set_driver_features(struct vdpa_device *vdev, u64 features)
 
 	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
 	if (ndev->mvdev.actual_features & BIT_ULL(VIRTIO_NET_F_MQ))
-		ndev->cur_num_vqs = 2 * mlx5vdpa16_to_cpu(mvdev, ndev->config.max_virtqueue_pairs);
+		ndev->rqt_size = mlx5vdpa16_to_cpu(mvdev, ndev->config.max_virtqueue_pairs);
 	else
-		ndev->cur_num_vqs = 2;
+		ndev->rqt_size = 1;
+
+	ndev->cur_num_vqs = 2 * ndev->rqt_size;
 
 	update_cvq_info(mvdev);
 	return err;
@@ -2463,7 +2443,7 @@ static void init_mvqs(struct mlx5_vdpa_net *ndev)
 	struct mlx5_vdpa_virtqueue *mvq;
 	int i;
 
-	for (i = 0; i < 2 * mlx5_vdpa_max_qps(ndev->mvdev.max_vqs); ++i) {
+	for (i = 0; i < ndev->mvdev.max_vqs; ++i) {
 		mvq = &ndev->vqs[i];
 		memset(mvq, 0, offsetof(struct mlx5_vdpa_virtqueue, ri));
 		mvq->index = i;
@@ -2583,7 +2563,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 		return -EOPNOTSUPP;
 	}
 
-	max_vqs = MLX5_CAP_DEV_VDPA_EMULATION(mdev, max_num_virtio_queues);
+	max_vqs = min_t(int, MLX5_CAP_DEV_VDPA_EMULATION(mdev, max_num_virtio_queues),
+			1 << MLX5_CAP_GEN(mdev, log_max_rqt_size));
 	if (max_vqs < 2) {
 		dev_warn(mdev->device,
 			 "%d virtqueues are supported. At least 2 are required\n",
@@ -2647,7 +2628,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 		ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_MAC);
 	}
 
-	config->max_virtqueue_pairs = cpu_to_mlx5vdpa16(mvdev, mlx5_vdpa_max_qps(max_vqs));
+	config->max_virtqueue_pairs = cpu_to_mlx5vdpa16(mvdev, max_vqs / 2);
 	mvdev->vdev.dma_dev = &mdev->pdev->dev;
 	err = mlx5_vdpa_alloc_resources(&ndev->mvdev);
 	if (err)
@@ -2674,7 +2655,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	ndev->nb.notifier_call = event_handler;
 	mlx5_notifier_register(mdev, &ndev->nb);
 	mvdev->vdev.mdev = &mgtdev->mgtdev;
-	err = _vdpa_register_device(&mvdev->vdev, 2 * mlx5_vdpa_max_qps(max_vqs) + 1);
+	err = _vdpa_register_device(&mvdev->vdev, max_vqs + 1);
 	if (err)
 		goto err_reg;
 
-- 
2.35.1



