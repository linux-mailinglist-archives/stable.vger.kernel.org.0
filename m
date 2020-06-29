Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CE620D14C
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgF2SkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgF2SkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CF4924060;
        Mon, 29 Jun 2020 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443932;
        bh=iVLEtNuN/GMh+pcLYfri49Eh+Ax/UHlczwS5d0b59wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTXXBjI0Jt+07DFJNG2h/Yj3ODq0FdyULTQTMkEcYle50UpdKCQ2FrUgRIzKdjRj8
         UMklR9n1sQGt+qSRTu0P8AwGByfhE0W3xK73AcxdiwZPOxzxMbd/DeBta/O1AZ7GH8
         OvpS6TlYeA4JHOEqTqTjZtKkih1RAUalCS0XK/Ig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 033/265] net: phylink: ensure manual pause mode configuration takes effect
Date:   Mon, 29 Jun 2020 11:14:26 -0400
Message-Id: <20200629151818.2493727-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 2e919bc446faee429ac862a6cdb5e40017051f6b ]

We have been relying on link events and mac_config() when the manual
pause modes are changed.  With recent developments, such as moving
the programming of link state to mac_link_up(), this no longer works.

To ensure that we update the MAC, we must generate a link-down followed
by a link-up event; we can do that by setting mac_link_dropped and
triggering a resolve.

Fixes: 91a208f2185a ("net: phylink: propagate resolved link config via mac_link_up()")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phylink.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b0ddeab2a8d2f..ac38bead1cd25 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1480,6 +1480,8 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 				   struct ethtool_pauseparam *pause)
 {
 	struct phylink_link_state *config = &pl->link_config;
+	bool manual_changed;
+	int pause_state;
 
 	ASSERT_RTNL();
 
@@ -1494,15 +1496,15 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	    !pause->autoneg && pause->rx_pause != pause->tx_pause)
 		return -EINVAL;
 
-	mutex_lock(&pl->state_mutex);
-	config->pause = 0;
+	pause_state = 0;
 	if (pause->autoneg)
-		config->pause |= MLO_PAUSE_AN;
+		pause_state |= MLO_PAUSE_AN;
 	if (pause->rx_pause)
-		config->pause |= MLO_PAUSE_RX;
+		pause_state |= MLO_PAUSE_RX;
 	if (pause->tx_pause)
-		config->pause |= MLO_PAUSE_TX;
+		pause_state |= MLO_PAUSE_TX;
 
+	mutex_lock(&pl->state_mutex);
 	/*
 	 * See the comments for linkmode_set_pause(), wrt the deficiencies
 	 * with the current implementation.  A solution to this issue would
@@ -1519,6 +1521,12 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	linkmode_set_pause(config->advertising, pause->tx_pause,
 			   pause->rx_pause);
 
+	manual_changed = (config->pause ^ pause_state) & MLO_PAUSE_AN ||
+			 (!(pause_state & MLO_PAUSE_AN) &&
+			   (config->pause ^ pause_state) & MLO_PAUSE_TXRX_MASK);
+
+	config->pause = pause_state;
+
 	if (!pl->phydev && !test_bit(PHYLINK_DISABLE_STOPPED,
 				     &pl->phylink_disable_state))
 		phylink_pcs_config(pl, true, &pl->link_config);
@@ -1534,6 +1542,15 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 		phy_set_asym_pause(pl->phydev, pause->rx_pause,
 				   pause->tx_pause);
 
+	/* If the manual pause settings changed, make sure we trigger a
+	 * resolve to update their state; we can not guarantee that the
+	 * link will cycle.
+	 */
+	if (manual_changed) {
+		pl->mac_link_dropped = true;
+		phylink_run_resolve(pl);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(phylink_ethtool_set_pauseparam);
-- 
2.25.1

