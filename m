Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2BE604852
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiJSN4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbiJSNyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599F9193748;
        Wed, 19 Oct 2022 06:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A860BB82383;
        Wed, 19 Oct 2022 08:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20439C433C1;
        Wed, 19 Oct 2022 08:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169421;
        bh=AWBYzKuSRGASn1poCM4D5EdymKeSS6RHn7wjl5AtJDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt5WdrNqjN+qaJGSOYvEfhZzMi65mnHFefvBzGjcTqFGveecyRVOpHbKWJ/0yz+fX
         SeH/u03I3bKWtaR7AyXEFy2PWQvtm3wJGWymfYlVhT7+zH8Uer2Q1sVL3yYuaX/XU/
         PDon/pu1cMWXnq2SfEqYXvNJFBQC0v5Z5Lalw0ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 236/862] net: prestera: cache port state for non-phylink ports too
Date:   Wed, 19 Oct 2022 10:25:23 +0200
Message-Id: <20221019083300.474641938@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maksym Glubokiy <maksym.glubokiy@plvision.eu>

[ Upstream commit 704438dd4f030c1b3d28a2a9c8f182c32d9b6bc4 ]

Port event data must stored to port-state cache regardless of whether
the port uses phylink or not since this data is used by ethtool.

Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/prestera/prestera_main.c | 36 +++++++++----------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index a895862b4821..a0ad0bcbf89f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -799,32 +799,30 @@ static void prestera_port_handle_event(struct prestera_switch *sw,
 
 		caching_dw = &port->cached_hw_stats.caching_dw;
 
-		if (port->phy_link) {
-			memset(&smac, 0, sizeof(smac));
-			smac.valid = true;
-			smac.oper = pevt->data.mac.oper;
-			if (smac.oper) {
-				smac.mode = pevt->data.mac.mode;
-				smac.speed = pevt->data.mac.speed;
-				smac.duplex = pevt->data.mac.duplex;
-				smac.fc = pevt->data.mac.fc;
-				smac.fec = pevt->data.mac.fec;
-				phylink_mac_change(port->phy_link, true);
-			} else {
-				phylink_mac_change(port->phy_link, false);
-			}
-			prestera_port_mac_state_cache_write(port, &smac);
+		memset(&smac, 0, sizeof(smac));
+		smac.valid = true;
+		smac.oper = pevt->data.mac.oper;
+		if (smac.oper) {
+			smac.mode = pevt->data.mac.mode;
+			smac.speed = pevt->data.mac.speed;
+			smac.duplex = pevt->data.mac.duplex;
+			smac.fc = pevt->data.mac.fc;
+			smac.fec = pevt->data.mac.fec;
 		}
+		prestera_port_mac_state_cache_write(port, &smac);
 
 		if (port->state_mac.oper) {
-			if (!port->phy_link)
+			if (port->phy_link)
+				phylink_mac_change(port->phy_link, true);
+			else
 				netif_carrier_on(port->dev);
 
 			if (!delayed_work_pending(caching_dw))
 				queue_delayed_work(prestera_wq, caching_dw, 0);
-		} else if (netif_running(port->dev) &&
-			   netif_carrier_ok(port->dev)) {
-			if (!port->phy_link)
+		} else {
+			if (port->phy_link)
+				phylink_mac_change(port->phy_link, false);
+			else if (netif_running(port->dev) && netif_carrier_ok(port->dev))
 				netif_carrier_off(port->dev);
 
 			if (delayed_work_pending(caching_dw))
-- 
2.35.1



