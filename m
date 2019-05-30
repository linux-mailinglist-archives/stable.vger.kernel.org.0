Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C264C2F5E5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfE3EvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728304AbfE3DK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:58 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5E8024496;
        Thu, 30 May 2019 03:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185857;
        bh=lG9g6xWdNOcCH7xw6fij6IKTMhN748dLgUokM2N4NBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUZplhswt9FHgaRH3OSEAkUf8hEsfPtcL4RABpsngnndHiZnxxBMG1GuqlQhaerfY
         1TrO4mB02GsG/7AX0fK2b7TMdXwxTvWK5joURT/qzuuDtVfEQY/+xU6Sm7/ic62W0C
         MTjRRO7LswVXMBPjTQAoJQmNg4djLG1jM/RDjZh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 186/405] dpaa2-eth: Fix Rx classification status
Date:   Wed, 29 May 2019 20:03:04 -0700
Message-Id: <20190530030550.459344401@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit df8e249be866e2f762be11b14a9e7a94752614d4 ]

Set the Rx flow classification enable flag only if key config
operation is successful.

Fixes 3f9b5c9 ("dpaa2-eth: Configure Rx flow classification key")

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index dc339dc1adb21..57cbaa38d2477 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2796,6 +2796,7 @@ int dpaa2_eth_set_hash(struct net_device *net_dev, u64 flags)
 static int dpaa2_eth_set_cls(struct dpaa2_eth_priv *priv)
 {
 	struct device *dev = priv->net_dev->dev.parent;
+	int err;
 
 	/* Check if we actually support Rx flow classification */
 	if (dpaa2_eth_has_legacy_dist(priv)) {
@@ -2814,9 +2815,13 @@ static int dpaa2_eth_set_cls(struct dpaa2_eth_priv *priv)
 		return -EOPNOTSUPP;
 	}
 
+	err = dpaa2_eth_set_dist_key(priv->net_dev, DPAA2_ETH_RX_DIST_CLS, 0);
+	if (err)
+		return err;
+
 	priv->rx_cls_enabled = 1;
 
-	return dpaa2_eth_set_dist_key(priv->net_dev, DPAA2_ETH_RX_DIST_CLS, 0);
+	return 0;
 }
 
 /* Bind the DPNI to its needed objects and resources: buffer pool, DPIOs,
-- 
2.20.1



