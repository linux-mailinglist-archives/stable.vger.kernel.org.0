Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DF21A0B8E
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgDGK0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728674AbgDGK0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:26:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4999D20644;
        Tue,  7 Apr 2020 10:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255207;
        bh=hhDMd2q+B4foZzqScTF1hMGEB0eCBYKc70Dio+EMIDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MApSaScDdmZLGsssCtB/+ptA2pAH0wfLx5E0oTine36EOsr4zh4BuczfYceMd70bW
         cMvAOEggv0WE1Gp8Zhqkufnj1xmOTtQb/ayhSkUN9fAigDcnwOEchE6CFZlMlJLdgO
         ZKBybD25P9uNy81fOTZPBIfGu+MG5GylvygoyuVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Meng <meng.a.jin@nokia-sbell.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 04/29] sctp: fix possibly using a bad saddr with a given dst
Date:   Tue,  7 Apr 2020 12:22:01 +0200
Message-Id: <20200407101452.516112496@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
References: <20200407101452.046058399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 582eea230536a6f104097dd46205822005d5fe3a ]

Under certain circumstances, depending on the order of addresses on the
interfaces, it could be that sctp_v[46]_get_dst() would return a dst
with a mismatched struct flowi.

For example, if when walking through the bind addresses and the first
one is not a match, it saves the dst as a fallback (added in
410f03831c07), but not the flowi. Then if the next one is also not a
match, the previous dst will be returned but with the flowi information
for the 2nd address, which is wrong.

The fix is to use a locally stored flowi that can be used for such
attempts, and copy it to the parameter only in case it is a possible
match, together with the corresponding dst entry.

The patch updates IPv6 code mostly just to be in sync. Even though the issue
is also present there, it fallback is not expected to work with IPv6.

Fixes: 410f03831c07 ("sctp: add routing output fallback")
Reported-by: Jin Meng <meng.a.jin@nokia-sbell.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Tested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/ipv6.c     |   20 ++++++++++++++------
 net/sctp/protocol.c |   28 +++++++++++++++++++---------
 2 files changed, 33 insertions(+), 15 deletions(-)

