Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A912F37C648
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbhELPuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234543AbhELPo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:44:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F06E61C93;
        Wed, 12 May 2021 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832971;
        bh=3RD+TccnU7IjzUSLYPKTCNFGrDt4wNRfh45NuLW48+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+35ICPmmjiiKy80tCM2JJ8awZOSQW122Z5Ku39ng4A3dR0S/1WQlzw5l7w1fQezC
         AwGVxUjJVaZeTOAF1irtdPTOvw1a3CaaJYKByYjV+cGFsrx/x/+OtPaGLJPX2GvB4W
         eeCaKGzxkO4YYiCoaBR0ioXWizDHHpmicSLU8330=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 480/530] net: stmmac: fix TSO and TBS feature enabling during driver open
Date:   Wed, 12 May 2021 16:49:50 +0200
Message-Id: <20210512144835.532681118@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 6012eadae460..5b9478dffe10 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2727,8 +2727,15 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 
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
@@ -2820,9 +2827,8 @@ static int stmmac_open(struct net_device *dev)
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



