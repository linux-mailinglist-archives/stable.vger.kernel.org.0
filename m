Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317F224B814
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgHTLIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730909AbgHTKKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:10:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6859D2067C;
        Thu, 20 Aug 2020 10:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918224;
        bh=ghHQ8uxGEmM1g14tRjmI8nKfOmNVTf0mTKT1Pd66Dg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJ2O1LnnJUbSPI1CSbqD4CyjFZBodFkysZszQv8m5rv2+OptAeXgWYsWnhqkyqs2q
         kOu/8ORsO9f/5udBIj6Y5Wv+eTPAX7P5e1ZO60+uAyO7uGoNvT2UdOfBX+ISI9V0Ez
         fTZUmUvAlDHzgKjWAk4DBdbaAwoXK76L2zWfoFgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YangYuxi <yx.atom1@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 096/228] ipvs: allow connection reuse for unconfirmed conntrack
Date:   Thu, 20 Aug 2020 11:21:11 +0200
Message-Id: <20200820091612.423387804@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit f0a5e4d7a594e0fe237d3dfafb069bb82f80f42f ]

YangYuxi is reporting that connection reuse
is causing one-second delay when SYN hits
existing connection in TIME_WAIT state.
Such delay was added to give time to expire
both the IPVS connection and the corresponding
conntrack. This was considered a rare case
at that time but it is causing problem for
some environments such as Kubernetes.

As nf_conntrack_tcp_packet() can decide to
release the conntrack in TIME_WAIT state and
to replace it with a fresh NEW conntrack, we
can use this to allow rescheduling just by
tuning our check: if the conntrack is
confirmed we can not schedule it to different
real server and the one-second delay still
applies but if new conntrack was created,
we are free to select new real server without
any delays.

YangYuxi lists some of the problem reports:

- One second connection delay in masquerading mode:
https://marc.info/?t=151683118100004&r=1&w=2

- IPVS low throughput #70747
https://github.com/kubernetes/kubernetes/issues/70747

- Apache Bench can fill up ipvs service proxy in seconds #544
https://github.com/cloudnativelabs/kube-router/issues/544

- Additional 1s latency in `host -> service IP -> pod`
https://github.com/kubernetes/kubernetes/issues/90854

Fixes: f719e3754ee2 ("ipvs: drop first packet to redirect conntrack")
Co-developed-by: YangYuxi <yx.atom1@gmail.com>
Signed-off-by: YangYuxi <yx.atom1@gmail.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h             | 10 ++++------
 net/netfilter/ipvs/ip_vs_core.c | 12 +++++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index f4e5ac8aa3668..1fb79c78e2007 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1607,18 +1607,16 @@ static inline void ip_vs_conn_drop_conntrack(struct ip_vs_conn *cp)
 }
 #endif /* CONFIG_IP_VS_NFCT */
 
-/* Really using conntrack? */
-static inline bool ip_vs_conn_uses_conntrack(struct ip_vs_conn *cp,
-					     struct sk_buff *skb)
+/* Using old conntrack that can not be redirected to another real server? */
+static inline bool ip_vs_conn_uses_old_conntrack(struct ip_vs_conn *cp,
+						 struct sk_buff *skb)
 {
 #ifdef CONFIG_IP_VS_NFCT
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
-	if (!(cp->flags & IP_VS_CONN_F_NFCT))
-		return false;
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct)
+	if (ct && nf_ct_is_confirmed(ct))
 		return true;
 #endif
 	return false;
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 2156571455dbf..a95fe5fe9f046 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1916,14 +1916,14 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 
 	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
 	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
-		bool uses_ct = false, resched = false;
+		bool old_ct = false, resched = false;
 
 		if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
 		    unlikely(!atomic_read(&cp->dest->weight))) {
 			resched = true;
-			uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
+			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 		} else if (is_new_conn_expected(cp, conn_reuse_mode)) {
-			uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
+			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 			if (!atomic_read(&cp->n_control)) {
 				resched = true;
 			} else {
@@ -1931,15 +1931,17 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 				 * that uses conntrack while it is still
 				 * referenced by controlled connection(s).
 				 */
-				resched = !uses_ct;
+				resched = !old_ct;
 			}
 		}
 
 		if (resched) {
+			if (!old_ct)
+				cp->flags &= ~IP_VS_CONN_F_NFCT;
 			if (!atomic_read(&cp->n_control))
 				ip_vs_conn_expire_now(cp);
 			__ip_vs_conn_put(cp);
-			if (uses_ct)
+			if (old_ct)
 				return NF_DROP;
 			cp = NULL;
 		}
-- 
2.25.1



