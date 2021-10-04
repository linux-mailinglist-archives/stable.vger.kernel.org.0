Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB019420FE2
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhJDNjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237960AbhJDNho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531C763247;
        Mon,  4 Oct 2021 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353433;
        bh=K/gY/bzftKgnELA1UKE1uJQ0LhA1rzex/nO+qBYe+dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwy+5uYeOitnebZJSQJMoWyzyEgylprB3TuNiaS13awsp0TMTzYMQ+aJOJvO6CpRz
         7RJzZ6KPfDQeWKWBblfPGocWHw3K4PZ7KBmr4wRpbbN77zjWWJ1SFNocP47DfgJKap
         5Iw5Zhc8djQHJKW6s6tzXCL/wEEGiBrXB09E94oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 125/172] net: hns3: remove tc enable checking
Date:   Mon,  4 Oct 2021 14:52:55 +0200
Message-Id: <20211004125049.010721018@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit a8e76fefe3de9b8e609cf192af75e7878d21fa3a ]

Currently, in function hns3_nic_set_real_num_queue(), the
driver doesn't report the queue count and offset for disabled
tc. If user enables multiple TCs, but only maps user
priorities to partial of them, it may cause the queue range
of the unmapped TC being displayed abnormally.

Fix it by removing the tc enable checking, ensure the queue
count is not zero.

With this change, the tc_en is useless now, so remove it.

Fixes: a75a8efa00c5 ("net: hns3: Fix tc setup when netdev is first up")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h           |  1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       | 11 ++---------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c    |  5 -----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  2 --
 4 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e0b7c3c44e7b..32987bd134a1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -750,7 +750,6 @@ struct hnae3_tc_info {
 	u8 prio_tc[HNAE3_MAX_USER_PRIO]; /* TC indexed by prio */
 	u16 tqp_count[HNAE3_MAX_TC];
 	u16 tqp_offset[HNAE3_MAX_TC];
-	unsigned long tc_en; /* bitmap of TC enabled */
 	u8 num_tc; /* Total number of enabled TCs */
 	bool mqprio_active;
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b24ad9bc8e1b..114692c4f797 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -620,13 +620,9 @@ static int hns3_nic_set_real_num_queue(struct net_device *netdev)
 			return ret;
 		}
 
-		for (i = 0; i < HNAE3_MAX_TC; i++) {
-			if (!test_bit(i, &tc_info->tc_en))
-				continue;
-
+		for (i = 0; i < tc_info->num_tc; i++)
 			netdev_set_tc_queue(netdev, i, tc_info->tqp_count[i],
 					    tc_info->tqp_offset[i]);
-		}
 	}
 
 	ret = netif_set_real_num_tx_queues(netdev, queue_size);
@@ -4830,12 +4826,9 @@ static void hns3_init_tx_ring_tc(struct hns3_nic_priv *priv)
 	struct hnae3_tc_info *tc_info = &kinfo->tc_info;
 	int i;
 
-	for (i = 0; i < HNAE3_MAX_TC; i++) {
+	for (i = 0; i < tc_info->num_tc; i++) {
 		int j;
 
-		if (!test_bit(i, &tc_info->tc_en))
-			continue;
-
 		for (j = 0; j < tc_info->tqp_count[i]; j++) {
 			struct hnae3_queue *q;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 39f56f245d84..5fadfdbc4858 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -420,8 +420,6 @@ static int hclge_mqprio_qopt_check(struct hclge_dev *hdev,
 static void hclge_sync_mqprio_qopt(struct hnae3_tc_info *tc_info,
 				   struct tc_mqprio_qopt_offload *mqprio_qopt)
 {
-	int i;
-
 	memset(tc_info, 0, sizeof(*tc_info));
 	tc_info->num_tc = mqprio_qopt->qopt.num_tc;
 	memcpy(tc_info->prio_tc, mqprio_qopt->qopt.prio_tc_map,
@@ -430,9 +428,6 @@ static void hclge_sync_mqprio_qopt(struct hnae3_tc_info *tc_info,
 	       sizeof_field(struct hnae3_tc_info, tqp_count));
 	memcpy(tc_info->tqp_offset, mqprio_qopt->qopt.offset,
 	       sizeof_field(struct hnae3_tc_info, tqp_offset));
-
-	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
-		set_bit(tc_info->prio_tc[i], &tc_info->tc_en);
 }
 
 static int hclge_config_tc(struct hclge_dev *hdev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 44618cc4cca1..6f5035a788c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -687,12 +687,10 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 
 	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		if (hdev->hw_tc_map & BIT(i) && i < kinfo->tc_info.num_tc) {
-			set_bit(i, &kinfo->tc_info.tc_en);
 			kinfo->tc_info.tqp_offset[i] = i * kinfo->rss_size;
 			kinfo->tc_info.tqp_count[i] = kinfo->rss_size;
 		} else {
 			/* Set to default queue if TC is disable */
-			clear_bit(i, &kinfo->tc_info.tc_en);
 			kinfo->tc_info.tqp_offset[i] = 0;
 			kinfo->tc_info.tqp_count[i] = 1;
 		}
-- 
2.33.0



