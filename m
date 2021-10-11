Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A0B429109
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbhJKOPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:15:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243502AbhJKONB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D9F611EF;
        Mon, 11 Oct 2021 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961039;
        bh=l2Eojidf55mG8gKBeq00TDGvRfF3j4KQioeXRomOkH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dk7hXeMLZ1GsK+MP7x6gwH1iuZRLkMcb5AH6vX2n2MYpahA9D1+LADJwrDHZXyPEc
         f5veQyAdmBKhyt1wmyNLrdzhEgfurDA21W19h4teZKMJv5OuE0aJv8l2vkb4ZzpvXL
         A8/WiUHb/E2xSvOdkJzksMvl3bl9fq+RG4ogfJ5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 107/151] net: stmmac: trigger PCS EEE to turn off on link down
Date:   Mon, 11 Oct 2021 15:46:19 +0200
Message-Id: <20211011134521.276677112@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@linux.intel.com>

[ Upstream commit d4aeaed80b0ebb020fadf2073b23462928dbdc17 ]

The current implementation enable PCS EEE feature in the event of link
up, but PCS EEE feature is not disabled on link down.

This patch makes sure PCE EEE feature is disabled on link down.

Fixes: 656ed8b015f1 ("net: stmmac: fix EEE init issue when paired with EEE capable PHYs")
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 86151a817b79..6b2a5e5769e8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -477,6 +477,10 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 			stmmac_lpi_entry_timer_config(priv, 0);
 			del_timer_sync(&priv->eee_ctrl_timer);
 			stmmac_set_eee_timer(priv, priv->hw, 0, eee_tw_timer);
+			if (priv->hw->xpcs)
+				xpcs_config_eee(priv->hw->xpcs,
+						priv->plat->mult_fact_100ns,
+						false);
 		}
 		mutex_unlock(&priv->lock);
 		return false;
@@ -1038,7 +1042,7 @@ static void stmmac_mac_link_down(struct phylink_config *config,
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	priv->eee_active = false;
 	priv->tx_lpi_enabled = false;
-	stmmac_eee_init(priv);
+	priv->eee_enabled = stmmac_eee_init(priv);
 	stmmac_set_eee_pls(priv, priv->hw, false);
 
 	if (priv->dma_cap.fpesel)
-- 
2.33.0



