Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4AD4F2A47
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350652AbiDEJ7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344159AbiDEJS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2620B5B3D3;
        Tue,  5 Apr 2022 02:04:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B51F8614E4;
        Tue,  5 Apr 2022 09:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5F8C385A1;
        Tue,  5 Apr 2022 09:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149484;
        bh=2R99bVrCP0tjVddYJvZrWRKY00NA2/UxWhsgD5k3QFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0FrIYhx+Adn3mY7QlmwD2sTvkDkJV96Eq4ClnbzRWNLFQeggb4fM2vwTOP/lmmZM
         ih3s9/2UwvbF6JrBt9doYozq10obfCGDKKrEoap2Q85jwQyLMB+esszluQLCc43Ou8
         4nFXk/JIAE62dKZs37elvxbWDccFCayEVz4qbnVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0731/1017] net: hns3: add vlan list lock to protect vlan list
Date:   Tue,  5 Apr 2022 09:27:24 +0200
Message-Id: <20220405070415.965539838@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 0338b4ffa003..3ba24c6d004d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10237,19 +10237,28 @@ static void hclge_add_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
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
@@ -10258,6 +10267,8 @@ static int hclge_add_vport_all_vlan_table(struct hclge_vport *vport)
 	struct hclge_dev *hdev = vport->back;
 	int ret;
 
+	mutex_lock(&hdev->vport_lock);
+
 	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 		if (!vlan->hd_tbl_status) {
 			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
@@ -10267,12 +10278,16 @@ static int hclge_add_vport_all_vlan_table(struct hclge_vport *vport)
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
 
@@ -10282,6 +10297,8 @@ static void hclge_rm_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
 	struct hclge_dev *hdev = vport->back;
 
+	mutex_lock(&hdev->vport_lock);
+
 	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 		if (vlan->vlan_id == vlan_id) {
 			if (is_write_tbl && vlan->hd_tbl_status)
@@ -10296,6 +10313,8 @@ static void hclge_rm_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 			break;
 		}
 	}
+
+	mutex_unlock(&hdev->vport_lock);
 }
 
 void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
@@ -10303,6 +10322,8 @@ void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
 	struct hclge_dev *hdev = vport->back;
 
+	mutex_lock(&hdev->vport_lock);
+
 	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 		if (vlan->hd_tbl_status)
 			hclge_set_vlan_filter_hw(hdev,
@@ -10318,6 +10339,7 @@ void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
 		}
 	}
 	clear_bit(vport->vport_id, hdev->vf_vlan_full);
+	mutex_unlock(&hdev->vport_lock);
 }
 
 void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
@@ -10326,6 +10348,8 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 	struct hclge_vport *vport;
 	int i;
 
+	mutex_lock(&hdev->vport_lock);
+
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		vport = &hdev->vport[i];
 		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
@@ -10333,6 +10357,8 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 			kfree(vlan);
 		}
 	}
+
+	mutex_unlock(&hdev->vport_lock);
 }
 
 void hclge_restore_vport_port_base_vlan_config(struct hclge_dev *hdev)
@@ -10372,6 +10398,8 @@ void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
 	struct hclge_dev *hdev = vport->back;
 	int ret;
 
+	mutex_lock(&hdev->vport_lock);
+
 	if (vport->port_base_vlan_cfg.state == HNAE3_PORT_BASE_VLAN_DISABLE) {
 		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
@@ -10382,6 +10410,8 @@ void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
 			vlan->hd_tbl_status = true;
 		}
 	}
+
+	mutex_unlock(&hdev->vport_lock);
 }
 
 /* For global reset and imp reset, hardware will clear the mac table,
@@ -12279,8 +12309,8 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_misc_irq_uninit(hdev);
 	hclge_devlink_uninit(hdev);
 	hclge_pci_uninit(hdev);
-	mutex_destroy(&hdev->vport_lock);
 	hclge_uninit_vport_vlan_table(hdev);
+	mutex_destroy(&hdev->vport_lock);
 	ae_dev->priv = NULL;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 801268b61e96..c841cce2d025 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1087,6 +1087,7 @@ struct hclge_vport {
 	spinlock_t mac_list_lock; /* protect mac address need to add/detele */
 	struct list_head uc_mac_list;   /* Store VF unicast table */
 	struct list_head mc_mac_list;   /* Store VF multicast table */
+
 	struct list_head vlan_list;     /* Store VF vlan table */
 };
 
-- 
2.34.1



