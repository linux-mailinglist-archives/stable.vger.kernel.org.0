Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF24711B03A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbfLKPUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732383AbfLKPUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E35B22B48;
        Wed, 11 Dec 2019 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077649;
        bh=PeYVoadsImi2LxPr0Kktv0Z4St0GaLqXgrkc7XGOcIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntG4J+v077pu4H7WnKYGw5XV6h+3eot8MA9h5il9t8pJirD9P3gYz0rn3jTbnc7Cz
         yZHOA1l6AqXZg5nQ2uhcTNmexlNnt3gKRAIhs10KCyW2Hltue2aj0IqTwODkM+2YBB
         LqD823ksRLF59qTuzTJv1EcaNCRs5Uk+XBhwXcg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/243] sctp: increase sk_wmem_alloc when head->truesize is increased
Date:   Wed, 11 Dec 2019 16:04:41 +0100
Message-Id: <20191211150347.164875650@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 0d32f17717e65e76cbdb248374dd162acdfe2fff ]

I changed to count sk_wmem_alloc by skb truesize instead of 1 to
fix the sk_wmem_alloc leak caused by later truesize's change in
xfrm in Commit 02968ccf0125 ("sctp: count sk_wmem_alloc by skb
truesize in sctp_packet_transmit").

But I should have also increased sk_wmem_alloc when head->truesize
is increased in sctp_packet_gso_append() as xfrm does. Otherwise,
sctp gso packet will cause sk_wmem_alloc underflow.

Fixes: 02968ccf0125 ("sctp: count sk_wmem_alloc by skb truesize in sctp_packet_transmit")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/output.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index b0e74a3e77ec5..025f48e14a91f 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -410,6 +410,7 @@ static void sctp_packet_gso_append(struct sk_buff *head, struct sk_buff *skb)
 	head->truesize += skb->truesize;
 	head->data_len += skb->len;
 	head->len += skb->len;
+	refcount_add(skb->truesize, &head->sk->sk_wmem_alloc);
 
 	__skb_header_release(skb);
 }
-- 
2.20.1



