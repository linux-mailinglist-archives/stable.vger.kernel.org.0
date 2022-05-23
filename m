Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFC653199A
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240617AbiEWRjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbiEWRej (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:34:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849187CB06;
        Mon, 23 May 2022 10:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2FEF60AB8;
        Mon, 23 May 2022 17:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2971C385A9;
        Mon, 23 May 2022 17:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326896;
        bh=vos7HQtzitOQyk2ED8TgNzrVfaTcR+2ug2+cBt23yW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1QNtneMjl3GoC7LPXFX+R3xUjCM8O7a2e8rHy9qPWy2feike4FyQJHAYayjrJMum
         /Uj1kEBxk52lG6oase4NP7iRyz665l97E8MXWZ483/gE9J+jyYEKhwTUoE1HSDclFQ
         ztMKU3VSG6cMlce12ofiaQSCpjpNZVGGIdBVaboc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 091/158] net: lan966x: Fix assignment of the MAC address
Date:   Mon, 23 May 2022 19:04:08 +0200
Message-Id: <20220523165846.254861069@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit af8ca6eaa9b24a90484218e356f959a94bff22fa ]

The following two scenarios were failing for lan966x.
1. If the port had the address X and then trying to assign the same
   address, then the HW was just removing this address because first it
   tries to learn new address and then delete the old one. As they are
   the same the HW remove it.
2. If the port eth0 was assigned the same address as one of the other
   ports eth1 then when assigning back the address to eth0 then the HW
   was deleting the address of eth1.

The case 1. is fixed by checking if the port has already the same
address while case 2. is fixed by checking if the address is used by any
other port.

Fixes: e18aba8941b40b ("net: lan966x: add mactable support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20220513180030.3076793-1-horatiu.vultur@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_main.c | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1f60fd125a1d..fee148bbf13e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -100,6 +100,24 @@ static int lan966x_create_targets(struct platform_device *pdev,
 	return 0;
 }
 
+static bool lan966x_port_unique_address(struct net_device *dev)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	int p;
+
+	for (p = 0; p < lan966x->num_phys_ports; ++p) {
+		port = lan966x->ports[p];
+		if (!port || port->dev == dev)
+			continue;
+
+		if (ether_addr_equal(dev->dev_addr, port->dev->dev_addr))
+			return false;
+	}
+
+	return true;
+}
+
 static int lan966x_port_set_mac_address(struct net_device *dev, void *p)
 {
 	struct lan966x_port *port = netdev_priv(dev);
@@ -107,16 +125,26 @@ static int lan966x_port_set_mac_address(struct net_device *dev, void *p)
 	const struct sockaddr *addr = p;
 	int ret;
 
+	if (ether_addr_equal(addr->sa_data, dev->dev_addr))
+		return 0;
+
 	/* Learn the new net device MAC address in the mac table. */
 	ret = lan966x_mac_cpu_learn(lan966x, addr->sa_data, HOST_PVID);
 	if (ret)
 		return ret;
 
+	/* If there is another port with the same address as the dev, then don't
+	 * delete it from the MAC table
+	 */
+	if (!lan966x_port_unique_address(dev))
+		goto out;
+
 	/* Then forget the previous one. */
 	ret = lan966x_mac_cpu_forget(lan966x, dev->dev_addr, HOST_PVID);
 	if (ret)
 		return ret;
 
+out:
 	eth_hw_addr_set(dev, addr->sa_data);
 	return ret;
 }
-- 
2.35.1



