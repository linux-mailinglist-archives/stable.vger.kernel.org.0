Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BE93D317C
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 04:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhGWBUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 21:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbhGWBUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 21:20:14 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788E9C061575
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 19:00:47 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m1so118206pjv.2
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 19:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=khYibZzO/7qTHyYBA46ONh8Or9EAp8/F0mFqntwNy14=;
        b=QIbCPDe8s/2d0TcdWeflQmaAu7IRTLbJXWJYrY+T0CQQ/uagAjjTF/BPgV/cumQ6eU
         Gzvt/8hOzSQrEh6cJMlCYa+csg4ZRzLkQ+rM8tUYIK+w+x+3yA0qURMSXeYE9+WzwAf1
         nsqrEu8ffsPXmo+Cx/946r+20a58hJny2UKHdIYed/TyjgdEIFFHjOjoph2VO/Y2/wvr
         dNHpcsuYW21QSisxXR0hEuYJ0uaGgSqCM7+D58UT91b2PY1o6HonIFI0ofD+lbwi+mFU
         ZbkVzTCE0CpGUCRuZJZc/o5Xft+TikIFzso40YgJhjqbglKdeoqFBtF7MfJckACginMP
         7aSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=khYibZzO/7qTHyYBA46ONh8Or9EAp8/F0mFqntwNy14=;
        b=qoXa0jM5d5q4hACiEPjSrTcSx5b8F3g5UDKyEpnuDwBgMlfkhmYZwQd8XHx/A4BOBY
         YMCqSEmJjSW6OAIgtmfzgCMQzeOTqKZqTSUn4tEyoCl5OTZNFXNbClKr7KKoviVFTOsO
         QK9IEnXzVx1d1kC0BqHd14TnXEc1WcGF9XiZZ1SxhRGyeFCfb+Q5pGGBxKmO+54UupHm
         S9T884pLOvMrT0X9CjdTobc37pknpq2MQrPtiXQYaDm9gRatag/Nz4x2bTt+XDkFF8L4
         YW8zIiCJD6ydjU1KphnkKxC0mf+sjcqoA4ZbhUJwOHF7ujds539jlD7RLUj12b0st7EP
         dQCw==
X-Gm-Message-State: AOAM533gcWe6JVG/tekS/F3CdSp/NM4UTyEd22S31hzEtUN+7tl/aOeM
        5tKlLFy1l90Z2tpT8ZmZFJBpgHzBgE7FxNNK
X-Google-Smtp-Source: ABdhPJznoNp5t33dnDSZLhR5DkP4YoWXVDHKIuMUVMaemJ+LElg9CLFP9BqB2FnaMhdDYGBJW0oXtw==
X-Received: by 2002:a17:90a:9b13:: with SMTP id f19mr2395468pjp.229.1627005646818;
        Thu, 22 Jul 2021 19:00:46 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id kz18sm26892174pjb.49.2021.07.22.19.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 19:00:46 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, davem@davemloft.net, jishi@redhat.com,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH 4.19] net: ip_tunnel: fix mtu calculation for ETHER tunnel devices
Date:   Fri, 23 Jul 2021 10:00:31 +0800
Message-Id: <20210723020031.343268-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1626967494217153@kroah.com>
References: <1626967494217153@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9992a078b1771da354ac1f9737e1e639b687caa2 upstream.

Commit 28e104d00281 ("net: ip_tunnel: fix mtu calculation") removed
dev->hard_header_len subtraction when calculate MTU for tunnel devices
as there is an overhead for device that has header_ops.

But there are ETHER tunnel devices, like gre_tap or erspan, which don't
have header_ops but set dev->hard_header_len during setup. This makes
pkts greater than (MTU - ETH_HLEN) could not be xmited. Fix it by
subtracting the ETHER tunnel devices' dev->hard_header_len for MTU
calculation.

Fixes: 28e104d00281 ("net: ip_tunnel: fix mtu calculation")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/ip_tunnel.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index bdd073ea300a..30e93b4f831f 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -330,7 +330,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 	}
 
 	dev->needed_headroom = t_hlen + hlen;
-	mtu -= t_hlen;
+	mtu -= t_hlen + (dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0);
 
 	if (mtu < IPV4_MIN_MTU)
 		mtu = IPV4_MIN_MTU;
@@ -361,6 +361,9 @@ static struct ip_tunnel *ip_tunnel_create(struct net *net,
 	t_hlen = nt->hlen + sizeof(struct iphdr);
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = IP_MAX_MTU - t_hlen;
+	if (dev->type == ARPHRD_ETHER)
+		dev->max_mtu -= dev->hard_header_len;
+
 	ip_tunnel_add(itn, nt);
 	return nt;
 
@@ -502,13 +505,18 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 			    const struct iphdr *inner_iph)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
-	int pkt_size = skb->len - tunnel->hlen;
+	int pkt_size;
 	int mtu;
 
-	if (df)
+	pkt_size = skb->len - tunnel->hlen;
+	pkt_size -= dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0;
+
+	if (df) {
 		mtu = dst_mtu(&rt->dst) - (sizeof(struct iphdr) + tunnel->hlen);
-	else
+		mtu -= dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0;
+	} else {
 		mtu = skb_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
+	}
 
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
 
@@ -936,6 +944,9 @@ int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict)
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 	int max_mtu = IP_MAX_MTU - t_hlen;
 
+	if (dev->type == ARPHRD_ETHER)
+		max_mtu -= dev->hard_header_len;
+
 	if (new_mtu < ETH_MIN_MTU)
 		return -EINVAL;
 
@@ -1113,6 +1124,9 @@ int ip_tunnel_newlink(struct net_device *dev, struct nlattr *tb[],
 	if (tb[IFLA_MTU]) {
 		unsigned int max = IP_MAX_MTU - (nt->hlen + sizeof(struct iphdr));
 
+		if (dev->type == ARPHRD_ETHER)
+			max -= dev->hard_header_len;
+
 		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU, max);
 	}
 
-- 
2.18.1

