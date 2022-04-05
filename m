Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9184F32DF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbiDEI2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239547AbiDEIUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9BE1132;
        Tue,  5 Apr 2022 01:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEBD7B81BAC;
        Tue,  5 Apr 2022 08:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD13C385A0;
        Tue,  5 Apr 2022 08:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146561;
        bh=rdK5mcYAvYDBjTtpXFY1r65fy+A1YkLBs/XFQ/Eway0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tG2t1tZ6SK+1+Idx8Xh9toGTUAGLBoYNXucaQNKALsnA1Np/ixassOzKD10wD7c7z
         CJCt3C+2IDFzcwFLPjD+5xT8F/1wHKh9Kec0toEqWVJBGXJ9Ts+IKg/a7wSJ1LBJfR
         JISTa7NK7xjmKICMIQfcFqHSQIbUMa8Ij9edDnCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0809/1126] net: hns3: add vlan list lock to protect vlan list
Date:   Tue,  5 Apr 2022 09:25:56 +0200
Message-Id: <20220405070431.312604781@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 1932a624ab88ff407d1a1d567fe581faa15dc725 ]

When adding port base VLAN, vf VLAN need to remove from HW and modify
the vlan state in vf VLAN list as false. If the periodicity task is
freeing the same node, it may cause "use after free" error.
This patch adds a vlan list lock to protect the vlan list.

Fixes: c6075b193462 ("net: hns3: Record VF vlan tables")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 38 +++++++++++++++++--
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  1 +
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d4fe92b22fb9..9655a7d2c200 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9809,19 +9809,28 @@ static void hclge_add_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 				       bool writen_to_tbl)
 {
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
+	struct hclge_dev *hdev = vport->back;
 
-	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node)
-		if (vlan->vlan_id == vlan_id)
+	mutex_lock(&hdev->vport_lock);
+
+	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
+		if (vlan->vlan_id == vlan_id) {
+			mutex_unlock(&hdev->vport_lock);
 			return;
+		}
+	}
 
 	vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
-	if (!vlan)
+	if (!vlan) {
+		mutex_unlock(&hdev->vport_lock);
 		return;
+	}
 
 	vlan->hd_tbl_status = writen_to_tbl;
 	vlan->vlan_id = vlan_id;
 
 	list_add_tail(&vlan->node, &vport->vlan_list);
+	mutex_unlock(&hdev->vport_lock);
 }
 
 static int hclge_add_vport_all_vlan_table(struct hclge_vport *vport)
@@ -9830,6 +9839,8 @@ static int hclge_add_vport_all_vlan_table(struct hclge_vport *vport)
 	struct hclge_dev *hdev = vport->back;
 	int ret;
 
+	mutex_lock(&hdev->vport_lock);
+
 	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 		if (!vlan->hd_tbl_status) {
 			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
@@ -9839,12 +9850,16 @@ static int hclge_add_vport_all_vlan_table(struct hclge_vport *vport)
 				dev_err(&hdev->pdev->dev,
 					"restore vport vlan list failed, ret=%d\n",
 					ret);
+
+				mutex_unlock(&hdev->vport_lock);
 				return ret;
 			}
 		}
 		vlan->hd_tbl_status = true;
 	}
 
+	mutex_unlock(&hdev->vport_lock);
+
 	return 0;
 }
 
@@ -9854,6 +9869,8 @@ static void hclge_rm_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
 	struct hclge_dev *hdev = vport->back;
 
+	mutex_lock(&hdev->vport_lock);
+
 	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 		if (vlan->vlan_id == vlan_id) {
 			if (is_write_tbl && vlan->hd_tbl_status)
@@ -9868,6 +9885,8 @@ static void hclge_rm_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 			break;
 		}
 	}
+
+	mutex_unlock(&hdev->vport_lock);
 }
 
 void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
@@ -9875,6 +9894,8 @@ void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
 	struct hclge_dev *hdev = vport->back;
 
+	mutex_lock(&hdev->vport_lock);
+
 	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 		if (vlan->hd_tbl_status)
 			hclge_set_vlan_filter_hw(hdev,
@@ -9890,6 +9911,7 @@ void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
 		}
 	}
 	clear_bit(vport->vport_id, hdev->vf_vlan_full);
+	mutex_unlock(&hdev->vport_lock);
 }
 
 void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
@@ -9898,6 +9920,8 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 	struct hclge_vport *vport;
 	int i;
 
+	mutex_lock(&hdev->vport_lock);
+
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		vport = &hdev->vport[i];
 		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
@@ -9905,6 +9929,8 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 			kfree(vlan);
 		}
 	}
+
+	mutex_unlock(&hdev->vport_lock);
 }
 
 void hclge_restore_vport_port_base_vlan_config(struct hclge_dev *hdev)
@@ -9944,6 +9970,8 @@ void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
 	struct hclge_dev *hdev = vport->back;
 	int ret;
 
+	mutex_lock(&hdev->vport_lock);
+
 	if (vport->port_base_vlan_cfg.state == HNAE3_PORT_BASE_VLAN_DISABLE) {
 		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
@@ -9954,6 +9982,8 @@ void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
 			vlan->hd_tbl_status = true;
 		}
 	}
+
+	mutex_unlock(&hdev->vport_lock);
 }
 
 /* For global reset and imp reset, hardware will clear the mac table,
@@ -11854,8 +11884,8 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_misc_irq_uninit(hdev);
 	hclge_devlink_uninit(hdev);
 	hclge_pci_uninit(hdev);
-	mutex_destroy(&hdev->vport_lock);
 	hclge_uninit_vport_vlan_table(hdev);
+	mutex_destroy(&hdev->vport_lock);
 	ae_dev->priv = NULL;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 31fef46b93b3..63197257dd4e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1025,6 +1025,7 @@ struct hclge_vport {
 	spinlock_t mac_list_lock; /* protect mac address need to add/detele */
 	struct list_head uc_mac_list;   /* Store VF unicast table */
 	struct list_head mc_mac_list;   /* Store VF multicast table */
+
 	struct list_head vlan_list;     /* Store VF vlan table */
 };
 
-- 
2.34.1



