Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447047F128
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbfHBJge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729530AbfHBJge (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:36:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC9820679;
        Fri,  2 Aug 2019 09:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738593;
        bh=VgkyJWjxi4/ryR8FqLPpV4vveEySu8OOX5bC331V+n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaMtk0S1Ck/N1gcTw0FWPx30yquxt3nnoPhHsxFEeyFO+LD8UtD7J6ik78osyOQsB
         4p4WjjCY5N13DJFkS8tEEGr8aWerOWtN3mHdZCzw2XodAYMCxSOuunMkTkqG1A56SI
         b8TXjeoNIh97Ewc8WoaSsLCpm517Y1O8XKrQBJx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 150/158] ipv6: check sk sk_type and protocol early in ip_mroute_set/getsockopt
Date:   Fri,  2 Aug 2019 11:29:31 +0200
Message-Id: <20190802092232.662779783@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 99253eb750fda6a644d5188fb26c43bad8d5a745 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6mr.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1666,6 +1666,10 @@ int ip6_mroute_setsockopt(struct sock *s
 	struct net *net = sock_net(sk);
 	struct mr6_table *mrt;
 
+	if (sk->sk_type != SOCK_RAW ||
+	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
+		return -EOPNOTSUPP;
+
 	mrt = ip6mr_get_table(net, raw6_sk(sk)->ip6mr_table ? : RT6_TABLE_DFLT);
 	if (!mrt)
 		return -ENOENT;
@@ -1677,9 +1681,6 @@ int ip6_mroute_setsockopt(struct sock *s
 
 	switch (optname) {
 	case MRT6_INIT:
-		if (sk->sk_type != SOCK_RAW ||
-		    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
-			return -EOPNOTSUPP;
 		if (optlen < sizeof(int))
 			return -EINVAL;
 
@@ -1816,6 +1817,10 @@ int ip6_mroute_getsockopt(struct sock *s
 	struct net *net = sock_net(sk);
 	struct mr6_table *mrt;
 
+	if (sk->sk_type != SOCK_RAW ||
+	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
+		return -EOPNOTSUPP;
+
 	mrt = ip6mr_get_table(net, raw6_sk(sk)->ip6mr_table ? : RT6_TABLE_DFLT);
 	if (!mrt)
 		return -ENOENT;


