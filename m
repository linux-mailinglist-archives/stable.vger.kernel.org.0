Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFE538A4B6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhETKIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235266AbhETKF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F2BE61935;
        Thu, 20 May 2021 09:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503685;
        bh=MQpu4WwJTKgdxc+EeP2Zj+e63L1hnstGQvQog8EE/JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ30JH1pOH7fFTjjGZu2V/nQo5z8hLylioNYOXgZwIOL8YKL53aPCwYjxHZHoGCfc
         szKgPYIaDqvbQ34KwRh1vWtRSa2gXvd80izhdKIu9DTCShcIpXuXHQ+MOYaVjDW+yV
         9riDStg+vMH7LgNTXQiIOwJPDm9zY8veQ8Qb04CQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 289/425] net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send
Date:   Thu, 20 May 2021 11:20:58 +0200
Message-Id: <20210520092140.949037993@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 6d72e7c767acbbdd44ebc7d89c6690b405b32b57 ]

In emac_mac_tx_buf_send, it calls emac_tx_fill_tpd(..,skb,..).
If some error happens in emac_tx_fill_tpd(), the skb will be freed via
dev_kfree_skb(skb) in error branch of emac_tx_fill_tpd().
But the freed skb is still used via skb->len by netdev_sent_queue(,skb->len).

As i observed that emac_tx_fill_tpd() haven't modified the value of skb->len,
thus my patch assigns skb->len to 'len' before the possible free and
use 'len' instead of skb->len later.

Fixes: b9b17debc69d2 ("net: emac: emac gigabit ethernet controller driver")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/emac/emac-mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index 031f6e6ee9c1..351a90698010 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1449,6 +1449,7 @@ int emac_mac_tx_buf_send(struct emac_adapter *adpt, struct emac_tx_queue *tx_q,
 {
 	struct emac_tpd tpd;
 	u32 prod_idx;
+	int len;
 
 	memset(&tpd, 0, sizeof(tpd));
 
@@ -1468,9 +1469,10 @@ int emac_mac_tx_buf_send(struct emac_adapter *adpt, struct emac_tx_queue *tx_q,
 	if (skb_network_offset(skb) != ETH_HLEN)
 		TPD_TYP_SET(&tpd, 1);
 
+	len = skb->len;
 	emac_tx_fill_tpd(adpt, tx_q, skb, &tpd);
 
-	netdev_sent_queue(adpt->netdev, skb->len);
+	netdev_sent_queue(adpt->netdev, len);
 
 	/* Make sure the are enough free descriptors to hold one
 	 * maximum-sized SKB.  We need one desc for each fragment,
-- 
2.30.2



