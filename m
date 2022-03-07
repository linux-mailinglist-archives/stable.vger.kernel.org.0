Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7601F4CF739
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbiCGJpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237903AbiCGJhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:37:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E028B6E542;
        Mon,  7 Mar 2022 01:31:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CFAFB810C0;
        Mon,  7 Mar 2022 09:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C459FC340F3;
        Mon,  7 Mar 2022 09:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645492;
        bh=zm7X+mczjZZVjYf1HfHRRL5vRFs3/Yfw66muXvDoBRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f06zK8PTgP9FQES9LdIBT51ODyRkLLd8Byykqk9Rmt0GDtGTLX4w3IkVnC5JZxWo2
         Hg4z4r5z8JgiiVBF5o1E6wTkiCJkrtUeXgIR5hdaKl1cBwlZw16YpOJnhzh2LG8uWQ
         wj1qyiEN2Uwdx0MjneBEN5eaDcD768R6ctU00KvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.10 048/105] batman-adv: Dont expect inter-netns unique iflink indices
Date:   Mon,  7 Mar 2022 10:18:51 +0100
Message-Id: <20220307091645.536552023@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/hard-interface.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -159,13 +159,15 @@ static bool batadv_is_on_batman_iface(co
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
@@ -225,8 +227,7 @@ static struct net_device *batadv_get_rea
 		return NULL;
 
 	iflink = dev_get_iflink(netdev);
-
-	if (netdev->ifindex == iflink) {
+	if (iflink == 0) {
 		dev_hold(netdev);
 		return netdev;
 	}
@@ -237,6 +238,14 @@ static struct net_device *batadv_get_rea
 
 	net = dev_net(hard_iface->soft_iface);
 	real_net = batadv_getlink_net(netdev, net);
+
+	/* iflink to itself, most likely physical device */
+	if (net == real_net && netdev->ifindex == iflink) {
+		real_netdev = netdev;
+		dev_hold(real_netdev);
+		goto out;
+	}
+
 	real_netdev = dev_get_by_index(real_net, iflink);
 
 out:


