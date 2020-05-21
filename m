Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0A41DDB24
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbgEUXj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgEUXj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:39:56 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2551AC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:56 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id l4so9332614qke.2
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2IFANfsnVpCv6KrTuPyoEujFNsAs/qX5syophaFA3gU=;
        b=hJSB5x8scTxIbZ2n0IhWmYMUKX+GNtSEByMupbf0/zwuPD/4EhZi/qpM45wMe2ZVjy
         OP3Xyqy1ERvXgvmWl70xxJgmmZEI6BKePfw25+Rpj7JQmkjWBBz3rP0Yd2j9ASpeZRDX
         O1baoA2JwndT3WxiD2DSbhRIi1fxpfsUKVcN+sOFCxlQCPkYM8ara0iGyLEXzupf9pVu
         JNFy9AuMnAtCFHuekdEmuWBuo6YQrjroqOON3KHymiRnqwUQrG9l76P6DkS+Mfhge5Fh
         5txWJzssCRjZfUMGfllTsd5O9O1ByC1yPIExfSZL6cdXyl29QkGDgskHyAujnrhQLM1G
         LVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2IFANfsnVpCv6KrTuPyoEujFNsAs/qX5syophaFA3gU=;
        b=X0i+YDS+3Ya9MJjouQPqfaGItktxrKP0y8/M/0ziQw1n/ktbYqk0BvDby7ZwZHATnW
         PecZ0efZR36A2ptGkynV7OF7aH1ihXs3nQTA32VeJnLAnLLsqf32dSwplAxrJ3ABudyg
         7CKnMMecQ4k0z4aGx8+I/1+JaloPzDosIekEINuCMu/64pVZ/3+nVksUxQWYwTHi0xMi
         TysOl+cCP1JAbrhkq8VKyixiMuArnytB7IUMivCLemMS0ud4OPVUHJgg3zdtqXg6F7oN
         I4nEDvv8GSVXz1WZ+cwGMBlA8Gh5qvWlIpm7S2QtKviPw+Z3jvq9i4aTcYAJhFhScH56
         BfCQ==
X-Gm-Message-State: AOAM531xu8TkcxYDr0OamDD1bFk9sB9IYZBsjxH/EyapO4UDcWXFOeBu
        GKscq5zgfnBkMCgwzzpYZ9sffS0kJZVc6g==
X-Google-Smtp-Source: ABdhPJx5GxHApEqrr8rWKyuqP4PhwDccjfR9oopUPbIQ1R4sF+wKXaKm5Bw4sqZvbvAspjg7mojqHt58gGMvbA==
X-Received: by 2002:a05:6214:1594:: with SMTP id m20mr1248760qvw.110.1590104395285;
 Thu, 21 May 2020 16:39:55 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:20 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-6-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 05/22] L2TP:Adjust intf MTU, add underlay L3, L2 hdrs.
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
index eecc64e138de..f0efbf1e9a49 100644
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