--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -228,7 +228,8 @@ static void sctp_v6_get_dst(struct sctp_
 {
 	struct sctp_association *asoc = t->asoc;
 	struct dst_entry *dst = NULL;
-	struct flowi6 *fl6 = &fl->u.ip6;
+	struct flowi _fl;
+	struct flowi6 *fl6 = &_fl.u.ip6;
 	struct sctp_bind_addr *bp;
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sctp_sockaddr_entry *laddr;
@@ -238,7 +239,7 @@ static void sctp_v6_get_dst(struct sctp_
 	enum sctp_scope scope;
 	__u8 matchlen = 0;
 
-	memset(fl6, 0, sizeof(struct flowi6));
+	memset(&_fl, 0, sizeof(_fl));
 	fl6->daddr = daddr->v6.sin6_addr;
 	fl6->fl6_dport = daddr->v6.sin6_port;
 	fl6->flowi6_proto = IPPROTO_SCTP;
@@ -276,8 +277,11 @@ static void sctp_v6_get_dst(struct sctp_
 	rcu_read_unlock();
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
-	if (!asoc || saddr)
+	if (!asoc || saddr) {
+		t->dst = dst;
+		memcpy(fl, &_fl, sizeof(_fl));
 		goto out;
+	}
 
 	bp = &asoc->base.bind_addr;
 	scope = sctp_scope(daddr);
@@ -300,6 +304,8 @@ static void sctp_v6_get_dst(struct sctp_
 			if ((laddr->a.sa.sa_family == AF_INET6) &&
 			    (sctp_v6_cmp_addr(&dst_saddr, &laddr->a))) {
 				rcu_read_unlock();
+				t->dst = dst;
+				memcpy(fl, &_fl, sizeof(_fl));
 				goto out;
 			}
 		}
@@ -338,6 +344,8 @@ static void sctp_v6_get_dst(struct sctp_
 			if (!IS_ERR_OR_NULL(dst))
 				dst_release(dst);
 			dst = bdst;
+			t->dst = dst;
+			memcpy(fl, &_fl, sizeof(_fl));
 			break;
 		}
 
@@ -351,6 +359,8 @@ static void sctp_v6_get_dst(struct sctp_
 			dst_release(dst);
 		dst = bdst;
 		matchlen = bmatchlen;
+		t->dst = dst;
+		memcpy(fl, &_fl, sizeof(_fl));
 	}
 	rcu_read_unlock();
 
@@ -359,14 +369,12 @@ out:
 		struct rt6_info *rt;
 
 		rt = (struct rt6_info *)dst;
-		t->dst = dst;
 		t->dst_cookie = rt6_get_cookie(rt);
 		pr_debug("rt6_dst:%pI6/%d rt6_src:%pI6\n",
 			 &rt->rt6i_dst.addr, rt->rt6i_dst.plen,
-			 &fl6->saddr);
+			 &fl->u.ip6.saddr);
 	} else {
 		t->dst = NULL;
-
 		pr_debug("no route\n");
 	}
 }
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -409,7 +409,8 @@ static void sctp_v4_get_dst(struct sctp_
 {
 	struct sctp_association *asoc = t->asoc;
 	struct rtable *rt;
-	struct flowi4 *fl4 = &fl->u.ip4;
+	struct flowi _fl;
+	struct flowi4 *fl4 = &_fl.u.ip4;
 	struct sctp_bind_addr *bp;
 	struct sctp_sockaddr_entry *laddr;
 	struct dst_entry *dst = NULL;
@@ -419,7 +420,7 @@ static void sctp_v4_get_dst(struct sctp_
 
 	if (t->dscp & SCTP_DSCP_SET_MASK)
 		tos = t->dscp & SCTP_DSCP_VAL_MASK;
-	memset(fl4, 0x0, sizeof(struct flowi4));
+	memset(&_fl, 0x0, sizeof(_fl));
 	fl4->daddr  = daddr->v4.sin_addr.s_addr;
 	fl4->fl4_dport = daddr->v4.sin_port;
 	fl4->flowi4_proto = IPPROTO_SCTP;
@@ -438,8 +439,11 @@ static void sctp_v4_get_dst(struct sctp_
 		 &fl4->saddr);
 
 	rt = ip_route_output_key(sock_net(sk), fl4);
-	if (!IS_ERR(rt))
+	if (!IS_ERR(rt)) {
 		dst = &rt->dst;
+		t->dst = dst;
+		memcpy(fl, &_fl, sizeof(_fl));
+	}
 
 	/* If there is no association or if a source address is passed, no
 	 * more validation is required.
@@ -502,27 +506,33 @@ static void sctp_v4_get_dst(struct sctp_
 		odev = __ip_dev_find(sock_net(sk), laddr->a.v4.sin_addr.s_addr,
 				     false);
 		if (!odev || odev->ifindex != fl4->flowi4_oif) {
-			if (!dst)
+			if (!dst) {
 				dst = &rt->dst;
-			else
+				t->dst = dst;
+				memcpy(fl, &_fl, sizeof(_fl));
+			} else {
 				dst_release(&rt->dst);
+			}
 			continue;
 		}
 
 		dst_release(dst);
 		dst = &rt->dst;
+		t->dst = dst;
+		memcpy(fl, &_fl, sizeof(_fl));
 		break;
 	}
 
 out_unlock:
 	rcu_read_unlock();
 out:
-	t->dst = dst;
-	if (dst)
+	if (dst) {
 		pr_debug("rt_dst:%pI4, rt_src:%pI4\n",
-			 &fl4->daddr, &fl4->saddr);
-	else
+			 &fl->u.ip4.daddr, &fl->u.ip4.saddr);
+	} else {
+		t->dst = NULL;
 		pr_debug("no route\n");
+	}
 }
 
 /* For v4, the source address is cached in the route entry(dst). So no need


