Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF20C499BC6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456746AbiAXVzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:55:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52876 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573671AbiAXVpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:45:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2694CB80FA1;
        Mon, 24 Jan 2022 21:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244AEC340E5;
        Mon, 24 Jan 2022 21:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060733;
        bh=uyerVO+UteF3ZIZcetYXxzLHy9BxVQRYWe9gb8chIxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYaJF6mKTujXVkF00S0VJt32QmhX0oQpnf52i8xK1cfEnx0bwPr8Ezje61NchESpw
         FHyJx19L4WjTqScOPO41cXLy4NAyNP89/TVpTyStMibGUBcJn9HXGl158Bhp+002Y5
         LPsr4ETpT8wYT1rj5eCloJCZCuKjh28dHFjIk4Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 1017/1039] net: ocelot: Fix the call to switchdev_bridge_port_offload
Date:   Mon, 24 Jan 2022 19:46:46 +0100
Message-Id: <20220124184159.481452009@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
 


