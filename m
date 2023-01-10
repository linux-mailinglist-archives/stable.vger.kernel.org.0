Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF54664870
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjAJSLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239080AbjAJSK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0E62DD9
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:09:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE1DDB81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F869C433D2;
        Tue, 10 Jan 2023 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374146;
        bh=vq6JODt3lOqDapBmchU7gOd2SkufPOElNBiR9ejM3vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mh7B65YZ/DmGMVRYFCKf4XDRTLlGtfKFlOiSA+ySdHYBnEnMM4JEMULGsRyG/Bb7R
         4d/msfuB+h4vstlkJ9Vv0MlqREAB0g+8OC1AjgzHpQykre7XFkB96U1EiPbob5yTbx
         cxTn33M8SAuT10H7v16x43k9l6GlSYe/cimMO3Qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jian Shen <shenjian15@huawei.com>,
        Hao Lan <lanhao@huawei.com>, kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 062/148] net: hns3: refine the handling for VF heartbeat
Date:   Tue, 10 Jan 2023 19:02:46 +0100
Message-Id: <20230110180019.193299808@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit fec7352117fa301bfbc31bacc14bb9a579376b36 ]

Currently, the PF check the VF alive by the KEEP_ALVE
mailbox from VF. VF keep sending the mailbox per 2
seconds. Once PF lost the mailbox for more than 8
seconds, it will regards the VF is abnormal, and stop
notifying the state change to VF, include link state,
vf mac, reset, even though it receives the KEEP_ALIVE
mailbox again. It's inreasonable.

This patch fixes it. PF will record the state change which
need to notify VF when lost the VF's KEEP_ALIVE mailbox.
And notify VF when receive the mailbox again. Introduce a
new flag HCLGE_VPORT_STATE_INITED, used to distinguish the
case whether VF driver loaded or not. For VF will query
these states when initializing, so it's unnecessary to
notify it in this case.

Fixes: aa5c4f175be6 ("net: hns3: add reset handling for VF when doing PF reset")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 57 +++++++++++----
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  7 ++
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 71 ++++++++++++++++---
 3 files changed, 112 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2a1765eed4c8..d2dde3f1fb88 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3713,9 +3713,17 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 			return ret;
 		}
 
-		if (!reset || !test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
+		if (!reset ||
+		    !test_bit(HCLGE_VPORT_STATE_INITED, &vport->state))
 			continue;
 
+		if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state) &&
+		    hdev->reset_type == HNAE3_FUNC_RESET) {
+			set_bit(HCLGE_VPORT_NEED_NOTIFY_RESET,
+				&vport->need_notify);
+			continue;
+		}
+
 		/* Inform VF to process the reset.
 		 * hclge_inform_reset_assert_to_vf may fail if VF
 		 * driver is not loaded.
@@ -4412,18 +4420,25 @@ static void hclge_reset_service_task(struct hclge_dev *hdev)
 
 static void hclge_update_vport_alive(struct hclge_dev *hdev)
 {
+#define HCLGE_ALIVE_SECONDS_NORMAL		8
+
+	unsigned long alive_time = HCLGE_ALIVE_SECONDS_NORMAL * HZ;
 	int i;
 
 	/* start from vport 1 for PF is always alive */
 	for (i = 1; i < hdev->num_alloc_vport; i++) {
 		struct hclge_vport *vport = &hdev->vport[i];
 
-		if (time_after(jiffies, vport->last_active_jiffies + 8 * HZ))
+		if (!test_bit(HCLGE_VPORT_STATE_INITED, &vport->state) ||
+		    !test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
+			continue;
+		if (time_after(jiffies, vport->last_active_jiffies +
+			       alive_time)) {
 			clear_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
-
-		/* If vf is not alive, set to default value */
-		if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
-			vport->mps = HCLGE_MAC_DEFAULT_FRAME;
+			dev_warn(&hdev->pdev->dev,
+				 "VF %u heartbeat timeout\n",
+				 i - HCLGE_VF_VPORT_START_NUM);
+		}
 	}
 }
 
