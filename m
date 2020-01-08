Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6750134BFB
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgAHTss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:48:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43626 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730441AbgAHTqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:03 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006pB-LS; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007do5-RL; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Bhadram Varka" <vbhadram@nvidia.com>,
        "Arnd Bergmann" <arnd@arndb.de>
Date:   Wed, 08 Jan 2020 19:43:43 +0000
Message-ID: <lsq.1578512578.478323157@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 45/63] stmmac: copy unicast mac address to MAC registers
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bhadram Varka <vbhadram@nvidia.com>

commit a830405ee452ddc4101c3c9334e6fedd42c6b357 upstream.

Currently stmmac driver not copying the valid ethernet
MAC address to MAC registers. This patch takes care
of updating the MAC register with MAC address.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
[bwh: Backported to 3.16:
 - Pass priv->ioaddr as first argument to set_umac_addr operation
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2388,6 +2388,20 @@ static int stmmac_ioctl(struct net_devic
 	return ret;
 }
 
+static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
+{
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int ret = 0;
+
+	ret = eth_mac_addr(ndev, addr);
+	if (ret)
+		return ret;
+
+	priv->hw->mac->set_umac_addr(priv->ioaddr, ndev->dev_addr, 0);
+
+	return ret;
+}
+
 #ifdef CONFIG_STMMAC_DEBUG_FS
 static struct dentry *stmmac_fs_dir;
 static struct dentry *stmmac_rings_status;
@@ -2587,7 +2601,7 @@ static const struct net_device_ops stmma
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = stmmac_poll_controller,
 #endif
-	.ndo_set_mac_address = eth_mac_addr,
+	.ndo_set_mac_address = stmmac_set_mac_address,
 };
 
 /**

