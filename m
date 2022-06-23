Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9805586EE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbiFWSSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236726AbiFWSR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:17:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F269482687;
        Thu, 23 Jun 2022 10:23:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F808B824B8;
        Thu, 23 Jun 2022 17:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2BBC3411B;
        Thu, 23 Jun 2022 17:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005020;
        bh=E0lgWaK+wTrtgx+NOHmYoyAHE5JLXtccaud7lMVI+84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlS85rlfjdo1Cp6/fOtlwvn14MuxZSHC54rhGdPTMe56rRQCA8/tekbb02mc3ACJ1
         rcgi6MfH1LwHF/rqD8uCgskLtpUsLQdCk1QLCsuVAzKcKo5veMRj2wuKBS5K03Urr3
         oE4dwYEAzIy5a4o0xQRy0nDS8B+ojgEsu1oc0nIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marian Postevca <posteuca@mutex.one>
Subject: [PATCH 4.19 226/234] usb: gadget: u_ether: fix regression in setting fixed MAC address
Date:   Thu, 23 Jun 2022 18:44:53 +0200
Message-Id: <20220623164349.444968307@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Marian Postevca <posteuca@mutex.one>

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

Fixes: 890d5b40908bfd1a ("usb: gadget: u_ether: fix race in setting MAC address in setup phase")
Cc: stable@vger.kernel.org
Signed-off-by: Marian Postevca <posteuca@mutex.one>
Link: https://lore.kernel.org/r/20220603153459.32722-1-posteuca@mutex.one
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -772,9 +772,13 @@ struct eth_dev *gether_setup_name(struct
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
@@ -831,6 +835,9 @@ struct net_device *gether_setup_name_def
 	INIT_LIST_HEAD(&dev->tx_reqs);
 	INIT_LIST_HEAD(&dev->rx_reqs);
 
+	/* by default we always have a random MAC address */
+	net->addr_assign_type = NET_ADDR_RANDOM;
+
 	skb_queue_head_init(&dev->rx_frames);
 
 	/* network device setup */
@@ -868,7 +875,6 @@ int gether_register_netdev(struct net_de
 	g = dev->gadget;
 
 	memcpy(net->dev_addr, dev->dev_mac, ETH_ALEN);
-	net->addr_assign_type = NET_ADDR_RANDOM;
 
 	status = register_netdev(net);
 	if (status < 0) {
@@ -908,6 +914,7 @@ int gether_set_dev_addr(struct net_devic
 	if (get_ether_addr(dev_addr, new_addr))
 		return -EINVAL;
 	memcpy(dev->dev_mac, new_addr, ETH_ALEN);
+	net->addr_assign_type = NET_ADDR_SET;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gether_set_dev_addr);


