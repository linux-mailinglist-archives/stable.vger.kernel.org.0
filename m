Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA95420DDE7
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbgF2UUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731890AbgF2TZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8352530A;
        Mon, 29 Jun 2020 15:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445136;
        bh=Q4Lswz6i6II4qFDhrgBuB9RG8nq8AdjQIpsfofTTtPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yC6MAI3zfu5iQF43cKskBxXXwR2IWsZDhcDnhbIebSfC8yxiblm2VaPtF0xfspyAW
         iVQOz9r54XARpfBwM2MwAPBjI6m5H1zFxrNTlpDzPCt6N996kX/Zf4QIAfP5AEBIfP
         GY3QBbiuMz0Z7R9EGE/u8jFvjIJvSkDiaw8I5gX4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 42/78] rxrpc: Fix handling of rwind from an ACK packet
Date:   Mon, 29 Jun 2020 11:37:30 -0400
Message-Id: <20200629153806.2494953-43-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit a2ad7c21ad8cf1ce4ad65e13df1c2a1c29b38ac5 ]

The handling of the receive window size (rwind) from a received ACK packet
is not correct.  The rxrpc_input_ackinfo() function currently checks the
current Tx window size against the rwind from the ACK to see if it has
changed, but then limits the rwind size before storing it in the tx_winsize
member and, if it increased, wake up the transmitting process.  This means
that if rwind > RXRPC_RXTX_BUFF_SIZE - 1, this path will always be
followed.

Fix this by limiting rwind before we compare it to tx_winsize.

The effect of this can be seen by enabling the rxrpc_rx_rwind_change
tracepoint.

Fixes: 702f2ac87a9a ("rxrpc: Wake up the transmitter if Rx window size increases on the peer")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/input.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 18ce6f97462b6..98285b117a7c0 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -664,13 +664,12 @@ static void rxrpc_input_ackinfo(struct rxrpc_call *call, struct sk_buff *skb,
 	       ntohl(ackinfo->rxMTU), ntohl(ackinfo->maxMTU),
 	       rwind, ntohl(ackinfo->jumbo_max));
 
+	if (rwind > RXRPC_RXTX_BUFF_SIZE - 1)
+		rwind = RXRPC_RXTX_BUFF_SIZE - 1;
 	if (call->tx_winsize != rwind) {
-		if (rwind > RXRPC_RXTX_BUFF_SIZE - 1)
-			rwind = RXRPC_RXTX_BUFF_SIZE - 1;
 		if (rwind > call->tx_winsize)
 			wake = true;
-		trace_rxrpc_rx_rwind_change(call, sp->hdr.serial,
-					    ntohl(ackinfo->rwind), wake);
+		trace_rxrpc_rx_rwind_change(call, sp->hdr.serial, rwind, wake);
 		call->tx_winsize = rwind;
 	}
 
-- 
2.25.1

