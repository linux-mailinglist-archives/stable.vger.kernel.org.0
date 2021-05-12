Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F9F37C26B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbhELPKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhELPHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01E266147E;
        Wed, 12 May 2021 15:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831688;
        bh=0MGGrlJwnmEUHb9kFRxkRt3XADl/a+IYP4Wp6b+5FeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jU7QNwkfaZhl+Ln0ZT+zcehUPs9uQPAoWYEg63o4Qp54MDW7uYS91SoO/cXxkGsuU
         cg5GJzakWxn7eFUJJvFAE61y05e6Mt882bH3dlGJuNvBFh5WxpW743ShAJfNrWxZnq
         ndrIFn63OWX8jjwMvnJqjIdi0nU3B6B84UaQMFxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 220/244] net: renesas: ravb: Fix a stuck issue when a lot of frames are received
Date:   Wed, 12 May 2021 16:49:51 +0200
Message-Id: <20210512144750.041841643@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 5718458b092bf6bf4482c5df32affba3c3259517 ]

When a lot of frames were received in the short term, the driver
caused a stuck of receiving until a new frame was received. For example,
the following command from other device could cause this issue.

    $ sudo ping -f -l 1000 -c 1000 <this driver's ipaddress>

The previous code always cleared the interrupt flag of RX but checks
the interrupt flags in ravb_poll(). So, ravb_poll() could not call
ravb_rx() in the next time until a new RX frame was received if
ravb_rx() returned true. To fix the issue, always calls ravb_rx()
regardless the interrupt flags condition.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 35 ++++++++----------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 551799fb3842..9208a72fe17e 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -911,31 +911,20 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	int q = napi - priv->napi;
 	int mask = BIT(q);
 	int quota = budget;
-	u32 ris0, tis;
 
-	for (;;) {
-		tis = ravb_read(ndev, TIS);
-		ris0 = ravb_read(ndev, RIS0);
-		if (!((ris0 & mask) || (tis & mask)))
-			break;
+	/* Processing RX Descriptor Ring */
+	/* Clear RX interrupt */
+	ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
+	if (ravb_rx(ndev, &quota, q))
+		goto out;
 
-		/* Processing RX Descriptor Ring */
-		if (ris0 & mask) {
-			/* Clear RX interrupt */
-			ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
-			if (ravb_rx(ndev, &quota, q))
-				goto out;
-		}
-		/* Processing TX Descriptor Ring */
-		if (tis & mask) {
-			spin_lock_irqsave(&priv->lock, flags);
-			/* Clear TX interrupt */
-			ravb_write(ndev, ~(mask | TIS_RESERVED), TIS);
-			ravb_tx_free(ndev, q, true);
-			netif_wake_subqueue(ndev, q);
-			spin_unlock_irqrestore(&priv->lock, flags);
-		}
-	}
+	/* Processing RX Descriptor Ring */
+	spin_lock_irqsave(&priv->lock, flags);
+	/* Clear TX interrupt */
+	ravb_write(ndev, ~(mask | TIS_RESERVED), TIS);
+	ravb_tx_free(ndev, q, true);
+	netif_wake_subqueue(ndev, q);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	napi_complete(napi);
 
-- 
2.30.2



