Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516151017A6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfKSFlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:41:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbfKSFlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1320C21939;
        Tue, 19 Nov 2019 05:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142062;
        bh=2bxnzyA9OA70eb6o/ISq1eO7ir0jU9NT735LvRxqyBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LoeiScXaJMpKCh+iGO7haJkrKM0svRpmiXclT8Mnox4Dn8JYMuxbo6LwHeXfZsjjA
         DYgtoKlkj0DlqBuGpAoynzOe00oqjqq7YzsqpSUA4rAjIkNRt3E6zaf5gO/EdFeuaa
         lKuiCaDHqKCQRIld+8VEa81ge9KRvE38bv0dR9Hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 375/422] net: faraday: fix return type of ndo_start_xmit function
Date:   Tue, 19 Nov 2019 06:19:32 +0100
Message-Id: <20191119051423.326026707@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 0a715156656bddf4aa92d9868f850aeeb0465fd0 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 4 ++--
 drivers/net/ethernet/faraday/ftmac100.c  | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index f6ed889bc36a2..e4fc38cbe8535 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -712,8 +712,8 @@ static bool ftgmac100_prep_tx_csum(struct sk_buff *skb, u32 *csum_vlan)
 	return skb_checksum_help(skb) == 0;
 }
 
-static int ftgmac100_hard_start_xmit(struct sk_buff *skb,
-				     struct net_device *netdev)
+static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
+					     struct net_device *netdev)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
 	struct ftgmac100_txdes *txdes, *first;
diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 9015bd911bee9..084f24daf2b5a 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -634,8 +634,8 @@ static void ftmac100_tx_complete(struct ftmac100 *priv)
 		;
 }
 
-static int ftmac100_xmit(struct ftmac100 *priv, struct sk_buff *skb,
-			 dma_addr_t map)
+static netdev_tx_t ftmac100_xmit(struct ftmac100 *priv, struct sk_buff *skb,
+				 dma_addr_t map)
 {
 	struct net_device *netdev = priv->netdev;
 	struct ftmac100_txdes *txdes;
@@ -1015,7 +1015,8 @@ static int ftmac100_stop(struct net_device *netdev)
 	return 0;
 }
 
-static int ftmac100_hard_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t
+ftmac100_hard_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct ftmac100 *priv = netdev_priv(netdev);
 	dma_addr_t map;
-- 
2.20.1



