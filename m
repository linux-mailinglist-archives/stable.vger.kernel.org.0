Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D026FCD48D
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfJFR1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbfJFR1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:27:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D520217D6;
        Sun,  6 Oct 2019 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382821;
        bh=AcwuN2HBRyI1eYM+h+mINPecMOfKwcXviV7htaH0aSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRF9HJDYhdRlSYAGfuuMav+YQaP5wVZuyR/0ML3YlOp3s62flpmdTrKFtQ9r/z85c
         Gxzf+b9VLTre1DMZ/od+Ffq441YnpNPFWXkiw03cxwkoexAGf6Oy30PwCNN3IvF5J3
         YT6QbjRuRAMb1A4hjaVeUieXhHiFOeTFWBEc3q7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 53/68] net: ipv4: avoid mixed n_redirects and rate_tokens usage
Date:   Sun,  6 Oct 2019 19:21:29 +0200
Message-Id: <20191006171132.572610019@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
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
@@ -925,16 +925,15 @@ void ip_rt_send_redirect(struct sk_buff
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


