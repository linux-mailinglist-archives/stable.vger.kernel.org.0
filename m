Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269374AA899
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379820AbiBEMPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 07:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379845AbiBEMPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 07:15:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EAFC043181;
        Sat,  5 Feb 2022 04:15:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24D0C60C3A;
        Sat,  5 Feb 2022 12:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C771EC340E8;
        Sat,  5 Feb 2022 12:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644063314;
        bh=lHMreQdz8kC1oYKWWb1ppk2ZOpn2El6Yf2pUn32WGoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5BieYkZ9qXVG17OuW7a9SY+ZglFUtyCda0nooMIUV2PoSE0aW/8kmXlx6rHrtMYh
         2PScSjj564IYTMmoLNmeGiOIdU04KFGsPt40Rcopi1xWWUthCdesFgmJbIw4j7XdBn
         EY912t1t4K9gosxpMB2fBK74VWncV/a0v+sILOEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.20
Date:   Sat,  5 Feb 2022 13:15:04 +0100
Message-Id: <164406330440122@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164406330442229@kroah.com>
References: <164406330442229@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 463d46a9e617..3643400c15d8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 19
+SUBLEVEL = 20
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 5580267fb362..2d532c0fe819 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1738,18 +1738,18 @@ static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 	u32 val;
 	int ret;
 
-	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
-	if (ret)
-		return ret;
+	if (enable) {
+		ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
+		if (ret)
+			return ret;
 
-	val = HDMI_READ(HDMI_CEC_CNTRL_5);
-	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
-		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
-		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
-	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
-	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
+		val = HDMI_READ(HDMI_CEC_CNTRL_5);
+		val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
+			 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
+			 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
+		val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
+			((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
 
-	if (enable) {
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
 			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val);
@@ -1777,7 +1777,10 @@ static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 			HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
 			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
+
+		pm_runtime_put(&vc4_hdmi->pdev->dev);
 	}
+
 	return 0;
 }
 
@@ -1888,8 +1891,6 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 	if (ret < 0)
 		goto err_remove_handlers;
 
-	pm_runtime_put(&vc4_hdmi->pdev->dev);
-
 	return 0;
 
 err_remove_handlers:
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 17a585adfb49..e6883d52d230 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -721,7 +721,9 @@ static void xgbe_stop_timers(struct xgbe_prv_data *pdata)
 		if (!channel->tx_ring)
 			break;
 
+		/* Deactivate the Tx timer */
 		del_timer_sync(&channel->tx_timer);
+		channel->tx_timer_active = 0;
 	}
 }
 
@@ -2555,6 +2557,14 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 			buf2_len = xgbe_rx_buf2_len(rdata, packet, len);
 			len += buf2_len;
 
