Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D23053CCAE
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 17:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243761AbiFCPxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 11:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238696AbiFCPxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 11:53:44 -0400
X-Greylist: delayed 1041 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Jun 2022 08:53:43 PDT
Received: from mail.mutex.one (mail.mutex.one [62.77.152.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7572632B
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 08:53:43 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.mutex.one (Postfix) with ESMTP id 9820B16C0076;
        Fri,  3 Jun 2022 18:36:19 +0300 (EEST)
X-Virus-Scanned: Debian amavisd-new at mail.mutex.one
Received: from mail.mutex.one ([127.0.0.1])
        by localhost (mail.mutex.one [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kEP0ZE0wriDL; Fri,  3 Jun 2022 18:36:18 +0300 (EEST)
From:   Marian Postevca <posteuca@mutex.one>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mutex.one; s=default;
        t=1654270578; bh=xpkzoKD+3NFGKOGZdS4+dLZEOE2yrpd76uIagdM6p7Y=;
        h=From:To:Cc:Subject:Date:From;
        b=DT6HKYmZev2nPfWOf69FkYUiJbBxdpyessDtjcuP2bZLYYFw3G5PGHRCAQAhQSyYS
         KC3VREYxmTSOQfS0QpHQceDNDEDmf9NQD4OHmGbReH3wR/TTXdeSwMVK2iJLGP1wmP
         OqZBjxRJfNhCY1YhxQcTYjQCbnEnqM8N2GU4rFQA=
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marian Postevca <posteuca@mutex.one>, stable@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: u_ether: fix regression in setting fixed MAC address
Date:   Fri,  3 Jun 2022 18:34:59 +0300
Message-Id: <20220603153459.32722-1-posteuca@mutex.one>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/gadget/function/u_ether.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 6f5d45ef2e39a..f51694f29de92 100644
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
-- 
2.35.1

