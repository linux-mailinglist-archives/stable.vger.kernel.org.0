Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E384408F4
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 15:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhJ3NKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhJ3NKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 09:10:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6362860E9C;
        Sat, 30 Oct 2021 13:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635599280;
        bh=qjx7PXb5tDYmDH2pGbC1OCEqZ1sRGVY+rJqSPoXxcf0=;
        h=Subject:To:Cc:From:Date:From;
        b=lvNgwTmG+H+srxcKvjlu/YrBiBjk+KNFFMlN94aSP9IOdFoU4ZKsiAFc0K0txtfQS
         pselqjVPP8vkGfXXVYa2W/Rdur/irkm0A34lGdRQ5iee0Z6AD7LSQUP1me+LkenuCS
         TGNnC3CzsBT9qirC5g3pSoYHr2lh4dK6LWkjCImM=
Subject: FAILED: patch "[PATCH] net: hns3: fix pause config problem after autoneg disabled" failed to apply to 5.10-stable tree
To:     huangguangbin2@huawei.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 15:07:58 +0200
Message-ID: <1635599278253134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3bda2e5df476417b6d08967e2d84234a59d57b1c Mon Sep 17 00:00:00 2001
From: Guangbin Huang <huangguangbin2@huawei.com>
Date: Wed, 27 Oct 2021 20:11:43 +0800
Subject: [PATCH] net: hns3: fix pause config problem after autoneg disabled

If a TP port is configured by follow steps:
1.ethtool -s ethx autoneg off speed 100 duplex full
2.ethtool -A ethx rx on tx on
3.ethtool -s ethx autoneg on(rx&tx negotiated pause results are off)
4.ethtool -s ethx autoneg off speed 100 duplex full

In step 3, driver will set rx&tx pause parameters of hardware to off as
pause parameters negotiated with link partner are off.

After step 4, the "ethtool -a ethx" command shows both rx and tx pause
parameters are on. However, pause parameters of hardware are still off
and port has no flow control function actually.

To fix this problem, if autoneg is disabled, driver uses its saved
parameters to restore pause of hardware. If the speed is not changed in
this case, there is no link state changed for phy, it will cause the pause
parameter is not taken effect, so we need to force phy to go down and up.

Fixes: aacbe27e82f0 ("net: hns3: modify how pause options is displayed")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index d701451596c8..da3a593f6a56 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -568,6 +568,7 @@ struct hnae3_ae_ops {
 			       u32 *auto_neg, u32 *rx_en, u32 *tx_en);
 	int (*set_pauseparam)(struct hnae3_handle *handle,
 			      u32 auto_neg, u32 rx_en, u32 tx_en);
+	int (*restore_pauseparam)(struct hnae3_handle *handle);
 
 	int (*set_autoneg)(struct hnae3_handle *handle, bool enable);
 	int (*get_autoneg)(struct hnae3_handle *handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 5ebd96f6833d..7d92dd273ed7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -824,6 +824,26 @@ static int hns3_check_ksettings_param(const struct net_device *netdev,
 	return 0;
 }
 
+static int hns3_set_phy_link_ksettings(struct net_device *netdev,
+				       const struct ethtool_link_ksettings *cmd)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	int ret;
+
+	if (cmd->base.speed == SPEED_1000 &&
+	    cmd->base.autoneg == AUTONEG_DISABLE)
+		return -EINVAL;
+
+	if (cmd->base.autoneg == AUTONEG_DISABLE && ops->restore_pauseparam) {
+		ret = ops->restore_pauseparam(handle);
+		if (ret)
+			return ret;
+	}
+
+	return phy_ethtool_ksettings_set(netdev->phydev, cmd);
+}
+
 static int hns3_set_link_ksettings(struct net_device *netdev,
 				   const struct ethtool_link_ksettings *cmd)
 {
@@ -842,16 +862,11 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 		  cmd->base.autoneg, cmd->base.speed, cmd->base.duplex);
 
 	/* Only support ksettings_set for netdev with phy attached for now */
-	if (netdev->phydev) {
-		if (cmd->base.speed == SPEED_1000 &&
-		    cmd->base.autoneg == AUTONEG_DISABLE)
-			return -EINVAL;
-
-		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
-	} else if (test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps) &&
-		   ops->set_phy_link_ksettings) {
+	if (netdev->phydev)
+		return hns3_set_phy_link_ksettings(netdev, cmd);
+	else if (test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps) &&
+		 ops->set_phy_link_ksettings)
 		return ops->set_phy_link_ksettings(handle, cmd);
-	}
 
 	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dcd40cc73082..c6b9806c75a5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11021,6 +11021,35 @@ static int hclge_set_pauseparam(struct hnae3_handle *handle, u32 auto_neg,
 	return -EOPNOTSUPP;
 }
 
+static int hclge_restore_pauseparam(struct hnae3_handle *handle)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	u32 auto_neg, rx_pause, tx_pause;
+	int ret;
+
+	hclge_get_pauseparam(handle, &auto_neg, &rx_pause, &tx_pause);
+	/* when autoneg is disabled, the pause setting of phy has no effect
+	 * unless the link goes down.
+	 */
+	ret = phy_suspend(hdev->hw.mac.phydev);
+	if (ret)
+		return ret;
+
+	phy_set_asym_pause(hdev->hw.mac.phydev, rx_pause, tx_pause);
+
+	ret = phy_resume(hdev->hw.mac.phydev);
+	if (ret)
+		return ret;
+
+	ret = hclge_mac_pause_setup_hw(hdev);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"restore pauseparam error, ret = %d.\n", ret);
+
+	return ret;
+}
+
 static void hclge_get_ksettings_an_result(struct hnae3_handle *handle,
 					  u8 *auto_neg, u32 *speed, u8 *duplex)
 {
@@ -12984,6 +13013,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.halt_autoneg = hclge_halt_autoneg,
 	.get_pauseparam = hclge_get_pauseparam,
 	.set_pauseparam = hclge_set_pauseparam,
+	.restore_pauseparam = hclge_restore_pauseparam,
 	.set_mtu = hclge_set_mtu,
 	.reset_queue = hclge_reset_tqp,
 	.get_stats = hclge_get_stats,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 95074e91a846..124791e4bfee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1435,7 +1435,7 @@ static int hclge_bp_setup_hw(struct hclge_dev *hdev, u8 tc)
 	return 0;
 }
 
-static int hclge_mac_pause_setup_hw(struct hclge_dev *hdev)
+int hclge_mac_pause_setup_hw(struct hclge_dev *hdev)
 {
 	bool tx_en, rx_en;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 2ee9b795f71d..4b2c3a788980 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -244,6 +244,7 @@ int hclge_tm_get_pri_weight(struct hclge_dev *hdev, u8 pri_id, u8 *weight);
 int hclge_tm_get_pri_shaper(struct hclge_dev *hdev, u8 pri_id,
 			    enum hclge_opcode_type cmd,
 			    struct hclge_tm_shaper_para *para);
+int hclge_mac_pause_setup_hw(struct hclge_dev *hdev);
 int hclge_tm_get_q_to_qs_map(struct hclge_dev *hdev, u16 q_id, u16 *qset_id);
 int hclge_tm_get_q_to_tc(struct hclge_dev *hdev, u16 q_id, u8 *tc_id);
 int hclge_tm_get_pg_to_pri_map(struct hclge_dev *hdev, u8 pg_id,

