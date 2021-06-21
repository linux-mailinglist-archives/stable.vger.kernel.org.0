Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC463AEF88
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhFUQkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230217AbhFUQh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:37:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 413666137D;
        Mon, 21 Jun 2021 16:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292949;
        bh=t8MPqhAav1Ram4qaeeGtXLWIVbRnpGRwsuaCLIcM7hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eebhTKDbtd0evZJTfA6VRDbLpBptK5dPIYD6eaVfHsa4+BmDe6cvbXf/YUomo/IpE
         5elaMoQ1Kbl31ev5RkTk3I7pCqClzhKxTNtm/vtRsv4BiRV40lN1Wr74DuvifKO/cV
         UQHyWhJJrmXzHMVGAKlyM7LAC4T+dxNVT8idnC44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 044/178] mptcp: try harder to borrow memory from subflow under pressure
Date:   Mon, 21 Jun 2021 18:14:18 +0200
Message-Id: <20210621154923.718041746@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 72f961320d5d15bfcb26dbe3edaa3f7d25fd2c8a ]

If the host is under sever memory pressure, and RX forward
memory allocation for the msk fails, we try to borrow the
required memory from the ingress subflow.

The current attempt is a bit flaky: if skb->truesize is less
than SK_MEM_QUANTUM, the ssk will not release any memory, and
the next schedule will fail again.

Instead, directly move the required amount of pages from the
ssk to the msk, if available

Fixes: 9c3f94e1681b ("mptcp: add missing memory scheduling in the rx path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 225b98821517..1d981babbcfe 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -287,11 +287,13 @@ static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 
 	/* try to fetch required memory from subflow */
 	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
-		if (ssk->sk_forward_alloc < skb->truesize)
-			goto drop;
-		__sk_mem_reclaim(ssk, skb->truesize);
-		if (!sk_rmem_schedule(sk, skb, skb->truesize))
+		int amount = sk_mem_pages(skb->truesize) << SK_MEM_QUANTUM_SHIFT;
+
+		if (ssk->sk_forward_alloc < amount)
 			goto drop;
+
+		ssk->sk_forward_alloc -= amount;
+		sk->sk_forward_alloc += amount;
 	}
 
 	/* the skb map_seq accounts for the skb offset:
-- 
2.30.2



