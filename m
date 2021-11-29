Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C685461DFE
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352450AbhK2SbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:31:25 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49492 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378261AbhK2S3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:29:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40C08CE1621;
        Mon, 29 Nov 2021 18:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA1EC53FAD;
        Mon, 29 Nov 2021 18:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210363;
        bh=LLomapkl7F2Ti/KY2gCsz3Vtez9UVVVzr3Kwkh7tYcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zup1bR6JmphN2lL0kTGU+I/I3VXe8cpNBSRmki6WNYc11fmNQ/YMFGXJyxpIiDtNN
         IG4EAIAG9gBf4DwvgwsES7Jays7kHSNC7U42IRtRaqubLvP/d5kayUiYtw5br+A9nK
         CoHc1hf4n/C6+GRKdmeUGuDIuFdE5xyj6j7wYPtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 61/92] net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group
Date:   Mon, 29 Nov 2021 19:18:30 +0100
Message-Id: <20211129181709.451479035@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit 1005f19b9357b81aa64e1decd08d6e332caaa284 ]

When replacing a nexthop group, we must release the IPv6 per-cpu dsts of
the removed nexthop entries after an RCU grace period because they
contain references to the nexthop's net device and to the fib6 info.
With specific series of events[1] we can reach net device refcount
imbalance which is unrecoverable. IPv4 is not affected because dsts
don't take a refcount on the route.

[1]
 $ ip nexthop list
  id 200 via 2002:db8::2 dev bridge.10 scope link onlink
  id 201 via 2002:db8::3 dev bridge scope link onlink
  id 203 group 201/200
 $ ip -6 route
  2001:db8::10 nhid 203 metric 1024 pref medium
     nexthop via 2002:db8::3 dev bridge weight 1 onlink
     nexthop via 2002:db8::2 dev bridge.10 weight 1 onlink

Create rt6_info through one of the multipath legs, e.g.:
 $ taskset -a -c 1  ./pkt_inj 24 bridge.10 2001:db8::10
 (pkt_inj is just a custom packet generator, nothing special)

Then remove that leg from the group by replace (let's assume it is id
200 in this case):
 $ ip nexthop replace id 203 group 201

Now remove the IPv6 route:
 $ ip -6 route del 2001:db8::10/128

The route won't be really deleted due to the stale rt6_info holding 1
refcnt in nexthop id 200.
At this point we have the following reference count dependency:
 (deleted) IPv6 route holds 1 reference over nhid 203
 nh 203 holds 1 ref over id 201
 nh 200 holds 1 ref over the net device and the route due to the stale
 rt6_info

Now to create circular dependency between nh 200 and the IPv6 route, and
also to get a reference over nh 200, restore nhid 200 in the group:
 $ ip nexthop replace id 203 group 201/200

And now we have a permanent circular dependncy because nhid 203 holds a
reference over nh 200 and 201, but the route holds a ref over nh 203 and
is deleted.

To trigger the bug just delete the group (nhid 203):
 $ ip nexthop del id 203

It won't really be deleted due to the IPv6 route dependency, and now we
have 2 unlinked and deleted objects that reference each other: the group
and the IPv6 route. Since the group drops the reference it holds over its
entries at free time (i.e. its own refcount needs to drop to 0) that will
never happen and we get a permanent ref on them, since one of the entries
holds a reference over the IPv6 route it will also never be released.

At this point the dependencies are:
 (deleted, only unlinked) IPv6 route holds reference over group nh 203
 (deleted, only unlinked) group nh 203 holds reference over nh 201 and 200
 nh 200 holds 1 ref over the net device and the route due to the stale
 rt6_info

This is the last point where it can be fixed by running traffic through
nh 200, and specifically through the same CPU so the rt6_info (dst) will
get released due to the IPv6 genid, that in turn will free the IPv6
route, which in turn will free the ref count over the group nh 203.

If nh 200 is deleted at this point, it will never be released due to the
ref from the unlinked group 203, it will only be unlinked:
 $ ip nexthop del id 200
 $ ip nexthop
 $

Now we can never release that stale rt6_info, we have IPv6 route with ref
over group nh 203, group nh 203 with ref over nh 200 and 201, nh 200 with
rt6_info (dst) with ref over the net device and the IPv6 route. All of
these objects are only unlinked, and cannot be released, thus they can't
release their ref counts.

 Message from syslogd@dev at Nov 19 14:04:10 ...
  kernel:[73501.828730] unregister_netdevice: waiting for bridge.10 to become free. Usage count = 3
 Message from syslogd@dev at Nov 19 14:04:20 ...
  kernel:[73512.068811] unregister_netdevice: waiting for bridge.10 to become free. Usage count = 3

Fixes: 7bf4796dd099 ("nexthops: add support for replace")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 8bdffdf0502a1..4d69b3de980a6 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -839,15 +839,36 @@ static void remove_nexthop(struct net *net, struct nexthop *nh,
 /* if any FIB entries reference this nexthop, any dst entries
  * need to be regenerated
  */
-static void nh_rt_cache_flush(struct net *net, struct nexthop *nh)
+static void nh_rt_cache_flush(struct net *net, struct nexthop *nh,
+			      struct nexthop *replaced_nh)
 {
 	struct fib6_info *f6i;
+	struct nh_group *nhg;
+	int i;
 
 	if (!list_empty(&nh->fi_list))
 		rt_cache_flush(net);
 
 	list_for_each_entry(f6i, &nh->f6i_list, nh_list)
 		ipv6_stub->fib6_update_sernum(net, f6i);
+
+	/* if an IPv6 group was replaced, we have to release all old
+	 * dsts to make sure all refcounts are released
+	 */
+	if (!replaced_nh->is_group)
+		return;
+
+	/* new dsts must use only the new nexthop group */
+	synchronize_net();
+
+	nhg = rtnl_dereference(replaced_nh->nh_grp);
+	for (i = 0; i < nhg->num_nh; i++) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+		struct nh_info *nhi = rtnl_dereference(nhge->nh->nh_info);
+
+		if (nhi->family == AF_INET6)
+			ipv6_stub->fib6_nh_release_dsts(&nhi->fib6_nh);
+	}
 }
 
 static int replace_nexthop_grp(struct net *net, struct nexthop *old,
@@ -994,7 +1015,7 @@ static int replace_nexthop(struct net *net, struct nexthop *old,
 		err = replace_nexthop_single(net, old, new, extack);
 
 	if (!err) {
-		nh_rt_cache_flush(net, old);
+		nh_rt_cache_flush(net, old, new);
 
 		__remove_nexthop(net, new, NULL);
 		nexthop_put(new);
-- 
2.33.0



