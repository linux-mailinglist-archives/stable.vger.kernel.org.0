Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B272E1CABBF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbgEHMqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729023AbgEHMqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A33C21473;
        Fri,  8 May 2020 12:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941993;
        bh=bVwiLSdWxPWSAr8o/F56IA3nZH0r+W5kByTgzuaespU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrL7L2oQmmSM0O7jZYdvwY7SLNI9nUUyk3ZTgenjHYmt9zuaXMASd+Aag8cdfW6gv
         POrkosuhpXAx/Y5CSJNPZpzGzh8kfA5Ob2L2f1QOHECZ8wITwsoVo6ocCG82boT6Mo
         U1O4OhA+WjCHmiwFab2I40oZ0Fvkz/5IMlzIwoaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 254/312] gre: do not assign header_ops in collect metadata mode
Date:   Fri,  8 May 2020 14:34:05 +0200
Message-Id: <20200508123142.269598976@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

commit a64b04d86d14c81f50f68e102f79ef301e3d0a0e upstream.

In ipgre mode (i.e. not gretap) with collect metadata flag set, the tunnel
is incorrectly assumed to be mGRE in NBMA mode (see commit 6a5f44d7a048c).
This is not the case, we're controlling the encapsulation addresses by
lwtunnel metadata. And anyway, assigning dev->header_ops in collect metadata
mode does not make sense.

Although it would be more user firendly to reject requests that specify
both the collect metadata flag and a remote/local IP address, this would
break current users of gretap or introduce ugly code and differences in
handling ipgre and gretap configuration. Keep the current behavior of
remote/local IP address being ignored in such case.

v3: Back to v1, added explanation paragraph.
v2: Reject configuration specifying both remote/local address and collect
    metadata flag.

Fixes: 2e15ea390e6f4 ("ip_gre: Add support to collect tunnel metadata.")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ip_gre.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -882,7 +882,7 @@ static int ipgre_tunnel_init(struct net_
 	netif_keep_dst(dev);
 	dev->addr_len		= 4;
 
-	if (iph->daddr) {
+	if (iph->daddr && !tunnel->collect_md) {
 #ifdef CONFIG_NET_IPGRE_BROADCAST
 		if (ipv4_is_multicast(iph->daddr)) {
 			if (!iph->saddr)
@@ -891,8 +891,9 @@ static int ipgre_tunnel_init(struct net_
 			dev->header_ops = &ipgre_header_ops;
 		}
 #endif
-	} else
+	} else if (!tunnel->collect_md) {
 		dev->header_ops = &ipgre_header_ops;
+	}
 
 	return ip_tunnel_init(dev);
 }