@@ -7853,9 +7868,11 @@ int hclge_vport_start(struct hclge_vport *vport)
 {
 	struct hclge_dev *hdev = vport->back;
 
+	set_bit(HCLGE_VPORT_STATE_INITED, &vport->state);
 	set_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
 	set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
 	vport->last_active_jiffies = jiffies;
+	vport->need_notify = 0;
 
 	if (test_bit(vport->vport_id, hdev->vport_config_block)) {
 		if (vport->vport_id) {
@@ -7873,7 +7890,9 @@ int hclge_vport_start(struct hclge_vport *vport)
 
 void hclge_vport_stop(struct hclge_vport *vport)
 {
+	clear_bit(HCLGE_VPORT_STATE_INITED, &vport->state);
 	clear_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
+	vport->need_notify = 0;
 }
 
 static int hclge_client_start(struct hnae3_handle *handle)
@@ -8997,7 +9016,8 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 		return 0;
 	}
 
-	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %s\n",
+	dev_info(&hdev->pdev->dev,
+		 "MAC of VF %d has been set to %s, will be active after VF reset\n",
 		 vf, format_mac_addr);
 	return 0;
 }
@@ -10254,12 +10274,16 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 	 * for DEVICE_VERSION_V3, vf doesn't need to know about the port based
 	 * VLAN state.
 	 */
-	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3 &&
-	    test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
-		(void)hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
-							vport->vport_id,
-							state, &vlan_info);
-
+	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3) {
+		if (test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
+			(void)hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
+								vport->vport_id,
+								state,
+								&vlan_info);
+		else
+			set_bit(HCLGE_VPORT_NEED_NOTIFY_VF_VLAN,
+				&vport->need_notify);
+	}
 	return 0;
 }
 
@@ -11723,7 +11747,7 @@ static void hclge_reset_vport_state(struct hclge_dev *hdev)
 	int i;
 
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
-		hclge_vport_stop(vport);
+		clear_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
 		vport++;
 	}
 }
@@ -12737,6 +12761,11 @@ static void hclge_clear_vport_vf_info(struct hclge_vport *vport, int vfid)
 	struct hclge_vlan_info vlan_info;
 	int ret;
 
+	clear_bit(HCLGE_VPORT_STATE_INITED, &vport->state);
+	clear_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
+	vport->need_notify = 0;
+	vport->mps = 0;
+
 	/* after disable sriov, clean VF rate configured by PF */
 	ret = hclge_tm_qs_shaper_cfg(vport, 0);
 	if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 18caddd541f8..14473e29fe03 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -972,9 +972,15 @@ enum HCLGE_VPORT_STATE {
 	HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
 	HCLGE_VPORT_STATE_PROMISC_CHANGE,
 	HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
+	HCLGE_VPORT_STATE_INITED,
 	HCLGE_VPORT_STATE_MAX
 };
 
+enum HCLGE_VPORT_NEED_NOTIFY {
+	HCLGE_VPORT_NEED_NOTIFY_RESET,
+	HCLGE_VPORT_NEED_NOTIFY_VF_VLAN,
+};
+
 struct hclge_vlan_info {
 	u16 vlan_proto; /* so far support 802.1Q only */
 	u16 qos;
@@ -1021,6 +1027,7 @@ struct hclge_vport {
 	struct hnae3_handle roce;
 
 	unsigned long state;
+	unsigned long need_notify;
 	unsigned long last_active_jiffies;
 	u32 mps; /* Max packet size */
 	struct hclge_vf_info vf_info;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index a7b06c63143c..04ff9bf12185 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -124,17 +124,26 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 	return status;
 }
 
+static int hclge_inform_vf_reset(struct hclge_vport *vport, u16 reset_type)
+{
+	__le16 msg_data;
+	u8 dest_vfid;
+
+	dest_vfid = (u8)vport->vport_id;
+	msg_data = cpu_to_le16(reset_type);
+
+	/* send this requested info to VF */
+	return hclge_send_mbx_msg(vport, (u8 *)&msg_data, sizeof(msg_data),
+				  HCLGE_MBX_ASSERTING_RESET, dest_vfid);
+}
+
 int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport)
 {
 	struct hclge_dev *hdev = vport->back;
-	__le16 msg_data;
 	u16 reset_type;
-	u8 dest_vfid;
 
 	BUILD_BUG_ON(HNAE3_MAX_RESET > U16_MAX);
 
-	dest_vfid = (u8)vport->vport_id;
-
 	if (hdev->reset_type == HNAE3_FUNC_RESET)
 		reset_type = HNAE3_VF_PF_FUNC_RESET;
 	else if (hdev->reset_type == HNAE3_FLR_RESET)
@@ -142,11 +151,7 @@ int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport)
 	else
 		reset_type = HNAE3_VF_FUNC_RESET;
 
