Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEBE82F2B7
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbfE3EYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbfE3DOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:51 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA27724585;
        Thu, 30 May 2019 03:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186090;
        bh=04Trd73qiFU1O86K9BIr3b/8N0ZYnRRlWR2TB6BlRo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsKtaLYClBbyLIcXv6HoucoXIbWmUlCtENJd9/+R+KU8N4I6wmutElm4A6UtRd6vz
         FWaoEaCEYBX9dSuM9ePCROUKADdqWHPv86n1qGM9EGLfNB3Kibxt2pKDE3rbR8qkkH
         8eMAsHZ9yPmEd/fjclH7ROolFL8tqNqIzyHj103w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 221/346] net: hns3: add protect when handling mac addr list
Date:   Wed, 29 May 2019 20:04:54 -0700
Message-Id: <20190530030552.279834702@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 389775a6605e040dddea21a778a88eaaa57c068d ]

It used netdev->uc and netdev->mc list in function
hns3_recover_hw_addr() and hns3_remove_hw_addr().
We should add protect for them.

Fixes: f05e21097121 ("net: hns3: Clear mac vlan table entries when unload driver or function reset")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index fb5cb15aea9ec..a6481bd34c3bb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3794,12 +3794,13 @@ static int hns3_recover_hw_addr(struct net_device *ndev)
 	struct netdev_hw_addr *ha, *tmp;
 	int ret = 0;
 
+	netif_addr_lock_bh(ndev);
 	/* go through and sync uc_addr entries to the device */
 	list = &ndev->uc;
 	list_for_each_entry_safe(ha, tmp, &list->list, list) {
 		ret = hns3_nic_uc_sync(ndev, ha->addr);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	/* go through and sync mc_addr entries to the device */
@@ -3807,9 +3808,11 @@ static int hns3_recover_hw_addr(struct net_device *ndev)
 	list_for_each_entry_safe(ha, tmp, &list->list, list) {
 		ret = hns3_nic_mc_sync(ndev, ha->addr);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
+out:
+	netif_addr_unlock_bh(ndev);
 	return ret;
 }
 
@@ -3820,6 +3823,7 @@ static void hns3_remove_hw_addr(struct net_device *netdev)
 
 	hns3_nic_uc_unsync(netdev, netdev->dev_addr);
 
+	netif_addr_lock_bh(netdev);
 	/* go through and unsync uc_addr entries to the device */
 	list = &netdev->uc;
 	list_for_each_entry_safe(ha, tmp, &list->list, list)
@@ -3830,6 +3834,8 @@ static void hns3_remove_hw_addr(struct net_device *netdev)
 	list_for_each_entry_safe(ha, tmp, &list->list, list)
 		if (ha->refcount > 1)
 			hns3_nic_mc_unsync(netdev, ha->addr);
+
+	netif_addr_unlock_bh(netdev);
 }
 
 static void hns3_clear_tx_ring(struct hns3_enet_ring *ring)
-- 
2.20.1



