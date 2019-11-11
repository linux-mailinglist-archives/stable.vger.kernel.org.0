Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC49CF7D64
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfKKS4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:56:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730701AbfKKS4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:56:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 379E32173B;
        Mon, 11 Nov 2019 18:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498578;
        bh=6GKlE5c1X7Fx/I6EQaAYcQY55nqx95iZiiBVJ7+o18o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sG8IYItIOp6ji3ILSwvtBVuArFHUAcHZb6vN7KWpyKpWlCcFHLNFn9olFDwz48991
         BMDdWnOSNTACCaSKv+4voJub03T//D0zbvdTlfD2IO9jzDV8LCXS/h/0RCk7Q/9hOC
         N9/WdGChTUsh4BkhoPlHO0QiKshsnWVoHRFYqiCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 161/193] net: mscc: ocelot: refuse to overwrite the ports native vlan
Date:   Mon, 11 Nov 2019 19:29:03 +0100
Message-Id: <20191111181513.003301670@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit b9cd75e6689560140dadaed98eb4b41aad75d55d ]

The switch driver keeps a "vid" variable per port, which signifies _the_
VLAN ID that is stripped on that port's egress (aka the native VLAN on a
trunk port).

That is the way the hardware is designed (mostly). The port->vid is
programmed into REW:PORT:PORT_VLAN_CFG:PORT_VID and the rewriter is told
to send all traffic as tagged except the one having port->vid.

There exists a possibility of finer-grained egress untagging decisions:
using the VCAP IS1 engine, one rule can be added to match every
VLAN-tagged frame whose VLAN should be untagged, and set POP_CNT=1 as
action. However, the IS1 can hold at most 512 entries, and the VLANs are
in the order of 6 * 4096.

So the code is fine for now. But this sequence of commands:

$ bridge vlan add dev swp0 vid 1 pvid untagged
$ bridge vlan add dev swp0 vid 2 untagged

makes untagged and pvid-tagged traffic be sent out of swp0 as tagged
with VID 1, despite user's request.

Prevent that from happening. The user should temporarily remove the
existing untagged VLAN (1 in this case), add it back as tagged, and then
add the new untagged VLAN (2 in this case).

Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Fixes: 7142529f1688 ("net: mscc: ocelot: add VLAN filtering")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 07ca3e0cdf92b..7ffe5959a7e73 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -260,8 +260,15 @@ static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 		port->pvid = vid;
 
 	/* Untagged egress vlan clasification */
-	if (untagged)
+	if (untagged && port->vid != vid) {
+		if (port->vid) {
+			dev_err(ocelot->dev,
+				"Port already has a native VLAN: %d\n",
+				port->vid);
+			return -EBUSY;
+		}
 		port->vid = vid;
+	}
 
 	ocelot_vlan_port_apply(ocelot, port);
 
-- 
2.20.1



