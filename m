Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4840420ED1
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhJDN24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236804AbhJDN04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:26:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BFEF61222;
        Mon,  4 Oct 2021 13:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353113;
        bh=azXybXZHbpy+XsP8n9p+uIXt2pHz7ey1Me2sReFsKrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7cgZ0Bo0pBR1o2aY2eGhxe75eGBvqv7ZQ7e16azVsZ20F3hbanMYOI463kiRNgGZ
         1uaEH0bv0adNkpA2z0jpBFZaiSChpUo7Ss1HV1P2Tl6XGBiUCgz3NiJRCKGk/eDNqp
         mXWpL5Rd32EVc5yhNMJs59JbeCbGEUfO5XpUuhTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Li <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 61/93] net: hns3: reconstruct function hns3_self_test
Date:   Mon,  4 Oct 2021 14:52:59 +0200
Message-Id: <20211004125036.581079585@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit 4c8dab1c709c5a715bce14efdb8f4e889d86aa04 ]

This patch reconstructs function hns3_self_test to reduce the code
cycle complexity and make code more concise.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 101 +++++++++++-------
 1 file changed, 64 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 0aee100902ff..436d777cce06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -300,33 +300,8 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 	return ret_val;
 }
 
-/**
- * hns3_self_test - self test
- * @ndev: net device
- * @eth_test: test cmd
- * @data: test result
- */
-static void hns3_self_test(struct net_device *ndev,
-			   struct ethtool_test *eth_test, u64 *data)
+static void hns3_set_selftest_param(struct hnae3_handle *h, int (*st_param)[2])
 {
-	struct hns3_nic_priv *priv = netdev_priv(ndev);
-	struct hnae3_handle *h = priv->ae_handle;
-	int st_param[HNS3_SELF_TEST_TYPE_NUM][2];
-	bool if_running = netif_running(ndev);
-	int test_index = 0;
-	u32 i;
-
-	if (hns3_nic_resetting(ndev)) {
-		netdev_err(ndev, "dev resetting!");
-		return;
-	}
-
-	/* Only do offline selftest, or pass by default */
-	if (eth_test->flags != ETH_TEST_FL_OFFLINE)
-		return;
-
-	netif_dbg(h, drv, ndev, "self test start");
-
 	st_param[HNAE3_LOOP_APP][0] = HNAE3_LOOP_APP;
 	st_param[HNAE3_LOOP_APP][1] =
 			h->flags & HNAE3_SUPPORT_APP_LOOPBACK;
@@ -343,6 +318,18 @@ static void hns3_self_test(struct net_device *ndev,
 	st_param[HNAE3_LOOP_PHY][0] = HNAE3_LOOP_PHY;
 	st_param[HNAE3_LOOP_PHY][1] =
 			h->flags & HNAE3_SUPPORT_PHY_LOOPBACK;
+}
+
+static void hns3_selftest_prepare(struct net_device *ndev,
+				  bool if_running, int (*st_param)[2])
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+
+	if (netif_msg_ifdown(h))
+		netdev_info(ndev, "self test start\n");
+
+	hns3_set_selftest_param(h, st_param);
 
 	if (if_running)
 		ndev->netdev_ops->ndo_stop(ndev);
@@ -361,6 +348,35 @@ static void hns3_self_test(struct net_device *ndev,
 		h->ae_algo->ops->halt_autoneg(h, true);
 
 	set_bit(HNS3_NIC_STATE_TESTING, &priv->state);
+}
+
+static void hns3_selftest_restore(struct net_device *ndev, bool if_running)
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+
+	clear_bit(HNS3_NIC_STATE_TESTING, &priv->state);
+
+	if (h->ae_algo->ops->halt_autoneg)
+		h->ae_algo->ops->halt_autoneg(h, false);
+
+#if IS_ENABLED(CONFIG_VLAN_8021Q)
+	if (h->ae_algo->ops->enable_vlan_filter)
+		h->ae_algo->ops->enable_vlan_filter(h, true);
+#endif
+
+	if (if_running)
+		ndev->netdev_ops->ndo_open(ndev);
+
+	if (netif_msg_ifdown(h))
+		netdev_info(ndev, "self test end\n");
+}
+
+static void hns3_do_selftest(struct net_device *ndev, int (*st_param)[2],
+			     struct ethtool_test *eth_test, u64 *data)
+{
+	int test_index = 0;
+	u32 i;
 
 	for (i = 0; i < HNS3_SELF_TEST_TYPE_NUM; i++) {
 		enum hnae3_loop loop_type = (enum hnae3_loop)st_param[i][0];
@@ -379,21 +395,32 @@ static void hns3_self_test(struct net_device *ndev,
 
 		test_index++;
 	}
+}
 
-	clear_bit(HNS3_NIC_STATE_TESTING, &priv->state);
-
-	if (h->ae_algo->ops->halt_autoneg)
-		h->ae_algo->ops->halt_autoneg(h, false);
+/**
+ * hns3_nic_self_test - self test
+ * @ndev: net device
+ * @eth_test: test cmd
+ * @data: test result
+ */
+static void hns3_self_test(struct net_device *ndev,
+			   struct ethtool_test *eth_test, u64 *data)
+{
+	int st_param[HNS3_SELF_TEST_TYPE_NUM][2];
+	bool if_running = netif_running(ndev);
 
-#if IS_ENABLED(CONFIG_VLAN_8021Q)
-	if (h->ae_algo->ops->enable_vlan_filter)
-		h->ae_algo->ops->enable_vlan_filter(h, true);
-#endif
+	if (hns3_nic_resetting(ndev)) {
+		netdev_err(ndev, "dev resetting!");
+		return;
+	}
 
-	if (if_running)
-		ndev->netdev_ops->ndo_open(ndev);
+	/* Only do offline selftest, or pass by default */
+	if (eth_test->flags != ETH_TEST_FL_OFFLINE)
+		return;
 
-	netif_dbg(h, drv, ndev, "self test end\n");
+	hns3_selftest_prepare(ndev, if_running, st_param);
+	hns3_do_selftest(ndev, st_param, eth_test, data);
+	hns3_selftest_restore(ndev, if_running);
 }
 
 static int hns3_get_sset_count(struct net_device *netdev, int stringset)
-- 
2.33.0



