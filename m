Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4963643C6
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240858AbhDSNVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241359AbhDSNU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5723C613E8;
        Mon, 19 Apr 2021 13:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838181;
        bh=fN2mtwZZeJajqB6xdE9xvau7nZPC4vSVWR80iu+0jww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ny+ekhAydZ6PKlwJfnegT+xPXjhRjvtjU++rbzqydNlTE647EN6yhW+L0Cz/UFssi
         Eydx45e/jI+CPBcsh+oCfJZAqY3oJJQHxLfrDK44Fm3i4KCE6e6O9S+kz85XUAudul
         uWj9XoXQGX0NLg4R7o54gRbLX21uWt68sIgZdR+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hristo Venev <hristo@venev.name>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 071/103] net: ip6_tunnel: Unregister catch-all devices
Date:   Mon, 19 Apr 2021 15:06:22 +0200
Message-Id: <20210419130530.255356635@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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
@@ -2275,6 +2275,16 @@ static void __net_exit ip6_tnl_destroy_t
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


