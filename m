Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC2D2C0739
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732112AbgKWMig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732108AbgKWMie (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 243AD20857;
        Mon, 23 Nov 2020 12:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135114;
        bh=Lr8yG7a/h9lNCCfxshKz1kSJ4UUgtX6WFQHKFkf/oco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkGldUN4pYG6FKyNOIpYe2mIpZErgUkVATz2IsMkIei3kETqP2Ryyb0BHCw+SVJJk
         PmZ18nff5chkQ7ti6oJ2K5UaqFtobcepshSBRRg6HiNvqB2B/5n/XTd3qcB5gyTF6Y
         PQUWjpwjbEQU7ygSWyM2//QzdgJ+5CvL1ohwZzO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkman <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/158] bpf, sockmap: Use truesize with sk_rmem_schedule()
Date:   Mon, 23 Nov 2020 13:22:17 +0100
Message-Id: <20201123121825.196763523@linuxfoundation.org>
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
index 4fad59ee3df0b..ddb1b7d94c998 100644
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



