Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48672461F3F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380015AbhK2SpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46230 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380143AbhK2SnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:43:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54772B815CE;
        Mon, 29 Nov 2021 18:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D4EC53FCF;
        Mon, 29 Nov 2021 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211188;
        bh=BKMeYVGzAWH8jpVuimxSKjXR5VW5NbBF3u0fnSQ+lG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16odk7zG2Vg+gSoCAJ4v7BkWQgAHTqSmrxFnf6aWMyYBd+Ud4pRcZ4qNEQF2MvzGn
         ArslYjj57dyGleRS2oXWvx1/r7kmEkK7d79ridcFe9TUrdO3P+iKSP6Ja7RimkGew1
         bJlmqIP9dFuHoDtFgiLh0EAHTfmsiuHX5fBWWKbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/179] net: phylink: Force link down and retrigger resolve on interface change
Date:   Mon, 29 Nov 2021 19:18:49 +0100
Message-Id: <20211129181723.392573180@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 80662f4fd4771bc9c7cc4abdfbe866ebd1179621 ]

On PHY state change the phylink_resolve() function can read stale
information from the MAC and report incorrect link speed and duplex to
the kernel message log.

Example with a Marvell 88X3310 PHY connected to a SerDes port on Marvell
88E6393X switch:
- PHY driver triggers state change due to PHY interface mode being
  changed from 10gbase-r to 2500base-x due to copper change in speed
  from 10Gbps to 2.5Gbps, but the PHY itself either hasn't yet changed
  its interface to the host, or the interrupt about loss of SerDes link
  hadn't arrived yet (there can be a delay of several milliseconds for
  this), so we still think that the 10gbase-r mode is up
- phylink_resolve()
  - phylink_mac_pcs_get_state()
    - this fills in speed=10g link=up
  - interface mode is updated to 2500base-x but speed is left at 10Gbps
  - phylink_major_config()
    - interface is changed to 2500base-x
  - phylink_link_up()
    - mv88e6xxx_mac_link_up()
      - .port_set_speed_duplex()
        - speed is set to 10Gbps
    - reports "Link is Up - 10Gbps/Full" to dmesg

Afterwards when the interrupt finally arrives for mv88e6xxx, another
resolve is forced in which we get the correct speed from
phylink_mac_pcs_get_state(), but since the interface is not being
changed anymore, we don't call phylink_major_config() but only
phylink_mac_config(), which does not set speed/duplex anymore.

To fix this, we need to force the link down and trigger another resolve
on PHY interface change event.

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7ec3105010ac1..59ee87df5746e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -657,6 +657,7 @@ static void phylink_resolve(struct work_struct *w)
 	struct phylink_link_state link_state;
 	struct net_device *ndev = pl->netdev;
 	bool mac_config = false;
+	bool retrigger = false;
 	bool cur_link_state;
 
 	mutex_lock(&pl->state_mutex);
@@ -670,6 +671,7 @@ static void phylink_resolve(struct work_struct *w)
 		link_state.link = false;
 	} else if (pl->mac_link_dropped) {
 		link_state.link = false;
+		retrigger = true;
 	} else {
 		switch (pl->cur_link_an_mode) {
 		case MLO_AN_PHY:
@@ -694,6 +696,15 @@ static void phylink_resolve(struct work_struct *w)
 
 			/* Only update if the PHY link is up */
 			if (pl->phydev && pl->phy_state.link) {
+				/* If the interface has changed, force a
+				 * link down event if the link isn't already
+				 * down, and re-resolve.
+				 */
+				if (link_state.interface !=
+				    pl->phy_state.interface) {
+					retrigger = true;
+					link_state.link = false;
+				}
 				link_state.interface = pl->phy_state.interface;
 
 				/* If we have a PHY, we need to update with
@@ -736,7 +747,7 @@ static void phylink_resolve(struct work_struct *w)
 		else
 			phylink_link_up(pl, link_state);
 	}
-	if (!link_state.link && pl->mac_link_dropped) {
+	if (!link_state.link && retrigger) {
 		pl->mac_link_dropped = false;
 		queue_work(system_power_efficient_wq, &pl->resolve);
 	}
-- 
2.33.0



