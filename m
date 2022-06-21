Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA1C553D60
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355338AbiFUVMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355354AbiFUVMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 17:12:39 -0400
Received: from mail.mutex.one (mail.mutex.one [62.77.152.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524FE3AA4D;
        Tue, 21 Jun 2022 13:58:35 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.mutex.one (Postfix) with ESMTP id 4E46C16C00A0;
        Tue, 21 Jun 2022 23:58:18 +0300 (EEST)
X-Virus-Scanned: Debian amavisd-new at mail.mutex.one
Received: from mail.mutex.one ([127.0.0.1])
        by localhost (mail.mutex.one [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Jk9ZoUcCUrVN; Tue, 21 Jun 2022 23:58:17 +0300 (EEST)
From:   Marian Postevca <posteuca@mutex.one>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mutex.one; s=default;
        t=1655845097; bh=vpNthc+lldxuvJbZ7zxIciUxabh3k038ETcMBiLjAOs=;
        h=From:To:Cc:Subject:Date:From;
        b=RxSc0hQi5h2gzEr2CUj6KMIEzlaUYhp21qBaf+RtgAXfqkJ9cjyOgSzNyiOl7hfz1
         jrWPr20+WF+PD7DyfR2y8p+7OOx1hgBKGzOJgShlDIA2Lx8n+c/zeKVHs64XV9PXt2
         1sNpTadLLnTVdvwo2yT7Kq5RM2z5Syq1dTKePbVs=
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marian Postevca <posteuca@mutex.one>,
        Maximilian Senftleben <kernel@mail.msdigital.de>,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.14] usb: gadget: u_ether: fix regression in setting fixed MAC address
Date:   Tue, 21 Jun 2022 23:54:07 +0300
Message-Id: <20220621205406.22599-1-posteuca@mutex.one>
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
index f59c20457e658..2d45233ba027e 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -776,9 +776,13 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
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
@@ -835,6 +839,9 @@ struct net_device *gether_setup_name_default(const char *netname)
 	INIT_LIST_HEAD(&dev->tx_reqs);
 	INIT_LIST_HEAD(&dev->rx_reqs);
 
+	/* by default we always have a random MAC address */
+	net->addr_assign_type = NET_ADDR_RANDOM;
+
 	skb_queue_head_init(&dev->rx_frames);
 
 	/* network device setup */
@@ -872,7 +879,6 @@ int gether_register_netdev(struct net_device *net)
 	g = dev->gadget;
 
 	memcpy(net->dev_addr, dev->dev_mac, ETH_ALEN);
-	net->addr_assign_type = NET_ADDR_RANDOM;
 
 	status = register_netdev(net);
 	if (status < 0) {
@@ -912,6 +918,7 @@ int gether_set_dev_addr(struct net_device *net, const char *dev_addr)
 	if (get_ether_addr(dev_addr, new_addr))
 		return -EINVAL;
 	memcpy(dev->dev_mac, new_addr, ETH_ALEN);
+	net->addr_assign_type = NET_ADDR_SET;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gether_set_dev_addr);
-- 
2.35.1

