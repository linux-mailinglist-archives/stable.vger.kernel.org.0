Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7602C0959
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733001AbgKWNGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730942AbgKWMtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B88E2137B;
        Mon, 23 Nov 2020 12:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135735;
        bh=brmv+xcIbzNPrUtEwrCykpe+azBF4ZSawaykY07SGZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afPFe9xCi8HEzQVa+Pi1wI5w6Bdgpp+YqY9prOJbAN9QvLWZdFr7MbZtQlobZpkkg
         yfBeMH0nrwymR0NDTxUKDhtH+MDKkMzT7MdJpXe1vdRGeAB3O+HaT/5gsQyvE3sfkN
         gWinYoB1luR4+KVnFU0PNVlMijnBj6rb3UBB/Vo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkman <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 175/252] bpf, sockmap: Use truesize with sk_rmem_schedule()
Date:   Mon, 23 Nov 2020 13:22:05 +0100
Message-Id: <20201123121844.038953695@linuxfoundation.org>
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

[ Upstream commit 70796fb751f1d34cc650e640572a174faf009cd4 ]

We use skb->size with sk_rmem_scheduled() which is not correct. Instead
use truesize to align with socket and tcp stack usage of sk_rmem_schedule.

Suggested-by: Daniel Borkman <daniel@iogearbox.net>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/160556570616.73229.17003722112077507863.stgit@john-XPS-13-9370
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index eaf9c90389517..4ac112cc490c5 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -411,7 +411,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	if (unlikely(!msg))
 		return -EAGAIN;
-	if (!sk_rmem_schedule(sk, skb, skb->len)) {
+	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
 		kfree(msg);
 		return -EAGAIN;
 	}
-- 
2.27.0



