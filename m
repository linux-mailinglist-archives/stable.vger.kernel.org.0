Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298C16CC506
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjC1PLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjC1PLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57840EFB5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52AB6617F1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67644C433D2;
        Tue, 28 Mar 2023 15:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016095;
        bh=cLOIroqt9BcPPln3W/TQwTBXgfBEf+GG/pepPI16hmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=andwLvAfdaFjNO9lu254xklvQbFSCw+j3K2LKI1h5KLml6I5bNkLyh/B+GREZuguu
         3vF39OG+JMCTeTSkt5+FHFHfvD1OBpn0L9rVosoZ5EscPxKKn5rQRQR89+6yYGW01g
         0Z6lFGZIUj+IY4i+dqWSmPrvUOMnjoWpdKcFeEMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/146] net: phy: Ensure state transitions are processed from phy_stop()
Date:   Tue, 28 Mar 2023 16:42:02 +0200
Message-Id: <20230328142604.089684240@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 4203d84032e28f893594a453bd8bc9c3b15c7334 ]

In the phy_disconnect() -> phy_stop() path, we will be forcibly setting
the PHY state machine to PHY_HALTED. This invalidates the old_state !=
phydev->state condition in phy_state_machine() such that we will neither
display the state change for debugging, nor will we invoke the
link_change_notify() callback.

Factor the code by introducing phy_process_state_change(), and ensure
that we process the state change from phy_stop() as well.

Fixes: 5c5f626bcace ("net: phy: improve handling link_change_notify callback")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 2fc851082e7b4..1135e63a4a76e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -57,6 +57,18 @@ static const char *phy_state_to_str(enum phy_state st)
 	return NULL;
 }
 
+static void phy_process_state_change(struct phy_device *phydev,
+				     enum phy_state old_state)
+{
+	if (old_state != phydev->state) {
+		phydev_dbg(phydev, "PHY state change %s -> %s\n",
+			   phy_state_to_str(old_state),
+			   phy_state_to_str(phydev->state));
+		if (phydev->drv && phydev->drv->link_change_notify)
+			phydev->drv->link_change_notify(phydev);
+	}
+}
+
 static void phy_link_up(struct phy_device *phydev)
 {
 	phydev->phy_link_change(phydev, true);
@@ -1061,6 +1073,7 @@ EXPORT_SYMBOL(phy_free_interrupt);
 void phy_stop(struct phy_device *phydev)
 {
 	struct net_device *dev = phydev->attached_dev;
+	enum phy_state old_state;
 
 	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
 		WARN(1, "called from state %s\n",
@@ -1069,6 +1082,7 @@ void phy_stop(struct phy_device *phydev)
 	}
 
 	mutex_lock(&phydev->lock);
+	old_state = phydev->state;
 
 	if (phydev->state == PHY_CABLETEST) {
 		phy_abort_cable_test(phydev);
@@ -1079,6 +1093,7 @@ void phy_stop(struct phy_device *phydev)
 		sfp_upstream_stop(phydev->sfp_bus);
 
 	phydev->state = PHY_HALTED;
+	phy_process_state_change(phydev, old_state);
 
 	mutex_unlock(&phydev->lock);
 
@@ -1196,13 +1211,7 @@ void phy_state_machine(struct work_struct *work)
 	if (err < 0)
 		phy_error(phydev);
 
-	if (old_state != phydev->state) {
-		phydev_dbg(phydev, "PHY state change %s -> %s\n",
-			   phy_state_to_str(old_state),
-			   phy_state_to_str(phydev->state));
-		if (phydev->drv && phydev->drv->link_change_notify)
-			phydev->drv->link_change_notify(phydev);
-	}
+	phy_process_state_change(phydev, old_state);
 
 	/* Only re-schedule a PHY state machine change if we are polling the
 	 * PHY, if PHY_MAC_INTERRUPT is set, then we will be moving
-- 
2.39.2



