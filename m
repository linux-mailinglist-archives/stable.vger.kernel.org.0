Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEB0CD743
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbfJFRyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbfJFRy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:54:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADA9422475;
        Sun,  6 Oct 2019 17:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383987;
        bh=wilHd7f3424w3wg25Q+jpu88/mbdRfTrzNJ1RzgXKXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKdvftyn61snBTCpySaofS0coNCxNHrTB3VAsKbDsqy476O2vung7CF/zcY67Vvt5
         hkhCa9+aEU88mJMGF6ZA0F7ruVnPE5Cli3mYZ2EMzl+Jn9NxmkHsgE10dE+yi6wZlA
         8k+6k6bK3MtTzx19UU/qu+t2sm0rEp348rM7JsKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 133/166] net: ipv4: avoid mixed n_redirects and rate_tokens usage
Date:   Sun,  6 Oct 2019 19:21:39 +0200
Message-Id: <20191006171224.389581438@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit b406472b5ad79ede8d10077f0c8f05505ace8b6d ]

Since commit c09551c6ff7f ("net: ipv4: use a dedicated counter
for icmp_v4 redirect packets") we use 'n_redirects' to account
for redirect packets, but we still use 'rate_tokens' to compute
the redirect packets exponential backoff.

If the device sent to the relevant peer any ICMP error packet
after sending a redirect, it will also update 'rate_token' according
to the leaking bucket schema; typically 'rate_token' will raise
above BITS_PER_LONG and the redirect packets backoff algorithm
will produce undefined behavior.

Fix the issue using 'n_redirects' to compute the exponential backoff
in ip_rt_send_redirect().

Note that we still clear rate_tokens after a redirect silence period,
to avoid changing an established behaviour.

The root cause predates git history; before the mentioned commit in
the critical scenario, the kernel stopped sending redirects, after
the mentioned commit the behavior more randomic.

Reported-by: Xiumei Mu <xmu@redhat.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: c09551c6ff7f ("net: ipv4: use a dedicated counter for icmp_v4 redirect packets")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -916,16 +916,15 @@ void ip_rt_send_redirect(struct sk_buff
 	if (peer->rate_tokens == 0 ||
 	    time_after(jiffies,
 		       (peer->rate_last +
-			(ip_rt_redirect_load << peer->rate_tokens)))) {
+			(ip_rt_redirect_load << peer->n_redirects)))) {
 		__be32 gw = rt_nexthop(rt, ip_hdr(skb)->daddr);
 
 		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST, gw);
 		peer->rate_last = jiffies;
-		++peer->rate_tokens;
 		++peer->n_redirects;
 #ifdef CONFIG_IP_ROUTE_VERBOSE
 		if (log_martians &&
-		    peer->rate_tokens == ip_rt_redirect_number)
+		    peer->n_redirects == ip_rt_redirect_number)
 			net_warn_ratelimited("host %pI4/if%d ignores redirects for %pI4 to %pI4\n",
 					     &ip_hdr(skb)->saddr, inet_iif(skb),
 					     &ip_hdr(skb)->daddr, &gw);


