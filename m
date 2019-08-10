Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B761888E5E
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfHJUyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:54:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53812 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbfHJUns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-00053j-6D; Sat, 10 Aug 2019 21:43:46 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003Zv-CT; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.490919960@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 031/157] dccp: do not use ipv6 header for ipv4 flow
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit e0aa67709f89d08c8d8e5bdd9e0b649df61d0090 upstream.

When a dual stack dccp listener accepts an ipv4 flow,
it should not attempt to use an ipv6 header or
inet6_iif() helper.

Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/dccp/ipv6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -491,8 +491,8 @@ static struct sock *dccp_v6_request_recv
 		newnp->ipv6_mc_list = NULL;
 		newnp->ipv6_ac_list = NULL;
 		newnp->ipv6_fl_list = NULL;
-		newnp->mcast_oif   = inet6_iif(skb);
-		newnp->mcast_hops  = ipv6_hdr(skb)->hop_limit;
+		newnp->mcast_oif   = inet_iif(skb);
+		newnp->mcast_hops  = ip_hdr(skb)->ttl;
 
 		/*
 		 * No need to charge this sock to the relevant IPv6 refcnt debug socks count

