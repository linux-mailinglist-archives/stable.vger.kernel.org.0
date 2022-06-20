Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F52355127B
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 10:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbiFTIUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 04:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbiFTIUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 04:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78AC11A28
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 01:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43C996129A
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 08:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4721CC3411B;
        Mon, 20 Jun 2022 08:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655713230;
        bh=JuW+HVaSX9huLxLnX970EhL+fXVhiY5j51oUu/B2E0Q=;
        h=Subject:To:Cc:From:Date:From;
        b=EvWm52tphAkmF9m1aLp7eG3JN+1MVli0fx4QQ1Uw9vxqXEFwC3D1jXY08d/iKbPQc
         iRhenuP0tEXzoiGtNZCapFZRMaweEPdaI4XGxT1chwUGJ/K6cfzp8+ob8kV1oJP62R
         g6m2ZwKUwP+le3+YwJeN8/icpHPy//oEiD0qSDIA=
Subject: FAILED: patch "[PATCH] usb: gadget: u_ether: fix regression in setting fixed MAC" failed to apply to 4.19-stable tree
To:     posteuca@mutex.one, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 10:20:12 +0200
Message-ID: <165571321218346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b337af3a4d6147000b7ca6b3438bf5c820849b37 Mon Sep 17 00:00:00 2001
From: Marian Postevca <posteuca@mutex.one>
Date: Fri, 3 Jun 2022 18:34:59 +0300
Subject: [PATCH] usb: gadget: u_ether: fix regression in setting fixed MAC
 address

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

Fixes: 890d5b40908bfd1a ("usb: gadget: u_ether: fix race in setting MAC address in setup phase")
Cc: stable@vger.kernel.org
Signed-off-by: Marian Postevca <posteuca@mutex.one>
Link: https://lore.kernel.org/r/20220603153459.32722-1-posteuca@mutex.one
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 6f5d45ef2e39..f51694f29de9 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -775,9 +775,13 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
 	dev->qmult = qmult;
 	snprintf(net->name, sizeof(net->name), "%s%%d", netname);
 
-	if (get_ether_addr(dev_addr, addr))
+	if (get_ether_addr(dev_addr, addr)) {
+		net->addr_assign_type = NET_ADDR_RANDOM;
 		dev_warn(&g->dev,
 			"using random %s ethernet address\n", "self");
+	} else {
+		net->addr_assign_type = NET_ADDR_SET;
+	}
 	eth_hw_addr_set(net, addr);
 	if (get_ether_addr(host_addr, dev->host_mac))
 		dev_warn(&g->dev,
@@ -844,6 +848,10 @@ struct net_device *gether_setup_name_default(const char *netname)
 
 	eth_random_addr(dev->dev_mac);
 	pr_warn("using random %s ethernet address\n", "self");
+
+	/* by default we always have a random MAC address */
+	net->addr_assign_type = NET_ADDR_RANDOM;
+
 	eth_random_addr(dev->host_mac);
 	pr_warn("using random %s ethernet address\n", "host");
 
@@ -871,7 +879,6 @@ int gether_register_netdev(struct net_device *net)
 	dev = netdev_priv(net);
 	g = dev->gadget;
 
-	net->addr_assign_type = NET_ADDR_RANDOM;
 	eth_hw_addr_set(net, dev->dev_mac);
 
 	status = register_netdev(net);
@@ -912,6 +919,7 @@ int gether_set_dev_addr(struct net_device *net, const char *dev_addr)
 	if (get_ether_addr(dev_addr, new_addr))
 		return -EINVAL;
 	memcpy(dev->dev_mac, new_addr, ETH_ALEN);
+	net->addr_assign_type = NET_ADDR_SET;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gether_set_dev_addr);

