Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0B162551
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732254AbfGHPPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732245AbfGHPPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:15:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0557F216C4;
        Mon,  8 Jul 2019 15:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598906;
        bh=yTjW/8PijZkN6N/vsCgJLuOzygm7pX03BnGK9KWHeTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AccbrKEIshrJlGS7eah5CI4jUPTOdelyIV9h33Hrl9S9oZLd8eJCMpRdcA7/AO7HR
         6goFmvA97I91Gohz8HY+jwIyniOIW/FPX0Orw23G+gdw7YPoaEiR9AABFz7ohU/Be4
         4O3FXq7qSde0Tx4tSqRpNEfNGeSHE9ZjZ877WSRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/73] net: hns: Fix loopback test failed at copper ports
Date:   Mon,  8 Jul 2019 17:12:23 +0200
Message-Id: <20190708150519.845696916@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2e1f164861e500f4e068a9d909bbd3fcc7841483 ]

When doing a loopback test at copper ports, the serdes loopback
and the phy loopback will fail, because of the adjust link had
not finished, and phy not ready.

Adds sleep between adjust link and test process to fix it.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 4b91eb70c683..a2f2db58b5ab 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -351,6 +351,7 @@ static int __lb_setup(struct net_device *ndev,
 static int __lb_up(struct net_device *ndev,
 		   enum hnae_loop loop_mode)
 {
+#define NIC_LB_TEST_WAIT_PHY_LINK_TIME 300
 	struct hns_nic_priv *priv = netdev_priv(ndev);
 	struct hnae_handle *h = priv->ae_handle;
 	int speed, duplex;
@@ -389,6 +390,9 @@ static int __lb_up(struct net_device *ndev,
 
 	h->dev->ops->adjust_link(h, speed, duplex);
 
+	/* wait adjust link done and phy ready */
+	msleep(NIC_LB_TEST_WAIT_PHY_LINK_TIME);
+
 	return 0;
 }
 
-- 
2.20.1



