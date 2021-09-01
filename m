Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02E53FDC75
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344676AbhIAMvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345823AbhIAMsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA88610E7;
        Wed,  1 Sep 2021 12:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500040;
        bh=FZ28ebaIHoobKvuJXHwLOsBD2eJgQshKmz5OdwX222o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrwnK4oaVm4kqdThIeDbbcmQe44HlS5o0BDF7nZ+s+2BQZDoakYpMHunvBWsu5d3g
         I5b3AHYNNJXDaoRDDm+g3sutj9T2JYwH2hHxFcUow1JQi59pvq4tVSaqAXhOXTP2c0
         nhyuTd/e5Gww61KFythiH6kJis+EAche6DEdlzyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 062/113] net: hns3: fix speed unknown issue in bond 4
Date:   Wed,  1 Sep 2021 14:28:17 +0200
Message-Id: <20210901122304.037010360@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit b15c072a9f4a404c09ad589477f4389034742a8b ]

In bond 4, when the link goes down and up repeatedly, the bond may get an
unknown speed, and then this port can not work.

The driver notify netif_carrier_on() before update the link state, when the
bond receive carrier on, will query the speed of the port, if the query
operation happens before updating the link state, will get an unknown
speed. So need to notify netif_carrier_on() after update the link state.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9ea4007dbac9..00254d167904 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2924,12 +2924,12 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 	}
 
 	if (state != hdev->hw.mac.link) {
+		hdev->hw.mac.link = state;
 		client->ops->link_status_change(handle, state);
 		hclge_config_mac_tnl_int(hdev, state);
 		if (rclient && rclient->ops->link_status_change)
 			rclient->ops->link_status_change(rhandle, state);
 
-		hdev->hw.mac.link = state;
 		hclge_push_link_status(hdev);
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index fe03c8419890..d3f36e2b2b90 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -498,10 +498,10 @@ void hclgevf_update_link_status(struct hclgevf_dev *hdev, int link_state)
 	link_state =
 		test_bit(HCLGEVF_STATE_DOWN, &hdev->state) ? 0 : link_state;
 	if (link_state != hdev->hw.mac.link) {
+		hdev->hw.mac.link = link_state;
 		client->ops->link_status_change(handle, !!link_state);
 		if (rclient && rclient->ops->link_status_change)
 			rclient->ops->link_status_change(rhandle, !!link_state);
-		hdev->hw.mac.link = link_state;
 	}
 
 	clear_bit(HCLGEVF_STATE_LINK_UPDATING, &hdev->state);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 9b17735b9f4c..987b88d7e0c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -304,8 +304,8 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 			flag = (u8)msg_q[5];
 
 			/* update upper layer with new link link status */
-			hclgevf_update_link_status(hdev, link_status);
 			hclgevf_update_speed_duplex(hdev, speed, duplex);
+			hclgevf_update_link_status(hdev, link_status);
 
 			if (flag & HCLGE_MBX_PUSH_LINK_STATUS_EN)
 				set_bit(HCLGEVF_STATE_PF_PUSH_LINK_STATUS,
-- 
2.30.2



