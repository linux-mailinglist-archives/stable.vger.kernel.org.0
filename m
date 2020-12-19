Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D48E2DEF33
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgLSNAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbgLSM76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:59:58 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cengiz Can <cengiz@kernel.wtf>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.9 32/49] net: tipc: prevent possible null deref of link
Date:   Sat, 19 Dec 2020 13:58:36 +0100
Message-Id: <20201219125346.242208399@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cengiz Can <cengiz@kernel.wtf>

[ Upstream commit 0398ba9e5a4b5675aa571e0445689d3c2e499c2d ]

`tipc_node_apply_property` does a null check on a `tipc_link_entry`
pointer but also accesses the same pointer out of the null check block.

This triggers a warning on Coverity Static Analyzer because we're
implying that `e->link` can BE null.

Move "Update MTU for node link entry" line into if block to make sure
that we're not in a state that `e->link` is null.

Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/node.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2170,9 +2170,11 @@ void tipc_node_apply_property(struct net
 							&xmitq);
 			else if (prop == TIPC_NLA_PROP_MTU)
 				tipc_link_set_mtu(e->link, b->mtu);
+
+			/* Update MTU for node link entry */
+			e->mtu = tipc_link_mss(e->link);
 		}
-		/* Update MTU for node link entry */
-		e->mtu = tipc_link_mss(e->link);
+
 		tipc_node_write_unlock(n);
 		tipc_bearer_xmit(net, bearer_id, &xmitq, &e->maddr, NULL);
 	}


