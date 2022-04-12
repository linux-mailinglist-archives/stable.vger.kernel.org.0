Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644744FD03A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiDLGpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349876AbiDLGlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:41:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5A4167C0;
        Mon, 11 Apr 2022 23:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F0C2618C8;
        Tue, 12 Apr 2022 06:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC806C385A6;
        Tue, 12 Apr 2022 06:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745379;
        bh=QY4kv2XVS0BxmcE/hGWOj2tDEp7EWkcYggDdRGYPwjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wv+BmlxBCmLxzr55QwqCkl42foEFcT0vSMdlIzubjtpz3nffyvfPAKzwTjM5NGiFT
         q8ikz3FN2cCE7yRLYQPooFoLthGfYZuPazidZai63Ty0ZGqb8U0XhTq1nzMuaRGWYN
         ICUmUqDAey0l7TauTX5mCiRT/qm7m209WQDFgh/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Hai <wanghai38@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/171] ipv4: Invalidate neighbour for broadcast address upon address addition
Date:   Tue, 12 Apr 2022 08:28:47 +0200
Message-Id: <20220412062928.931730716@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 0c51e12e218f20b7d976158fdc18019627326f7a ]

In case user space sends a packet destined to a broadcast address when a
matching broadcast route is not configured, the kernel will create a
unicast neighbour entry that will never be resolved [1].

When the broadcast route is configured, the unicast neighbour entry will
not be invalidated and continue to linger, resulting in packets being
dropped.

Solve this by invalidating unresolved neighbour entries for broadcast
addresses after routes for these addresses are internally configured by
the kernel. This allows the kernel to create a broadcast neighbour entry
following the next route lookup.

Another possible solution that is more generic but also more complex is
to have the ARP code register a listener to the FIB notification chain
and invalidate matching neighbour entries upon the addition of broadcast
routes.

It is also possible to wave off the issue as a user space problem, but
it seems a bit excessive to expect user space to be that intimately
familiar with the inner workings of the FIB/neighbour kernel code.

[1] https://lore.kernel.org/netdev/55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com/

Reported-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/arp.h       | 1 +
 net/ipv4/arp.c          | 9 +++++++--
 net/ipv4/fib_frontend.c | 5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index 4950191f6b2b..4a23a97195f3 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -71,6 +71,7 @@ void arp_send(int type, int ptype, __be32 dest_ip,
 	      const unsigned char *src_hw, const unsigned char *th);
 int arp_mc_map(__be32 addr, u8 *haddr, struct net_device *dev, int dir);
 void arp_ifdown(struct net_device *dev);
+int arp_invalidate(struct net_device *dev, __be32 ip, bool force);
 
 struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
 			   struct net_device *dev, __be32 src_ip,
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 922dd73e5740..83a47998c4b1 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1116,13 +1116,18 @@ static int arp_req_get(struct arpreq *r, struct net_device *dev)
 	return err;
 }
 
-static int arp_invalidate(struct net_device *dev, __be32 ip)
+int arp_invalidate(struct net_device *dev, __be32 ip, bool force)
 {
 	struct neighbour *neigh = neigh_lookup(&arp_tbl, &ip, dev);
 	int err = -ENXIO;
 	struct neigh_table *tbl = &arp_tbl;
 
 	if (neigh) {
+		if ((neigh->nud_state & NUD_VALID) && !force) {
+			neigh_release(neigh);
+			return 0;
+		}
+
 		if (neigh->nud_state & ~NUD_NOARP)
 			err = neigh_update(neigh, NULL, NUD_FAILED,
 					   NEIGH_UPDATE_F_OVERRIDE|
@@ -1169,7 +1174,7 @@ static int arp_req_delete(struct net *net, struct arpreq *r,
 		if (!dev)
 			return -EINVAL;
 	}
-	return arp_invalidate(dev, ip);
+	return arp_invalidate(dev, ip, true);
 }
 
 /*
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 917ea953dfad..0df4594b49c7 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1112,9 +1112,11 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 		return;
 
 	/* Add broadcast address, if it is explicitly assigned. */
-	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF))
+	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF)) {
 		fib_magic(RTM_NEWROUTE, RTN_BROADCAST, ifa->ifa_broadcast, 32,
 			  prim, 0);
+		arp_invalidate(dev, ifa->ifa_broadcast, false);
+	}
 
 	if (!ipv4_is_zeronet(prefix) && !(ifa->ifa_flags & IFA_F_SECONDARY) &&
 	    (prefix != addr || ifa->ifa_prefixlen < 32)) {
@@ -1130,6 +1132,7 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 				  prim, 0);
 			fib_magic(RTM_NEWROUTE, RTN_BROADCAST, prefix | ~mask,
 				  32, prim, 0);
+			arp_invalidate(dev, prefix | ~mask, false);
 		}
 	}
 }
-- 
2.35.1



