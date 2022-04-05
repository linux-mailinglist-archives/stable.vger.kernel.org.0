Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E539D4F38E8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377391AbiDEL3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350029AbiDEJwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:52:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397D3393CB;
        Tue,  5 Apr 2022 02:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFA0DB81B7A;
        Tue,  5 Apr 2022 09:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E315C385A1;
        Tue,  5 Apr 2022 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152221;
        bh=jK4gwc8pp6SUbKLBDyjaf2de90fiMd/Y+u9tePDO4Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op3ZNy/hxxulTBRW+pCCSRXrJwuRQLSFRwQT103EOAq+eJF7mCVCu2NrZDaiWp4Sp
         Ud+2DLWMZUeXnAKCf8Slcg5LfZ8e6AzNxqWD2Uk0c44/okSHamL6b3UU7Rcj5fQSdJ
         v8WRbZInpen25IlGwolY9UqI07zCOljphvpBjEiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 662/913] net: hns3: fix port base vlan add fail when concurrent with reset
Date:   Tue,  5 Apr 2022 09:28:44 +0200
Message-Id: <20220405070359.681457248@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit c0f46de30c965d4ba208b5bf1a6d3437a7556ee2 ]

Currently, Port base vlan is initiated by PF and configured to its VFs,
by using command "ip link set <pf name> vf <vf id> vlan <vlan id>".
When a global reset was triggered, the hardware vlan table and the soft
recorded vlan information will be cleared by PF, and restored them until
VFs were ready. There is a short time window between the table had been
cleared and before table restored. If configured a new port base vlan tag
at this moment, driver will check the soft recorded vlan information,
and find there hasn't the old tag in it, which causing a warning print.

Due to the port base vlan is managed by PF, so the VFs's port base vlan
restoring should be handled by PF when PF was ready.

This patch fixes it.

Fixes: 039ba863e8d7 ("net: hns3: optimize the filter table entries handling when resetting")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 62 +++++++++++++------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  3 +
 2 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b78de80d6c05..4be90d0f2b91 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1863,6 +1863,7 @@ static int hclge_alloc_vport(struct hclge_dev *hdev)
 		vport->vf_info.link_state = IFLA_VF_LINK_STATE_AUTO;
 		vport->mps = HCLGE_MAC_DEFAULT_FRAME;
 		vport->port_base_vlan_cfg.state = HNAE3_PORT_BASE_VLAN_DISABLE;
+		vport->port_base_vlan_cfg.tbl_sta = true;
 		vport->rxvlan_cfg.rx_vlan_offload_en = true;
 		vport->req_vlan_fltr_en = true;
 		INIT_LIST_HEAD(&vport->vlan_list);
@@ -10175,34 +10176,52 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 	}
 }
 
-void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
+void hclge_restore_vport_port_base_vlan_config(struct hclge_dev *hdev)
 {
-	struct hclge_vport_vlan_cfg *vlan, *tmp;
-	struct hclge_dev *hdev = vport->back;
+	struct hclge_vlan_info *vlan_info;
+	struct hclge_vport *vport;
 	u16 vlan_proto;
 	u16 vlan_id;
 	u16 state;
+	int vf_id;
 	int ret;
 
-	vlan_proto = vport->port_base_vlan_cfg.vlan_info.vlan_proto;
-	vlan_id = vport->port_base_vlan_cfg.vlan_info.vlan_tag;
-	state = vport->port_base_vlan_cfg.state;
+	/* PF should restore all vfs port base vlan */
+	for (vf_id = 0; vf_id < hdev->num_alloc_vfs; vf_id++) {
+		vport = &hdev->vport[vf_id + HCLGE_VF_VPORT_START_NUM];
+		vlan_info = vport->port_base_vlan_cfg.tbl_sta ?
+			    &vport->port_base_vlan_cfg.vlan_info :
+			    &vport->port_base_vlan_cfg.old_vlan_info;
 
-	if (state != HNAE3_PORT_BASE_VLAN_DISABLE) {
-		clear_bit(vport->vport_id, hdev->vlan_table[vlan_id]);
-		hclge_set_vlan_filter_hw(hdev, htons(vlan_proto),
-					 vport->vport_id, vlan_id,
-					 false);
-		return;
+		vlan_id = vlan_info->vlan_tag;
+		vlan_proto = vlan_info->vlan_proto;
+		state = vport->port_base_vlan_cfg.state;
+
+		if (state != HNAE3_PORT_BASE_VLAN_DISABLE) {
+			clear_bit(vport->vport_id, hdev->vlan_table[vlan_id]);
+			ret = hclge_set_vlan_filter_hw(hdev, htons(vlan_proto),
+						       vport->vport_id,
+						       vlan_id, false);
+			vport->port_base_vlan_cfg.tbl_sta = ret == 0;
+		}
 	}
+}
 
-	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
-		ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
-					       vport->vport_id,
-					       vlan->vlan_id, false);
-		if (ret)
-			break;
-		vlan->hd_tbl_status = true;
+void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
+{
+	struct hclge_vport_vlan_cfg *vlan, *tmp;
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	if (vport->port_base_vlan_cfg.state == HNAE3_PORT_BASE_VLAN_DISABLE) {
+		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
+			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
+						       vport->vport_id,
+						       vlan->vlan_id, false);
+			if (ret)
+				break;
+			vlan->hd_tbl_status = true;
+		}
 	}
 }
 
@@ -10243,6 +10262,7 @@ static void hclge_restore_hw_table(struct hclge_dev *hdev)
 	struct hnae3_handle *handle = &vport->nic;
 
 	hclge_restore_mac_table_common(vport);
+	hclge_restore_vport_port_base_vlan_config(hdev);
 	hclge_restore_vport_vlan_table(vport);
 	set_bit(HCLGE_STATE_FD_USER_DEF_CHANGED, &hdev->state);
 	hclge_restore_fd_entries(handle);
@@ -10299,6 +10319,8 @@ static int hclge_update_vlan_filter_entries(struct hclge_vport *vport,
 						 false);
 	}
 
+	vport->port_base_vlan_cfg.tbl_sta = false;
+
 	/* force add VLAN 0 */
 	ret = hclge_set_vf_vlan_common(hdev, vport->vport_id, false, 0);
 	if (ret)
@@ -10385,7 +10407,9 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 	else
 		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_ENABLE;
 
+	vport->port_base_vlan_cfg.old_vlan_info = *old_vlan_info;
 	vport->port_base_vlan_cfg.vlan_info = *vlan_info;
+	vport->port_base_vlan_cfg.tbl_sta = true;
 	hclge_set_vport_vlan_fltr_change(vport);
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 2fa6e14c96e5..ae8c26c194ec 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1000,7 +1000,9 @@ struct hclge_vlan_info {
 
 struct hclge_port_base_vlan_config {
 	u16 state;
+	bool tbl_sta;
 	struct hclge_vlan_info vlan_info;
+	struct hclge_vlan_info old_vlan_info;
 };
 
 struct hclge_vf_info {
@@ -1124,6 +1126,7 @@ void hclge_rm_vport_all_mac_table(struct hclge_vport *vport, bool is_del_list,
 void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list);
 void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev);
 void hclge_restore_mac_table_common(struct hclge_vport *vport);
+void hclge_restore_vport_port_base_vlan_config(struct hclge_dev *hdev);
 void hclge_restore_vport_vlan_table(struct hclge_vport *vport);
 int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 				    struct hclge_vlan_info *vlan_info);
-- 
2.34.1



