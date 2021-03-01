Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523E73286DB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbhCARQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:16:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236684AbhCARIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5953465016;
        Mon,  1 Mar 2021 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616925;
        bh=K98Xo5Lpmx5cL/9oGyD0a9cOvzfxByJ1hmiICAqCcj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hy3iYTJZVCDtMca4EBs0iyB3quXmIruvX/qYUs6BQzG1T/Svcj4ngqTfiBXs7f2Q5
         tLW27ffgYO8UWsYo7ajOcJy/J8pgIWqajlzq7e54JtQS0ndpgeFb9Mtd8eu8SRwFmZ
         2yVNK7gbHbKjwvvctuws/rBQ7zJFuocOhmM1PGN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 142/247] RDMA/rxe: Correct skb on loopback path
Date:   Mon,  1 Mar 2021 17:12:42 +0100
Message-Id: <20210301161038.622620163@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 7903bd5c639ea..04bfc36cc8d76 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -500,6 +500,11 @@ int rxe_send(struct rxe_pkt_info *pkt, struct sk_buff *skb)
 
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



