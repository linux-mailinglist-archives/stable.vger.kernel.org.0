Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1F82E7C26
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 20:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgL3TeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 14:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgL3TeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 14:34:11 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDEBC061575
        for <stable@vger.kernel.org>; Wed, 30 Dec 2020 11:33:31 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id c1so4715631pjo.6
        for <stable@vger.kernel.org>; Wed, 30 Dec 2020 11:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=jWwGarJT8aIR4YrIbnMairVGcl/uZaGyhdk6GKewmF8=;
        b=jpJzY+8Y9/aBp21jNxt7G9bJQ931nAa85Vp77XyPAtsOjHSqTfltdzNKE86lcrXFBc
         Rf1dVYra8ASorwgIqBaTPwHw2DM7SpgCP9GZFwNtORqnzBFb7FP7tEDjemqWdf/JyK0N
         hKHBLfxdgapSb0halhxjGyfaJxEOenNtM301Jta6rydOkWWvzBTGNOelu1yV/AJGXkab
         DbKPtPfIv6EdwxmFMXFW8s3kxrkKLzyLUUyB3CDMXnGv8F2xv7/eE6RFyHpUOCrJCnTx
         9SH/1PNMIFmt7FVlv0Zq6wcDhSbZwR3WNo7RMKHIQdCPRA+KQwbE9YxQ3oj51gqflGb8
         jtbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jWwGarJT8aIR4YrIbnMairVGcl/uZaGyhdk6GKewmF8=;
        b=ZzDShPQpSjvqlj8VEkEyEaedCQolXDc5Idjs5bMfliuJFK33iK9DHJkgn3gURH/mJN
         DS78nyoEdLsaN8L5O+KtEdWRMShm+lpAOKUn3CXqOKfIV/ewooQqpMtOH1eh5uFeFUof
         PdjwTyWhD/9x6d5TC4Oskm2dtoNwQbPUVp9DcJud6aoINOvjHIhs3q8bFIkUO3RSXgt2
         CnViaQgDxjdDiux/s9HEllW2/V9rVOrzweZ6WlVaTqaB4OLGU4QGeNoCdK8ONYcfx4Ay
         /wFFMuTylLEykcPGwDnoog7enoEvWlQhj7Rf3vD+Z2RUs7vEmY6r33dAZWKPAVbGNRcE
         xjJg==
X-Gm-Message-State: AOAM532xZxZIzosWWic1c0hVKsQ+4ldhP3zQdntpsSjwMQcHgeqP4El3
        XDko5VjP6bdJe3uDygquPveokhoSerg=
X-Google-Smtp-Source: ABdhPJx42clR0VodsKReAcsiV5YhhORHOoOS314h1yv6Iue4RxTzrkLg2K5cKicCEeOoQE9qUsOmWJMvH+M=
Sender: "surenb via sendgmr" <surenb@surenb1.mtv.corp.google.com>
X-Received: from surenb1.mtv.corp.google.com ([100.98.240.136]) (user=surenb
 job=sendgmr) by 2002:a17:90a:8b94:: with SMTP id z20mr1032910pjn.1.1609356810570;
 Wed, 30 Dec 2020 11:33:30 -0800 (PST)
Date:   Wed, 30 Dec 2020 11:33:22 -0800
In-Reply-To: <20201230193323.2133009-1-surenb@google.com>
Message-Id: <20201230193323.2133009-2-surenb@google.com>
Mime-Version: 1.0
References: <20201230193323.2133009-1-surenb@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 1/2] net: ipv6: keep sk status consistent after datagram
 connect failure
From:   Suren Baghdasaryan <surenb@google.com>
To:     surenb@google.com
Cc:     pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 2f987a76a97773beafbc615b9c4d8fe79129a7f4 upstream

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
---
 net/ipv6/datagram.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 58929622de0e..fa4987827cda 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -145,10 +145,12 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
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
@@ -238,9 +240,13 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
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
@@ -249,8 +255,15 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
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
-- 
2.29.2.729.g45daf8777d-goog

