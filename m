Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732172C078C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732589AbgKWMmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732725AbgKWMls (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:41:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEC3B20888;
        Mon, 23 Nov 2020 12:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135307;
        bh=G17YmGOpGS1F8BrpIoOxM0pLteiQcuPK3HZFniMoa24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flhi6ewP5Fsy7P8pJCn1FT2UtFsMkXoredezNfeOItxnhw6d1A8FYOzPkHfFn1Qac
         bfMAUIaY6i9Cj9gCwexWS6A5xEfydc0j6AKf9xmzOgVWatlK8SWp5E4dlzweEBOPFV
         3Sdj1Y65CHY3Xaxfj7wbfIDlG8aFhKjv8j6+gzs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 022/252] net: Have netpoll bring-up DSA management interface
Date:   Mon, 23 Nov 2020 13:19:32 +0100
Message-Id: <20201123121836.668387214@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 1532b9778478577152201adbafa7738b1e844868 ]

DSA network devices rely on having their DSA management interface up and
running otherwise their ndo_open() will return -ENETDOWN. Without doing
this it would not be possible to use DSA devices as netconsole when
configured on the command line. These devices also do not utilize the
upper/lower linking so the check about the netpoll device having upper
is not going to be a problem.

The solution adopted here is identical to the one done for
net/ipv4/ipconfig.c with 728c02089a0e ("net: ipv4: handle DSA enabled
master network devices"), with the network namespace scope being
restricted to that of the process configuring netpoll.

Fixes: 04ff53f96a93 ("net: dsa: Add netconsole support")
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20201117035236.22658-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/if_vlan.h>
+#include <net/dsa.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/addrconf.h>
@@ -657,15 +658,15 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
 
 int netpoll_setup(struct netpoll *np)
 {
-	struct net_device *ndev = NULL;
+	struct net_device *ndev = NULL, *dev = NULL;
+	struct net *net = current->nsproxy->net_ns;
 	struct in_device *in_dev;
 	int err;
 
 	rtnl_lock();
-	if (np->dev_name[0]) {
-		struct net *net = current->nsproxy->net_ns;
+	if (np->dev_name[0])
 		ndev = __dev_get_by_name(net, np->dev_name);
-	}
+
 	if (!ndev) {
 		np_err(np, "%s doesn't exist, aborting\n", np->dev_name);
 		err = -ENODEV;
@@ -673,6 +674,19 @@ int netpoll_setup(struct netpoll *np)
 	}
 	dev_hold(ndev);
 
+	/* bring up DSA management network devices up first */
+	for_each_netdev(net, dev) {
+		if (!netdev_uses_dsa(dev))
+			continue;
+
+		err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
+		if (err < 0) {
+			np_err(np, "%s failed to open %s\n",
+			       np->dev_name, dev->name);
+			goto put;
+		}
+	}
+
 	if (netdev_master_upper_dev_get(ndev)) {
 		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
 		err = -EBUSY;


