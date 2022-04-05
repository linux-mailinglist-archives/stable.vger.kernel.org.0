Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A924F38EB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377407AbiDEL3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350048AbiDEJwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:52:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1940A3CA4E;
        Tue,  5 Apr 2022 02:50:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C573CE1C9E;
        Tue,  5 Apr 2022 09:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55410C385A3;
        Tue,  5 Apr 2022 09:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152230;
        bh=Tv0xSwsZaqQQPMurIFTLQHo6ohxRt5bwc++549QLfGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fr+SL6NrRGqL0BkDWcCz2sDd1ftEZm6prkXNJGqyJE+FAvORnfHgENBkNUPFXoXi
         5YfkHf86yx8LexNG29tUVNxq77DO0gfMOfYjbQEgeNDUtJ1QlEJ4k4f6EFO6NPNzr/
         5+IwSRIijvWlErqG3JrZVDwmkOC0ytZI7ISF5OQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 664/913] net: hns3: format the output of the MAC address
Date:   Tue,  5 Apr 2022 09:28:46 +0200
Message-Id: <20220405070359.740167425@linuxfoundation.org>
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

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 4f331fda35f1695af8ddd8180edc948880def74b ]

Printing the whole MAC addresse may bring security risks. Therefore,
the MAC address is partially encrypted to improve security.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   | 14 +++++
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 29 +++++++---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 55 ++++++++++++-------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  7 ++-
 4 files changed, 74 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 47bba4c62f04..4aa6d21f2fd8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -852,6 +852,20 @@ struct hnae3_handle {
 #define hnae3_get_bit(origin, shift) \
 	hnae3_get_field(origin, 0x1 << (shift), shift)
 
+#define HNAE3_FORMAT_MAC_ADDR_LEN	18
+#define HNAE3_FORMAT_MAC_ADDR_OFFSET_0	0
+#define HNAE3_FORMAT_MAC_ADDR_OFFSET_4	4
+#define HNAE3_FORMAT_MAC_ADDR_OFFSET_5	5
+
+static inline void hnae3_format_mac_addr(char *format_mac_addr,
+					 const u8 *mac_addr)
+{
+	snprintf(format_mac_addr, HNAE3_FORMAT_MAC_ADDR_LEN, "%02x:**:**:**:%02x:%02x",
+		 mac_addr[HNAE3_FORMAT_MAC_ADDR_OFFSET_0],
+		 mac_addr[HNAE3_FORMAT_MAC_ADDR_OFFSET_4],
+		 mac_addr[HNAE3_FORMAT_MAC_ADDR_OFFSET_5]);
+}
+
 int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
 void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4b886a13e079..e4f6b5a8537c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2255,6 +2255,8 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
 {
+	char format_mac_addr_perm[HNAE3_FORMAT_MAC_ADDR_LEN];
+	char format_mac_addr_sa[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct sockaddr *mac_addr = p;
 	int ret;
@@ -2263,8 +2265,9 @@ static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
 		return -EADDRNOTAVAIL;
 
 	if (ether_addr_equal(netdev->dev_addr, mac_addr->sa_data)) {
-		netdev_info(netdev, "already using mac address %pM\n",
-			    mac_addr->sa_data);
+		hnae3_format_mac_addr(format_mac_addr_sa, mac_addr->sa_data);
+		netdev_info(netdev, "already using mac address %s\n",
+			    format_mac_addr_sa);
 		return 0;
 	}
 
@@ -2273,8 +2276,10 @@ static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
 	 */
 	if (!hns3_is_phys_func(h->pdev) &&
 	    !is_zero_ether_addr(netdev->perm_addr)) {
-		netdev_err(netdev, "has permanent MAC %pM, user MAC %pM not allow\n",
-			   netdev->perm_addr, mac_addr->sa_data);
+		hnae3_format_mac_addr(format_mac_addr_perm, netdev->perm_addr);
+		hnae3_format_mac_addr(format_mac_addr_sa, mac_addr->sa_data);
+		netdev_err(netdev, "has permanent MAC %s, user MAC %s not allow\n",
+			   format_mac_addr_perm, format_mac_addr_sa);
 		return -EPERM;
 	}
 
@@ -2836,14 +2841,16 @@ static int hns3_nic_set_vf_rate(struct net_device *ndev, int vf,
 static int hns3_nic_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 
 	if (!h->ae_algo->ops->set_vf_mac)
 		return -EOPNOTSUPP;
 
 	if (is_multicast_ether_addr(mac)) {
+		hnae3_format_mac_addr(format_mac_addr, mac);
 		netdev_err(netdev,
-			   "Invalid MAC:%pM specified. Could not set MAC\n",
-			   mac);
+			   "Invalid MAC:%s specified. Could not set MAC\n",
+			   format_mac_addr);
 		return -EINVAL;
 	}
 
@@ -4927,6 +4934,7 @@ static void hns3_uninit_all_ring(struct hns3_nic_priv *priv)
 static int hns3_init_mac_addr(struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hnae3_handle *h = priv->ae_handle;
 	u8 mac_addr_temp[ETH_ALEN];
 	int ret = 0;
@@ -4937,8 +4945,9 @@ static int hns3_init_mac_addr(struct net_device *netdev)
 	/* Check if the MAC address is valid, if not get a random one */
 	if (!is_valid_ether_addr(mac_addr_temp)) {
 		eth_hw_addr_random(netdev);
-		dev_warn(priv->dev, "using random MAC address %pM\n",
-			 netdev->dev_addr);
+		hnae3_format_mac_addr(format_mac_addr, netdev->dev_addr);
+		dev_warn(priv->dev, "using random MAC address %s\n",
+			 format_mac_addr);
 	} else if (!ether_addr_equal(netdev->dev_addr, mac_addr_temp)) {
 		ether_addr_copy(netdev->dev_addr, mac_addr_temp);
 		ether_addr_copy(netdev->perm_addr, mac_addr_temp);
@@ -4990,8 +4999,10 @@ static void hns3_client_stop(struct hnae3_handle *handle)
 static void hns3_info_show(struct hns3_nic_priv *priv)
 {
 	struct hnae3_knic_private_info *kinfo = &priv->ae_handle->kinfo;
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 
-	dev_info(priv->dev, "MAC address: %pM\n", priv->netdev->dev_addr);
+	hnae3_format_mac_addr(format_mac_addr, priv->netdev->dev_addr);
+	dev_info(priv->dev, "MAC address: %s\n", format_mac_addr);
 	dev_info(priv->dev, "Task queue pairs numbers: %u\n", kinfo->num_tqps);
 	dev_info(priv->dev, "RSS size: %u\n", kinfo->rss_size);
 	dev_info(priv->dev, "Allocated RSS size: %u\n", kinfo->req_rss_size);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index af6c4a5cb0a2..0b0b79eec1a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8570,6 +8570,7 @@ int hclge_update_mac_list(struct hclge_vport *vport,
 			  enum HCLGE_MAC_ADDR_TYPE mac_type,
 			  const unsigned char *addr)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_node *mac_node;
 	struct list_head *list;
@@ -8594,9 +8595,10 @@ int hclge_update_mac_list(struct hclge_vport *vport,
 	/* if this address is never added, unnecessary to delete */
 	if (state == HCLGE_MAC_TO_DEL) {
 		spin_unlock_bh(&vport->mac_list_lock);
+		hnae3_format_mac_addr(format_mac_addr, addr);
 		dev_err(&hdev->pdev->dev,
-			"failed to delete address %pM from mac list\n",
-			addr);
+			"failed to delete address %s from mac list\n",
+			format_mac_addr);
 		return -ENOENT;
 	}
 
@@ -8629,6 +8631,7 @@ static int hclge_add_uc_addr(struct hnae3_handle *handle,
 int hclge_add_uc_addr_common(struct hclge_vport *vport,
 			     const unsigned char *addr)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_vlan_tbl_entry_cmd req;
 	struct hclge_desc desc;
@@ -8639,9 +8642,10 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
 	if (is_zero_ether_addr(addr) ||
 	    is_broadcast_ether_addr(addr) ||
 	    is_multicast_ether_addr(addr)) {
+		hnae3_format_mac_addr(format_mac_addr, addr);
 		dev_err(&hdev->pdev->dev,
-			"Set_uc mac err! invalid mac:%pM. is_zero:%d,is_br=%d,is_mul=%d\n",
-			 addr, is_zero_ether_addr(addr),
+			"Set_uc mac err! invalid mac:%s. is_zero:%d,is_br=%d,is_mul=%d\n",
+			 format_mac_addr, is_zero_ether_addr(addr),
 			 is_broadcast_ether_addr(addr),
 			 is_multicast_ether_addr(addr));
 		return -EINVAL;
@@ -8698,6 +8702,7 @@ static int hclge_rm_uc_addr(struct hnae3_handle *handle,
 int hclge_rm_uc_addr_common(struct hclge_vport *vport,
 			    const unsigned char *addr)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_vlan_tbl_entry_cmd req;
 	int ret;
@@ -8706,8 +8711,9 @@ int hclge_rm_uc_addr_common(struct hclge_vport *vport,
 	if (is_zero_ether_addr(addr) ||
 	    is_broadcast_ether_addr(addr) ||
 	    is_multicast_ether_addr(addr)) {
-		dev_dbg(&hdev->pdev->dev, "Remove mac err! invalid mac:%pM.\n",
-			addr);
+		hnae3_format_mac_addr(format_mac_addr, addr);
+		dev_dbg(&hdev->pdev->dev, "Remove mac err! invalid mac:%s.\n",
+			format_mac_addr);
 		return -EINVAL;
 	}
 
@@ -8737,6 +8743,7 @@ static int hclge_add_mc_addr(struct hnae3_handle *handle,
 int hclge_add_mc_addr_common(struct hclge_vport *vport,
 			     const unsigned char *addr)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_vlan_tbl_entry_cmd req;
 	struct hclge_desc desc[3];
@@ -8744,9 +8751,10 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
 
 	/* mac addr check */
 	if (!is_multicast_ether_addr(addr)) {
+		hnae3_format_mac_addr(format_mac_addr, addr);
 		dev_err(&hdev->pdev->dev,
-			"Add mc mac err! invalid mac:%pM.\n",
-			 addr);
+			"Add mc mac err! invalid mac:%s.\n",
+			 format_mac_addr);
 		return -EINVAL;
 	}
 	memset(&req, 0, sizeof(req));
@@ -8782,6 +8790,7 @@ static int hclge_rm_mc_addr(struct hnae3_handle *handle,
 int hclge_rm_mc_addr_common(struct hclge_vport *vport,
 			    const unsigned char *addr)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_vlan_tbl_entry_cmd req;
 	enum hclge_cmd_status status;
@@ -8789,9 +8798,10 @@ int hclge_rm_mc_addr_common(struct hclge_vport *vport,
 
 	/* mac addr check */
 	if (!is_multicast_ether_addr(addr)) {
+		hnae3_format_mac_addr(format_mac_addr, addr);
 		dev_dbg(&hdev->pdev->dev,
-			"Remove mc mac err! invalid mac:%pM.\n",
-			 addr);
+			"Remove mc mac err! invalid mac:%s.\n",
+			 format_mac_addr);
 		return -EINVAL;
 	}
 
@@ -9257,16 +9267,18 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 			    u8 *mac_addr)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 
 	vport = hclge_get_vf_vport(hdev, vf);
 	if (!vport)
 		return -EINVAL;
 
+	hnae3_format_mac_addr(format_mac_addr, mac_addr);
 	if (ether_addr_equal(mac_addr, vport->vf_info.mac)) {
 		dev_info(&hdev->pdev->dev,
-			 "Specified MAC(=%pM) is same as before, no change committed!\n",
-			 mac_addr);
+			 "Specified MAC(=%s) is same as before, no change committed!\n",
+			 format_mac_addr);
 		return 0;
 	}
 
@@ -9280,13 +9292,13 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 
 	if (test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
 		dev_info(&hdev->pdev->dev,
-			 "MAC of VF %d has been set to %pM, and it will be reinitialized!\n",
-			 vf, mac_addr);
+			 "MAC of VF %d has been set to %s, and it will be reinitialized!\n",
+			 vf, format_mac_addr);
 		return hclge_inform_reset_assert_to_vf(vport);
 	}
 
-	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %pM\n",
-		 vf, mac_addr);
+	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %s\n",
+		 vf, format_mac_addr);
 	return 0;
 }
 
@@ -9390,6 +9402,7 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, void *p,
 {
 	const unsigned char *new_addr = (const unsigned char *)p;
 	struct hclge_vport *vport = hclge_get_vport(handle);
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclge_dev *hdev = vport->back;
 	unsigned char *old_addr = NULL;
 	int ret;
@@ -9398,9 +9411,10 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, void *p,
 	if (is_zero_ether_addr(new_addr) ||
 	    is_broadcast_ether_addr(new_addr) ||
 	    is_multicast_ether_addr(new_addr)) {
+		hnae3_format_mac_addr(format_mac_addr, new_addr);
 		dev_err(&hdev->pdev->dev,
-			"change uc mac err! invalid mac: %pM.\n",
-			 new_addr);
+			"change uc mac err! invalid mac: %s.\n",
+			 format_mac_addr);
 		return -EINVAL;
 	}
 
@@ -9418,9 +9432,10 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, void *p,
 	spin_lock_bh(&vport->mac_list_lock);
 	ret = hclge_update_mac_node_for_dev_addr(vport, old_addr, new_addr);
 	if (ret) {
+		hnae3_format_mac_addr(format_mac_addr, new_addr);
 		dev_err(&hdev->pdev->dev,
-			"failed to change the mac addr:%pM, ret = %d\n",
-			new_addr, ret);
+			"failed to change the mac addr:%s, ret = %d\n",
+			format_mac_addr, ret);
 		spin_unlock_bh(&vport->mac_list_lock);
 
 		if (!is_first)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 417a08d600b8..98c847fe4c5b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1514,15 +1514,18 @@ static void hclgevf_config_mac_list(struct hclgevf_dev *hdev,
 				    struct list_head *list,
 				    enum HCLGEVF_MAC_ADDR_TYPE mac_type)
 {
+	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hclgevf_mac_addr_node *mac_node, *tmp;
 	int ret;
 
 	list_for_each_entry_safe(mac_node, tmp, list, node) {
 		ret = hclgevf_add_del_mac_addr(hdev, mac_node, mac_type);
 		if  (ret) {
+			hnae3_format_mac_addr(format_mac_addr,
+					      mac_node->mac_addr);
 			dev_err(&hdev->pdev->dev,
-				"failed to configure mac %pM, state = %d, ret = %d\n",
-				mac_node->mac_addr, mac_node->state, ret);
+				"failed to configure mac %s, state = %d, ret = %d\n",
+				format_mac_addr, mac_node->state, ret);
 			return;
 		}
 		if (mac_node->state == HCLGEVF_MAC_TO_ADD) {
-- 
2.34.1