+			if (buf2_len > rdata->rx.buf.dma_len) {
+				/* Hardware inconsistency within the descriptors
+				 * that has resulted in a length underflow.
+				 */
+				error = 1;
+				goto skip_data;
+			}
+
 			if (!skb) {
 				skb = xgbe_create_skb(pdata, napi, rdata,
 						      buf1_len);
@@ -2584,8 +2594,10 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 		if (!last || context_next)
 			goto read_again;
 
-		if (!skb)
+		if (!skb || error) {
+			dev_kfree_skb(skb);
 			goto next_packet;
+		}
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index ebcb2a30add0..276a0aa1ed4a 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6346,7 +6346,8 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 	u32 mac_data;
 	u16 phy_data;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
 		/* Request ME configure the device for S0ix */
 		mac_data = er32(H2ME);
 		mac_data |= E1000_H2ME_START_DPG;
@@ -6495,7 +6496,8 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	u16 phy_data;
 	u32 i = 0;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
 		/* Request ME unconfigure the device from S0ix */
 		mac_data = er32(H2ME);
 		mac_data &= ~E1000_H2ME_START_DPG;
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 389df4d86ab4..56a3a6d1dbe4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -144,6 +144,7 @@ enum i40e_state_t {
 	__I40E_VIRTCHNL_OP_PENDING,
 	__I40E_RECOVERY_MODE,
 	__I40E_VF_RESETS_DISABLED,	/* disable resets during i40e_remove */
+	__I40E_IN_REMOVE,
 	__I40E_VFS_RELEASING,
 	/* This must be last as it determines the size of the BITMAP */
 	__I40E_STATE_SIZE__,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 20c8c0231e2c..063ded36b902 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5372,7 +5372,15 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 	/* There is no need to reset BW when mqprio mode is on.  */
 	if (pf->flags & I40E_FLAG_TC_MQPRIO)
 		return 0;
-	if (!vsi->mqprio_qopt.qopt.hw && !(pf->flags & I40E_FLAG_DCB_ENABLED)) {
+
+	if (!vsi->mqprio_qopt.qopt.hw) {
+		if (pf->flags & I40E_FLAG_DCB_ENABLED)
+			goto skip_reset;
+
+		if (IS_ENABLED(CONFIG_I40E_DCB) &&
+		    i40e_dcb_hw_get_num_tc(&pf->hw) == 1)
+			goto skip_reset;
+
 		ret = i40e_set_bw_limit(vsi, vsi->seid, 0);
 		if (ret)
 			dev_info(&pf->pdev->dev,
@@ -5380,6 +5388,8 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 				 vsi->seid);
 		return ret;
 	}
+
+skip_reset:
 	memset(&bw_data, 0, sizeof(bw_data));
 	bw_data.tc_valid_bits = enabled_tc;
 	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)
@@ -10853,6 +10863,9 @@ static void i40e_reset_and_rebuild(struct i40e_pf *pf, bool reinit,
 				   bool lock_acquired)
 {
 	int ret;
+
+	if (test_bit(__I40E_IN_REMOVE, pf->state))
+		return;
 	/* Now we wait for GRST to settle out.
 	 * We don't have to delete the VEBs or VSIs from the hw switch
 	 * because the reset will make them disappear.
@@ -12212,6 +12225,8 @@ int i40e_reconfig_rss_queues(struct i40e_pf *pf, int queue_count)
 
 		vsi->req_queue_pairs = queue_count;
 		i40e_prep_for_reset(pf);
+		if (test_bit(__I40E_IN_REMOVE, pf->state))
+			return pf->alloc_rss_size;
 
 		pf->alloc_rss_size = new_rss_size;
 
@@ -13038,6 +13053,10 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 	if (need_reset)
 		i40e_prep_for_reset(pf);
 
+	/* VSI shall be deleted in a moment, just return EINVAL */
+	if (test_bit(__I40E_IN_REMOVE, pf->state))
+		return -EINVAL;
+
 	old_prog = xchg(&vsi->xdp_prog, prog);
 
 	if (need_reset) {
@@ -15928,8 +15947,13 @@ static void i40e_remove(struct pci_dev *pdev)
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), 0);
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(1), 0);
 
-	while (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state))
+	/* Grab __I40E_RESET_RECOVERY_PENDING and set __I40E_IN_REMOVE
+	 * flags, once they are set, i40e_rebuild should not be called as
+	 * i40e_prep_for_reset always returns early.
+	 */
+	while (test_and_set_bit(__I40E_RESET_RECOVERY_PENDING, pf->state))
 		usleep_range(1000, 2000);
