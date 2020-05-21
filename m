Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A0D1DDB6E
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbgEUX6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:15 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC2EC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:14 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id g15so8868646qvx.6
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gqASSjb9luK5ttprYOR2fG7EzqfVt33wKQt+HICuTFM=;
        b=LDo+EDZl3a/EoSttKsSHia8wxzDMnWPoDKYmSE57h/zF5TJURu2D5dFo/YZqF7XC8p
         /g59SFh9nfmQrLTb4qvsWHuHsu2tFSkdnNYldXPvQdpE6uWFCxeR2sUnphs8hkozqMuY
         ADOOQdgs7kSXg/84It/GqYSRAxQrnRx3J6Wp5YbLuxLNnTWT5RlLbnrpgcCHf7Qv0NoA
         IMkxwjxiicXBAYcQMD3uTgKcgq8TeQjDz0GX/+qW+IUUnQx86WS5rBs6tt8Qb+Rg8n3N
         6JgyMAc9XdfgVm6hDFZD2DJFDU7YYD3Stp2qZtDh+aoJkkDiwZGNFPlYAeY0e1DW1Ybi
         izTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gqASSjb9luK5ttprYOR2fG7EzqfVt33wKQt+HICuTFM=;
        b=aoFqpiVdGWEUtFMxHZPmCK4JWCyrq5Gqu36rcEVqmb6Wz2Aqe5tWJUc5yUxF+K+Tpp
         2arfooBAzYRFb8gsKLiXZ0uqdia/44j/aSv3TkomLYXwh4IOHcJ9z0BvRtj93wLYp4Fl
         BVNFv/iFxhjEAxT3D0DjSfkUWk7hv2brgVomdLw+xCWkkJsAUpeCZqqb++7wV+BfNOmw
         aqyqh2gg5pvV7ujmAfdH3uRJu1P5cxRtaeOImPq0W9HiDvjDQOQwgMsPQW0794HhASK5
         UyLLfnSBzljgW24ZJBKsGFyYgWD0u+IFdMCVEVaZF4tNEzDOtKAtZdQ7XWOWMuyfA7MJ
         daOw==
X-Gm-Message-State: AOAM530BUen6q/LQ95kumVvq+qqisxm2QY0J+7hvyRZhqKTRjV8LzwJM
        DsDAo9XUIYHLqLq3NPaTu2wemYdcbL0JLA==
X-Google-Smtp-Source: ABdhPJxqyRejSi5bvhwIRBr6DEDqX6FNkWDUKwChFkOWEtVXZflbVTUVRpr8rfsj+1rNjwkYSaePh1iqDH2FmA==
X-Received: by 2002:a05:6214:13d4:: with SMTP id cg20mr1260387qvb.214.1590105493818;
 Thu, 21 May 2020 16:58:13 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:23 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-11-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 10/27] L2TP:Adjust intf MTU, add underlay L3, L2 hdrs.
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org,
        "R. Parameswaran" <parameswaran.r7@gmail.com>,
        "R . Parameswaran" <rparames@brocade.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "R. Parameswaran" <parameswaran.r7@gmail.com>

commit b784e7ebfce8cfb16c6f95e14e8532d0768ab7ff upstream.

Existing L2TP kernel code does not derive the optimal MTU for Ethernet
pseudowires and instead leaves this to a userspace L2TP daemon or
operator. If an MTU is not specified, the existing kernel code chooses
an MTU that does not take account of all tunnel header overheads, which
can lead to unwanted IP fragmentation. When L2TP is used without a
control plane (userspace daemon), we would prefer that the kernel does a
better job of choosing a default pseudowire MTU, taking account of all
tunnel header overheads, including IP header options, if any. This patch
addresses this.

Change-set here uses the new kernel function, kernel_sock_ip_overhead(),
to factor the outer IP overhead on the L2TP tunnel socket (including
IP Options, if any) when calculating the default MTU for an Ethernet
pseudowire, along with consideration of the inner Ethernet header.

Signed-off-by: R. Parameswaran <rparames@brocade.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_eth.c | 55 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index c94160df71af..cef312da3422 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -30,6 +30,9 @@
 #include <net/xfrm.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/udp.h>
 
 #include "l2tp_core.h"
 
@@ -206,6 +209,53 @@ static void l2tp_eth_show(struct seq_file *m, void *arg)
 }
 #endif
 
+static void l2tp_eth_adjust_mtu(struct l2tp_tunnel *tunnel,
+				struct l2tp_session *session,
+				struct net_device *dev)
+{
+	unsigned int overhead = 0;
+	struct dst_entry *dst;
+	u32 l3_overhead = 0;
+
+	/* if the encap is UDP, account for UDP header size */
+	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
+		overhead += sizeof(struct udphdr);
+		dev->needed_headroom += sizeof(struct udphdr);
+	}
+	if (session->mtu != 0) {
+		dev->mtu = session->mtu;
+		dev->needed_headroom += session->hdr_len;
+		return;
+	}
+	l3_overhead = kernel_sock_ip_overhead(tunnel->sock);
+	if (l3_overhead == 0) {
+		/* L3 Overhead couldn't be identified, this could be
+		 * because tunnel->sock was NULL or the socket's
+		 * address family was not IPv4 or IPv6,
+		 * dev mtu stays at 1500.
+		 */
+		return;
+	}
+	/* Adjust MTU, factor overhead - underlay L3, overlay L2 hdr
+	 * UDP overhead, if any, was already factored in above.
+	 */
+	overhead += session->hdr_len + ETH_HLEN + l3_overhead;
+
+	/* If PMTU discovery was enabled, use discovered MTU on L2TP device */
+	dst = sk_dst_get(tunnel->sock);
+	if (dst) {
+		/* dst_mtu will use PMTU if found, else fallback to intf MTU */
+		u32 pmtu = dst_mtu(dst);
+
+		if (pmtu != 0)
+			dev->mtu = pmtu;
+		dst_release(dst);
+	}
+	session->mtu = dev->mtu - overhead;
+	dev->mtu = session->mtu;
+	dev->needed_headroom += session->hdr_len;
+}
+
 static int l2tp_eth_create(struct net *net, u32 tunnel_id, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
 {
 	struct net_device *dev;
@@ -249,10 +299,7 @@ static int l2tp_eth_create(struct net *net, u32 tunnel_id, u32 session_id, u32 p
 	}
 
 	dev_net_set(dev, net);
-	if (session->mtu == 0)
-		session->mtu = dev->mtu - session->hdr_len;
-	dev->mtu = session->mtu;
-	dev->needed_headroom += session->hdr_len;
+	l2tp_eth_adjust_mtu(tunnel, session, dev);
 
 	priv = netdev_priv(dev);
 	priv->dev = dev;
-- 
2.27.0.rc0.183.gde8f92d652-goog

