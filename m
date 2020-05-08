Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9651CAFE1
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgEHNVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbgEHMk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54E882495C;
        Fri,  8 May 2020 12:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941625;
        bh=vwci9RWDmnCqqO27ReEHvvAjO3atjmtDijjFMQmolW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZjJpqavKiQYH6MGKuAzHfABqVT/grDRODJhnXSTt8PzSsT9zaTRdeHL2kzZLMAd2
         yw3BaJV6g0Z/kEiDASWI6QRt6BDeiZX9OZFWhyLmNf1N+P4Axxbd8aReuH9qM9oJBw
         f+cmU4Nt+i2A7awbvh+OCMpVGRWic6bPWMPDkQoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wragg <david@weave.works>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 067/312] ovs/gre,geneve: fix error path when creating an iface
Date:   Fri,  8 May 2020 14:30:58 +0200
Message-Id: <20200508123129.264117885@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 106da663ff495e0aea3ac15b8317aa410754fcac upstream.

After ipgre_newlink()/geneve_configure() call, the netdev is registered.

Fixes: 7e059158d57b ("vxlan, gre, geneve: Set a large MTU on ovs-created tunnel devices")
CC: David Wragg <david@weave.works>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/geneve.c |   10 +++++++---
 net/ipv4/ip_gre.c    |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1340,6 +1340,7 @@ struct net_device *geneve_dev_create_fb(
 {
 	struct nlattr *tb[IFLA_MAX + 1];
 	struct net_device *dev;
+	LIST_HEAD(list_kill);
 	int err;
 
 	memset(tb, 0, sizeof(tb));
@@ -1350,8 +1351,10 @@ struct net_device *geneve_dev_create_fb(
 
 	err = geneve_configure(net, dev, &geneve_remote_unspec,
 			       0, 0, 0, htons(dst_port), true);
-	if (err)
-		goto err;
+	if (err) {
+		free_netdev(dev);
+		return ERR_PTR(err);
+	}
 
 	/* openvswitch users expect packet sizes to be unrestricted,
 	 * so set the largest MTU we can.
@@ -1363,7 +1366,8 @@ struct net_device *geneve_dev_create_fb(
 	return dev;
 
  err:
-	free_netdev(dev);
+	geneve_dellink(dev, &list_kill);
+	unregister_netdevice_many(&list_kill);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(geneve_dev_create_fb);
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1230,6 +1230,7 @@ struct net_device *gretap_fb_dev_create(
 {
 	struct nlattr *tb[IFLA_MAX + 1];
 	struct net_device *dev;
+	LIST_HEAD(list_kill);
 	struct ip_tunnel *t;
 	int err;
 
@@ -1245,8 +1246,10 @@ struct net_device *gretap_fb_dev_create(
 	t->collect_md = true;
 
 	err = ipgre_newlink(net, dev, tb, NULL);
-	if (err < 0)
-		goto out;
+	if (err < 0) {
+		free_netdev(dev);
+		return ERR_PTR(err);
+	}
 
 	/* openvswitch users expect packet sizes to be unrestricted,
 	 * so set the largest MTU we can.
@@ -1257,7 +1260,8 @@ struct net_device *gretap_fb_dev_create(
 
 	return dev;
 out:
-	free_netdev(dev);
+	ip_tunnel_dellink(dev, &list_kill);
+	unregister_netdevice_many(&list_kill);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(gretap_fb_dev_create);


