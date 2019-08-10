Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A897188E75
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfHJUnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:43:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53720 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726024AbfHJUnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:47 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-00052p-FI; Sat, 10 Aug 2019 21:43:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003XW-9v; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Xin Long" <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.259330882@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 001/157] ipv6: check sk sk_type and protocol early in
 ip_mroute_set/getsockopt
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

From: Xin Long <lucien.xin@gmail.com>

commit 99253eb750fda6a644d5188fb26c43bad8d5a745 upstream.

Commit 5e1859fbcc3c ("ipv4: ipmr: various fixes and cleanups") fixed
the issue for ipv4 ipmr:

  ip_mroute_setsockopt() & ip_mroute_getsockopt() should not
  access/set raw_sk(sk)->ipmr_table before making sure the socket
  is a raw socket, and protocol is IGMP

The same fix should be done for ipv6 ipmr as well.

This patch can fix the panic caused by overwriting the same offset
as ipmr_table as in raw_sk(sk) when accessing other type's socket
by ip_mroute_setsockopt().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/ip6mr.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1662,6 +1662,10 @@ int ip6_mroute_setsockopt(struct sock *s
 	struct net *net = sock_net(sk);
 	struct mr6_table *mrt;
 
+	if (sk->sk_type != SOCK_RAW ||
+	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
+		return -EOPNOTSUPP;
+
 	mrt = ip6mr_get_table(net, raw6_sk(sk)->ip6mr_table ? : RT6_TABLE_DFLT);
 	if (mrt == NULL)
 		return -ENOENT;
@@ -1673,9 +1677,6 @@ int ip6_mroute_setsockopt(struct sock *s
 
 	switch (optname) {
 	case MRT6_INIT:
-		if (sk->sk_type != SOCK_RAW ||
-		    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
-			return -EOPNOTSUPP;
 		if (optlen < sizeof(int))
 			return -EINVAL;
 
@@ -1812,6 +1813,10 @@ int ip6_mroute_getsockopt(struct sock *s
 	struct net *net = sock_net(sk);
 	struct mr6_table *mrt;
 
+	if (sk->sk_type != SOCK_RAW ||
+	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
+		return -EOPNOTSUPP;
+
 	mrt = ip6mr_get_table(net, raw6_sk(sk)->ip6mr_table ? : RT6_TABLE_DFLT);
 	if (mrt == NULL)
 		return -ENOENT;

