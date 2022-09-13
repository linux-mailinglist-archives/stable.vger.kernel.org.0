Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF4B5B70D8
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiIMO3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiIMO2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:28:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BD4696DE;
        Tue, 13 Sep 2022 07:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C9B13CE1270;
        Tue, 13 Sep 2022 14:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0292C433D6;
        Tue, 13 Sep 2022 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078567;
        bh=C9ezMYuFDpYMj1YwyJAS6fB9Xd0dzfPqUz407YsNaCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gh3vJQbxvUts0VNTRBmf88CKWfac0qzodb1LKZjQk5ebFIRyEb5/3Pnk43uRiu0/z
         wRh/FNQ3KnlkfLgJK+KzOPzebt+78SAw2D+eq3Z5k3pySnApM//aSu/loVWyFTn2Y7
         YbeaT6VBmm2ggVdUZBD38t2ceYJXbP5NmJJCGVk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 164/192] i40e: Refactor tc mqprio checks
Date:   Tue, 13 Sep 2022 16:04:30 +0200
Message-Id: <20220913140418.201892271@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit 2313e69c84c024a85d017a60ae925085de47530a ]

Refactor bitwise checks for whether TC MQPRIO is enabled
into one single method for improved readability.

Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 45bb006d3c92 ("i40e: Fix ADQ rate limiting for PF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h        | 14 +++++++++++++
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 20 +++++++++----------
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 407fe8f340a06..c5b61bc80f783 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1291,4 +1291,18 @@ int i40e_add_del_cloud_filter(struct i40e_vsi *vsi,
 int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 				      struct i40e_cloud_filter *filter,
 				      bool add);
+
+/**
+ * i40e_is_tc_mqprio_enabled - check if TC MQPRIO is enabled on PF
+ * @pf: pointer to a pf.
+ *
+ * Check and return value of flag I40E_FLAG_TC_MQPRIO.
+ *
+ * Return: I40E_FLAG_TC_MQPRIO set state.
+ **/
+static inline u32 i40e_is_tc_mqprio_enabled(struct i40e_pf *pf)
+{
+	return pf->flags & I40E_FLAG_TC_MQPRIO;
+}
+
 #endif /* _I40E_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 22a61802a4027..ed9984f1e1b9f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4931,7 +4931,7 @@ static int i40e_set_channels(struct net_device *dev,
 	/* We do not support setting channels via ethtool when TCs are
 	 * configured through mqprio
 	 */
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return -EINVAL;
 
 	/* verify they are not requesting separate vectors */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 71a8e1698ed48..45c56832c14fd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5339,7 +5339,7 @@ static u8 i40e_pf_get_num_tc(struct i40e_pf *pf)
 	u8 num_tc = 0;
 	struct i40e_dcbx_config *dcbcfg = &hw->local_dcbx_config;
 
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return pf->vsi[pf->lan_vsi]->mqprio_qopt.qopt.num_tc;
 
 	/* If neither MQPRIO nor DCB is enabled, then always use single TC */
@@ -5371,7 +5371,7 @@ static u8 i40e_pf_get_num_tc(struct i40e_pf *pf)
  **/
 static u8 i40e_pf_get_tc_map(struct i40e_pf *pf)
 {
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return i40e_mqprio_get_enabled_tc(pf);
 
 	/* If neither MQPRIO nor DCB is enabled for this PF then just return
@@ -5468,7 +5468,7 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 	int i;
 
 	/* There is no need to reset BW when mqprio mode is on.  */
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return 0;
 	if (!vsi->mqprio_qopt.qopt.hw && !(pf->flags & I40E_FLAG_DCB_ENABLED)) {
 		ret = i40e_set_bw_limit(vsi, vsi->seid, 0);
@@ -5540,7 +5540,7 @@ static void i40e_vsi_config_netdev_tc(struct i40e_vsi *vsi, u8 enabled_tc)
 					vsi->tc_config.tc_info[i].qoffset);
 	}
 
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return;
 
 	/* Assign UP2TC map for the VSI */
@@ -5701,7 +5701,7 @@ static int i40e_vsi_config_tc(struct i40e_vsi *vsi, u8 enabled_tc)
 	ctxt.vf_num = 0;
 	ctxt.uplink_seid = vsi->uplink_seid;
 	ctxt.info = vsi->info;
-	if (vsi->back->flags & I40E_FLAG_TC_MQPRIO) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		ret = i40e_vsi_setup_queue_map_mqprio(vsi, &ctxt, enabled_tc);
 		if (ret)
 			goto out;
@@ -6425,7 +6425,7 @@ int i40e_create_queue_channel(struct i40e_vsi *vsi,
 		pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
 
 		if (vsi->type == I40E_VSI_MAIN) {
-			if (pf->flags & I40E_FLAG_TC_MQPRIO)
+			if (i40e_is_tc_mqprio_enabled(pf))
 				i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
 			else
 				i40e_do_reset_safe(pf, I40E_PF_RESET_FLAG);
@@ -7819,7 +7819,7 @@ static void *i40e_fwd_add(struct net_device *netdev, struct net_device *vdev)
 		netdev_info(netdev, "Macvlans are not supported when DCB is enabled\n");
 		return ERR_PTR(-EINVAL);
 	}
-	if ((pf->flags & I40E_FLAG_TC_MQPRIO)) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		netdev_info(netdev, "Macvlans are not supported when HW TC offload is on\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -8072,7 +8072,7 @@ static int i40e_setup_tc(struct net_device *netdev, void *type_data)
 	/* Quiesce VSI queues */
 	i40e_quiesce_vsi(vsi);
 
-	if (!hw && !(pf->flags & I40E_FLAG_TC_MQPRIO))
+	if (!hw && !i40e_is_tc_mqprio_enabled(pf))
 		i40e_remove_queue_channels(vsi);
 
 	/* Configure VSI for enabled TCs */
@@ -8096,7 +8096,7 @@ static int i40e_setup_tc(struct net_device *netdev, void *type_data)
 		 "Setup channel (id:%u) utilizing num_queues %d\n",
 		 vsi->seid, vsi->tc_config.tc_info[0].qcount);
 
-	if (pf->flags & I40E_FLAG_TC_MQPRIO) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		if (vsi->mqprio_qopt.max_rate[0]) {
 			u64 max_tx_rate = vsi->mqprio_qopt.max_rate[0];
 
@@ -10750,7 +10750,7 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	 * unless I40E_FLAG_TC_MQPRIO was enabled or DCB
 	 * is not supported with new link speed
 	 */
-	if (pf->flags & I40E_FLAG_TC_MQPRIO) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		i40e_aq_set_dcb_parameters(hw, false, NULL);
 	} else {
 		if (I40E_IS_X710TL_DEVICE(hw->device_id) &&
-- 
2.35.1



