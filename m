Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515552C0738
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732106AbgKWMid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:38:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732102AbgKWMic (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B0202065E;
        Mon, 23 Nov 2020 12:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135111;
        bh=0WTG0wKp3SjudkOLDd/4oO9az8gxhcNf5WYwP6xNCJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inxPZ7ReqK1mkJFpSFcY4VFjZV2fCocJU9XuU/unpcJ8bZo7vRMUHun7qxNp86vas
         K8X5sPPrmBCGDlhcDvvP2h7FAt21D7rX4Mx2QZknQWR/beTk9ABAgqAo9ZKaK/BnHS
         o+f2u9tw0U9BSX4Ap7ceGrrBn6hR/HhO8gA8A2Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/158] bpf, sockmap: On receive programs try to fast track SK_PASS ingress
Date:   Mon, 23 Nov 2020 13:22:16 +0100
Message-Id: <20201123121825.151271530@linuxfoundation.org>
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

[ Upstream commit 9ecbfb06a078c4911fb444203e8e41d93d22f886 ]

When we receive an skb and the ingress skb verdict program returns
SK_PASS we currently set the ingress flag and put it on the workqueue
so it can be turned into a sk_msg and put on the sk_msg ingress queue.
Then finally telling userspace with data_ready hook.

Here we observe that if the workqueue is empty then we can try to
convert into a sk_msg type and call data_ready directly without
bouncing through a workqueue. Its a common pattern to have a recv
verdict program for visibility that always returns SK_PASS. In this
case unless there is an ENOMEM error or we overrun the socket we
can avoid the workqueue completely only using it when we fall back
to error cases caused by memory pressure.

By doing this we eliminate another case where data may be dropped
if errors occur on memory limits in workqueue.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/160226859704.5692.12929678876744977669.stgit@john-Precision-5820-Tower
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 605c48df7eb68..4fad59ee3df0b 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -767,6 +767,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 {
 	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
+	int err = -EIO;
 
 	switch (verdict) {
 	case __SK_PASS:
@@ -778,8 +779,20 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 
 		tcp = TCP_SKB_CB(skb);
 		tcp->bpf.flags |= BPF_F_INGRESS;
-		skb_queue_tail(&psock->ingress_skb, skb);
-		schedule_work(&psock->work);
+
+		/* If the queue is empty then we can submit directly
+		 * into the msg queue. If its not empty we have to
+		 * queue work otherwise we may get OOO data. Otherwise,
+		 * if sk_psock_skb_ingress errors will be handled by
+		 * retrying later from workqueue.
+		 */
+		if (skb_queue_empty(&psock->ingress_skb)) {
+			err = sk_psock_skb_ingress(psock, skb);
+		}
+		if (err < 0) {
+			skb_queue_tail(&psock->ingress_skb, skb);
+			schedule_work(&psock->work);
+		}
 		break;
 	case __SK_REDIRECT:
 		sk_psock_skb_redirect(skb);
-- 
2.27.0



