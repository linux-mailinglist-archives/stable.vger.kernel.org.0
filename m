Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A909134C9EB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhC2IeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234603AbhC2IdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72BEA619AE;
        Mon, 29 Mar 2021 08:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006742;
        bh=SopsyA0vO07sbLLPBW87Kh0w+yJ5r24GHvSWAtZLiQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPvlqq2UUL2DZU/H6Ad16N4Z9p4Kiwh8VE4udMlK3yhfSKGNKZZJZR2Vb+ugttVho
         vk95xDJf53db9KtbFIA1Sc54rhCrqTre/ztWswALzkhiWz8XZ8G+3SG6lbPf/SMEZP
         EqpV70WvJHmzgJOUFGtutT7BMfWJEf4wiZYrWAkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mian Yousaf Kaukab <ykaukab@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 075/254] netsec: restore phy power state after controller reset
Date:   Mon, 29 Mar 2021 09:56:31 +0200
Message-Id: <20210329075635.614673361@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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
@@ -1718,14 +1718,17 @@ static int netsec_netdev_init(struct net
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
 


