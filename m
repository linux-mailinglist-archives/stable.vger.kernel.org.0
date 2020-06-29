Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4046A20E50C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgF2Vbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728724AbgF2SlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9F062405E;
        Mon, 29 Jun 2020 15:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443931;
        bh=xD1BMjfAN1scEy6upLBMty2kJ9YUg0f0fS4LilD7uLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5TcluXn+A1BXRRWL//bZ28k3f/iXvKWWjiRMnzzSAoStaANqm6ZY6FKdZxZwwf2G
         aRwBSFWfa2iexsD15h4rgMj5XBEW/PgYts2zj4V1K+rdFfo+EBwUCMHqZCX4vlC1ZV
         v8KwV59g3r7ah/z9QtPUjftE6DYhs8KNCQIdNqDw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 032/265] net: phylink: fix ethtool -A with attached PHYs
Date:   Mon, 29 Jun 2020 11:14:25 -0400
Message-Id: <20200629151818.2493727-33-sashal@kernel.org>
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

[ Upstream commit c718af2d00a37587b09e5958d142da7569f3d55b ]

Fix a phylink's ethtool set_pauseparam support deadlock caused by phylib
interacting with phylink: we must not hold the state lock while calling
phylib functions that may call into phylink_phy_change().

Fixes: f904f15ea9b5 ("net: phylink: allow ethtool -A to change flow control advertisement")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phylink.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 34ca12aec61b3..b0ddeab2a8d2f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1519,18 +1519,20 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	linkmode_set_pause(config->advertising, pause->tx_pause,
 			   pause->rx_pause);
 
-	/* If we have a PHY, phylib will call our link state function if the
-	 * mode has changed, which will trigger a resolve and update the MAC
-	 * configuration.
+	if (!pl->phydev && !test_bit(PHYLINK_DISABLE_STOPPED,
+				     &pl->phylink_disable_state))
+		phylink_pcs_config(pl, true, &pl->link_config);
+
+	mutex_unlock(&pl->state_mutex);
+
+	/* If we have a PHY, a change of the pause frame advertisement will
+	 * cause phylib to renegotiate (if AN is enabled) which will in turn
+	 * call our phylink_phy_change() and trigger a resolve.  Note that
+	 * we can't hold our state mutex while calling phy_set_asym_pause().
 	 */
-	if (pl->phydev) {
+	if (pl->phydev)
 		phy_set_asym_pause(pl->phydev, pause->rx_pause,
 				   pause->tx_pause);
-	} else if (!test_bit(PHYLINK_DISABLE_STOPPED,
-			     &pl->phylink_disable_state)) {
-		phylink_pcs_config(pl, true, &pl->link_config);
-	}
-	mutex_unlock(&pl->state_mutex);
 
 	return 0;
 }
-- 
2.25.1

