Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8C3CD79C
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfJFRcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbfJFRcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:32:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B9562080F;
        Sun,  6 Oct 2019 17:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383140;
        bh=anC2h8HLrJ225GNI/6kpNgNtxjSNr0e6gzPUyAcYfdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZRvN+wvJDQC9P15RWvM0OWSymTmkryqsFoI7jygdz7LB6+l776YUaxR8dXvYL/MB
         cmvmTo9/aPqFYRrnW30LSGqROj1QWJdzKSQuOZbzYDcjSCdki6o5005P3S3Sie+jrF
         ipq6lyrARj/H+wKlTdffwkCXrdC8z+YqiZUl8YW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 084/106] ipv6: Handle missing host route in __ipv6_ifa_notify
Date:   Sun,  6 Oct 2019 19:21:30 +0200
Message-Id: <20191006171158.119464512@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 2d819d250a1393a3e725715425ab70a0e0772a71 ]

Rajendra reported a kernel panic when a link was taken down:

    [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
    [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290

    <snip>

    [ 6870.570501] Call Trace:
    [ 6870.573238] [<ffffffff8efc58c6>] ? ipv6_ifa_notify+0x26/0x40
    [ 6870.579665] [<ffffffff8efc98ec>] ? addrconf_dad_completed+0x4c/0x2c0
    [ 6870.586869] [<ffffffff8efe70c6>] ? ipv6_dev_mc_inc+0x196/0x260
    [ 6870.593491] [<ffffffff8efc9c6a>] ? addrconf_dad_work+0x10a/0x430
    [ 6870.600305] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
    [ 6870.606732] [<ffffffff8ea93a7a>] ? process_one_work+0x18a/0x430
    [ 6870.613449] [<ffffffff8ea93d6d>] ? worker_thread+0x4d/0x490
    [ 6870.619778] [<ffffffff8ea93d20>] ? process_one_work+0x430/0x430
    [ 6870.626495] [<ffffffff8ea99dd9>] ? kthread+0xd9/0xf0
    [ 6870.632145] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
    [ 6870.638573] [<ffffffff8ea99d00>] ? kthread_park+0x60/0x60
    [ 6870.644707] [<ffffffff8f01ae77>] ? ret_from_fork+0x57/0x70
    [ 6870.650936] Code: 31 c0 31 d2 41 b9 20 00 08 02 b9 09 00 00 0

addrconf_dad_work is kicked to be scheduled when a device is brought
up. There is a race between addrcond_dad_work getting scheduled and
taking the rtnl lock and a process taking the link down (under rtnl).
The latter removes the host route from the inet6_addr as part of
addrconf_ifdown which is run for NETDEV_DOWN. The former attempts
to use the host route in __ipv6_ifa_notify. If the down event removes
the host route due to the race to the rtnl, then the BUG listed above
occurs.

Since the DAD sequence can not be aborted, add a check for the missing
host route in __ipv6_ifa_notify. The only way this should happen is due
to the previously mentioned race. The host route is created when the
address is added to an interface; it is only removed on a down event
where the address is kept. Add a warning if the host route is missing
AND the device is up; this is a situation that should never happen.

Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
Reported-by: Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5678,13 +5678,20 @@ static void __ipv6_ifa_notify(int event,
 	switch (event) {
 	case RTM_NEWADDR:
 		/*
-		 * If the address was optimistic
-		 * we inserted the route at the start of
-		 * our DAD process, so we don't need
-		 * to do it again
+		 * If the address was optimistic we inserted the route at the
+		 * start of our DAD process, so we don't need to do it again.
+		 * If the device was taken down in the middle of the DAD
+		 * cycle there is a race where we could get here without a
+		 * host route, so nothing to insert. That will be fixed when
+		 * the device is brought up.
 		 */
-		if (!rcu_access_pointer(ifp->rt->fib6_node))
+		if (ifp->rt && !rcu_access_pointer(ifp->rt->fib6_node)) {
 			ip6_ins_rt(net, ifp->rt);
+		} else if (!ifp->rt && (ifp->idev->dev->flags & IFF_UP)) {
+			pr_warn("BUG: Address %pI6c on device %s is missing its host route.\n",
+				&ifp->addr, ifp->idev->dev->name);
+		}
+
 		if (ifp->idev->cnf.forwarding)
 			addrconf_join_anycast(ifp);
 		if (!ipv6_addr_any(&ifp->peer_addr))


