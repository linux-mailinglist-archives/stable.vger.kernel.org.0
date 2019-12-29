Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B7C12C777
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbfL2RmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:42:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730278AbfL2RmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD9EE222D9;
        Sun, 29 Dec 2019 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641341;
        bh=cBgzuICka7qKRUpP1h9A+ypvW+9kuBWQNbxSyaJaqEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CefOZs2uQT0mX+ULoUiDKnFDwbB8VD8BDZyVntSbJQ85FT4kdrjO3VZJi0r+94R4Y
         AuoQVOLrsqUNluPPnfG80UXK7mtQHmqI6jt3YDQJUWwIHXrBwi3l8B5ONgMF7GCa7b
         YUGAORXztcs+/eQH6R+9trNdPldjyGLjQexsVCsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 018/434] neighbour: remove neigh_cleanup() method
Date:   Sun, 29 Dec 2019 18:21:11 +0100
Message-Id: <20191229172703.394318455@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f394722fb0d0f701119368959d7cd0ecbc46363a ]

neigh_cleanup() has not been used for seven years, and was a wrong design.

Messing with shared pointer in bond_neigh_init() without proper
memory barriers would at least trigger syzbot complains eventually.

It is time to remove this stuff.

Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    8 --------
 include/net/neighbour.h         |    1 -
 net/core/neighbour.c            |    3 ---
 3 files changed, 12 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3622,18 +3622,10 @@ static int bond_neigh_init(struct neighb
 		return 0;
 
 	parms.neigh_setup = NULL;
-	parms.neigh_cleanup = NULL;
 	ret = slave_ops->ndo_neigh_setup(slave->dev, &parms);
 	if (ret)
 		return ret;
 
-	/* Assign slave's neigh_cleanup to neighbour in case cleanup is called
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
@@ -72,7 +72,6 @@ struct neigh_parms {
 	struct net_device *dev;
 	struct list_head list;
 	int	(*neigh_setup)(struct neighbour *);
-	void	(*neigh_cleanup)(struct neighbour *);
 	struct neigh_table *tbl;
 
 	void	*sysctl_table;
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -98,9 +98,6 @@ static int neigh_blackhole(struct neighb
 
 static void neigh_cleanup_and_release(struct neighbour *neigh)
 {
-	if (neigh->parms->neigh_cleanup)
-		neigh->parms->neigh_cleanup(neigh);
-
 	trace_neigh_cleanup_and_release(neigh, 0);
 	__neigh_notify(neigh, RTM_DELNEIGH, 0, 0);
 	call_netevent_notifiers(NETEVENT_NEIGH_UPDATE, neigh);


