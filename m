Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE9528B868
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390206AbgJLNwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731817AbgJLNsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A476D22228;
        Mon, 12 Oct 2020 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510413;
        bh=KdPHV2cte4sVFZL0Okkv/FLuSzbaFgt7IhYGNIOrrSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iiHRJbV3/pbPXXzsUbWW9X4hnUCmEZ2LmkAJba915EIFUvSB1v6XWVO/Rc4piYI+g
         HA3V8EyuNw9JhKzK2n8Tbrz/w6oixzrcjox7jpcUSGB7d+F2eS8Rc+4oUcq740MiVE
         Nr/3xgy4mErY1ca8HSheIRkIkpH6GTT/B92/nZyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Voon Weifeng <weifeng.voon@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 058/124] net: stmmac: removed enabling eee in EEE set callback
Date:   Mon, 12 Oct 2020 15:31:02 +0200
Message-Id: <20201012133149.667731482@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
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
index eae11c5850251..c16d0cc3e9c44 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -662,23 +662,16 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
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
 
 	ret = phylink_ethtool_set_eee(priv->phylink, edata);
 	if (ret)
 		return ret;
 
-	priv->eee_enabled = edata->eee_enabled;
 	priv->tx_lpi_timer = edata->tx_lpi_timer;
 	return 0;
 }
-- 
2.25.1



