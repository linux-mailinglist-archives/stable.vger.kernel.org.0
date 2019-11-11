Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358F7F7E5C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfKKSqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:46:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727813AbfKKSqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:46:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E93DB204FD;
        Mon, 11 Nov 2019 18:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497963;
        bh=Qm4CgikDf/ByDHWDdREon3KcTscBsvq7y+65VqmgNiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLQU/Ot9PZhrjl0petjwXk8o2yE6kJVU69op0d9cxs1zDW7xoOAvBcsNl5Sxph80p
         dNPfDHTH0Nycnbhqaf0BXg7dkNs+07apcpqteyyN8RJMQb1BuawjCeG5NULS6COzaC
         Vy9+FhcINHrMHh8sVevf/y43ZwTqgKmPP1h8Aw1Y=
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
Subject: [PATCH 4.19 108/125] net: mscc: ocelot: refuse to overwrite the ports native vlan
Date:   Mon, 11 Nov 2019 19:29:07 +0100
Message-Id: <20191111181454.341251788@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
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
index 965f13944c76b..a29a6a618110e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -253,8 +253,15 @@ static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
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



