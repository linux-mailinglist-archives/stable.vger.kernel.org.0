Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D431B690E
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgDWXUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48730 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728231AbgDWXGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:34 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvN-0004d7-LX; Fri, 24 Apr 2020 00:06:29 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-00E6kV-FP; Fri, 24 Apr 2020 00:06:27 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 24 Apr 2020 00:05:03 +0100
Message-ID: <lsq.1587683028.6911736@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 076/245] neighbour: remove neigh_cleanup() method
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit f394722fb0d0f701119368959d7cd0ecbc46363a upstream.

neigh_cleanup() has not been used for seven years, and was a wrong design.

Messing with shared pointer in bond_neigh_init() without proper
memory barriers would at least trigger syzbot complains eventually.

It is time to remove this stuff.

Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3431,19 +3431,10 @@ static int bond_neigh_init(struct neighb
 		return 0;
 
 	parms.neigh_setup = NULL;
-	parms.neigh_cleanup = NULL;
 	ret = slave_ops->ndo_neigh_setup(slave->dev, &parms);
 	if (ret)
 		return ret;
 
-	/*
-	 * Assign slave's neigh_cleanup to neighbour in case cleanup is called
-	 * after the last slave has been detached.  Assumes that all slaves
-	 * utilize the same neigh_cleanup (true at this writing as only user
-	 * is ipoib).
-	 */
-	n->parms->neigh_cleanup = parms.neigh_cleanup;
-
 	if (!parms.neigh_setup)
 		return 0;
 
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -71,7 +71,6 @@ struct neigh_parms {
 	struct net_device *dev;
 	struct neigh_parms *next;
 	int	(*neigh_setup)(struct neighbour *);
-	void	(*neigh_cleanup)(struct neighbour *);
 	struct neigh_table *tbl;
 
 	void	*sysctl_table;
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -103,9 +103,6 @@ static int neigh_blackhole(struct neighb
 
 static void neigh_cleanup_and_release(struct neighbour *neigh)
 {
-	if (neigh->parms->neigh_cleanup)
-		neigh->parms->neigh_cleanup(neigh);
-
 	__neigh_notify(neigh, RTM_DELNEIGH, 0);
 	neigh_release(neigh);
 }

