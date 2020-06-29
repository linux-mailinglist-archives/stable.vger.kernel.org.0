Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817A920E30F
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgF2VLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730306AbgF2TAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B9302552F;
        Mon, 29 Jun 2020 15:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446094;
        bh=WUitdJWmkG6QX/RcPT3sZzbXh2tUsaNL7rYm7Sr8PN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4mYMIWvpKXAn8MiAYfq+qrFtYkPWWgl8yqSeK+pPB7EXGAi8vatJwMpxBvgXRlgk
         QXRs6wjGH9vggPfetvcboNLukyrC6aZyBKn0+aYMpVymKORSZWz60a+NxFz276P+wh
         f4D5RmA793+yUJgkhX301CVFt27BehbOINiFPe8c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 088/135] tcp: grow window for OOO packets only for SACK flows
Date:   Mon, 29 Jun 2020 11:52:22 -0400
Message-Id: <20200629155309.2495516-89-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 662051215c758ae8545451628816204ed6cd372d ]

Back in 2013, we made a change that broke fast retransmit
for non SACK flows.

Indeed, for these flows, a sender needs to receive three duplicate
ACK before starting fast retransmit. Sending ACK with different
receive window do not count.

Even if enabling SACK is strongly recommended these days,
there still are some cases where it has to be disabled.

Not increasing the window seems better than having to
rely on RTO.

After the fix, following packetdrill test gives :

// Initialize connection
    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

   +0 < S 0:0(0) win 32792 <mss 1000,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <mss 1460,nop,wscale 8>
   +0 < . 1:1(0) ack 1 win 514

   +0 accept(3, ..., ...) = 4

   +0 < . 1:1001(1000) ack 1 win 514
// Quick ack
   +0 > . 1:1(0) ack 1001 win 264

   +0 < . 2001:3001(1000) ack 1 win 514
// DUPACK : Normally we should not change the window
   +0 > . 1:1(0) ack 1001 win 264

   +0 < . 3001:4001(1000) ack 1 win 514
// DUPACK : Normally we should not change the window
   +0 > . 1:1(0) ack 1001 win 264

   +0 < . 4001:5001(1000) ack 1 win 514
// DUPACK : Normally we should not change the window
    +0 > . 1:1(0) ack 1001 win 264

   +0 < . 1001:2001(1000) ack 1 win 514
// Hole is repaired.
   +0 > . 1:1(0) ack 5001 win 272

Fixes: 4e4f1fc22681 ("tcp: properly increase rcv_ssthresh for ofo packets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 64c7265793a59..e2066f2f19b4a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4465,7 +4465,11 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	if (tcp_ooo_try_coalesce(sk, tp->ooo_last_skb,
 				 skb, &fragstolen)) {
 coalesce_done:
-		tcp_grow_window(sk, skb);
+		/* For non sack flows, do not grow window to force DUPACK
+		 * and trigger fast retransmit.
+		 */
+		if (tcp_is_sack(tp))
+			tcp_grow_window(sk, skb);
 		kfree_skb_partial(skb, fragstolen);
 		skb = NULL;
 		goto add_sack;
@@ -4545,7 +4549,11 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_sack_new_ofo_skb(sk, seq, end_seq);
 end:
 	if (skb) {
-		tcp_grow_window(sk, skb);
+		/* For non sack flows, do not grow window to force DUPACK
+		 * and trigger fast retransmit.
+		 */
+		if (tcp_is_sack(tp))
+			tcp_grow_window(sk, skb);
 		skb_set_owner_r(skb, sk);
 	}
 }
-- 
2.25.1

