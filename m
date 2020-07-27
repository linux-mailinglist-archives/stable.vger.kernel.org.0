Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881DE22F123
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgG0OWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731296AbgG0OWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 029182173E;
        Mon, 27 Jul 2020 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859727;
        bh=gyQdnrPqdFImMtpb8jo3c1WTMauHr62tKoWb/8+nMWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjKy1Way9fgeXeKnJRuyWef+5e3i04mg4T4fVe5dcDuAgAKYgp8VhdHSXGjklk2pL
         dTbXs1/Ms7MxL71sPLZHYLrhlCNCHsr/26YcGjrnY4Q4ROGkXKbij1Lf8byxX+Wo5I
         NKwqGi0GLCHC7LKYUXJtoMI04ViUGz4sQ5Itc7wI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 080/179] net: hns3: fix return value error when query MAC link status fail
Date:   Mon, 27 Jul 2020 16:04:15 +0200
Message-Id: <20200727134936.580410663@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit fac24df7b9a6d9363abdff0e351ade041dd16daa ]

Currently, PF queries the MAC link status per second by calling
function hclge_get_mac_link_status(). It return the error code
when failed to send cmdq command to firmware. It's incorrect,
because this return value is used as the MAC link status, which
0 means link down, and none-zero means link up. So fixes it.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 49 +++++++++----------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  3 ++
 2 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4de268a879582..b66b93f320b42 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2680,11 +2680,10 @@ void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time)
 				    delay_time);
 }
 
-static int hclge_get_mac_link_status(struct hclge_dev *hdev)
+static int hclge_get_mac_link_status(struct hclge_dev *hdev, int *link_status)
 {
 	struct hclge_link_status_cmd *req;
 	struct hclge_desc desc;
-	int link_status;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_LINK_STATUS, true);
@@ -2696,33 +2695,25 @@ static int hclge_get_mac_link_status(struct hclge_dev *hdev)
 	}
 
 	req = (struct hclge_link_status_cmd *)desc.data;
-	link_status = req->status & HCLGE_LINK_STATUS_UP_M;
+	*link_status = (req->status & HCLGE_LINK_STATUS_UP_M) > 0 ?
+		HCLGE_LINK_STATUS_UP : HCLGE_LINK_STATUS_DOWN;
 
-	return !!link_status;
+	return 0;
 }
 
-static int hclge_get_mac_phy_link(struct hclge_dev *hdev)
+static int hclge_get_mac_phy_link(struct hclge_dev *hdev, int *link_status)
 {
-	unsigned int mac_state;
-	int link_stat;
+	struct phy_device *phydev = hdev->hw.mac.phydev;
+
+	*link_status = HCLGE_LINK_STATUS_DOWN;
 
 	if (test_bit(HCLGE_STATE_DOWN, &hdev->state))
 		return 0;
 
-	mac_state = hclge_get_mac_link_status(hdev);
-
-	if (hdev->hw.mac.phydev) {
-		if (hdev->hw.mac.phydev->state == PHY_RUNNING)
-			link_stat = mac_state &
-				hdev->hw.mac.phydev->link;
-		else
-			link_stat = 0;
-
-	} else {
-		link_stat = mac_state;
-	}
+	if (phydev && (phydev->state != PHY_RUNNING || !phydev->link))
+		return 0;
 
-	return !!link_stat;
+	return hclge_get_mac_link_status(hdev, link_status);
 }
 
 static void hclge_update_link_status(struct hclge_dev *hdev)
@@ -2732,6 +2723,7 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 	struct hnae3_handle *rhandle;
 	struct hnae3_handle *handle;
 	int state;
+	int ret;
 	int i;
 
 	if (!client)
@@ -2740,7 +2732,12 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 	if (test_and_set_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state))
 		return;
 
-	state = hclge_get_mac_phy_link(hdev);
+	ret = hclge_get_mac_phy_link(hdev, &state);
+	if (ret) {
+		clear_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state);
+		return;
+	}
+
 	if (state != hdev->hw.mac.link) {
 		for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
 			handle = &hdev->vport[i].nic;
@@ -6435,14 +6432,15 @@ static int hclge_mac_link_status_wait(struct hclge_dev *hdev, int link_ret)
 {
 #define HCLGE_MAC_LINK_STATUS_NUM  100
 
+	int link_status;
 	int i = 0;
 	int ret;
 
 	do {
-		ret = hclge_get_mac_link_status(hdev);
-		if (ret < 0)
+		ret = hclge_get_mac_link_status(hdev, &link_status);
+		if (ret)
 			return ret;
-		else if (ret == link_ret)
+		if (link_status == link_ret)
 			return 0;
 
 		msleep(HCLGE_LINK_STATUS_MS);
@@ -6453,9 +6451,6 @@ static int hclge_mac_link_status_wait(struct hclge_dev *hdev, int link_ret)
 static int hclge_mac_phy_link_status_wait(struct hclge_dev *hdev, bool en,
 					  bool is_phy)
 {
-#define HCLGE_LINK_STATUS_DOWN 0
-#define HCLGE_LINK_STATUS_UP   1
-
 	int link_ret;
 
 	link_ret = en ? HCLGE_LINK_STATUS_UP : HCLGE_LINK_STATUS_DOWN;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 71df23d5f1b4d..8784168f8f6f7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -316,6 +316,9 @@ enum hclge_link_fail_code {
 	HCLGE_LF_XSFP_ABSENT,
 };
 
+#define HCLGE_LINK_STATUS_DOWN 0
+#define HCLGE_LINK_STATUS_UP   1
+
 #define HCLGE_PG_NUM		4
 #define HCLGE_SCH_MODE_SP	0
 #define HCLGE_SCH_MODE_DWRR	1
-- 
2.25.1



