Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1922ED1C9
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbhAGOR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:17:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729128AbhAGOR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BD8523120;
        Thu,  7 Jan 2021 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028977;
        bh=tQ5gXxSUHeeSgSCyrj1hbazk8PpGBmZlzpF5I77FAEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynSduuTjmxypFEuq570dVFB1l1SDJz7CFK9f0P8sfFaT+SViBwgQWAo2UjpkyHlHR
         JLE123fci8Bo66rTyN6QOVkqzucLwk0wm8jbEw8rCoPa+IM+DH8AcuQwbeP9UiICVe
         SFl/PPxeS6VrgbTiTWUNHaEMRTJs09mrVdzIqLWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 4.9 11/32] net: ipv6: keep sk status consistent after datagram connect failure
Date:   Thu,  7 Jan 2021 15:16:31 +0100
Message-Id: <20210107140828.398567212@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.866214702@linuxfoundation.org>
References: <20210107140827.866214702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 2f987a76a97773beafbc615b9c4d8fe79129a7f4 upstream.

On unsuccesful ip6_datagram_connect(), if the failure is caused by
ip6_datagram_dst_update(), the sk peer information are cleared, but
the sk->sk_state is preserved.

If the socket was already in an established status, the overall sk
status is inconsistent and fouls later checks in datagram code.

Fix this saving the old peer information and restoring them in
case of failure. This also aligns ipv6 datagram connect() behavior
with ipv4.

v1 -> v2:
 - added missing Fixes tag

Fixes: 85cb73ff9b74 ("net: ipv6: reset daddr and dport in sk if connect() fails")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/datagram.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -145,10 +145,12 @@ int __ip6_datagram_connect(struct sock *
 	struct sockaddr_in6	*usin = (struct sockaddr_in6 *) uaddr;
 	struct inet_sock	*inet = inet_sk(sk);
 	struct ipv6_pinfo	*np = inet6_sk(sk);
-	struct in6_addr		*daddr;
+	struct in6_addr		*daddr, old_daddr;
+	__be32			fl6_flowlabel = 0;
+	__be32			old_fl6_flowlabel;
+	__be32			old_dport;
 	int			addr_type;
 	int			err;
-	__be32			fl6_flowlabel = 0;
 
 	if (usin->sin6_family == AF_INET) {
 		if (__ipv6_only_sock(sk))
@@ -238,9 +240,13 @@ ipv4_connected:
 		}
 	}
 
+	/* save the current peer information before updating it */
+	old_daddr = sk->sk_v6_daddr;
+	old_fl6_flowlabel = np->flow_label;
+	old_dport = inet->inet_dport;
+
 	sk->sk_v6_daddr = *daddr;
 	np->flow_label = fl6_flowlabel;
-
 	inet->inet_dport = usin->sin6_port;
 
 	/*
@@ -249,8 +255,15 @@ ipv4_connected:
 	 */
 
 	err = ip6_datagram_dst_update(sk, true);
-	if (err)
+	if (err) {
+		/* Restore the socket peer info, to keep it consistent with
+		 * the old socket state
+		 */
+		sk->sk_v6_daddr = old_daddr;
+		np->flow_label = old_fl6_flowlabel;
+		inet->inet_dport = old_dport;
 		goto out;
+	}
 
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);


