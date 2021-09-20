Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C0741245C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346614AbhITSeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348410AbhITSa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB966142A;
        Mon, 20 Sep 2021 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158839;
        bh=yiG7g5vz8qMijZz7pcpW/M3mzvkR6hIj0Ee5agDPfB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvicEzjk4yodW9y8IFgKWBgdcqL7oHw5SYkzXhVQbTVjf+O7cuQgUONKMhBmLSYmt
         s4KP0d4Y/tDluh63BLoplrFeuJ2DP+6PJjmcJFOycP8qODVkEIq3KOJJsnvVmc9fFv
         BCumXpwJ1weKGPcydFX8Q3c0VEtJliv6gnJPkG0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/122] net: phylink: add suspend/resume support
Date:   Mon, 20 Sep 2021 18:44:11 +0200
Message-Id: <20210920163918.373775935@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit f97493657c6372eeefe70faadd214bf31488c44e ]

Joakim Zhang reports that Wake-on-Lan with the stmmac ethernet driver broke
when moving the incorrect handling of mac link state out of mac_config().
This reason this breaks is because the stmmac's WoL is handled by the MAC
rather than the PHY, and phylink doesn't cater for that scenario.

This patch adds the necessary phylink code to handle suspend/resume events
according to whether the MAC still needs a valid link or not. This is the
barest minimum for this support.

Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 82 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 ++
 2 files changed, 85 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6072e87ed6c3..42826ce0e0bf 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -32,6 +32,7 @@
 enum {
 	PHYLINK_DISABLE_STOPPED,
 	PHYLINK_DISABLE_LINK,
+	PHYLINK_DISABLE_MAC_WOL,
 };
 
 /**
@@ -1251,6 +1252,9 @@ EXPORT_SYMBOL_GPL(phylink_start);
  * network device driver's &struct net_device_ops ndo_stop() method.  The
  * network device's carrier state should not be changed prior to calling this
  * function.
+ *
+ * This will synchronously bring down the link if the link is not already
+ * down (in other words, it will trigger a mac_link_down() method call.)
  */
 void phylink_stop(struct phylink *pl)
 {
@@ -1270,6 +1274,84 @@ void phylink_stop(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_stop);
 
+/**
+ * phylink_suspend() - handle a network device suspend event
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @mac_wol: true if the MAC needs to receive packets for Wake-on-Lan
+ *
+ * Handle a network device suspend event. There are several cases:
+ * - If Wake-on-Lan is not active, we can bring down the link between
+ *   the MAC and PHY by calling phylink_stop().
+ * - If Wake-on-Lan is active, and being handled only by the PHY, we
+ *   can also bring down the link between the MAC and PHY.
+ * - If Wake-on-Lan is active, but being handled by the MAC, the MAC
+ *   still needs to receive packets, so we can not bring the link down.
+ */
+void phylink_suspend(struct phylink *pl, bool mac_wol)
+{
+	ASSERT_RTNL();
+
+	if (mac_wol && (!pl->netdev || pl->netdev->wol_enabled)) {
+		/* Wake-on-Lan enabled, MAC handling */
+		mutex_lock(&pl->state_mutex);
+
+		/* Stop the resolver bringing the link up */
+		__set_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state);
+
+		/* Disable the carrier, to prevent transmit timeouts,
+		 * but one would hope all packets have been sent. This
+		 * also means phylink_resolve() will do nothing.
+		 */
+		netif_carrier_off(pl->netdev);
+
+		/* We do not call mac_link_down() here as we want the
+		 * link to remain up to receive the WoL packets.
+		 */
+		mutex_unlock(&pl->state_mutex);
+	} else {
+		phylink_stop(pl);
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_suspend);
+
+/**
+ * phylink_resume() - handle a network device resume event
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Undo the effects of phylink_suspend(), returning the link to an
+ * operational state.
+ */
+void phylink_resume(struct phylink *pl)
+{
+	ASSERT_RTNL();
+
+	if (test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)) {
+		/* Wake-on-Lan enabled, MAC handling */
+
+		/* Call mac_link_down() so we keep the overall state balanced.
+		 * Do this under the state_mutex lock for consistency. This
+		 * will cause a "Link Down" message to be printed during
+		 * resume, which is harmless - the true link state will be
+		 * printed when we run a resolve.
+		 */
+		mutex_lock(&pl->state_mutex);
+		phylink_link_down(pl);
+		mutex_unlock(&pl->state_mutex);
+
+		/* Re-apply the link parameters so that all the settings get
+		 * restored to the MAC.
+		 */
+		phylink_mac_initial_config(pl, true);
+
+		/* Re-enable and re-resolve the link parameters */
+		clear_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state);
+		phylink_run_resolve(pl);
+	} else {
+		phylink_start(pl);
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_resume);
+
 /**
  * phylink_ethtool_get_wol() - get the wake on lan parameters for the PHY
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index d81a714cfbbd..ff56e3e373f0 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -446,6 +446,9 @@ void phylink_mac_change(struct phylink *, bool up);
 void phylink_start(struct phylink *);
 void phylink_stop(struct phylink *);
 
+void phylink_suspend(struct phylink *pl, bool mac_wol);
+void phylink_resume(struct phylink *pl);
+
 void phylink_ethtool_get_wol(struct phylink *, struct ethtool_wolinfo *);
 int phylink_ethtool_set_wol(struct phylink *, struct ethtool_wolinfo *);
 
-- 
2.30.2



