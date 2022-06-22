Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479D455554A
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 22:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiFVURN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 16:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFVURM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 16:17:12 -0400
Received: from mail.mutex.one (mail.mutex.one [62.77.152.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A583234B99;
        Wed, 22 Jun 2022 13:17:11 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.mutex.one (Postfix) with ESMTP id 9290416C007C;
        Wed, 22 Jun 2022 23:17:09 +0300 (EEST)
X-Virus-Scanned: Debian amavisd-new at mail.mutex.one
Received: from mail.mutex.one ([127.0.0.1])
        by localhost (mail.mutex.one [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tJAFoSIpfZdJ; Wed, 22 Jun 2022 23:17:09 +0300 (EEST)
From:   Marian Postevca <posteuca@mutex.one>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mutex.one; s=default;
        t=1655929029; bh=F39pPOCk5LJbjzxOxaPcJXDJYJADDBnzr5DdpvKy0h0=;
        h=From:To:Cc:Subject:Date:From;
        b=eY/3xvXNSThv9jdP4DWrn83uYiVtakefrX5lm8kB38D1nbA+Dw1HGniJq+VSinl40
         1rwkiuzoF5md6t6gchvw0YfdURAl8E5qtev7+ZA0q4i+/aWnLH+E836W+oHIFB2jA5
         8MBDM+gr3t/HK76PbwE+5e8K8FKxQIe+TccBYwTg=
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marian Postevca <posteuca@mutex.one>,
        Maximilian Senftleben <kernel@mail.msdigital.de>,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.10] usb: gadget: u_ether: fix regression in setting fixed MAC address
Date:   Wed, 22 Jun 2022 23:16:38 +0300
Message-Id: <20220622201638.1512-1-posteuca@mutex.one>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b337af3a4d6147000b7ca6b3438bf5c820849b37 upstream.

In systemd systems setting a fixed MAC address through
the "dev_addr" module argument fails systematically.
When checking the MAC address after the interface is created
it always has the same but different MAC address to the one
supplied as argument.

This is partially caused by systemd which by default will
set an internally generated permanent MAC address for interfaces
that are marked as having a randomly generated address.

Commit 890d5b40908bfd1a ("usb: gadget: u_ether: fix race in
setting MAC address in setup phase") didn't take into account
the fact that the interface must be marked as having a set
MAC address when it's set as module argument.

Fixed by marking the interface with NET_ADDR_SET when
the "dev_addr" module argument is supplied.

Reported-by: Maximilian Senftleben <kernel@mail.msdigital.de>
Cc: stable@vger.kernel.org
Fixes: 890d5b40908bfd1a ("usb: gadget: u_ether: fix race in setting MAC address in setup phase")
Signed-off-by: Marian Postevca <posteuca@mutex.one>
---
 drivers/usb/gadget/function/u_ether.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index a40be8b448c24..64ef97ab9274a 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -772,9 +772,13 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
 	dev->qmult = qmult;
 	snprintf(net->name, sizeof(net->name), "%s%%d", netname);
 
-	if (get_ether_addr(dev_addr, net->dev_addr))
+	if (get_ether_addr(dev_addr, net->dev_addr)) {
+		net->addr_assign_type = NET_ADDR_RANDOM;
 		dev_warn(&g->dev,
 			"using random %s ethernet address\n", "self");
+	} else {
+		net->addr_assign_type = NET_ADDR_SET;
+	}
 	if (get_ether_addr(host_addr, dev->host_mac))
 		dev_warn(&g->dev,
 			"using random %s ethernet address\n", "host");
@@ -831,6 +835,9 @@ struct net_device *gether_setup_name_default(const char *netname)
 	INIT_LIST_HEAD(&dev->tx_reqs);
 	INIT_LIST_HEAD(&dev->rx_reqs);
 
+	/* by default we always have a random MAC address */
+	net->addr_assign_type = NET_ADDR_RANDOM;
+
 	skb_queue_head_init(&dev->rx_frames);
 
 	/* network device setup */
@@ -868,7 +875,6 @@ int gether_register_netdev(struct net_device *net)
 	g = dev->gadget;
 
 	memcpy(net->dev_addr, dev->dev_mac, ETH_ALEN);
-	net->addr_assign_type = NET_ADDR_RANDOM;
 
 	status = register_netdev(net);
 	if (status < 0) {
@@ -908,6 +914,7 @@ int gether_set_dev_addr(struct net_device *net, const char *dev_addr)
 	if (get_ether_addr(dev_addr, new_addr))
 		return -EINVAL;
 	memcpy(dev->dev_mac, new_addr, ETH_ALEN);
+	net->addr_assign_type = NET_ADDR_SET;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gether_set_dev_addr);
-- 
2.35.1

