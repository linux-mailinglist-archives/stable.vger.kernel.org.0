Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097744FD232
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242627AbiDLHJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352385AbiDLHFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:05:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169A14755A;
        Mon, 11 Apr 2022 23:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4B911CE1ACD;
        Tue, 12 Apr 2022 06:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669B3C385A1;
        Tue, 12 Apr 2022 06:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746082;
        bh=aerjsHYta4p5BO75zyRyU/TcN/xKZqEZrsirsAEO+Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSjT6uMpdUXQGBB82zAPUZWkJpBt8zrDguUV8lsX9Zi02XCTf9zal0MwXJBGzn/PI
         h4q+0lWfEFz6hIK3OBJ4U3NbgUKUcI3W0+J2ZT0xoCQsacJZUAsHG3uxZKkHm7TdYO
         Z4bc3Wr6kQN6+41a9+76plQXeT2cZPiIARZmAq74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/277] vdpa/mlx5: Propagate link status from device to vdpa driver
Date:   Tue, 12 Apr 2022 08:29:18 +0200
Message-Id: <20220412062946.525005726@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit edf747affc41a18ccc3a616813d4c2b6d38b46ce ]

Add code to register to hardware asynchronous events. Use this
mechanism to track link status events coming from the device and update
the config struct.

After doing link status change, call the vdpa callback to notify of the
link status change.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210909123635.30884-4-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 94 ++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index f769e2dc6d26..92a2484c8596 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -161,6 +161,8 @@ struct mlx5_vdpa_net {
 	bool setup;
 	u16 mtu;
 	u32 cur_num_vqs;
+	struct notifier_block nb;
+	struct vdpa_callback config_cb;
 };
 
 static void free_resources(struct mlx5_vdpa_net *ndev);
@@ -1868,6 +1870,7 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
 	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_CTRL_VQ);
 	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_CTRL_MAC_ADDR);
 	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_MQ);
+	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_STATUS);
 
 	print_features(mvdev, ndev->mvdev.mlx_features, false);
 	return ndev->mvdev.mlx_features;
@@ -1980,8 +1983,10 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
 
 static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callback *cb)
 {
-	/* not implemented */
-	mlx5_vdpa_warn(to_mvdev(vdev), "set config callback not supported\n");
+	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+
+	ndev->config_cb = *cb;
 }
 
 #define MLX5_VDPA_MAX_VQ_ENTRIES 256
@@ -2433,6 +2438,82 @@ struct mlx5_vdpa_mgmtdev {
 	struct mlx5_vdpa_net *ndev;
 };
 
+static u8 query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
+{
+	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_vport_state_in)] = {};
+	int err;
+
+	MLX5_SET(query_vport_state_in, in, opcode, MLX5_CMD_OP_QUERY_VPORT_STATE);
+	MLX5_SET(query_vport_state_in, in, op_mod, opmod);
+	MLX5_SET(query_vport_state_in, in, vport_number, vport);
+	if (vport)
+		MLX5_SET(query_vport_state_in, in, other_vport, 1);
+
+	err = mlx5_cmd_exec_inout(mdev, query_vport_state, in, out);
+	if (err)
+		return 0;
+
+	return MLX5_GET(query_vport_state_out, out, state);
+}
+
+static bool get_link_state(struct mlx5_vdpa_dev *mvdev)
+{
+	if (query_vport_state(mvdev->mdev, MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT, 0) ==
+	    VPORT_STATE_UP)
+		return true;
+
+	return false;
+}
+
+static void update_carrier(struct work_struct *work)
+{
+	struct mlx5_vdpa_wq_ent *wqent;
+	struct mlx5_vdpa_dev *mvdev;
+	struct mlx5_vdpa_net *ndev;
+
+	wqent = container_of(work, struct mlx5_vdpa_wq_ent, work);
+	mvdev = wqent->mvdev;
+	ndev = to_mlx5_vdpa_ndev(mvdev);
+	if (get_link_state(mvdev))
+		ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
+	else
+		ndev->config.status &= cpu_to_mlx5vdpa16(mvdev, ~VIRTIO_NET_S_LINK_UP);
+
+	if (ndev->config_cb.callback)
+		ndev->config_cb.callback(ndev->config_cb.private);
+
+	kfree(wqent);
+}
+
+static int event_handler(struct notifier_block *nb, unsigned long event, void *param)
+{
+	struct mlx5_vdpa_net *ndev = container_of(nb, struct mlx5_vdpa_net, nb);
+	struct mlx5_eqe *eqe = param;
+	int ret = NOTIFY_DONE;
+	struct mlx5_vdpa_wq_ent *wqent;
+
+	if (event == MLX5_EVENT_TYPE_PORT_CHANGE) {
+		switch (eqe->sub_type) {
+		case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
+		case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
+			wqent = kzalloc(sizeof(*wqent), GFP_ATOMIC);
+			if (!wqent)
+				return NOTIFY_DONE;
+
+			wqent->mvdev = &ndev->mvdev;
+			INIT_WORK(&wqent->work, update_carrier);
+			queue_work(ndev->mvdev.wq, &wqent->work);
+			ret = NOTIFY_OK;
+			break;
+		default:
+			return NOTIFY_DONE;
+		}
+		return ret;
+	}
+	return ret;
+}
+
 static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 {
 	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
@@ -2477,6 +2558,11 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 	if (err)
 		goto err_mtu;
 
+	if (get_link_state(mvdev))
+		ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
+	else
+		ndev->config.status &= cpu_to_mlx5vdpa16(mvdev, ~VIRTIO_NET_S_LINK_UP);
+
 	if (!is_zero_ether_addr(config->mac)) {
 		pfmdev = pci_get_drvdata(pci_physfn(mdev->pdev));
 		err = mlx5_mpfs_add_mac(pfmdev, config->mac);
@@ -2508,6 +2594,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 		goto err_res2;
 	}
 
+	ndev->nb.notifier_call = event_handler;
+	mlx5_notifier_register(mdev, &ndev->nb);
 	ndev->cur_num_vqs = 2 * mlx5_vdpa_max_qps(max_vqs);
 	mvdev->vdev.mdev = &mgtdev->mgtdev;
 	err = _vdpa_register_device(&mvdev->vdev, ndev->cur_num_vqs + 1);
@@ -2538,7 +2626,9 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 {
 	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(dev);
+	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 
+	mlx5_notifier_unregister(mvdev->mdev, &ndev->nb);
 	destroy_workqueue(mvdev->wq);
 	_vdpa_unregister_device(dev);
 	mgtdev->ndev = NULL;
-- 
2.35.1



