Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87031419C1C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbhI0RZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237515AbhI0RXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:23:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96CD56139E;
        Mon, 27 Sep 2021 17:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762887;
        bh=zmlKPEvCPy4VDKcUyOH5io7XNhDQByhPPa7mxy69/sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZM7AoKswApZ11SHhLsNmuHaB6BkJQcOYhTGSDKjyHW1qUIqkg3qqejx5qBlE5EHmy
         56p5ISnKrlVx9KDHlMzlAe1VRFjg66wzqj/XzU/7tR89omg08l4QRtyzvoMGrVK38O
         L2LCQ/vtUO+Zss9bjotQsGlYOp/G+WMauZeMRjYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 087/162] net: mscc: ocelot: fix forwarding from BLOCKING ports remaining enabled
Date:   Mon, 27 Sep 2021 19:02:13 +0200
Message-Id: <20210927170236.445780907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit acc64f52afac15e9e44d9b5253271346841786e0 ]

The blamed commit made the fatally incorrect assumption that ports which
aren't in the FORWARDING STP state should not have packets forwarded
towards them, and that is all that needs to be done.

However, that logic alone permits BLOCKING ports to forward to
FORWARDING ports, which of course allows packet storms to occur when
there is an L2 loop.

The ocelot_get_bridge_fwd_mask should not only ask "what can the bridge
do for you", but "what can you do for the bridge". This way, only
FORWARDING ports forward to the other FORWARDING ports from the same
bridging domain, and we are still compatible with the idea of multiple
bridges.

Fixes: df291e54ccca ("net: ocelot: support multiple bridges")
Suggested-by: Colin Foster <colin.foster@in-advantage.com>
Reported-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 2948d731a1c1..512dff955166 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1260,14 +1260,19 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
 	return mask;
 }
 
-static u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot,
+static u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port,
 				      struct net_device *bridge)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[src_port];
 	u32 mask = 0;
 	int port;
 
+	if (!ocelot_port || ocelot_port->bridge != bridge ||
+	    ocelot_port->stp_state != BR_STATE_FORWARDING)
+		return 0;
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		ocelot_port = ocelot->ports[port];
 
 		if (!ocelot_port)
 			continue;
@@ -1333,7 +1338,7 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			struct net_device *bridge = ocelot_port->bridge;
 			struct net_device *bond = ocelot_port->bond;
 
-			mask = ocelot_get_bridge_fwd_mask(ocelot, bridge);
+			mask = ocelot_get_bridge_fwd_mask(ocelot, port, bridge);
 			mask |= cpu_fwd_mask;
 			mask &= ~BIT(port);
 			if (bond) {
-- 
2.33.0



