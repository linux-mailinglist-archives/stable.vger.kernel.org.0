Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F016101615
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbfKSFuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbfKSFuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:50:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89CAF20721;
        Tue, 19 Nov 2019 05:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142603;
        bh=pcXpAcOVE3NvxebTUdEuPJe/gAbBCH1+DZ41goKBY2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7YVKSYnpuAkjXL8uC7hfs4ZWoGoGjTL4XHsgPBDJdoizRkQ2Bco25R5PoCUu4sDJ
         i0CmXl00epYZBnfQOwQT3vch6SI/mEtLtRe0YUDpWwlwcRgMSvhmi1+ZRvRtI+9g0O
         lTtEWskVs34pOK3DTsM39gWx0bpXXohj1M69vrF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 138/239] net: hns3: fix return type of ndo_start_xmit function
Date:   Tue, 19 Nov 2019 06:18:58 +0100
Message-Id: <20191119051331.386693914@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit c9c3941186c5637caed131c4f4064411d6882299 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, also the implementation in this
driver has returns 'netdev_tx_t' value, so just change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c    | 3 ++-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index ebc056b9a0fd2..84c0f22ac2db0 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -424,7 +424,8 @@ static void hip04_start_tx_timer(struct hip04_priv *priv)
 			       ns, HRTIMER_MODE_REL);
 }
 
-static int hip04_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t
+hip04_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct hip04_priv *priv = netdev_priv(ndev);
 	struct net_device_stats *stats = &ndev->stats;
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 25a6c8722ecac..aab6fb10af94a 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -736,7 +736,7 @@ static int hix5hd2_fill_sg_desc(struct hix5hd2_priv *priv,
 	return 0;
 }
 
-static int hix5hd2_net_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t hix5hd2_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct hix5hd2_priv *priv = netdev_priv(dev);
 	struct hix5hd2_desc *desc;
-- 
2.20.1



