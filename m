Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC2332901F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242663AbhCAUDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241968AbhCATw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:52:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 835F2651A0;
        Mon,  1 Mar 2021 17:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621169;
        bh=Rex5nsfLetPhwlgcEJ6NQpbEQSd5JBpMwOJn5U52yyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLUAPWWgNbIA49+MY4PJMYoobttmPpJ9wKj5teS4gtR8DByyiKFlITZGUEtCyKYYe
         8+CHqfY8FEEvbpnlwXp3DzzuNk1kI8ypz3NxQ/4RfOPZfvvLwXiZKj59ponq8MbE+Q
         pcdoMwYTBBFDS7zVM7xvKOXt4u6j7TpzchnURh8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 418/775] RDMA/rxe: Correct skb on loopback path
Date:   Mon,  1 Mar 2021 17:09:46 +0100
Message-Id: <20210301161222.235358408@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 5120bf0a5fc15dec210a0fe0f39e4a256bb6e349 ]

rxe_net.c sends packets at the IP layer with skb->data pointing at the IP
header but receives packets from a UDP tunnel with skb->data pointing at
the UDP header.  On the loopback path this was not correctly accounted
for.  This patch corrects for this by using sbk_pull() to strip the IP
header from the skb on received packets.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20210128182301.16859-1-rpearson@hpe.com
Signed-off-by: Bob Pearson <rpearson@hpe.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 943914c2a50c7..bce44502ab0ed 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -414,6 +414,11 @@ int rxe_send(struct rxe_pkt_info *pkt, struct sk_buff *skb)
 
 void rxe_loopback(struct sk_buff *skb)
 {
+	if (skb->protocol == htons(ETH_P_IP))
+		skb_pull(skb, sizeof(struct iphdr));
+	else
+		skb_pull(skb, sizeof(struct ipv6hdr));
+
 	rxe_rcv(skb);
 }
 
-- 
2.27.0



