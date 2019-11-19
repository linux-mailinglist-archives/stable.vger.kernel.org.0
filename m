Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BBE1018AF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfKSF1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbfKSF1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84838222A2;
        Tue, 19 Nov 2019 05:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141272;
        bh=N1pWcBOj31y9uIOAZtMAT/3HfEKBzIxyzNdyyjpV8zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBXfm02MBmmX5KhBVfpV0nd4hTRvhBMWIXGUln1cWjzCKWUeoK8aDu3dLctAJk6Dc
         jQhCZYgqeBW9rLdEaLLwg9yrRjO8LRFYGjwc0EpXlw9ks/VnZ64I4Ns5mrEl3oSIHv
         5pMyqA6a5Ke/0nKaSbag5GPppH/dkhMZeH5XCrIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/422] net: hns3: Fix for loopback selftest failed problem
Date:   Tue, 19 Nov 2019 06:15:02 +0100
Message-Id: <20191119051405.992741910@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 0f29fc23b21d3cbd966537bfabba07c00466b787 ]

Tqp and mac need to be enabled when doing loopback selftest,
ae_algo->ops->start/stop is used to do the job, there is a
time window between ae_algo->ops->start/stop and loopback setup,
which will cause selftest failed problem when there is frame
coming in during that time window.

This patch fixes it by enabling the tqp and mac during loopback
setup process.

Fixes: c39c4d98dc65 ("net: hns3: Add mac loopback selftest support in hns3 driver")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 17 +------
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 51 +++++++++++--------
 2 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6a3c6b02a77cd..5bdcd92d86122 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -100,41 +100,26 @@ static int hns3_lp_up(struct net_device *ndev, enum hnae3_loop loop_mode)
 	struct hnae3_handle *h = hns3_get_handle(ndev);
 	int ret;
 
-	if (!h->ae_algo->ops->start)
-		return -EOPNOTSUPP;
-
 	ret = hns3_nic_reset_all_ring(h);
 	if (ret)
 		return ret;
 
-	ret = h->ae_algo->ops->start(h);
-	if (ret) {
-		netdev_err(ndev,
-			   "hns3_lb_up ae start return error: %d\n", ret);
-		return ret;
-	}
-
 	ret = hns3_lp_setup(ndev, loop_mode, true);
 	usleep_range(10000, 20000);
 
-	return ret;
+	return 0;
 }
 
 static int hns3_lp_down(struct net_device *ndev, enum hnae3_loop loop_mode)
 {
-	struct hnae3_handle *h = hns3_get_handle(ndev);
 	int ret;
 
-	if (!h->ae_algo->ops->stop)
-		return -EOPNOTSUPP;
-
 	ret = hns3_lp_setup(ndev, loop_mode, false);
 	if (ret) {
 		netdev_err(ndev, "lb_setup return error: %d\n", ret);
 		return ret;
 	}
 
-	h->ae_algo->ops->stop(h);
 	usleep_range(10000, 20000);
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0e7c92f624e91..0cf33fa351df3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3666,6 +3666,8 @@ static int hclge_set_mac_loopback(struct hclge_dev *hdev, bool en)
 	/* 2 Then setup the loopback flag */
 	loop_en = le32_to_cpu(req->txrx_pad_fcs_loop_en);
 	hnae3_set_bit(loop_en, HCLGE_MAC_APP_LP_B, en ? 1 : 0);
+	hnae3_set_bit(loop_en, HCLGE_MAC_TX_EN_B, en ? 1 : 0);
+	hnae3_set_bit(loop_en, HCLGE_MAC_RX_EN_B, en ? 1 : 0);
 
 	req->txrx_pad_fcs_loop_en = cpu_to_le32(loop_en);
 
@@ -3726,15 +3728,36 @@ static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en)
 		return -EIO;
 	}
 
+	hclge_cfg_mac_mode(hdev, en);
 	return 0;
 }
 
+static int hclge_tqp_enable(struct hclge_dev *hdev, int tqp_id,
+			    int stream_id, bool enable)
+{
+	struct hclge_desc desc;
+	struct hclge_cfg_com_tqp_queue_cmd *req =
+		(struct hclge_cfg_com_tqp_queue_cmd *)desc.data;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_COM_TQP_QUEUE, false);
+	req->tqp_id = cpu_to_le16(tqp_id & HCLGE_RING_ID_MASK);
+	req->stream_id = cpu_to_le16(stream_id);
+	req->enable |= enable << HCLGE_TQP_ENABLE_B;
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"Tqp enable fail, status =%d.\n", ret);
+	return ret;
+}
+
 static int hclge_set_loopback(struct hnae3_handle *handle,
 			      enum hnae3_loop loop_mode, bool en)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
-	int ret;
+	int i, ret;
 
 	switch (loop_mode) {
 	case HNAE3_MAC_INTER_LOOP_MAC:
@@ -3750,27 +3773,13 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 		break;
 	}
 
-	return ret;
-}
-
-static int hclge_tqp_enable(struct hclge_dev *hdev, int tqp_id,
-			    int stream_id, bool enable)
-{
-	struct hclge_desc desc;
-	struct hclge_cfg_com_tqp_queue_cmd *req =
-		(struct hclge_cfg_com_tqp_queue_cmd *)desc.data;
-	int ret;
-
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_COM_TQP_QUEUE, false);
-	req->tqp_id = cpu_to_le16(tqp_id & HCLGE_RING_ID_MASK);
-	req->stream_id = cpu_to_le16(stream_id);
-	req->enable |= enable << HCLGE_TQP_ENABLE_B;
+	for (i = 0; i < vport->alloc_tqps; i++) {
+		ret = hclge_tqp_enable(hdev, i, 0, en);
+		if (ret)
+			return ret;
+	}
 
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		dev_err(&hdev->pdev->dev,
-			"Tqp enable fail, status =%d.\n", ret);
-	return ret;
+	return 0;
 }
 
 static void hclge_reset_tqp_stats(struct hnae3_handle *handle)
-- 
2.20.1



