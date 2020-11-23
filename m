Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C0B2C0736
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgKWMic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:38:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732099AbgKWMia (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48CE520732;
        Mon, 23 Nov 2020 12:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135109;
        bh=g6Feh2htxV7HMEZau/zqSu7cLlyR+IG7c0WryBTjzGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUD1T1cGIUOBR8vqvBw2sFhr2KuZIAb/CE0Iv4BpwhgFfaWlAdckBhXVWmWZLyytF
         3hrbiAZwG/9WWHxZJI5tFJMhYMDRo8InEaFDMC45O+OY/BDhj+gjUIV6HTe9kRHvl0
         yGRMGbAK+OC9lUUNYRqIoiaLKEZwV8glIvY7Vc/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/158] bpf, sockmap: Skb verdict SK_PASS to self already checked rmem limits
Date:   Mon, 23 Nov 2020 13:22:15 +0100
Message-Id: <20201123121825.102685070@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit cfea28f890cf292d5fe90680db64b68086ef25ba ]

For sk_skb case where skb_verdict program returns SK_PASS to continue to
pass packet up the stack, the memory limits were already checked before
enqueuing in skb_queue_tail from TCP side. So, lets remove the extra checks
here. The theory is if the TCP stack believes we have memory to receive
the packet then lets trust the stack and not double check the limits.

In fact the accounting here can cause a drop if sk_rmem_alloc has increased
after the stack accepted this packet, but before the duplicate check here.
And worse if this happens because TCP stack already believes the data has
been received there is no retransmit.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/160226857664.5692.668205469388498375.stgit@john-Precision-5820-Tower
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1f8e3445cd2f0..605c48df7eb68 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -765,6 +765,7 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static void sk_psock_verdict_apply(struct sk_psock *psock,
 				   struct sk_buff *skb, int verdict)
 {
+	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
 
 	switch (verdict) {
@@ -774,16 +775,12 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		    !sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 			goto out_free;
 		}
-		if (atomic_read(&sk_other->sk_rmem_alloc) <=
-		    sk_other->sk_rcvbuf) {
-			struct tcp_skb_cb *tcp = TCP_SKB_CB(skb);
 
-			tcp->bpf.flags |= BPF_F_INGRESS;
-			skb_queue_tail(&psock->ingress_skb, skb);
-			schedule_work(&psock->work);
-			break;
-		}
-		goto out_free;
+		tcp = TCP_SKB_CB(skb);
+		tcp->bpf.flags |= BPF_F_INGRESS;
+		skb_queue_tail(&psock->ingress_skb, skb);
+		schedule_work(&psock->work);
+		break;
 	case __SK_REDIRECT:
 		sk_psock_skb_redirect(skb);
 		break;
-- 
2.27.0



