Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C124D372C
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbiCIRFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239470AbiCIRFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:05:02 -0500
X-Greylist: delayed 561 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 08:55:33 PST
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5948FDBD35
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 08:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1646844373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZwpCCR3j0fJP68u+mjeOcu9cn7tpGvSxapemqPWCvhE=;
        b=cqlYL+8mTLRxIvZN3ZFnaSBUkDE/9cMvb4YWqnMz4PyYCzxgAhSf61mmqd//2yGITuBDTA
        IuYuBMaIP7FFOLqcoXVSHuer4XXwb8ObZHkFKNDDc+B5znfl2cL3AFxVV2pbEJf4rL+var
        IEiyttfUcJ6Yj2SMuF+HCxAzuHU3Jj4=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 2/2] batman-adv: Don't expect inter-netns unique iflink indices
Date:   Wed,  9 Mar 2022 17:45:42 +0100
Message-Id: <20220309164542.408824-3-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220309164542.408824-1-sven@narfation.org>
References: <20220309164542.408824-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6c1f41afc1dbe59d9d3c8bb0d80b749c119aa334 upstream.

The ifindex doesn't have to be unique for multiple network namespaces on
the same machine.

  $ ip netns add test1
  $ ip -net test1 link add dummy1 type dummy
  $ ip netns add test2
  $ ip -net test2 link add dummy2 type dummy

  $ ip -net test1 link show dev dummy1
  6: dummy1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/ether 96:81:55:1e:dd:85 brd ff:ff:ff:ff:ff:ff
  $ ip -net test2 link show dev dummy2
  6: dummy2: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/ether 5a:3c:af:35:07:c3 brd ff:ff:ff:ff:ff:ff

But the batman-adv code to walk through the various layers of virtual
interfaces uses this assumption because dev_get_iflink handles it
internally and doesn't return the actual netns of the iflink. And
dev_get_iflink only documents the situation where ifindex == iflink for
physical devices.

But only checking for dev->netdev_ops->ndo_get_iflink is also not an option
because ipoib_get_iflink implements it even when it sometimes returns an
iflink != ifindex and sometimes iflink == ifindex. The caller must
therefore make sure itself to check both netns and iflink + ifindex for
equality. Only when they are equal, a "physical" interface was detected
which should stop the traversal. On the other hand, vxcan_get_iflink can
also return 0 in case there was currently no valid peer. In this case, it
is still necessary to stop.

Fixes: b7eddd0b3950 ("batman-adv: prevent using any virtual device created on batman-adv as hard-interface")
Fixes: 5ed4a460a1d3 ("batman-adv: additional checks for virtual interfaces on top of WiFi")
Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.9 backported: drop modification of non-existing batadv_get_real_netdevice. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/hard-interface.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 64cf9cd3be4d..eaf0a483211a 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -163,13 +163,15 @@ static bool batadv_is_on_batman_iface(const struct net_device *net_dev)
 		return true;
 
 	iflink = dev_get_iflink(net_dev);
-
-	/* no more parents..stop recursion */
-	if (iflink == 0 || iflink == net_dev->ifindex)
+	if (iflink == 0)
 		return false;
 
 	parent_net = batadv_getlink_net(net_dev, net);
 
+	/* iflink to itself, most likely physical device */
+	if (net == parent_net && iflink == net_dev->ifindex)
+		return false;
+
 	/* recurse over the parent device */
 	parent_dev = __dev_get_by_index((struct net *)parent_net, iflink);
 	/* if we got a NULL parent_dev there is something broken.. */
-- 
2.30.2

