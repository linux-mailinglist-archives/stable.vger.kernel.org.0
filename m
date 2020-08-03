Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80F323A421
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgHCMXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727797AbgHCMXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:23:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CB2E207FC;
        Mon,  3 Aug 2020 12:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457394;
        bh=UHtW8gr5ECAWR/VH94aqmSyCXDjEJAbSu5JGNwEo1aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQ/VUTymKzmZTs2rwIReOSP1w1OgwNxz2z9onr9HIRF0C3Z29C6ladg+vnMpFtieW
         syVyBEh25r3k95CtDyOxgPKFLkpVFHjMNWR8TYIVyTwfnc9liwUglAUrdprak1T9E2
         1zM5X2vkjI0fatZm0L1JB9gdolKwmX0OF1wtbgtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 051/120] net: hns3: add reset check for VF updating port based VLAN
Date:   Mon,  3 Aug 2020 14:18:29 +0200
Message-Id: <20200803121905.292698090@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit a6f7bfdc78ddd8d719d108fef973b4e4a5a6ac6b ]

Currently hclgevf_update_port_base_vlan_info() may be called when
VF is resetting,  which may cause hns3_nic_net_open() being called
twice unexpectedly.

So fix it by adding a reset check for it, and extend critical
region for rntl_lock in hclgevf_update_port_base_vlan_info().

Fixes: 92f11ea177cd ("net: hns3: fix set port based VLAN issue for VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 30 +++++++++++++------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index e6cdd06925e6b..1bdff64bb70f9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3142,23 +3142,35 @@ void hclgevf_update_port_base_vlan_info(struct hclgevf_dev *hdev, u16 state,
 {
 	struct hnae3_handle *nic = &hdev->nic;
 	struct hclge_vf_to_pf_msg send_msg;
+	int ret;
 
 	rtnl_lock();
-	hclgevf_notify_client(hdev, HNAE3_DOWN_CLIENT);
-	rtnl_unlock();
+
+	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state)) {
+		dev_warn(&hdev->pdev->dev,
+			 "is resetting when updating port based vlan info\n");
+		rtnl_unlock();
+		return;
+	}
+
+	ret = hclgevf_notify_client(hdev, HNAE3_DOWN_CLIENT);
+	if (ret) {
+		rtnl_unlock();
+		return;
+	}
 
 	/* send msg to PF and wait update port based vlan info */
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
 			       HCLGE_MBX_PORT_BASE_VLAN_CFG);
 	memcpy(send_msg.data, port_base_vlan_info, data_size);
-	hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
-
-	if (state == HNAE3_PORT_BASE_VLAN_DISABLE)
-		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_DISABLE;
-	else
-		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_ENABLE;
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
+	if (!ret) {
+		if (state == HNAE3_PORT_BASE_VLAN_DISABLE)
+			nic->port_base_vlan_state = state;
+		else
+			nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_ENABLE;
+	}
 
-	rtnl_lock();
 	hclgevf_notify_client(hdev, HNAE3_UP_CLIENT);
 	rtnl_unlock();
 }
-- 
2.25.1



