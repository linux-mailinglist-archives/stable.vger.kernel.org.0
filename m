Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AB12D048E
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgLFLqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:46:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729378AbgLFLol (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:44:41 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 22/46] tipc: fix incompatible mtu of transmission
Date:   Sun,  6 Dec 2020 12:17:30 +0100
Message-Id: <20201206111557.521963143@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit 0643334902fcdc770e2d9555811200213339a3f6 ]

In commit 682cd3cf946b6
("tipc: confgiure and apply UDP bearer MTU on running links"), we
introduced a function to change UDP bearer MTU and applied this new value
across existing per-link. However, we did not apply this new MTU value at
node level. This lead to packet dropped at link level if its size is
greater than new MTU value.

To fix this issue, we also apply this new MTU value for node level.

Fixes: 682cd3cf946b6 ("tipc: confgiure and apply UDP bearer MTU on running links")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Link: https://lore.kernel.org/r/20201130025544.3602-1-hoang.h.le@dektech.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/node.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2171,6 +2171,8 @@ void tipc_node_apply_property(struct net
 			else if (prop == TIPC_NLA_PROP_MTU)
 				tipc_link_set_mtu(e->link, b->mtu);
 		}
+		/* Update MTU for node link entry */
+		e->mtu = tipc_link_mss(e->link);
 		tipc_node_write_unlock(n);
 		tipc_bearer_xmit(net, bearer_id, &xmitq, &e->maddr, NULL);
 	}


