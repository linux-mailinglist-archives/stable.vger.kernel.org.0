Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0EC73A2C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391244AbfGXTr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391239AbfGXTr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:47:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0898217D4;
        Wed, 24 Jul 2019 19:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997645;
        bh=I5M5n/oVA0hib1J6oDVxP5V0BH2K4pTfdVCdQbaijgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXyoP2hoOZ28vHnJ+jlzOgfqIEHgy9EIR1C3Ip4MXGv4tz6BfMlp0Bl3O9sw/xAiM
         LA+Z8Z7OEiA2yHeo+fn3p5Hm9075R8bybXlXAaezfso1CqJcBWzHhn+lVcD0LIJJ1w
         eZuniv6IWRvELQ8O5G9DIdW98P0hwe3fcrPWfqbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 095/371] net: hns3: fix for skb leak when doing selftest
Date:   Wed, 24 Jul 2019 21:17:27 +0200
Message-Id: <20190724191731.979364920@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8f9eed1a8791b83eb1c54c261d68424717e4111e ]

If hns3_nic_net_xmit does not return NETDEV_TX_BUSY when doing
a loopback selftest, the skb is not freed in hns3_clean_tx_ring
or hns3_nic_net_xmit, which causes skb not freed problem.

This patch fixes it by freeing skb when hns3_nic_net_xmit does
not return NETDEV_TX_OK.

Fixes: c39c4d98dc65 ("net: hns3: Add mac loopback selftest support in hns3 driver")

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index ea94b5152963..cf20fa6768d7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -241,11 +241,13 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 
 		skb_get(skb);
 		tx_ret = hns3_nic_net_xmit(skb, ndev);
-		if (tx_ret == NETDEV_TX_OK)
+		if (tx_ret == NETDEV_TX_OK) {
 			good_cnt++;
-		else
+		} else {
+			kfree_skb(skb);
 			netdev_err(ndev, "hns3_lb_run_test xmit failed: %d\n",
 				   tx_ret);
+		}
 	}
 	if (good_cnt != HNS3_NIC_LB_TEST_PKT_NUM) {
 		ret_val = HNS3_NIC_LB_TEST_TX_CNT_ERR;
-- 
2.20.1



