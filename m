Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E46B35BD1B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbhDLIrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237937AbhDLIqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:46:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A630961220;
        Mon, 12 Apr 2021 08:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217185;
        bh=pBiuFMJPzf4Rp6C7xa3pnOi72vsJAVTLQTbict89G2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6IpSMIuttD6MJm+z8P+X4yCLxqkQqBi33lmsUjDMlfD5qHFc4IfgHXwV2vsU0gBm
         JMR08hHhS3ybU/OdIN58OlrHRQ/4daN+fI0eIXqRSMyrvLqsabKk5OrCOVFBFowMZp
         85ENiwtDfSr5dsfcIVxT7bWigm75wsuZAYQViVZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 034/111] net-ipv6: bugfix - raw & sctp - switch to ipv6_can_nonlocal_bind()
Date:   Mon, 12 Apr 2021 10:40:12 +0200
Message-Id: <20210412084005.390427833@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

commit 630e4576f83accf90366686f39808d665d8dbecc upstream.

Found by virtue of ipv6 raw sockets not honouring the per-socket
IP{,V6}_FREEBIND setting.

Based on hits found via:
  git grep '[.]ip_nonlocal_bind'
We fix both raw ipv6 sockets to honour IP{,V6}_FREEBIND and IP{,V6}_TRANSPARENT,
and we fix sctp sockets to honour IP{,V6}_TRANSPARENT (they already honoured
FREEBIND), and not just the ipv6 'ip_nonlocal_bind' sysctl.

The helper is defined as:
  static inline bool ipv6_can_nonlocal_bind(struct net *net, struct inet_sock *inet) {
    return net->ipv6.sysctl.ip_nonlocal_bind || inet->freebind || inet->transparent;
  }
so this change only widens the accepted opt-outs and is thus a clean bugfix.

I'm not entirely sure what 'fixes' tag to add, since this is AFAICT an ancient bug,
but IMHO this should be applied to stable kernels as far back as possible.
As such I'm adding a 'fixes' tag with the commit that originally added the helper,
which happened in 4.19.  Backporting to older LTS kernels (at least 4.9 and 4.14)
would presumably require open-coding it or backporting the helper as well.

Other possibly relevant commits:
  v4.18-rc6-1502-g83ba4645152d net: add helpers checking if socket can be bound to nonlocal address
  v4.18-rc6-1431-gd0c1f01138c4 net/ipv6: allow any source address for sendmsg pktinfo with ip_nonlocal_bind
  v4.14-rc5-271-gb71d21c274ef sctp: full support for ipv6 ip_nonlocal_bind & IP_FREEBIND
  v4.7-rc7-1883-g9b9742022888 sctp: support ipv6 nonlocal bind
  v4.1-12247-g35a256fee52c ipv6: Nonlocal bind

Cc: Lorenzo Colitti <lorenzo@google.com>
Fixes: 83ba4645152d ("net: add helpers checking if socket can be bound to nonlocal address")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Reviewed-By: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/raw.c  |    2 +-
 net/sctp/ipv6.c |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -298,7 +298,7 @@ static int rawv6_bind(struct sock *sk, s
 		 */
 		v4addr = LOOPBACK4_IPV6;
 		if (!(addr_type & IPV6_ADDR_MULTICAST) &&
-		    !sock_net(sk)->ipv6.sysctl.ip_nonlocal_bind) {
+		    !ipv6_can_nonlocal_bind(sock_net(sk), inet)) {
 			err = -EADDRNOTAVAIL;
 			if (!ipv6_chk_addr(sock_net(sk), &addr->sin6_addr,
 					   dev, 0)) {
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -643,8 +643,8 @@ static int sctp_v6_available(union sctp_
 	if (!(type & IPV6_ADDR_UNICAST))
 		return 0;
 
-	return sp->inet.freebind || net->ipv6.sysctl.ip_nonlocal_bind ||
-		ipv6_chk_addr(net, in6, NULL, 0);
+	return ipv6_can_nonlocal_bind(net, &sp->inet) ||
+	       ipv6_chk_addr(net, in6, NULL, 0);
 }
 
 /* This function checks if the address is a valid address to be used for
@@ -933,8 +933,7 @@ static int sctp_inet6_bind_verify(struct
 			net = sock_net(&opt->inet.sk);
 			rcu_read_lock();
 			dev = dev_get_by_index_rcu(net, addr->v6.sin6_scope_id);
-			if (!dev || !(opt->inet.freebind ||
-				      net->ipv6.sysctl.ip_nonlocal_bind ||
+			if (!dev || !(ipv6_can_nonlocal_bind(net, &opt->inet) ||
 				      ipv6_chk_addr(net, &addr->v6.sin6_addr,
 						    dev, 0))) {
 				rcu_read_unlock();


