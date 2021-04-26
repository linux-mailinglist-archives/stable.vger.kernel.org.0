Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6105B36AE18
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbhDZHlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233543AbhDZHjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0A74613CB;
        Mon, 26 Apr 2021 07:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422674;
        bh=bWjkEMqWk8LpqfI0qoaV2gfWeqoPKQ0GCiIZbx7y7bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkY6aa7HAYNlN92gvDFAbGDyg7aTVA4SSFuqsXEZgon6UUh3fgFTgunXd1VLZxZED
         17SBkgdomvSZho6LiUmxpob53J356hCOpRSXYEcz15ATaZeweQpCl10BUG0yGTQT2S
         OEe23pqsmYszD3BvsPSC5cO8QaG7jjb9kXegH2fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hristo Venev <hristo@venev.name>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 35/57] net: ip6_tunnel: Unregister catch-all devices
Date:   Mon, 26 Apr 2021 09:29:32 +0200
Message-Id: <20210426072821.763792328@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hristo Venev <hristo@venev.name>

commit 941ea91e87a6e879ed82dad4949f6234f2702bec upstream.

Similarly to the sit case, we need to remove the tunnels with no
addresses that have been moved to another network namespace.

Fixes: 0bd8762824e73 ("ip6tnl: add x-netns support")
Signed-off-by: Hristo Venev <hristo@venev.name>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -2222,6 +2222,16 @@ static void __net_exit ip6_tnl_destroy_t
 			t = rtnl_dereference(t->next);
 		}
 	}
+
+	t = rtnl_dereference(ip6n->tnls_wc[0]);
+	while (t) {
+		/* If dev is in the same netns, it has already
+		 * been added to the list by the previous loop.
+		 */
+		if (!net_eq(dev_net(t->dev), net))
+			unregister_netdevice_queue(t->dev, list);
+		t = rtnl_dereference(t->next);
+	}
 }
 
 static int __net_init ip6_tnl_init_net(struct net *net)


