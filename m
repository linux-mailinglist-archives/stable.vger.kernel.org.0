Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69350521821
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243362AbiEJNdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243922AbiEJNcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CB647397;
        Tue, 10 May 2022 06:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4EDC6170D;
        Tue, 10 May 2022 13:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB09C385A6;
        Tue, 10 May 2022 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189026;
        bh=cr94HvuOY+ar8/Psx+ZQoQk1dqg2cHIVgfMXgDzaZNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I//E6LbPtBgbw3R6gptpgYlLgU3GFKYZdMhtuKabs2UZt0y8XPVz4EkYvld/5mF8X
         AE2tHNFOVUFOhOsilrLB9KBR4WqRgy+ZF467F69M8RIQmYECm78ydH7PSUSKG8ktDt
         2DXd+O9kx2GfKJ9us7cho00t4eNy1oBBpFNjfM0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Nixdorf <j.nixdorf@avm.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 39/52] net: ipv6: ensure we call ipv6_mc_down() at most once
Date:   Tue, 10 May 2022 15:08:08 +0200
Message-Id: <20220510130730.996638140@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: j.nixdorf@avm.de <j.nixdorf@avm.de>

commit 9995b408f17ff8c7f11bc725c8aa225ba3a63b1c upstream.

There are two reasons for addrconf_notify() to be called with NETDEV_DOWN:
either the network device is actually going down, or IPv6 was disabled
on the interface.

If either of them stays down while the other is toggled, we repeatedly
call the code for NETDEV_DOWN, including ipv6_mc_down(), while never
calling the corresponding ipv6_mc_up() in between. This will cause a
new entry in idev->mc_tomb to be allocated for each multicast group
the interface is subscribed to, which in turn leaks one struct ifmcaddr6
per nontrivial multicast group the interface is subscribed to.

The following reproducer will leak at least $n objects:

ip addr add ff2e::4242/32 dev eth0 autojoin
sysctl -w net.ipv6.conf.eth0.disable_ipv6=1
for i in $(seq 1 $n); do
	ip link set up eth0; ip link set down eth0
done

Joining groups with IPV6_ADD_MEMBERSHIP (unprivileged) or setting the
sysctl net.ipv6.conf.eth0.forwarding to 1 (=> subscribing to ff02::2)
can also be used to create a nontrivial idev->mc_list, which will the
leak objects with the right up-down-sequence.

Based on both sources for NETDEV_DOWN events the interface IPv6 state
should be considered:

 - not ready if the network interface is not ready OR IPv6 is disabled
   for it
 - ready if the network interface is ready AND IPv6 is enabled for it

The functions ipv6_mc_up() and ipv6_down() should only be run when this
state changes.

Implement this by remembering when the IPv6 state is ready, and only
run ipv6_mc_down() if it actually changed from ready to not ready.

The other direction (not ready -> ready) already works correctly, as:

 - the interface notification triggered codepath for NETDEV_UP /
   NETDEV_CHANGE returns early if ipv6 is disabled, and
 - the disable_ipv6=0 triggered codepath skips fully initializing the
   interface as long as addrconf_link_ready(dev) returns false
 - calling ipv6_mc_up() repeatedly does not leak anything

Fixes: 3ce62a84d53c ("ipv6: exit early in addrconf_notify() if IPv6 is disabled")
Signed-off-by: Johannes Nixdorf <j.nixdorf@avm.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
[jnixdorf: context updated for bpo to v4.19/v5.4]
Signed-off-by: Johannes Nixdorf <j.nixdorf@avm.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3715,6 +3715,7 @@ static int addrconf_ifdown(struct net_de
 	struct inet6_dev *idev;
 	struct inet6_ifaddr *ifa, *tmp;
 	bool keep_addr = false;
+	bool was_ready;
 	int state, i;
 
 	ASSERT_RTNL();
@@ -3780,7 +3781,10 @@ restart:
 
 	addrconf_del_rs_timer(idev);
 
-	/* Step 2: clear flags for stateless addrconf */
+	/* Step 2: clear flags for stateless addrconf, repeated down
+	 *         detection
+	 */
+	was_ready = idev->if_flags & IF_READY;
 	if (!how)
 		idev->if_flags &= ~(IF_RS_SENT|IF_RA_RCVD|IF_READY);
 
@@ -3854,7 +3858,7 @@ restart:
 	if (how) {
 		ipv6_ac_destroy_dev(idev);
 		ipv6_mc_destroy_dev(idev);
-	} else {
+	} else if (was_ready) {
 		ipv6_mc_down(idev);
 	}
 


