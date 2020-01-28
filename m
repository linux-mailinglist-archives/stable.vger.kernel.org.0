Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12DD14B9B0
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgA1OeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730770AbgA1OYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA5EA2071E;
        Tue, 28 Jan 2020 14:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221470;
        bh=cVPb9uNZQ2z9mi5VKTB6bUSUPdMKJ5FBKUzdMMvQVeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBesTrBVICrYJsIj5WXCPx2fMcCnnoZaMn8xfVMEgPkGaRs31Ahmez3gHL8Gh0scy
         Mly1GSm1Wysws/m2Dzpfx8wo/OXqK23LfEvS2J9uyBqK03DHkHqbwq91WlH++fA/xJ
         QyXurX0eDio/mpDZQctjkt8c+JJw/WltI16C4gDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Dauchy <w.dauchy@criteo.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 238/271] net, ip_tunnel: fix namespaces move
Date:   Tue, 28 Jan 2020 15:06:27 +0100
Message-Id: <20200128135910.263079055@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Dauchy <w.dauchy@criteo.com>

[ Upstream commit d0f418516022c32ecceaf4275423e5bd3f8743a9 ]

in the same manner as commit 690afc165bb3 ("net: ip6_gre: fix moving
ip6gre between namespaces"), fix namespace moving as it was broken since
commit 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.").
Indeed, the ip6_gre commit removed the local flag for collect_md
condition, so there is no reason to keep it for ip_gre/ip_tunnel.

this patch will fix both ip_tunnel and ip_gre modules.

Fixes: 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.")
Signed-off-by: William Dauchy <w.dauchy@criteo.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -1184,10 +1184,8 @@ int ip_tunnel_init(struct net_device *de
 	iph->version		= 4;
 	iph->ihl		= 5;
 
-	if (tunnel->collect_md) {
-		dev->features |= NETIF_F_NETNS_LOCAL;
+	if (tunnel->collect_md)
 		netif_keep_dst(dev);
-	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ip_tunnel_init);