+	set_bit(__I40E_IN_REMOVE, pf->state);
 
 	if (pf->flags & I40E_FLAG_SRIOV_ENABLED) {
 		set_bit(__I40E_VF_RESETS_DISABLED, pf->state);
@@ -16128,6 +16152,9 @@ static void i40e_pci_error_reset_done(struct pci_dev *pdev)
 {
 	struct i40e_pf *pf = pci_get_drvdata(pdev);
 
+	if (test_bit(__I40E_IN_REMOVE, pf->state))
+		return;
+
 	i40e_reset_and_rebuild(pf, false, false);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index e8a8d78e3e4d..965838893432 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -553,7 +553,8 @@ static int mlx5e_htb_convert_rate(struct mlx5e_priv *priv, u64 rate,
 
 static void mlx5e_htb_convert_ceil(struct mlx5e_priv *priv, u64 ceil, u32 *max_average_bw)
 {
-	*max_average_bw = div_u64(ceil, BYTES_IN_MBIT);
+	/* Hardware treats 0 as "unlimited", set at least 1. */
+	*max_average_bw = max_t(u32, div_u64(ceil, BYTES_IN_MBIT), 1);
 
 	qos_dbg(priv->mdev, "Convert: ceil %llu -> max_average_bw %u\n",
 		ceil, *max_average_bw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index 9c076aa20306..b6f5c1bcdbcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -183,18 +183,7 @@ void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 
 static bool mlx5e_rep_is_lag_netdev(struct net_device *netdev)
 {
-	struct mlx5e_rep_priv *rpriv;
-	struct mlx5e_priv *priv;
-
-	/* A given netdev is not a representor or not a slave of LAG configuration */
-	if (!mlx5e_eswitch_rep(netdev) || !netif_is_lag_port(netdev))
-		return false;
-
-	priv = netdev_priv(netdev);
-	rpriv = priv->ppriv;
-
-	/* Egress acl forward to vport is supported only non-uplink representor */
-	return rpriv->rep->vport != MLX5_VPORT_UPLINK;
+	return netif_is_lag_port(netdev) && mlx5e_eswitch_vf_rep(netdev);
 }
 
 static void mlx5e_rep_changelowerstate_event(struct net_device *netdev, void *ptr)
@@ -210,9 +199,6 @@ static void mlx5e_rep_changelowerstate_event(struct net_device *netdev, void *pt
 	u16 fwd_vport_num;
 	int err;
 
-	if (!mlx5e_rep_is_lag_netdev(netdev))
-		return;
-
 	info = ptr;
 	lag_info = info->lower_state_info;
 	/* This is not an event of a representor becoming active slave */
@@ -266,9 +252,6 @@ static void mlx5e_rep_changeupper_event(struct net_device *netdev, void *ptr)
 	struct net_device *lag_dev;
 	struct mlx5e_priv *priv;
 
-	if (!mlx5e_rep_is_lag_netdev(netdev))
-		return;
-
 	priv = netdev_priv(netdev);
 	rpriv = priv->ppriv;
 	lag_dev = info->upper_dev;
@@ -293,6 +276,19 @@ static int mlx5e_rep_esw_bond_netevent(struct notifier_block *nb,
 				       unsigned long event, void *ptr)
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_rep_bond *bond;
+	struct mlx5e_priv *priv;
+
+	if (!mlx5e_rep_is_lag_netdev(netdev))
+		return NOTIFY_DONE;
+
+	bond = container_of(nb, struct mlx5e_rep_bond, nb);
+	priv = netdev_priv(netdev);
+	rpriv = mlx5_eswitch_get_uplink_priv(priv->mdev->priv.eswitch, REP_ETH);
+	/* Verify VF representor is on the same device of the bond handling the netevent. */
+	if (rpriv->uplink_priv.bond != bond)
+		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_CHANGELOWERSTATE:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index c6d2f8c78db7..48dc121b2cb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -491,7 +491,7 @@ void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 	}
 
 	br_offloads->netdev_nb.notifier_call = mlx5_esw_bridge_switchdev_port_event;
-	err = register_netdevice_notifier(&br_offloads->netdev_nb);
+	err = register_netdevice_notifier_net(&init_net, &br_offloads->netdev_nb);
 	if (err) {
 		esw_warn(mdev, "Failed to register bridge offloads netdevice notifier (err=%d)\n",
 			 err);
@@ -509,7 +509,9 @@ void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 err_register_swdev:
 	destroy_workqueue(br_offloads->wq);
 err_alloc_wq:
+	rtnl_lock();
 	mlx5_esw_bridge_cleanup(esw);
+	rtnl_unlock();
 }
 
 void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv)
@@ -524,7 +526,7 @@ void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv)
 		return;
 
 	cancel_delayed_work_sync(&br_offloads->update_work);
-	unregister_netdevice_notifier(&br_offloads->netdev_nb);
+	unregister_netdevice_notifier_net(&init_net, &br_offloads->netdev_nb);
 	unregister_switchdev_blocking_notifier(&br_offloads->nb_blk);
 	unregister_switchdev_notifier(&br_offloads->nb);
 	destroy_workqueue(br_offloads->wq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 2db9573a3fe6..b56fea142c24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -157,11 +157,20 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 	/* Tunnel mode */
 	if (mode == XFRM_MODE_TUNNEL) {
 		eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
-		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
 		if (xo->proto == IPPROTO_IPV6)
 			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
-		if (inner_ip_hdr(skb)->protocol == IPPROTO_UDP)
+
+		switch (xo->inner_ipproto) {
+		case IPPROTO_UDP:
 			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
+			fallthrough;
+		case IPPROTO_TCP:
+			/* IP | ESP | IP | [TCP | UDP] */
+			eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
+			break;
+		default:
+			break;
+		}
 		return;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 7e221038df8d..317d76b97c42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1385,6 +1385,8 @@ struct mlx5_esw_bridge_offloads *mlx5_esw_bridge_init(struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_bridge_offloads *br_offloads;
 
+	ASSERT_RTNL();
+
 	br_offloads = kvzalloc(sizeof(*br_offloads), GFP_KERNEL);
 	if (!br_offloads)
 		return ERR_PTR(-ENOMEM);
@@ -1401,6 +1403,8 @@ void mlx5_esw_bridge_cleanup(struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_bridge_offloads *br_offloads = esw->br_offloads;
 
+	ASSERT_RTNL();
+
 	if (!br_offloads)
 		return;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
index 3401188e0a60..51ac24e6ec3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
@@ -21,7 +21,7 @@ DECLARE_EVENT_CLASS(mlx5_esw_bridge_fdb_template,
 			    __field(unsigned int, used)
 			    ),
 		    TP_fast_assign(
-			    strncpy(__entry->dev_name,
+			    strscpy(__entry->dev_name,
 				    netdev_name(fdb->dev),
 				    IFNAMSIZ);
 			    memcpy(__entry->addr, fdb->key.addr, ETH_ALEN);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 106b50e42b46..a45c6f25add1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -131,7 +131,7 @@ static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 
-	del_timer(&fw_reset->timer);
+	del_timer_sync(&fw_reset->timer);
 }
 
 static void mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, bool poll_health)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index d5e47630e284..df58cba37930 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -121,12 +121,13 @@ u32 mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *chains)
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
-	if (!mlx5_chains_prios_supported(chains))
-		return 1;
-
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 
+	if (!chains->dev->priv.eswitch ||
+	    chains->dev->priv.eswitch->mode != MLX5_ESWITCH_OFFLOADS)
+		return 1;
+
 	/* We should get here only for eswitch case */
 	return FDB_TC_MAX_PRIO;
 }
@@ -211,7 +212,7 @@ static int
 create_chain_restore(struct fs_chain *chain)
 {
 	struct mlx5_eswitch *esw = chain->chains->dev->priv.eswitch;
-	char modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)];
+	u8 modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_fs_chains *chains = chain->chains;
 	enum mlx5e_tc_attr_to_reg chain_to_reg;
 	struct mlx5_modify_hdr *mod_hdr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 1ef2b6a848c1..7b16a1188aab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -406,23 +406,24 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 
 	switch (module_id) {
 	case MLX5_MODULE_ID_SFP:
-		mlx5_sfp_eeprom_params_set(&query.i2c_address, &query.page, &query.offset);
+		mlx5_sfp_eeprom_params_set(&query.i2c_address, &query.page, &offset);
 		break;
 	case MLX5_MODULE_ID_QSFP:
 	case MLX5_MODULE_ID_QSFP_PLUS:
 	case MLX5_MODULE_ID_QSFP28:
-		mlx5_qsfp_eeprom_params_set(&query.i2c_address, &query.page, &query.offset);
+		mlx5_qsfp_eeprom_params_set(&query.i2c_address, &query.page, &offset);
 		break;
 	default:
 		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
 		return -EINVAL;
 	}
 
-	if (query.offset + size > MLX5_EEPROM_PAGE_LENGTH)
+	if (offset + size > MLX5_EEPROM_PAGE_LENGTH)
 		/* Cross pages read, read until offset 256 in low page */
-		size -= offset + size - MLX5_EEPROM_PAGE_LENGTH;
+		size = MLX5_EEPROM_PAGE_LENGTH - offset;
 
 	query.size = size;
+	query.offset = offset;
 
 	return mlx5_query_mcia(dev, &query, data);
 }
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index c8f90cb1ee8f..87e42db1b61e 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1069,21 +1069,33 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 	u32 backlog;
 	int delta;
 
-	if (!endpoint->replenish_enabled) {
+	if (!test_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags)) {
 		if (add_one)
 			atomic_inc(&endpoint->replenish_saved);
 		return;
 	}
 
+	/* If already active, just update the backlog */
+	if (test_and_set_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags)) {
+		if (add_one)
+			atomic_inc(&endpoint->replenish_backlog);
+		return;
+	}
+
 	while (atomic_dec_not_zero(&endpoint->replenish_backlog))
 		if (ipa_endpoint_replenish_one(endpoint))
 			goto try_again_later;
+
+	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
+
 	if (add_one)
 		atomic_inc(&endpoint->replenish_backlog);
 
 	return;
 
 try_again_later:
+	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
+
 	/* The last one didn't succeed, so fix the backlog */
 	delta = add_one ? 2 : 1;
 	backlog = atomic_add_return(delta, &endpoint->replenish_backlog);
@@ -1106,7 +1118,7 @@ static void ipa_endpoint_replenish_enable(struct ipa_endpoint *endpoint)
 	u32 max_backlog;
 	u32 saved;
 
-	endpoint->replenish_enabled = true;
+	set_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 	while ((saved = atomic_xchg(&endpoint->replenish_saved, 0)))
 		atomic_add(saved, &endpoint->replenish_backlog);
 
@@ -1120,7 +1132,7 @@ static void ipa_endpoint_replenish_disable(struct ipa_endpoint *endpoint)
 {
 	u32 backlog;
 
-	endpoint->replenish_enabled = false;
+	clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 	while ((backlog = atomic_xchg(&endpoint->replenish_backlog, 0)))
 		atomic_add(backlog, &endpoint->replenish_saved);
 }
@@ -1665,7 +1677,8 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
 		/* RX transactions require a single TRE, so the maximum
 		 * backlog is the same as the maximum outstanding TREs.
 		 */
-		endpoint->replenish_enabled = false;
+		clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
+		clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
 		atomic_set(&endpoint->replenish_saved,
 			   gsi_channel_tre_max(gsi, endpoint->channel_id));
 		atomic_set(&endpoint->replenish_backlog, 0);
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 0a859d10312d..0313cdc607de 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -40,6 +40,19 @@ enum ipa_endpoint_name {
 
 #define IPA_ENDPOINT_MAX		32	/* Max supported by driver */
 
+/**
+ * enum ipa_replenish_flag:	RX buffer replenish flags
+ *
+ * @IPA_REPLENISH_ENABLED:	Whether receive buffer replenishing is enabled
+ * @IPA_REPLENISH_ACTIVE:	Whether replenishing is underway
+ * @IPA_REPLENISH_COUNT:	Number of defined replenish flags
+ */
+enum ipa_replenish_flag {
+	IPA_REPLENISH_ENABLED,
+	IPA_REPLENISH_ACTIVE,
+	IPA_REPLENISH_COUNT,	/* Number of flags (must be last) */
+};
+
 /**
  * struct ipa_endpoint - IPA endpoint information
  * @ipa:		IPA pointer
@@ -51,7 +64,7 @@ enum ipa_endpoint_name {
  * @trans_tre_max:	Maximum number of TRE descriptors per transaction
  * @evt_ring_id:	GSI event ring used by the endpoint
  * @netdev:		Network device pointer, if endpoint uses one
- * @replenish_enabled:	Whether receive buffer replenishing is enabled
+ * @replenish_flags:	Replenishing state flags
  * @replenish_ready:	Number of replenish transactions without doorbell
  * @replenish_saved:	Replenish requests held while disabled
  * @replenish_backlog:	Number of buffers needed to fill hardware queue
@@ -72,7 +85,7 @@ struct ipa_endpoint {
 	struct net_device *netdev;
 
 	/* Receive buffer replenishing for RX endpoints */
-	bool replenish_enabled;
+	DECLARE_BITMAP(replenish_flags, IPA_REPLENISH_COUNT);
 	u32 replenish_ready;
 	atomic_t replenish_saved;
 	atomic_t replenish_backlog;
diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 06e2181e5810..d56e276e4d80 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -121,7 +121,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 	if (tx_buf == NULL)
 		goto free_rx_urb;
 
-	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 				    GFP_KERNEL, &rx_urb->transfer_dma);
 	if (rx_buf == NULL)
 		goto free_tx_buf;
@@ -146,7 +146,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, iphone->rx_buf,
 			  iphone->rx_urb->transfer_dma);
 	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
 			  iphone->tx_urb->transfer_dma);
