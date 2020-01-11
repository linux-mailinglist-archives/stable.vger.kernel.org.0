Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786D5138088
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgAKKbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbgAKKbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:31:03 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76E092087F;
        Sat, 11 Jan 2020 10:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738662;
        bh=8MzWV4eYSQYuaeCOKKsG+5mnNrwZDQJddPQNJTSKJgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQmuVSgLvMHkHaEt3Rw2DevYI6Ra7hi7K95l6wKKb2rWE1mapu5yYdLIATi4rD9FU
         5Dh6z8CnkhgJ+aN7YxMOBP63xTCO5cPwPdbAqGFz0bZGc2FMfR1BeKA9HhBIIcPKpl
         /TCNkcg57BE0AoKAzdELmJiglwQnZTDiu2EcWxqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/165] net: stmmac: Always arm TX Timer at end of transmission start
Date:   Sat, 11 Jan 2020 10:50:34 +0100
Message-Id: <20200111094932.349821973@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 4772f26db8d1fb568c4862c538344a1b5fb52081 ]

If TX Coalesce timer is enabled we should always arm it, otherwise we
may hit the case where an interrupt is missed and the TX Queue will
timeout.

Arming the timer does not necessarly mean it will run the tx_clean()
because this function is wrapped around NAPI launcher.

Fixes: 9125cdd1be11 ("stmmac: add the initial tx coalesce schema")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cfb60b20e625..903c5d8a226e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3101,6 +3101,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_q->tx_tail_addr = tx_q->dma_tx_phy + (tx_q->cur_tx * sizeof(*desc));
 	stmmac_set_tx_tail_ptr(priv, priv->ioaddr, tx_q->tx_tail_addr, queue);
+	stmmac_tx_timer_arm(priv, queue);
 
 	return NETDEV_TX_OK;
 
@@ -3328,6 +3329,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_q->tx_tail_addr = tx_q->dma_tx_phy + (tx_q->cur_tx * sizeof(*desc));
 	stmmac_set_tx_tail_ptr(priv, priv->ioaddr, tx_q->tx_tail_addr, queue);
+	stmmac_tx_timer_arm(priv, queue);
 
 	return NETDEV_TX_OK;
 
-- 
2.20.1



