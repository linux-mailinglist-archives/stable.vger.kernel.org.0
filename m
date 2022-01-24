Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF3F4995BA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359432AbiAXUya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:54:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49382 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441794AbiAXUvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:51:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 529FAB811A9;
        Mon, 24 Jan 2022 20:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E13EC340E5;
        Mon, 24 Jan 2022 20:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057498;
        bh=uyerVO+UteF3ZIZcetYXxzLHy9BxVQRYWe9gb8chIxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odWbh/BvnBsJiErCThK6d6v/d9dnpd1p4JMgPqfZ8pYCnlF4+JdoCAv5Vwdgaw6rn
         ca7/Nt9oPtLeBJmAW53lTxTsQvc6L2zmagw4a0IzH7LgJecyICCmnzXaPqsw+2PosQ
         18O0N3ffcqv/MdgGZWFKnj3cPOBdFGvgxfhyc4HQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 833/846] net: ocelot: Fix the call to switchdev_bridge_port_offload
Date:   Mon, 24 Jan 2022 19:45:50 +0100
Message-Id: <20220124184129.650789861@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

commit c0b7f7d7e0ad44f35745c01964b3fa2833e298cb upstream.

In the blamed commit, the call to the function
switchdev_bridge_port_offload was passing the wrong argument for
atomic_nb. It was ocelot_netdevice_nb instead of ocelot_swtchdev_nb.
This patch fixes this issue.

Fixes: 4e51bf44a03af6 ("net: bridge: move the switchdev object replay helpers to "push" mode")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1168,7 +1168,7 @@ static int ocelot_netdevice_bridge_join(
 	ocelot_port_bridge_join(ocelot, port, bridge);
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, priv,
-					    &ocelot_netdevice_nb,
+					    &ocelot_switchdev_nb,
 					    &ocelot_switchdev_blocking_nb,
 					    false, extack);
 	if (err)
@@ -1182,7 +1182,7 @@ static int ocelot_netdevice_bridge_join(
 
 err_switchdev_sync:
 	switchdev_bridge_port_unoffload(brport_dev, priv,
-					&ocelot_netdevice_nb,
+					&ocelot_switchdev_nb,
 					&ocelot_switchdev_blocking_nb);
 err_switchdev_offload:
 	ocelot_port_bridge_leave(ocelot, port, bridge);
@@ -1195,7 +1195,7 @@ static void ocelot_netdevice_pre_bridge_
 	struct ocelot_port_private *priv = netdev_priv(dev);
 
 	switchdev_bridge_port_unoffload(brport_dev, priv,
-					&ocelot_netdevice_nb,
+					&ocelot_switchdev_nb,
 					&ocelot_switchdev_blocking_nb);
 }
 


