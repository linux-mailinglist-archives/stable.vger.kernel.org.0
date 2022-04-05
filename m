Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9FF4F38C5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377175AbiDEL2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349689AbiDEJu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:50:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524DB65FE;
        Tue,  5 Apr 2022 02:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3599B81B14;
        Tue,  5 Apr 2022 09:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237B9C385A1;
        Tue,  5 Apr 2022 09:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152136;
        bh=YFLWhlvaxkN3JCCmjrtSuSMn+hhy7ajEtuGDlu5781w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peWvktd75S2gyARyvuFOHPB4X11yScsWOS+DOU/lEEsumdT8zCYKq7f5xLH0NcqjH
         rGbQq0E1KO1oP3l3uGDDlzJryukLlS0Vaav34MDN5YL3jr9pg6l6KzSZ8bNel6v2sM
         ZZC2PeFMZ/CzP41h002k/iT1hl9f84GNDtcAHh8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Li <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 669/913] net: hns3: clean residual vf config after disable sriov
Date:   Tue,  5 Apr 2022 09:28:51 +0200
Message-Id: <20220405070359.889198837@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit 671cb8cbb9c9e24b681d21b1bfae991e2386ac73 ]

After disable sriov, VF still has some config and info need to be
cleaned, which configured by PF. This patch clean the HW config
and SW struct vport->vf_info.

Fixes: fa8d82e853e8 ("net: hns3: Add support of .sriov_configure in HNS3 driver")
Signed-off-by: Peng Li<lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  3 ++
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 18 +++++++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 50 +++++++++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 4aa6d21f2fd8..8b7f059c49e6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -527,6 +527,8 @@ struct hnae3_ae_dev {
  *   Get 1588 rx hwstamp
  * get_ts_info
  *   Get phc info
+ * clean_vf_config
+ *   Clean residual vf info after disable sriov
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -720,6 +722,7 @@ struct hnae3_ae_ops {
 			   struct ethtool_ts_info *info);
 	int (*get_link_diagnosis_info)(struct hnae3_handle *handle,
 				       u32 *status_code);
+	void (*clean_vf_config)(struct hnae3_ae_dev *ae_dev, int num_vfs);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index e4f6b5a8537c..16cbd146ad06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2954,6 +2954,21 @@ static int hns3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 }
 
+/**
+ * hns3_clean_vf_config
+ * @pdev: pointer to a pci_dev structure
+ * @num_vfs: number of VFs allocated
+ *
+ * Clean residual vf config after disable sriov
+ **/
+static void hns3_clean_vf_config(struct pci_dev *pdev, int num_vfs)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
+
+	if (ae_dev->ops->clean_vf_config)
+		ae_dev->ops->clean_vf_config(ae_dev, num_vfs);
+}
+
 /* hns3_remove - Device removal routine
  * @pdev: PCI device information struct
  */
@@ -2992,7 +3007,10 @@ static int hns3_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
 		else
 			return num_vfs;
 	} else if (!pci_vfs_assigned(pdev)) {
+		int num_vfs_pre = pci_num_vf(pdev);
+
 		pci_disable_sriov(pdev);
+		hns3_clean_vf_config(pdev, num_vfs_pre);
 	} else {
 		dev_warn(&pdev->dev,
 			 "Unable to free VFs because some are assigned to VMs.\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d3a259ad8ce1..c1708ad32b88 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12987,6 +12987,55 @@ static int hclge_get_link_diagnosis_info(struct hnae3_handle *handle,
 	return 0;
 }
 
+/* After disable sriov, VF still has some config and info need clean,
+ * which configed by PF.
+ */
+static void hclge_clear_vport_vf_info(struct hclge_vport *vport, int vfid)
+{
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_vlan_info vlan_info;
+	int ret;
+
+	/* after disable sriov, clean VF rate configured by PF */
+	ret = hclge_tm_qs_shaper_cfg(vport, 0);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to clean vf%d rate config, ret = %d\n",
+			vfid, ret);
+
+	vlan_info.vlan_tag = 0;
+	vlan_info.qos = 0;
+	vlan_info.vlan_proto = ETH_P_8021Q;
+	ret = hclge_update_port_base_vlan_cfg(vport,
+					      HNAE3_PORT_BASE_VLAN_DISABLE,
+					      &vlan_info);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to clean vf%d port base vlan, ret = %d\n",
+			vfid, ret);
+
+	ret = hclge_set_vf_spoofchk_hw(hdev, vport->vport_id, false);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to clean vf%d spoof config, ret = %d\n",
+			vfid, ret);
+
+	memset(&vport->vf_info, 0, sizeof(vport->vf_info));
+}
+
+static void hclge_clean_vport_config(struct hnae3_ae_dev *ae_dev, int num_vfs)
+{
+	struct hclge_dev *hdev = ae_dev->priv;
+	struct hclge_vport *vport;
+	int i;
+
+	for (i = 0; i < num_vfs; i++) {
+		vport = &hdev->vport[i + HCLGE_VF_VPORT_START_NUM];
+
+		hclge_clear_vport_vf_info(vport, i);
+	}
+}
+
 static const struct hnae3_ae_ops hclge_ops = {
 	.init_ae_dev = hclge_init_ae_dev,
 	.uninit_ae_dev = hclge_uninit_ae_dev,
@@ -13088,6 +13137,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_rx_hwts = hclge_ptp_get_rx_hwts,
 	.get_ts_info = hclge_ptp_get_ts_info,
 	.get_link_diagnosis_info = hclge_get_link_diagnosis_info,
+	.clean_vf_config = hclge_clean_vport_config,
 };
 
 static struct hnae3_ae_algo ae_algo = {
-- 
2.34.1



