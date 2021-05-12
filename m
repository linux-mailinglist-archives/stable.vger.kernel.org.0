Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3122B37CE93
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345018AbhELRFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233461AbhELQrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:47:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ECD161E7F;
        Wed, 12 May 2021 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836118;
        bh=YZ4EGNozTOU8hGUZKKI0E3g1TalZVevFRK9ARMR80T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hp1eddF5mWeZ1ioYcx1+Fdu0hGpYwlOWADJvy2xerjVCb975cw05quGOv6ulD8/Jp
         scsZEgwW8jEXfKYL3Z17/nc7n1uIl20Jq5izJeslhMsB75BL9j49J30D2lClGMOqrQ
         Duf/ql6h/1Ks5SCBJNUadLBTU1MYCr/gkTtQb6Fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 618/677] net: stmmac: fix TSO and TBS feature enabling during driver open
Date:   Wed, 12 May 2021 16:51:04 +0200
Message-Id: <20210512144857.902673946@linuxfoundation.org>
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

From: Ong Boon Leong <boon.leong.ong@intel.com>

[ Upstream commit 5e6038b88a5718910dd74b949946d9d9cee9a041 ]

TSO and TBS cannot co-exist and current implementation requires two
fixes:

 1) stmmac_open() does not need to call stmmac_enable_tbs() because
    the MAC is reset in stmmac_init_dma_engine() anyway.
 2) Inside stmmac_hw_setup(), we should call stmmac_enable_tso() for
    TX Q that is _not_ configured for TBS.

Fixes: 579a25a854d4 ("net: stmmac: Initial support for TBS")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4749bd0af160..c6f24abf6432 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2757,8 +2757,15 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 
 	/* Enable TSO */
 	if (priv->tso) {
-		for (chan = 0; chan < tx_cnt; chan++)
+		for (chan = 0; chan < tx_cnt; chan++) {
+			struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+
+			/* TSO and TBS cannot co-exist */
+			if (tx_q->tbs & STMMAC_TBS_AVAIL)
+				continue;
+
 			stmmac_enable_tso(priv, priv->ioaddr, 1, chan);
+		}
 	}
 
 	/* Enable Split Header */
@@ -2850,9 +2857,8 @@ static int stmmac_open(struct net_device *dev)
 		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
 		int tbs_en = priv->plat->tx_queues_cfg[chan].tbs_en;
 
+		/* Setup per-TXQ tbs flag before TX descriptor alloc */
 		tx_q->tbs |= tbs_en ? STMMAC_TBS_AVAIL : 0;
-		if (stmmac_enable_tbs(priv, priv->ioaddr, tbs_en, chan))
-			tx_q->tbs &= ~STMMAC_TBS_AVAIL;
 	}
 
 	ret = alloc_dma_desc_resources(priv);
-- 
2.30.2



