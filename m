Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DF52C085C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732885AbgKWMtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:49:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732859AbgKWMsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E4F220732;
        Mon, 23 Nov 2020 12:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135730;
        bh=l18C14MD5q0JS5WqCDEtsEq+CfySPQvBGSZoFqIjdaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKEADp0H5nXxH38X+c7GGK2pDdbmbiopOjnNIeQZJeTiTtTNiJ04iBrS0/hNl8Wvv
         KYuJM5/TYkulo7OUH7Hux1hKT4WyUUBEnKABtF+NtqCYxTp4q2bUo0eGYwpn7F6d44
         ilTVXCZR1OahPBp96a2qNLuWsIx91OydEe0FIWs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 173/252] bpf, sockmap: Skb verdict SK_PASS to self already checked rmem limits
Date:   Mon, 23 Nov 2020 13:22:03 +0100
Message-Id: <20201123121843.940923831@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
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
index f41b06e60ad90..aa78784292a7e 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -762,6 +762,7 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static void sk_psock_verdict_apply(struct sk_psock *psock,
 				   struct sk_buff *skb, int verdict)
 {
+	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
 
 	switch (verdict) {
@@ -771,16 +772,12 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
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



