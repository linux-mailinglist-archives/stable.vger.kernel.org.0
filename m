Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E591C199216
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbgCaJDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730566AbgCaJDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:03:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9839208E0;
        Tue, 31 Mar 2020 09:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645385;
        bh=WEq957zAfjyZHs7RPLZbxFpac6ucSHDGcB02beUwI1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeDbuQkpGvCAx0L5L7sy8TAV0JBzNkrKWRe2fXkKsrSfVsfKu9ToxIUCzctArRWuR
         9Ob/O/M1TyrmjuPWaQVWipl2wYWyHgLvxsAwRbZMPlHgvWvB/cEhFA9a4dW05/kFnM
         T7CbYxsU+8KLFdmovBSjLY0Z0oKlCYqV4tumvP5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Martin Zaharinov <micron10@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 037/170] tcp: ensure skb->dev is NULL before leaving TCP stack
Date:   Tue, 31 Mar 2020 10:57:31 +0200
Message-Id: <20200331085427.965229450@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b738a185beaab8728943acdb3e67371b8a88185e ]

skb->rbnode is sharing three skb fields : next, prev, dev

When a packet is sent, TCP keeps the original skb (master)
in a rtx queue, which was converted to rbtree a while back.

__tcp_transmit_skb() is responsible to clone the master skb,
and add the TCP header to the clone before sending it
to network layer.

skb_clone() already clears skb->next and skb->prev, but copies
the master oskb->dev into the clone.

We need to clear skb->dev, otherwise lower layers could interpret
the value as a pointer to a netdev.

This old bug surfaced recently when commit 28f8bfd1ac94
("netfilter: Support iif matches in POSTROUTING") was merged.

Before this netfilter commit, skb->dev value was ignored and
changed before reaching dev_queue_xmit()

Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Fixes: 28f8bfd1ac94 ("netfilter: Support iif matches in POSTROUTING")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Martin Zaharinov <micron10@gmail.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1048,6 +1048,10 @@ static int __tcp_transmit_skb(struct soc
 
 		if (unlikely(!skb))
 			return -ENOBUFS;
+		/* retransmit skbs might have a non zero value in skb->dev
+		 * because skb->dev is aliased with skb->rbnode.rb_left
+		 */
+		skb->dev = NULL;
 	}
 
 	inet = inet_sk(sk);


