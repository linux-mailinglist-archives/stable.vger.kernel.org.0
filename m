Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B61E20DB50
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbgF2UF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732973AbgF2Ta2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE9332525A;
        Mon, 29 Jun 2020 15:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444971;
        bh=j1YDaC6IH6gS+KiXpMItb5OhVrH4IUnNqrmPXW67plI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Px2Vnc3foAs8hBxTcuh8MIcESWZxFzzbddRxyRC4ALjEmwWuaIYNsOWOFy79zmdLS
         gP0dbe4pXLLQGD3lb3bLHFQ0ZC+425HKHwJLGwl3xeFFrin7ivCEpA412NvGgRSNT4
         koWnHil+A7FN89ei7M15TjWu1xPCmCroKnUXS48o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/131] rxrpc: Fix handling of rwind from an ACK packet
Date:   Mon, 29 Jun 2020 11:34:01 -0400
Message-Id: <20200629153502.2494656-71-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
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
index e65b230fce4c4..58bd558a277a4 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -735,13 +735,12 @@ static void rxrpc_input_ackinfo(struct rxrpc_call *call, struct sk_buff *skb,
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

