Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C141289DA
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389691AbfEWTSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389313AbfEWTSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:18:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B32172133D;
        Thu, 23 May 2019 19:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639129;
        bh=b0VwoUslq5QPp9NlJd1ruUUqXSpc2qq2oRT1XJaKvXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GcOB60ymrOxPmosR2jV4+xjFgmQkmYi6LSiEO8VPR8Idd8OQuSdG5lmUUnBcSjHe
         bWxlmWp2bTD5bdC9aHD7rtsYoHerD28pLEVl3qa6+SLEyyVdqAZXAiXvj8DtQmPkqD
         ZS1c6ZuG9ayha03daXTm55MDpzyvs7ydtF9Wx8dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/114] xfrm: Honor original L3 slave device in xfrmi policy lookup
Date:   Thu, 23 May 2019 21:06:27 +0200
Message-Id: <20190523181739.547636418@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 025c65e119bf58b610549ca359c9ecc5dee6a8d2 ]

If an xfrmi is associated to a vrf layer 3 master device,
xfrm_policy_check() fails after traffic decapsulation. The input
interface is replaced by the layer 3 master device, and hence
xfrmi_decode_session() can't match the xfrmi anymore to satisfy
policy checking.

Extend ingress xfrmi lookup to honor the original layer 3 slave
device, allowing xfrm interfaces to operate within a vrf domain.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h        |  3 ++-
 net/xfrm/xfrm_interface.c | 17 ++++++++++++++---
 net/xfrm/xfrm_policy.c    |  2 +-
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 3e966c632f3b2..4ddd2b13ac8d6 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -295,7 +295,8 @@ struct xfrm_replay {
 };
 
 struct xfrm_if_cb {
-	struct xfrm_if	*(*decode_session)(struct sk_buff *skb);
+	struct xfrm_if	*(*decode_session)(struct sk_buff *skb,
+					   unsigned short family);
 };
 
 void xfrm_if_register_cb(const struct xfrm_if_cb *ifcb);
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 82723ef44db3e..555ee2aca6c01 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -70,17 +70,28 @@ static struct xfrm_if *xfrmi_lookup(struct net *net, struct xfrm_state *x)
 	return NULL;
 }
 
-static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb)
+static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
+					    unsigned short family)
 {
 	struct xfrmi_net *xfrmn;
-	int ifindex;
 	struct xfrm_if *xi;
+	int ifindex = 0;
 
 	if (!secpath_exists(skb) || !skb->dev)
 		return NULL;
 
+	switch (family) {
+	case AF_INET6:
+		ifindex = inet6_sdif(skb);
+		break;
+	case AF_INET:
+		ifindex = inet_sdif(skb);
+		break;
+	}
+	if (!ifindex)
+		ifindex = skb->dev->ifindex;
+
 	xfrmn = net_generic(xs_net(xfrm_input_state(skb)), xfrmi_net_id);
-	ifindex = skb->dev->ifindex;
 
 	for_each_xfrmi_rcu(xfrmn->xfrmi[0], xi) {
 		if (ifindex == xi->dev->ifindex &&
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index bf5d59270f79d..ce1b262ce9646 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2339,7 +2339,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	ifcb = xfrm_if_get_cb();
 
 	if (ifcb) {
-		xi = ifcb->decode_session(skb);
+		xi = ifcb->decode_session(skb, family);
 		if (xi) {
 			if_id = xi->p.if_id;
 			net = xi->net;
-- 
2.20.1



