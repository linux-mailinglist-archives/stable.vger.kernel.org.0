Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D7851A201
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 16:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351207AbiEDOSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 10:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351239AbiEDOSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 10:18:43 -0400
X-Greylist: delayed 510 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 May 2022 07:15:04 PDT
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1015E43AC2
        for <stable@vger.kernel.org>; Wed,  4 May 2022 07:15:03 -0700 (PDT)
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
        by mail.avm.de (Postfix) with ESMTPS;
        Wed,  4 May 2022 16:06:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
        t=1651673189; bh=Q0S8L4rEfUze7HnAAuiBOiCheph2AIJhofEcBHjdHDI=;
        h=From:To:Cc:Subject:Date:From;
        b=JthZbRzqvorGQJWIARBujF025bR6jpxKHobjBPNIPpnRK36gCxlwWCY8LeMFh91IC
         AQfMK/18RpFbILu6jpmDK3VTjXKRtHKAQF8fL4WrwH02O/Ua6UaqpHPEmmUd4E1HlT
         x+gs11DJUWxMgrg9ePyLZ/i99k2+8vBka/QSn2eU=
Received: from buildd.core.avm.de (buildd-sv-01.avm.de [172.16.0.225])
        by mail-auth.avm.de (Postfix) with ESMTPA id EAC1B81D27;
        Wed,  4 May 2022 16:06:21 +0200 (CEST)
Received: by buildd.core.avm.de (Postfix, from userid 1000)
        id DDB85188939; Wed,  4 May 2022 16:06:21 +0200 (CEST)
From:   Johannes Nixdorf <j.nixdorf@avm.de>
To:     stable@vger.kernel.org
Cc:     Johannes Nixdorf <j.nixdorf@avm.de>,
        =?UTF-8?q?Christoph=20B=C3=BCttner?= <c.buettner@avm.de>,
        Nicolas Schier <n.schier@avm.de>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 4.14] net: ipv6: ensure we call ipv6_mc_down() at most once
Date:   Wed,  4 May 2022 16:06:09 +0200
Message-Id: <20220504140610.880318-1-j.nixdorf@avm.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-purgate-ID: 149429::1651673187-000003AF-2BC0B4E5/0/0
X-purgate-type: clean
X-purgate-size: 3388
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[jnixdorf: context updated for bpo to v4.9/v4.14]
Signed-off-by: Johannes Nixdorf <j.nixdorf@avm.de>
---
 net/ipv6/addrconf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6119ab33a56e..30ca73c78125 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3539,6 +3539,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 	struct list_head del_list;
 	int _keep_addr;
 	bool keep_addr;
+	bool was_ready;
 	int state, i;
 
 	ASSERT_RTNL();
@@ -3602,7 +3603,10 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 
 	addrconf_del_rs_timer(idev);
 
-	/* Step 2: clear flags for stateless addrconf */
+	/* Step 2: clear flags for stateless addrconf, repeated down
+	 *         detection
+	 */
+	was_ready = idev->if_flags & IF_READY;
 	if (!how)
 		idev->if_flags &= ~(IF_RS_SENT|IF_RA_RCVD|IF_READY);
 
@@ -3689,7 +3693,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 	if (how) {
 		ipv6_ac_destroy_dev(idev);
 		ipv6_mc_destroy_dev(idev);
-	} else {
+	} else if (was_ready) {
 		ipv6_mc_down(idev);
 	}
 
-- 
2.36.0

