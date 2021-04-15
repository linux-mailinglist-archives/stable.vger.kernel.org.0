Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E235360C99
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhDOOwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234106AbhDOOvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B6BB6137D;
        Thu, 15 Apr 2021 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498260;
        bh=cwZi0PoEX5UxhnDCSVxN0fDAN9c/3MRRvsCLAFqVNqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=om2Fi8LLJurG0Pqjen4CQdF+B3fMhEv9GVZIbnMzPXs4iu75PZEqNkaRfxxfb9QcL
         ft/vpU859IvxHeNB5zdEuE8vfgaJh3XbX2VDoHGLwYOTv7Wnti0rqsdVJJnut9mMFT
         k4apVuGKoSha4DvOCGO5ePVzUALCbt02r/kBt3Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/47] net:tipc: Fix a double free in tipc_sk_mcast_rcv
Date:   Thu, 15 Apr 2021 16:47:12 +0200
Message-Id: <20210415144414.108806356@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 6bf24dc0cc0cc43b29ba344b66d78590e687e046 ]

In the if(skb_peek(arrvq) == skb) branch, it calls __skb_dequeue(arrvq) to get
the skb by skb = skb_peek(arrvq). Then __skb_dequeue() unlinks the skb from arrvq
and returns the skb which equals to skb_peek(arrvq). After __skb_dequeue(arrvq)
finished, the skb is freed by kfree_skb(__skb_dequeue(arrvq)) in the first time.

Unfortunately, the same skb is freed in the second time by kfree_skb(skb) after
the branch completed.

My patch removes kfree_skb() in the if(skb_peek(arrvq) == skb) branch, because
this skb will be freed by kfree_skb(skb) finally.

Fixes: cb1b728096f54 ("tipc: eliminate race condition at multicast reception")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 57df99ca6347..804cab8f9509 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -741,7 +741,7 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 		spin_lock_bh(&inputq->lock);
 		if (skb_peek(arrvq) == skb) {
 			skb_queue_splice_tail_init(&tmpq, inputq);
-			kfree_skb(__skb_dequeue(arrvq));
+			__skb_dequeue(arrvq);
 		}
 		spin_unlock_bh(&inputq->lock);
 		__skb_queue_purge(&tmpq);
-- 
2.30.2



