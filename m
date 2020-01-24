Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720EB148490
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388537AbgAXLML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:12:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389956AbgAXLMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:12:09 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38B2120708;
        Fri, 24 Jan 2020 11:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864328;
        bh=oKv8ZiAGJ4jNdEZvOnXSULZyM/gX5lc8fT5d2nEbLHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVzi6AqEwrTzJZm2HDfhEGGxRI+DPtBTp0/vM5DTFqj4B7CVwQ2v5RkSeA93PkPBb
         V+49vpddjvyzoVd694BqZ3mIRoxnDwxSZB7UF0IMVIQ8Eb2rjV3t8rdl7pkp6yKHwi
         cQ+juTq2G7FmsDQCB5U96Pb5MIwpm0M6rxpQl2ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 223/639] net: dsa: fix unintended change of bridge interface STP state
Date:   Fri, 24 Jan 2020 10:26:33 +0100
Message-Id: <20200124093114.848751898@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 9c2054a5cf415a9dc32c91ffde78399955deb571 ]

When a DSA port is added to a bridge and brought up, the resulting STP
state programmed into the hardware depends on the order that these
operations are performed.  However, the Linux bridge code believes that
the port is in disabled mode.

If the DSA port is first added to a bridge and then brought up, it will
be in blocking mode.  If it is brought up and then added to the bridge,
it will be in disabled mode.

This difference is caused by DSA always setting the STP mode in
dsa_port_enable() whether or not this port is part of a bridge.  Since
bridge always sets the STP state when the port is added, brought up or
taken down, it is unnecessary for us to manipulate the STP state.

Apparently, this code was copied from Rocker, and the very next day a
similar fix for Rocker was merged but was not propagated to DSA.  See
e47172ab7e41 ("rocker: put port in FORWADING state after leaving bridge")

Fixes: b73adef67765 ("net: dsa: integrate with SWITCHDEV for HW bridging")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/port.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index ed0595459df13..ea7efc86b9d7c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -69,7 +69,6 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state)
 
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
 {
-	u8 stp_state = dp->bridge_dev ? BR_STATE_BLOCKING : BR_STATE_FORWARDING;
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 	int err;
@@ -80,7 +79,8 @@ int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
 			return err;
 	}
 
-	dsa_port_set_state_now(dp, stp_state);
+	if (!dp->bridge_dev)
+		dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 
 	return 0;
 }
@@ -90,7 +90,8 @@ void dsa_port_disable(struct dsa_port *dp, struct phy_device *phy)
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 
-	dsa_port_set_state_now(dp, BR_STATE_DISABLED);
+	if (!dp->bridge_dev)
+		dsa_port_set_state_now(dp, BR_STATE_DISABLED);
 
 	if (ds->ops->port_disable)
 		ds->ops->port_disable(ds, port, phy);
-- 
2.20.1



