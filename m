Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6671DD041
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgEUOlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgEUOlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:21 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585C6C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:21 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id e43so7997669qtc.3
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=frdE5+sAuA9v/pij4+HJTPzcJcXg5ns2Wxgv7UFwBUM=;
        b=KDL+8/GHBq0KllUNOlC6fVg4kWV9/sERiuIKxYG3aC0ylWZXm0uuZ2eah3dHDwqzEC
         r+3wcOFU9vNV23lb1SMKijJnCB67ILypwSK6sReXFqbZ16TxKZSi8+SCcOnV9KdkSsUn
         FnZEZein2ZBTawR+CaFe/cM7gIClre4YVXDFnHy+VPrxShz0QcbiQzfCRMg60W3OeRLH
         XkItNSJGIAU00GlW4n5fkFgd2Y06/a39corieI+6m6NGDRwCjwuqcDRDa1ZIklAYj99K
         7rYDJu2DcU2OT7V7TBQIA5mAe85qfNJHV8axWR22aaxtPyxPTk0P4ik83VpeNKbok6tV
         Hykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=frdE5+sAuA9v/pij4+HJTPzcJcXg5ns2Wxgv7UFwBUM=;
        b=KGptqUsHly53sNtLfLFWQGyg9ogZRLxA5L55wxGeCB/bZ5mkiDRSaNQLATCftCcAso
         ZmiPMBsBu3+siijLHZumKOo54hg9A7/xQMAfYXln8yULrpWIIcwQi1MboGOIGJ+5dsu8
         ldEda5Z2MTbybnfih3cquu04xQzf5PcH4nHidqGQx8bo35eHGM/zYllJXdCMX6Hy9B8T
         fbnIRSDioAmjddedKt5DOshPT9XeIdJVFiAZBAAcg2ObFPtAUiD+D3Vu0IRxqq332l3V
         qm3IyMNvz0ZaAuAOjcu0qXylkBDXqBgGZFz8jBUF6dft/uMsLSj8Q4nJWk+3w2bBy29n
         FgUg==
X-Gm-Message-State: AOAM533ErdsD1YA26+5Jwg4/MYkL41rNlq0VFcRC770Iz1H5ziKPAsWR
        MCkmhCzoSpbeVRAbzw/l3GIvHErJXkl+JA==
X-Google-Smtp-Source: ABdhPJzu656mVywKWhMuLmPrkEdZDMrRHMzrBExygFiFwYfeR0i7TZ+NyBEamIY7x77Uvx7wzXKYvJ+F4O8vbw==
X-Received: by 2002:a0c:fa8c:: with SMTP id o12mr8974731qvn.60.1590072080558;
 Thu, 21 May 2020 07:41:20 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:43 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-6-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 05/22] L2TP:Adjust intf MTU, add underlay L3, L2 hdrs.
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
2.26.2.761.g0e0b3e54be-goog

