Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCB637CEC2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbhELRGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242846AbhELQuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 687AB61D54;
        Wed, 12 May 2021 16:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836196;
        bh=n+AlIZTnt6xoCymPDcnfpVGdh1ubkYkDSmHe4NPqy7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkFq/6WAWUFjsKcUESFhtrRGj8Hzg6TVouKF+lA6PWNogBf9d3cRGfKVVgTTXwand
         DMUXCi5QFnzWyR2eRJFXDat0sqhpJaj85OWgSpkl6E8GZEzjKmMnc8qTM/B4IrPydN
         oknadWKplS/QvWPSrm7R3PcOExb5sSrXt3LXVP7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 650/677] net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send
Date:   Wed, 12 May 2021 16:51:36 +0200
Message-Id: <20210512144858.965236950@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 117188e3c7de..87b8c032195d 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1437,6 +1437,7 @@ netdev_tx_t emac_mac_tx_buf_send(struct emac_adapter *adpt,
 {
 	struct emac_tpd tpd;
 	u32 prod_idx;
+	int len;
 
 	memset(&tpd, 0, sizeof(tpd));
 
@@ -1456,9 +1457,10 @@ netdev_tx_t emac_mac_tx_buf_send(struct emac_adapter *adpt,
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



