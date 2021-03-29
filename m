Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D1F34C846
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhC2IVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232230AbhC2IUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94F0261974;
        Mon, 29 Mar 2021 08:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006030;
        bh=EOcZtP1C9tkTuNpv/wXJe1TtdV70nAmD3KSU5vRAPBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nX6cjCa1BAvktToZODB6gturfrrIkLwG/igB+2d0j0l1pa5SZ5RGnvpiwnOWi0cJf
         WUi0F3cXJafwWAjJA1mh+Vyno2VF366+DafWXpvOR15SxtE8vypsydYCAEzzAt4WTA
         mTaNirenzsR/wC4m+Ey+/c08LGe4FNYtrNDcKQJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mian Yousaf Kaukab <ykaukab@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 065/221] netsec: restore phy power state after controller reset
Date:   Mon, 29 Mar 2021 09:56:36 +0200
Message-Id: <20210329075631.356378032@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>

commit 804741ac7b9f2fdebe3740cb0579cb8d94d49e60 upstream.

Since commit 8e850f25b581 ("net: socionext: Stop PHY before resetting
netsec") netsec_netdev_init() power downs phy before resetting the
controller. However, the state is not restored once the reset is
complete. As a result it is not possible to bring up network on a
platform with Broadcom BCM5482 phy.

Fix the issue by restoring phy power state after controller reset is
complete.

Fixes: 8e850f25b581 ("net: socionext: Stop PHY before resetting netsec")
Cc: stable@vger.kernel.org
Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/socionext/netsec.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1708,14 +1708,17 @@ static int netsec_netdev_init(struct net
 		goto err1;
 
 	/* set phy power down */
-	data = netsec_phy_read(priv->mii_bus, priv->phy_addr, MII_BMCR) |
-		BMCR_PDOWN;
-	netsec_phy_write(priv->mii_bus, priv->phy_addr, MII_BMCR, data);
+	data = netsec_phy_read(priv->mii_bus, priv->phy_addr, MII_BMCR);
+	netsec_phy_write(priv->mii_bus, priv->phy_addr, MII_BMCR,
+			 data | BMCR_PDOWN);
 
 	ret = netsec_reset_hardware(priv, true);
 	if (ret)
 		goto err2;
 
+	/* Restore phy power state */
+	netsec_phy_write(priv->mii_bus, priv->phy_addr, MII_BMCR, data);
+
 	spin_lock_init(&priv->desc_ring[NETSEC_RING_TX].lock);
 	spin_lock_init(&priv->desc_ring[NETSEC_RING_RX].lock);
 


