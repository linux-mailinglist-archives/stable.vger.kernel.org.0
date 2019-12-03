Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9467C111E6E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbfLCWzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:55:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730267AbfLCWzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:55:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DCA320674;
        Tue,  3 Dec 2019 22:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413719;
        bh=1iCYYouaItMbER6bksKCfjllwJWyolJzIHzovLyWJVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dT6sV43npYFqeoVCxZ4MUDdnK5OYtsoXdXXLRMnSwwPquK6XzHOknZMD9A3Y1y06r
         yqJKQKR0zX0CeVIFqd25xqH7TFawM2MTD4P8XY6e8zI3vCrfDnpzmXre1wxl+4Xch/
         kjFbFxALL4dyCaklIAEyzLgGLbZZnD2m70q+sksQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 236/321] net: ip_gre: do not report erspan_ver for gre or gretap
Date:   Tue,  3 Dec 2019 23:35:02 +0100
Message-Id: <20191203223439.408664471@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit 2bdf700e538828d6456150b9319e5f689b062d54 ]

Report erspan version field to userspace in ipgre_fill_info just for
erspan tunnels. The issue can be triggered with the following reproducer:

$ip link add name gre1 type gre local 192.168.0.1 remote 192.168.1.1
$ip link set dev gre1 up
$ip -d link sh gre1
13: gre1@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1476 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/gre 192.168.0.1 peer 192.168.1.1 promiscuity 0 minmtu 0 maxmtu 0
    gre remote 192.168.1.1 local 192.168.0.1 ttl inherit erspan_ver 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1

Fixes: f551c91de262 ("net: erspan: introduce erspan v2 for ip_gre")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 681276111310b..a3f77441f3e69 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1466,9 +1466,23 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct ip_tunnel_parm *p = &t->parms;
 	__be16 o_flags = p->o_flags;
 
-	if ((t->erspan_ver == 1 || t->erspan_ver == 2) &&
-	    !t->collect_md)
-		o_flags |= TUNNEL_KEY;
+	if (t->erspan_ver == 1 || t->erspan_ver == 2) {
+		if (!t->collect_md)
+			o_flags |= TUNNEL_KEY;
+
+		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
+			goto nla_put_failure;
+
+		if (t->erspan_ver == 1) {
+			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
+				goto nla_put_failure;
+		} else {
+			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
+				goto nla_put_failure;
+			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
+				goto nla_put_failure;
+		}
+	}
 
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
@@ -1504,19 +1518,6 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 			goto nla_put_failure;
 	}
 
-	if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
-		goto nla_put_failure;
-
-	if (t->erspan_ver == 1) {
-		if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
-			goto nla_put_failure;
-	} else if (t->erspan_ver == 2) {
-		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
-			goto nla_put_failure;
-		if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
-			goto nla_put_failure;
-	}
-
 	return 0;
 
 nla_put_failure:
-- 
2.20.1



