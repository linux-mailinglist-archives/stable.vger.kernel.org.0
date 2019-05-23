Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820DA28840
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390814AbfEWTYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390455AbfEWTYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:24:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D80CE20868;
        Thu, 23 May 2019 19:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639441;
        bh=3LCnykdvczOHiMlWD1ftBlEW8L15TV0zrYb9NTJ2fds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUD80yJxNKC/K3Zy03aU80WrAddJi/ezLVsf40NvM3skYWL1F5kHoIJdacdqcA6DR
         Fr2I84lYH+A0V3VRnAVmO7/5EefzROaUuHHZb7zcETakGuUW+10U1l67kMsqncLd8a
         sw/v5dCPTN29S3IUpFAWQYGGq5PEJfK3JZBVWJV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 106/139] xfrm: Honor original L3 slave device in xfrmi policy lookup
Date:   Thu, 23 May 2019 21:06:34 +0200
Message-Id: <20190523181734.066870227@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
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
index 902437dfbce77..c9b0b2b5d672f 100644
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
index dbb3c1945b5c9..85fec98676d34 100644
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
index 8d1a898d0ba56..a6b58df7a70f6 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3313,7 +3313,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	ifcb = xfrm_if_get_cb();
 
 	if (ifcb) {
-		xi = ifcb->decode_session(skb);
+		xi = ifcb->decode_session(skb, family);
 		if (xi) {
 			if_id = xi->p.if_id;
 			net = xi->net;
-- 
2.20.1



