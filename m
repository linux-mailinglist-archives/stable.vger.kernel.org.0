Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01034CF9B7
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbiCGKHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240276AbiCGKGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:06:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC5E7EB30;
        Mon,  7 Mar 2022 01:52:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C2A2B8102B;
        Mon,  7 Mar 2022 09:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AACC340F4;
        Mon,  7 Mar 2022 09:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646740;
        bh=utN3Mg+TcaVZU78y1E4spj9075o+Spo/CeMcNVraL58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1+vdAPwcuBfB3wzjGHMeGhXLbQW9N++LvjL4v2A0kVBY4kZdBVEpFPJsujs6MwpL
         Hmx+sPyZ0VWhE2mNWo1hFEiVI+T1hyzfS98yEs1EFWsvIrtdyIKw6GnE1Hww5QiWuE
         cDW1DUWKL1QfFiPox3sRe2xWMqKVoMSJpv+NADB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Nixdorf <j.nixdorf@avm.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 079/186] net: ipv6: ensure we call ipv6_mc_down() at most once
Date:   Mon,  7 Mar 2022 10:18:37 +0100
Message-Id: <20220307091656.296838128@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3732,6 +3732,7 @@ static int addrconf_ifdown(struct net_de
 	struct inet6_dev *idev;
 	struct inet6_ifaddr *ifa, *tmp;
 	bool keep_addr = false;
+	bool was_ready;
 	int state, i;
 
 	ASSERT_RTNL();
@@ -3797,7 +3798,10 @@ restart:
 
 	addrconf_del_rs_timer(idev);
 
-	/* Step 2: clear flags for stateless addrconf */
+	/* Step 2: clear flags for stateless addrconf, repeated down
+	 *         detection
+	 */
+	was_ready = idev->if_flags & IF_READY;
 	if (!unregister)
 		idev->if_flags &= ~(IF_RS_SENT|IF_RA_RCVD|IF_READY);
 
@@ -3871,7 +3875,7 @@ restart:
 	if (unregister) {
 		ipv6_ac_destroy_dev(idev);
 		ipv6_mc_destroy_dev(idev);
-	} else {
+	} else if (was_ready) {
 		ipv6_mc_down(idev);
 	}
 


