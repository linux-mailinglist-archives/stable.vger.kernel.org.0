Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C48632890D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhCARtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:49:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238705AbhCARiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:38:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71F7364F58;
        Mon,  1 Mar 2021 16:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617745;
        bh=+qkSZeJLQgQ+GW1/YGReed7MxP1cwDaragvS/5K/f6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqX/4Be0SRYUTI6sejjvOTIu0TsO+m6PKUroRqNINB/Cg3HxtH/8JjDadwizYt39E
         5FSqTT1C4zfUxYyq5a8L4E+NdgItzebW21dWUZRwcMvFopM1G0/7njuyJkC+J5XIA0
         0lgX5+/P+wNXXfn6XsbM2oYXMaZmw3TIARXDHvZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/340] RDMA/rxe: Correct skb on loopback path
Date:   Mon,  1 Mar 2021 17:12:05 +0100
Message-Id: <20210301161057.220115420@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 312c2fc961c00..d411356828911 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -453,6 +453,11 @@ int rxe_send(struct rxe_pkt_info *pkt, struct sk_buff *skb)
 
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