@@ -317,7 +317,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
 
 	usb_fill_bulk_urb(dev->rx_urb, udev,
 			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE,
+			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 			  ipheth_rcvbulk_callback,
 			  dev);
 	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 3a46227e2c73..b0692f33b03a 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -642,6 +642,8 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 	 */
 	if (ctrl->power_fault_detected)
 		status &= ~PCI_EXP_SLTSTA_PFD;
+	else if (status & PCI_EXP_SLTSTA_PFD)
+		ctrl->power_fault_detected = true;
 
 	events |= status;
 	if (!events) {
@@ -651,7 +653,7 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 	}
 
 	if (status) {
-		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, events);
+		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, status);
 
 		/*
 		 * In MSI mode, all event bits must be zero before the port
@@ -725,8 +727,7 @@ static irqreturn_t pciehp_ist(int irq, void *dev_id)
 	}
 
 	/* Check Power Fault Detected */
-	if ((events & PCI_EXP_SLTSTA_PFD) && !ctrl->power_fault_detected) {
-		ctrl->power_fault_detected = 1;
+	if (events & PCI_EXP_SLTSTA_PFD) {
 		ctrl_err(ctrl, "Slot(%s): Power fault\n", slot_name(ctrl));
 		pciehp_set_indicators(ctrl, PCI_EXP_SLTCTL_PWR_IND_OFF,
 				      PCI_EXP_SLTCTL_ATTN_IND_ON);
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index cb3a7512c33e..0a22a2faf552 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -179,19 +179,21 @@ nlm_delete_file(struct nlm_file *file)
 static int nlm_unlock_files(struct nlm_file *file)
 {
 	struct file_lock lock;
-	struct file *f;
 
+	locks_init_lock(&lock);
 	lock.fl_type  = F_UNLCK;
 	lock.fl_start = 0;
 	lock.fl_end   = OFFSET_MAX;
-	for (f = file->f_file[0]; f <= file->f_file[1]; f++) {
-		if (f && vfs_lock_file(f, F_SETLK, &lock, NULL) < 0) {
-			pr_warn("lockd: unlock failure in %s:%d\n",
-				__FILE__, __LINE__);
-			return 1;
-		}
-	}
+	if (file->f_file[O_RDONLY] &&
+	    vfs_lock_file(file->f_file[O_RDONLY], F_SETLK, &lock, NULL))
+		goto out_err;
+	if (file->f_file[O_WRONLY] &&
+	    vfs_lock_file(file->f_file[O_WRONLY], F_SETLK, &lock, NULL))
+		goto out_err;
 	return 0;
+out_err:
+	pr_warn("lockd: unlock failure in %s:%d\n", __FILE__, __LINE__);
+	return 1;
 }
 
 /*
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 6facdf476255..84ec851211d9 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -611,9 +611,6 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	if (fanotify_is_perm_event(event->mask))
 		FANOTIFY_PERM(event)->fd = fd;
 
-	if (f)
-		fd_install(fd, f);
-
 	if (info_mode) {
 		ret = copy_info_records_to_user(event, info, info_mode, pidfd,
 						buf, count);
@@ -621,6 +618,9 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 			goto out_close_fd;
 	}
 
+	if (f)
+		fd_install(fd, f);
+
 	return metadata.event_len;
 
 out_close_fd:
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index b193d08a3dc3..e040970408d4 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -145,7 +145,7 @@ static int ovl_copy_fileattr(struct inode *inode, struct path *old,
 		if (err == -ENOTTY || err == -EINVAL)
 			return 0;
 		pr_warn("failed to retrieve lower fileattr (%pd2, err=%i)\n",
-			old, err);
+			old->dentry, err);
 		return err;
 	}
 
@@ -157,7 +157,9 @@ static int ovl_copy_fileattr(struct inode *inode, struct path *old,
 	 */
 	if (oldfa.flags & OVL_PROT_FS_FLAGS_MASK) {
 		err = ovl_set_protattr(inode, new->dentry, &oldfa);
-		if (err)
+		if (err == -EPERM)
+			pr_warn_once("copying fileattr: no xattr on upper\n");
+		else if (err)
 			return err;
 	}
 
@@ -167,8 +169,16 @@ static int ovl_copy_fileattr(struct inode *inode, struct path *old,
 
 	err = ovl_real_fileattr_get(new, &newfa);
 	if (err) {
+		/*
+		 * Returning an error if upper doesn't support fileattr will
+		 * result in a regression, so revert to the old behavior.
+		 */
+		if (err == -ENOTTY || err == -EINVAL) {
+			pr_warn_once("copying fileattr: no support on upper\n");
+			return 0;
+		}
 		pr_warn("failed to retrieve upper fileattr (%pd2, err=%i)\n",
-			new, err);
+			new->dentry, err);
 		return err;
 	}
 
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 9537443de22d..c59aa2c7749b 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -552,6 +552,14 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
 
+	/*
+	 * Release agent gets called with all capabilities,
+	 * require capabilities to set release agent.
+	 */
+	if ((of->file->f_cred->user_ns != &init_user_ns) ||
+	    !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENODEV;
@@ -963,6 +971,12 @@ int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		/* Specifying two release agents is forbidden */
 		if (ctx->release_agent)
 			return invalfc(fc, "release_agent respecified");
+		/*
+		 * Release agent gets called with all capabilities,
+		 * require capabilities to set release agent.
+		 */
+		if ((fc->user_ns != &init_user_ns) || !capable(CAP_SYS_ADMIN))
+			return invalfc(fc, "Setting release_agent not allowed");
 		ctx->release_agent = param->string;
 		param->string = NULL;
 		break;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2a9695ccb65f..1d9d3e4d4cbc 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1597,8 +1597,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	 * Make sure that subparts_cpus is a subset of cpus_allowed.
 	 */
 	if (cs->nr_subparts_cpus) {
-		cpumask_andnot(cs->subparts_cpus, cs->subparts_cpus,
-			       cs->cpus_allowed);
+		cpumask_and(cs->subparts_cpus, cs->subparts_cpus, cs->cpus_allowed);
 		cs->nr_subparts_cpus = cpumask_weight(cs->subparts_cpus);
 	}
 	spin_unlock_irq(&callback_lock);
diff --git a/mm/gup.c b/mm/gup.c
index 886d6148d3d0..52f08e3177e9 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -124,8 +124,8 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
  * considered failure, and furthermore, a likely bug in the caller, so a warning
  * is also emitted.
  */
-struct page *try_grab_compound_head(struct page *page,
-				    int refs, unsigned int flags)
+__maybe_unused struct page *try_grab_compound_head(struct page *page,
+						   int refs, unsigned int flags)
 {
 	if (flags & FOLL_GET)
 		return try_get_compound_head(page, refs);
@@ -208,10 +208,35 @@ static void put_compound_head(struct page *page, int refs, unsigned int flags)
  */
 bool __must_check try_grab_page(struct page *page, unsigned int flags)
 {
-	if (!(flags & (FOLL_GET | FOLL_PIN)))
-		return true;
+	WARN_ON_ONCE((flags & (FOLL_GET | FOLL_PIN)) == (FOLL_GET | FOLL_PIN));
 
-	return try_grab_compound_head(page, 1, flags);
+	if (flags & FOLL_GET)
+		return try_get_page(page);
+	else if (flags & FOLL_PIN) {
+		int refs = 1;
+
+		page = compound_head(page);
+
+		if (WARN_ON_ONCE(page_ref_count(page) <= 0))
+			return false;
+
+		if (hpage_pincount_available(page))
+			hpage_pincount_add(page, 1);
+		else
+			refs = GUP_PIN_COUNTING_BIAS;
+
+		/*
+		 * Similar to try_grab_compound_head(): even if using the
+		 * hpage_pincount_add/_sub() routines, be sure to
+		 * *also* increment the normal page refcount field at least
+		 * once, so that the page really is pinned.
+		 */
+		page_ref_add(page, refs);
+
+		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED, 1);
+	}
+
+	return true;
 }
 
 /**
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 8ccce85562a1..198cc8b74dc3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3254,8 +3254,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *slave_attr[RTNL_SLAVE_MAX_TYPE + 1];
 	unsigned char name_assign_type = NET_NAME_USER;
 	struct nlattr *linkinfo[IFLA_INFO_MAX + 1];
-	const struct rtnl_link_ops *m_ops = NULL;
-	struct net_device *master_dev = NULL;
+	const struct rtnl_link_ops *m_ops;
+	struct net_device *master_dev;
 	struct net *net = sock_net(skb->sk);
 	const struct rtnl_link_ops *ops;
 	struct nlattr *tb[IFLA_MAX + 1];
@@ -3293,6 +3293,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	else
 		dev = NULL;
 
+	master_dev = NULL;
+	m_ops = NULL;
 	if (dev) {
 		master_dev = netdev_master_upper_dev_get(dev);
 		if (master_dev)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f3b623967436..509f577869d4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1652,6 +1652,8 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
 	    (mss != tcp_skb_seglen(skb)))
 		goto out;
 
+	if (!tcp_skb_can_collapse(prev, skb))
+		goto out;
 	len = skb->len;
 	pcount = tcp_skb_pcount(skb);
 	if (tcp_skb_shift(prev, skb, pcount, len))
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 1a138e8d32d6..e00c38f242c3 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1753,7 +1753,10 @@ static int fanout_add(struct sock *sk, struct fanout_args *args)
 		err = -ENOSPC;
 		if (refcount_read(&match->sk_ref) < match->max_num_members) {
 			__dev_remove_pack(&po->prot_hook);
-			po->fanout = match;
+
+			/* Paired with packet_setsockopt(PACKET_FANOUT_DATA) */
+			WRITE_ONCE(po->fanout, match);
+
 			po->rollover = rollover;
 			rollover = NULL;
 			refcount_set(&match->sk_ref, refcount_read(&match->sk_ref) + 1);
@@ -3906,7 +3909,8 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 	}
 	case PACKET_FANOUT_DATA:
 	{
-		if (!po->fanout)
+		/* Paired with the WRITE_ONCE() in fanout_add() */
+		if (!READ_ONCE(po->fanout))
 			return -EINVAL;
 
 		return fanout_set_data(po, optval, optlen);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index cc9409aa755e..56dba8519d7c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1945,9 +1945,9 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	bool prio_allocate;
 	u32 parent;
 	u32 chain_index;
-	struct Qdisc *q = NULL;
+	struct Qdisc *q;
 	struct tcf_chain_info chain_info;
-	struct tcf_chain *chain = NULL;
+	struct tcf_chain *chain;
 	struct tcf_block *block;
 	struct tcf_proto *tp;
 	unsigned long cl;
@@ -1976,6 +1976,8 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	tp = NULL;
 	cl = 0;
 	block = NULL;
+	q = NULL;
+	chain = NULL;
 	flags = 0;
 
 	if (prio == 0) {
@@ -2798,8 +2800,8 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 	struct tcmsg *t;
 	u32 parent;
 	u32 chain_index;
-	struct Qdisc *q = NULL;
-	struct tcf_chain *chain = NULL;
+	struct Qdisc *q;
+	struct tcf_chain *chain;
 	struct tcf_block *block;
 	unsigned long cl;
 	int err;
@@ -2809,6 +2811,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		return -EPERM;
 
 replay:
+	q = NULL;
 	err = nlmsg_parse_deprecated(n, sizeof(*t), tca, TCA_MAX,
 				     rtm_tca_policy, extack);
 	if (err < 0)
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 586af88194e5..3e9d3df9c45c 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -75,6 +75,7 @@ init()
 
 		# let $ns2 reach any $ns1 address from any interface
 		ip -net "$ns2" route add default via 10.0.$i.1 dev ns2eth$i metric 10$i
+		ip -net "$ns2" route add default via dead:beef:$i::1 dev ns2eth$i metric 10$i
 	done
 }
 
@@ -1383,7 +1384,7 @@ ipv6_tests()
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 dev ns2eth3 flags subflow
 	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
 	chk_join_nr "single subflow IPv6" 1 1 1
 
@@ -1418,7 +1419,7 @@ ipv6_tests()
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 dev ns2eth3 flags subflow
 	run_tests $ns1 $ns2 dead:beef:1::1 0 -1 -1 slow
 	chk_join_nr "remove subflow and signal IPv6" 2 2 2
 	chk_add_nr 1 1
