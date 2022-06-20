Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989145519BF
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243791AbiFTNBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244915AbiFTNAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:00:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCEB1A3A9;
        Mon, 20 Jun 2022 05:56:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81487CE138A;
        Mon, 20 Jun 2022 12:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C32AC341C6;
        Mon, 20 Jun 2022 12:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729810;
        bh=Rl2yJlwfl/wqcLveA/n079p33M4Fb+zHO8zRFtpI5zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yp9kk/nhS3xWs3+5eGQHqv7obEehVvUZxs2z3Lq7pGZzS+0hFtmc/uT6vMcIlq8CW
         Oc/xP3Ao6e3hbtESD8P4O8q7S7csiqk+22qb14LgAPvcfJ1f5uLBOsk55Ena5iX+nF
         uuWJD4x1LO8TYmA8Su66IBT6HK740NdIeIT4+tYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 073/141] net: hns3: fix tm port shapping of fibre port is incorrect after driver initialization
Date:   Mon, 20 Jun 2022 14:50:11 +0200
Message-Id: <20220620124731.697043679@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 12a3670887725df364cc3e030cf3bede6f13b364 ]

Currently in driver initialization process, driver will set shapping
parameters of tm port to default speed read from firmware. However, the
speed of SFP module may not be default speed, so shapping parameters of
tm port may be incorrect.

To fix this problem, driver sets new shapping parameters for tm port
after getting exact speed of SFP module in this case.

Fixes: 88d10bd6f730 ("net: hns3: add support for multiple media type")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 11 ++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |  1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c8c99ab60ec1..c0b4ff73128f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3276,7 +3276,7 @@ static int hclge_tp_port_init(struct hclge_dev *hdev)
 static int hclge_update_port_info(struct hclge_dev *hdev)
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
-	int speed = HCLGE_MAC_SPEED_UNKNOWN;
+	int speed;
 	int ret;
 
 	/* get the port info from SFP cmd if not copper port */
@@ -3287,10 +3287,13 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 	if (!hdev->support_sfp_query)
 		return 0;
 
-	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
+		speed = mac->speed;
 		ret = hclge_get_sfp_info(hdev, mac);
-	else
+	} else {
+		speed = HCLGE_MAC_SPEED_UNKNOWN;
 		ret = hclge_get_sfp_speed(hdev, &speed);
+	}
 
 	if (ret == -EOPNOTSUPP) {
 		hdev->support_sfp_query = false;
@@ -3302,6 +3305,8 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		if (mac->speed_type == QUERY_ACTIVE_SPEED) {
 			hclge_update_port_capability(hdev, mac);
+			if (mac->speed != speed)
+				(void)hclge_tm_port_shaper_cfg(hdev);
 			return 0;
 		}
 		return hclge_cfg_mac_speed_dup(hdev, mac->speed,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index f5296ff60694..2f33b036a47a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -420,7 +420,7 @@ static int hclge_tm_pg_shapping_cfg(struct hclge_dev *hdev,
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
-static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
+int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 {
 	struct hclge_port_shapping_cmd *shap_cfg_cmd;
 	struct hclge_shaper_ir_para ir_para;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 619cc30a2dfc..d943943912f7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -237,6 +237,7 @@ int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr);
 void hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
 void hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats);
 int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate);
+int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev);
 int hclge_tm_get_qset_num(struct hclge_dev *hdev, u16 *qset_num);
 int hclge_tm_get_pri_num(struct hclge_dev *hdev, u8 *pri_num);
 int hclge_tm_get_qset_map_pri(struct hclge_dev *hdev, u16 qset_id, u8 *priority,
-- 
2.35.1



