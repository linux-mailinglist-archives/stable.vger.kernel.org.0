Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFE72F14EC
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbhAKNcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732240AbhAKNPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B08682251F;
        Mon, 11 Jan 2021 13:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370876;
        bh=z4VlwkKKjCoKIoE1XyZL+SK3mpdynt4nY+gOETPlr6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfMyRNBI+C39gYDkUeb84ZHflUApUBU4EnhQhpbDk6gB6i64rnjDsemzIpQ/z0qoF
         e68FMULcImveELtBlReusEgHU2TOypc3WXaV3axLHdVtd2281/lf2pXkKsGhb2VOKh
         5hBqOxgxFZeMidGwSCmd+qMBY9gg4yq3O9Qi6mfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 043/145] net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also for internal PHYs
Date:   Mon, 11 Jan 2021 14:01:07 +0100
Message-Id: <20210111130050.591402411@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit c1a9ec7e5d577a9391660800c806c53287fca991 ]

Enable GSWIP_MII_CFG_EN also for internal PHYs to make traffic flow.
Without this the PHY link is detected properly and ethtool statistics
for TX are increasing but there's no RX traffic coming in.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Suggested-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lantiq_gswip.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1541,9 +1541,7 @@ static void gswip_phylink_mac_link_up(st
 {
 	struct gswip_priv *priv = ds->priv;
 
-	/* Enable the xMII interface only for the external PHY */
-	if (interface != PHY_INTERFACE_MODE_INTERNAL)
-		gswip_mii_mask_cfg(priv, 0, GSWIP_MII_CFG_EN, port);
+	gswip_mii_mask_cfg(priv, 0, GSWIP_MII_CFG_EN, port);
 }
 
 static void gswip_get_strings(struct dsa_switch *ds, int port, u32 stringset,


