Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C0B1CAF10
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgEHNOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728923AbgEHMrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3897021473;
        Fri,  8 May 2020 12:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942043;
        bh=xguceMokyyz8H/4yiZy08gxUVNB6y1oDK6yO1+sacWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1ROM2+qfBjvAE/NjAytKIGK7F1cHEltH6ZO7cvXSrUFJKJtqLSOjhBmX5GTodFWZ
         YenqjXYUcIBWyI7MNzS6twTMEsGW3Tg+Ol6l+tj4VrjevlfyCpqsM6oVo62Me98xOw
         NvGOWBXC99uxRK2BvQdr0yGug56XBoWXW92gCm5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 234/312] net: Dont delete routes in different VRFs
Date:   Fri,  8 May 2020 14:33:45 +0200
Message-Id: <20200508123140.882540730@linuxfoundation.org>
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

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

commit 5a56a0b3a45dd0cc5b2f7bec6afd053a474ed9f5 upstream.

When deleting an IP address from an interface, there is a clean-up of
routes which refer to this local address. However, there was no check to
see that the VRF matched. This meant that deletion wasn't confined to
the VRF it should have been.

To solve this, a new field has been added to fib_info to hold a table
id. When removing fib entries corresponding to a local ip address, this
table id is also used in the comparison.

The table id is populated when the fib_info is created. This was already
done in some places, but not in ip_rt_ioctl(). This has now been fixed.

Fixes: 021dd3b8a142 ("net: Add routes to the table associated with the device")
Acked-by: David Ahern <dsa@cumulusnetworks.com>
Tested-by: David Ahern <dsa@cumulusnetworks.com>
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/ip_fib.h     |    3 ++-
 net/ipv4/fib_frontend.c  |    3 ++-
 net/ipv4/fib_semantics.c |    8 ++++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -112,6 +112,7 @@ struct fib_info {
 	unsigned char		fib_scope;
 	unsigned char		fib_type;
 	__be32			fib_prefsrc;
+	u32			fib_tb_id;
 	u32			fib_priority;
 	struct dst_metrics	*fib_metrics;
 #define fib_mtu fib_metrics->metrics[RTAX_MTU-1]
@@ -320,7 +321,7 @@ void fib_flush_external(struct net *net)
 /* Exported by fib_semantics.c */
 int ip_fib_check_default(__be32 gw, struct net_device *dev);
 int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force);
-int fib_sync_down_addr(struct net *net, __be32 local);
+int fib_sync_down_addr(struct net_device *dev, __be32 local);
 int fib_sync_up(struct net_device *dev, unsigned int nh_flags);
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu);
 
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -509,6 +509,7 @@ static int rtentry_to_fib_config(struct
 		if (!dev)
 			return -ENODEV;
 		cfg->fc_oif = dev->ifindex;
+		cfg->fc_table = l3mdev_fib_table(dev);
 		if (colon) {
 			struct in_ifaddr *ifa;
 			struct in_device *in_dev = __in_dev_get_rtnl(dev);
@@ -1034,7 +1035,7 @@ no_promotions:
 			 * First of all, we scan fib_info list searching
 			 * for stray nexthop entries, then ignite fib_flush.
 			 */
-			if (fib_sync_down_addr(dev_net(dev), ifa->ifa_local))
+			if (fib_sync_down_addr(dev, ifa->ifa_local))
 				fib_flush(dev_net(dev));
 		}
 	}
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1069,6 +1069,7 @@ struct fib_info *fib_create_info(struct
 	fi->fib_priority = cfg->fc_priority;
 	fi->fib_prefsrc = cfg->fc_prefsrc;
 	fi->fib_type = cfg->fc_type;
+	fi->fib_tb_id = cfg->fc_table;
 
 	fi->fib_nhs = nhs;
 	change_nexthops(fi) {
@@ -1352,18 +1353,21 @@ nla_put_failure:
  *   referring to it.
  * - device went down -> we must shutdown all nexthops going via it.
  */
-int fib_sync_down_addr(struct net *net, __be32 local)
+int fib_sync_down_addr(struct net_device *dev, __be32 local)
 {
 	int ret = 0;
 	unsigned int hash = fib_laddr_hashfn(local);
 	struct hlist_head *head = &fib_info_laddrhash[hash];
+	struct net *net = dev_net(dev);
+	int tb_id = l3mdev_fib_table(dev);
 	struct fib_info *fi;
 
 	if (!fib_info_laddrhash || local == 0)
 		return 0;
 
 	hlist_for_each_entry(fi, head, fib_lhash) {
-		if (!net_eq(fi->fib_net, net))
+		if (!net_eq(fi->fib_net, net) ||
+		    fi->fib_tb_id != tb_id)
 			continue;
 		if (fi->fib_prefsrc == local) {
 			fi->fib_flags |= RTNH_F_DEAD;


