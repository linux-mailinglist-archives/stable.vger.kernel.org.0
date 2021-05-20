Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F273338A749
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbhETKgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237405AbhETKeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73C5661C4E;
        Thu, 20 May 2021 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504393;
        bh=+kLHwROEIgv5ph2zdEqrUmAQL6AVz54tVtpSmP3VTkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YadODJ8jKVMx5Rqz3ngOUmaRxS/RbXXsaDkl2kXSY8HlwIp4JscdNjnptNOG9TYjw
         tA+9oMqLKF1KdCiCmCu041dzb09CbWVAnOzi+/Q+wQZvmkhnN73b5YvbL6RfgAgt8b
         SrwDVel/D+yi4Wr7o2EYYUeDPsTTJIdpAicxXiGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 225/323] net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send
Date:   Thu, 20 May 2021 11:21:57 +0200
Message-Id: <20210520092127.854814690@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index 44f797ab5d15..57f509a6c449 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1458,6 +1458,7 @@ int emac_mac_tx_buf_send(struct emac_adapter *adpt, struct emac_tx_queue *tx_q,
 {
 	struct emac_tpd tpd;
 	u32 prod_idx;
+	int len;
 
 	memset(&tpd, 0, sizeof(tpd));
 
@@ -1477,9 +1478,10 @@ int emac_mac_tx_buf_send(struct emac_adapter *adpt, struct emac_tx_queue *tx_q,
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



