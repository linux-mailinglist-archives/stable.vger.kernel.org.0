Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0091BCBAE
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgD1S2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbgD1S2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A23208E0;
        Tue, 28 Apr 2020 18:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098509;
        bh=vQ8mnsbIeQGU8T6YGyNGLmDK4xoJW8U7rXdjDlh5rUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0u7zjgOwIcs4LEGQm7X0w1NrjbQYHPfAmlV3Q68tqnUVooQPHRQPPxsgD+Np48r5N
         cykrylxv0qeqLZAsqLSAtyx41pHwjnAZUIfJU1/+Au5sH7HzcaYo9aWn3m0JIdG+Fg
         H9aYmB3LWySqmXZirhHGcx+DgM6/Pj+lJO0reGd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 063/167] tipc: Fix potential tipc_node refcnt leak in tipc_rcv
Date:   Tue, 28 Apr 2020 20:23:59 +0200
Message-Id: <20200428182232.923942002@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit de058420767df21e2b6b0f3bb36d1616fb962032 ]

tipc_rcv() invokes tipc_node_find() twice, which returns a reference of
the specified tipc_node object to "n" with increased refcnt.

When tipc_rcv() returns or a new object is assigned to "n", the original
local reference of "n" becomes invalid, so the refcount should be
decreased to keep refcount balanced.

The issue happens in some paths of tipc_rcv(), which forget to decrease
the refcnt increased by tipc_node_find() and will cause a refcnt leak.

Fix this issue by calling tipc_node_put() before the original object
pointed by "n" becomes invalid.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/node.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2037,6 +2037,7 @@ void tipc_rcv(struct net *net, struct sk
 		n = tipc_node_find_by_id(net, ehdr->id);
 	}
 	tipc_crypto_rcv(net, (n) ? n->crypto_rx : NULL, &skb, b);
+	tipc_node_put(n);
 	if (!skb)
 		return;
 
@@ -2089,7 +2090,7 @@ rcv:
 	/* Check/update node state before receiving */
 	if (unlikely(skb)) {
 		if (unlikely(skb_linearize(skb)))
-			goto discard;
+			goto out_node_put;
 		tipc_node_write_lock(n);
 		if (tipc_node_check_state(n, skb, bearer_id, &xmitq)) {
 			if (le->link) {
@@ -2118,6 +2119,7 @@ rcv:
 	if (!skb_queue_empty(&xmitq))
 		tipc_bearer_xmit(net, bearer_id, &xmitq, &le->maddr, n);
 
+out_node_put:
 	tipc_node_put(n);
 discard:
 	kfree_skb(skb);


