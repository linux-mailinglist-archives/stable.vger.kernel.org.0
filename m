Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90885316F7
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241346AbiEWRfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241358AbiEWRdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:33:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3679279810;
        Mon, 23 May 2022 10:27:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFD8BB81204;
        Mon, 23 May 2022 17:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23149C385A9;
        Mon, 23 May 2022 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326866;
        bh=WsuSbAaIujyTIwrBD5apsAefDfG4Oh395kfYZcVJZF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0ZIaLVpFlZV3xPt1tYXH2SjiIPNhuuDqXhAl7cvBQ9ihCVriNgaH7HHYqJhdDYhQ
         BXS2T7D+PEyMAvhV7RoY3HNYfW1vj+ZLLeH7WOpjIUj4J2cyzpslQalBURfF4zPUjx
         dNlBfFtjTRG9TPrMcPplQSKDAMfEz/JnOg96q8WI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 083/158] xfrm: fix "disable_policy" flag use when arriving from different devices
Date:   Mon, 23 May 2022 19:04:00 +0200
Message-Id: <20220523165844.849740900@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit e6175a2ed1f18bf2f649625bf725e07adcfa6a28 ]

In IPv4 setting the "disable_policy" flag on a device means no policy
should be enforced for traffic originating from the device. This was
implemented by seting the DST_NOPOLICY flag in the dst based on the
originating device.

However, dsts are cached in nexthops regardless of the originating
devices, in which case, the DST_NOPOLICY flag value may be incorrect.

Consider the following setup:

                     +------------------------------+
                     | ROUTER                       |
  +-------------+    | +-----------------+          |
  | ipsec src   |----|-|ipsec0           |          |
  +-------------+    | |disable_policy=0 |   +----+ |
                     | +-----------------+   |eth1|-|-----
  +-------------+    | +-----------------+   +----+ |
  | noipsec src |----|-|eth0             |          |
  +-------------+    | |disable_policy=1 |          |
                     | +-----------------+          |
                     +------------------------------+

Where ROUTER has a default route towards eth1.

dst entries for traffic arriving from eth0 would have DST_NOPOLICY
and would be cached and therefore can be reused by traffic originating
from ipsec0, skipping policy check.

Fix by setting a IPSKB_NOPOLICY flag in IPCB and observing it instead
of the DST in IN/FWD IPv4 policy checks.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h   |  1 +
 include/net/xfrm.h | 14 +++++++++++++-
 net/ipv4/route.c   | 23 ++++++++++++++++++-----
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index b51bae43b0dd..9fba950fdf12 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -56,6 +56,7 @@ struct inet_skb_parm {
 #define IPSKB_DOREDIRECT	BIT(5)
 #define IPSKB_FRAG_PMTU		BIT(6)
 #define IPSKB_L3SLAVE		BIT(7)
+#define IPSKB_NOPOLICY		BIT(8)
 
 	u16			frag_max_size;
 };
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6fb899ff5afc..d2efddce65d4 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1093,6 +1093,18 @@ static inline bool __xfrm_check_nopolicy(struct net *net, struct sk_buff *skb,
 	return false;
 }
 
+static inline bool __xfrm_check_dev_nopolicy(struct sk_buff *skb,
+					     int dir, unsigned short family)
+{
+	if (dir != XFRM_POLICY_OUT && family == AF_INET) {
+		/* same dst may be used for traffic originating from
+		 * devices with different policy settings.
+		 */
+		return IPCB(skb)->flags & IPSKB_NOPOLICY;
+	}
+	return skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY);
+}
+
 static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 				       struct sk_buff *skb,
 				       unsigned int family, int reverse)
@@ -1104,7 +1116,7 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 		return __xfrm_policy_check(sk, ndir, skb, family);
 
 	return __xfrm_check_nopolicy(net, skb, dir) ||
-	       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
+	       __xfrm_check_dev_nopolicy(skb, dir, family) ||
 	       __xfrm_policy_check(sk, ndir, skb, family);
 }
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index eef07b62b2d8..1cdfac733bd8 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1721,6 +1721,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
 	unsigned int flags = RTCF_MULTICAST;
 	struct rtable *rth;
+	bool no_policy;
 	u32 itag = 0;
 	int err;
 
@@ -1731,8 +1732,12 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (our)
 		flags |= RTCF_LOCAL;
 
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	rth = rt_dst_alloc(dev_net(dev)->loopback_dev, flags, RTN_MULTICAST,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
+			   no_policy, false);
 	if (!rth)
 		return -ENOBUFS;
 
@@ -1791,7 +1796,7 @@ static int __mkroute_input(struct sk_buff *skb,
 	struct rtable *rth;
 	int err;
 	struct in_device *out_dev;
-	bool do_cache;
+	bool do_cache, no_policy;
 	u32 itag = 0;
 
 	/* get a working reference to the output device */
@@ -1836,6 +1841,10 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	fnhe = find_exception(nhc, daddr);
 	if (do_cache) {
 		if (fnhe)
@@ -1848,8 +1857,7 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
-	rth = rt_dst_alloc(out_dev->dev, 0, res->type,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY),
+	rth = rt_dst_alloc(out_dev->dev, 0, res->type, no_policy,
 			   IN_DEV_ORCONF(out_dev, NOXFRM));
 	if (!rth) {
 		err = -ENOBUFS;
@@ -2224,6 +2232,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct rtable	*rth;
 	struct flowi4	fl4;
 	bool do_cache = true;
+	bool no_policy;
 
 	/* IP on this device is disabled. */
 
@@ -2341,6 +2350,10 @@ out:	return err;
 	RT_CACHE_STAT_INC(in_brd);
 
 local_input:
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	do_cache &= res->fi && !itag;
 	if (do_cache) {
 		struct fib_nh_common *nhc = FIB_RES_NHC(*res);
@@ -2355,7 +2368,7 @@ out:	return err;
 
 	rth = rt_dst_alloc(ip_rt_get_dev(net, res),
 			   flags | RTCF_LOCAL, res->type,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
+			   no_policy, false);
 	if (!rth)
 		goto e_nobufs;
 
-- 
2.35.1