-	msg_data = cpu_to_le16(reset_type);
-
-	/* send this requested info to VF */
-	return hclge_send_mbx_msg(vport, (u8 *)&msg_data, sizeof(msg_data),
-				  HCLGE_MBX_ASSERTING_RESET, dest_vfid);
+	return hclge_inform_vf_reset(vport, reset_type);
 }
 
 static void hclge_free_vector_ring_chain(struct hnae3_ring_chain_node *head)
@@ -652,9 +657,56 @@ static int hclge_reset_vf(struct hclge_vport *vport)
 	return hclge_func_reset_cmd(hdev, vport->vport_id);
 }
 
+static void hclge_notify_vf_config(struct hclge_vport *vport)
+{
+	struct hclge_dev *hdev = vport->back;
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	struct hclge_port_base_vlan_config *vlan_cfg;
+	int ret;
+
+	hclge_push_vf_link_status(vport);
+	if (test_bit(HCLGE_VPORT_NEED_NOTIFY_RESET, &vport->need_notify)) {
+		ret = hclge_inform_vf_reset(vport, HNAE3_VF_PF_FUNC_RESET);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to inform VF %u reset!",
+				vport->vport_id - HCLGE_VF_VPORT_START_NUM);
+			return;
+		}
+		vport->need_notify = 0;
+		return;
+	}
+
+	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3 &&
+	    test_bit(HCLGE_VPORT_NEED_NOTIFY_VF_VLAN, &vport->need_notify)) {
+		vlan_cfg = &vport->port_base_vlan_cfg;
+		ret = hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
+							vport->vport_id,
+							vlan_cfg->state,
+							&vlan_cfg->vlan_info);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to inform VF %u port base vlan!",
+				vport->vport_id - HCLGE_VF_VPORT_START_NUM);
+			return;
+		}
+		clear_bit(HCLGE_VPORT_NEED_NOTIFY_VF_VLAN, &vport->need_notify);
+	}
+}
+
 static void hclge_vf_keep_alive(struct hclge_vport *vport)
 {
+	struct hclge_dev *hdev = vport->back;
+
 	vport->last_active_jiffies = jiffies;
+
+	if (test_bit(HCLGE_VPORT_STATE_INITED, &vport->state) &&
+	    !test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
+		set_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
+		dev_info(&hdev->pdev->dev, "VF %u is alive!",
+			 vport->vport_id - HCLGE_VF_VPORT_START_NUM);
+		hclge_notify_vf_config(vport);
+	}
 }
 
 static int hclge_set_vf_mtu(struct hclge_vport *vport,
@@ -954,6 +1006,7 @@ static int hclge_mbx_vf_uninit_handler(struct hclge_mbx_ops_param *param)
 	hclge_rm_vport_all_mac_table(param->vport, true,
 				     HCLGE_MAC_ADDR_MC);
 	hclge_rm_vport_all_vlan_table(param->vport, true);
+	param->vport->mps = 0;
 	return 0;
 }
 
-- 
2.35.1



