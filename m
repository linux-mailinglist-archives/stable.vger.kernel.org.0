Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D55C6CC29B
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbjC1Oq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbjC1Oqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:46:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45074D53F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9F1661824
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF89C4339B;
        Tue, 28 Mar 2023 14:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014771;
        bh=7nH1SfMLsmFvzMYqWA0S09qNLB8YoPOu83zhScXOO3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yXqkrq6eYrAIrYoUFTqxyllbGPG6T5BUZEouHu0zCEq3S4ZkNKK2Q6WZ8JlwYszD
         HksLR28/MhyhrVapXCcq7XpRXu2GWiF512oTd/dfRxrRvkKYCRreDypR8GDD6Tpbj+
         70V6J71V4/Tf0XbJQ40X8fWbgsjfmUkGrf+11o+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 047/240] net: phy: Ensure state transitions are processed from phy_stop()
Date:   Tue, 28 Mar 2023 16:40:10 +0200
Message-Id: <20230328142621.660940473@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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
index e5b6cb1a77f95..a8bf3c752c8a2 100644
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
@@ -1094,6 +1106,7 @@ EXPORT_SYMBOL(phy_free_interrupt);
 void phy_stop(struct phy_device *phydev)
 {
 	struct net_device *dev = phydev->attached_dev;
+	enum phy_state old_state;
 
 	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
 		WARN(1, "called from state %s\n",
@@ -1102,6 +1115,7 @@ void phy_stop(struct phy_device *phydev)
 	}
 
 	mutex_lock(&phydev->lock);
+	old_state = phydev->state;
 
 	if (phydev->state == PHY_CABLETEST) {
 		phy_abort_cable_test(phydev);
@@ -1112,6 +1126,7 @@ void phy_stop(struct phy_device *phydev)
 		sfp_upstream_stop(phydev->sfp_bus);
 
 	phydev->state = PHY_HALTED;
+	phy_process_state_change(phydev, old_state);
 
 	mutex_unlock(&phydev->lock);
 
@@ -1229,13 +1244,7 @@ void phy_state_machine(struct work_struct *work)
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



