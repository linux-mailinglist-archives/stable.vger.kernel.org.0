Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963B01DDB69
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgEUX6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310E5C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r18so7244520ybg.10
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1zP5YXAUai9NuLktmpuGTocokd0bJMpEb1yVDiy65/A=;
        b=fh/kwZlNEVPnuAsQS6Bx+7SW5tX2XzaILyGIlW11Ng6XwBI525AE6Wtf09aT//NBnF
         UtvTKRLQFajvsX2YjKaitjbvB0iIerJPdYc3KKWOML5kQc4VWxAE8cnO/6fcQ/nHflS0
         4bczsemVOq+XsJiTdA7att67niD5l09crBGNK/VTpSSyGVMLqO7CU2dUoQrk5O0xwV2v
         /gu8ULKD/UfC5D4N1aj4L8AMF6YuAay9DP077i4934rIF94JYK1O+UPHxWkE3bTCsx/3
         eG+8ozQPlVP1e305rJrDLe5JzfdmOjwGJpCf31C58p+l3PIvS2cGrECszjRsDA677MGc
         5uqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1zP5YXAUai9NuLktmpuGTocokd0bJMpEb1yVDiy65/A=;
        b=dP0thMH6HteBykq4oRXQqTE/rjV/y0AbXGiYa3Zfn/AHVOzLmddNHcMUiKk1cOtluK
         kADQJsxXt9lFKmMXRgE1WEXl4lTT/pk7Kx7nVVrUJHhhG8DwJ1HdDbPGTHwbwqFBqLwy
         R5YFYF3ZlzawylhWJ0FEPqlVL1+dvd+Uf2W8/lFFb9m1cLiojvvbXPnlOJA7pnL/PJNC
         Ypcy4CqawS6ASilkY8yW4Z6dJvmwgatGip7L/rLz9Z0f6n1+dWlpVDAWHHs+pHdf32Lh
         awV+xkn9c17vvtLW0d1+3g0+RjgGGULWruHqXkXPG5uk6dG1B8CSF84vAuQ8tk0V49jd
         OdKw==
X-Gm-Message-State: AOAM5326KkrMpuAVQyR74SeQscjSxkPNISgsOtaw9RNufkGLC6UJlIBl
        V/bmPSnOFUopRuFpB67Fw292H5yaouw+zg==
X-Google-Smtp-Source: ABdhPJxdsLDkh+qhF2pe+LDdDz568BrUdV387TwlLHe9tITe1HilU6ungAQ9YcD27yNmthBCTbQXJDG6LkHX8A==
X-Received: by 2002:a25:76c5:: with SMTP id r188mr10775588ybc.71.1590105483431;
 Thu, 21 May 2020 16:58:03 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:18 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-6-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 05/27] l2tp: don't use l2tp_tunnel_find() in l2tp_ip and l2tp_ip6
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Nicolas Schier <n.schier@avm.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 8f7dc9ae4a7aece9fbc3e6637bdfa38b36bcdf09 upstream.

Using l2tp_tunnel_find() in l2tp_ip_recv() is wrong for two reasons:

  * It doesn't take a reference on the returned tunnel, which makes the
    call racy wrt. concurrent tunnel deletion.

  * The lookup is only based on the tunnel identifier, so it can return
    a tunnel that doesn't match the packet's addresses or protocol.

For example, a packet sent to an L2TPv3 over IPv6 tunnel can be
delivered to an L2TPv2 over UDPv4 tunnel. This is worse than a simple
cross-talk: when delivering the packet to an L2TP over UDP tunnel, the
corresponding socket is UDP, where ->sk_backlog_rcv() is NULL. Calling
sk_receive_skb() will then crash the kernel by trying to execute this
callback.

And l2tp_tunnel_find() isn't even needed here. __l2tp_ip_bind_lookup()
properly checks the socket binding and connection settings. It was used
as a fallback mechanism for finding tunnels that didn't have their data
path registered yet. But it's not limited to this case and can be used
to replace l2tp_tunnel_find() in the general case.

Fix l2tp_ip6 in the same way.

Fixes: 0d76751fad77 ("l2tp: Add L2TPv3 IP encapsulation (no UDP) support")
Fixes: a32e0eec7042 ("l2tp: introduce L2TPv3 IP encapsulation support for IPv6")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_ip.c  | 22 ++++++++--------------
 net/l2tp/l2tp_ip6.c | 23 ++++++++---------------
 2 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 2a77732c6496..fd7363f8405a 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -122,6 +122,7 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 	unsigned char *ptr, *optr;
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel = NULL;
+	struct iphdr *iph;
 	int length;
 
 	if (!pskb_may_pull(skb, 4))
@@ -180,23 +181,16 @@ pass_up:
 		goto discard;
 
 	tunnel_id = ntohl(*(__be32 *) &skb->data[4]);
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel) {
-		sk = tunnel->sock;
-		sock_hold(sk);
-	} else {
-		struct iphdr *iph = (struct iphdr *) skb_network_header(skb);
+	iph = (struct iphdr *)skb_network_header(skb);
 
-		read_lock_bh(&l2tp_ip_lock);
-		sk = __l2tp_ip_bind_lookup(net, iph->daddr, 0, tunnel_id);
-		if (!sk) {
-			read_unlock_bh(&l2tp_ip_lock);
-			goto discard;
-		}
-
-		sock_hold(sk);
+	read_lock_bh(&l2tp_ip_lock);
+	sk = __l2tp_ip_bind_lookup(net, iph->daddr, 0, tunnel_id);
+	if (!sk) {
 		read_unlock_bh(&l2tp_ip_lock);
+		goto discard;
 	}
+	sock_hold(sk);
+	read_unlock_bh(&l2tp_ip_lock);
 
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_put;
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 4d4561dd4023..5bb5337e74fc 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -134,6 +134,7 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 	unsigned char *ptr, *optr;
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel = NULL;
+	struct ipv6hdr *iph;
 	int length;
 
 	if (!pskb_may_pull(skb, 4))
@@ -193,24 +194,16 @@ pass_up:
 		goto discard;
 
 	tunnel_id = ntohl(*(__be32 *) &skb->data[4]);
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel) {
-		sk = tunnel->sock;
-		sock_hold(sk);
-	} else {
-		struct ipv6hdr *iph = ipv6_hdr(skb);
-
-		read_lock_bh(&l2tp_ip6_lock);
-		sk = __l2tp_ip6_bind_lookup(net, &iph->daddr,
-					    0, tunnel_id);
-		if (!sk) {
-			read_unlock_bh(&l2tp_ip6_lock);
-			goto discard;
-		}
+	iph = ipv6_hdr(skb);
 
-		sock_hold(sk);
+	read_lock_bh(&l2tp_ip6_lock);
+	sk = __l2tp_ip6_bind_lookup(net, &iph->daddr, 0, tunnel_id);
+	if (!sk) {
 		read_unlock_bh(&l2tp_ip6_lock);
+		goto discard;
 	}
+	sock_hold(sk);
+	read_unlock_bh(&l2tp_ip6_lock);
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_put;
-- 
2.27.0.rc0.183.gde8f92d652-goog

