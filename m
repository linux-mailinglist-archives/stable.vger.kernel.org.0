Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9893A28BA1C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391075AbgJLOGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgJLNey (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:34:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40AF7204EA;
        Mon, 12 Oct 2020 13:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509693;
        bh=WaRSNmjJ0P7LxVJcmFnrIUckbJpl6ghTVNCjNVUK/6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5JEm1CYdIkf0GaWLbrSbHCZb4iWoQEcfGbhEtD8gXFS1dTL+gDnXsvAfy4OGsNRV
         eMO+TegwyMXE2ncpmrNDpctFBC05kqfF5V0fDbwmnvzgVO+V7bVHZS39wBC4y0D3sY
         dt8n7VlYxxa8v0E7DkntcSHDQMNYdZZIAKTRUTy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Voon Weifeng <weifeng.voon@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 44/54] net: stmmac: removed enabling eee in EEE set callback
Date:   Mon, 12 Oct 2020 15:27:06 +0200
Message-Id: <20201012132631.604985413@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

[ Upstream commit 7241c5a697479c7d0c5a96595822cdab750d41ae ]

EEE should be only be enabled during stmmac_mac_link_up() when the
link are up and being set up properly. set_eee should only do settings
configuration and disabling the eee.

Without this fix, turning on EEE using ethtool will return
"Operation not supported". This is due to the driver is in a dead loop
waiting for eee to be advertised in the for eee to be activated but the
driver will only configure the EEE advertisement after the eee is
activated.

Ethtool should only return "Operation not supported" if there is no EEE
capbility in the MAC controller.

Fixes: 8a7493e58ad6 ("net: stmmac: Fix a race in EEE enable callback")
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Acked-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c  | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 3519a8a589dda..c8673e231a880 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -678,23 +678,16 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
 
-	if (!edata->eee_enabled) {
+	if (!priv->dma_cap.eee)
+		return -EOPNOTSUPP;
+
+	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
-	} else {
-		/* We are asking for enabling the EEE but it is safe
-		 * to verify all by invoking the eee_init function.
-		 * In case of failure it will return an error.
-		 */
-		edata->eee_enabled = stmmac_eee_init(priv);
-		if (!edata->eee_enabled)
-			return -EOPNOTSUPP;
-	}
 
 	ret = phy_ethtool_set_eee(dev->phydev, edata);
 	if (ret)
 		return ret;
 
-	priv->eee_enabled = edata->eee_enabled;
 	priv->tx_lpi_timer = edata->tx_lpi_timer;
 	return 0;
 }
-- 
2.25.1



