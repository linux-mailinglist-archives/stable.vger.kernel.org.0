Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99B3F557E
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbfKHTCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:02:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731744AbfKHTCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:02:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D9C215EA;
        Fri,  8 Nov 2019 19:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239767;
        bh=n+DjzyOSmmmFEl8IbLZkY3lr0MNUV7MEu3/2CzBSCnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZIsSdBVbiBwyjjjrVOy/s99D6osF8ZDFP8aQhuN5/CJ+2CRNZ2UKZTNSxD77SB1r
         VAeL4MYtCp9EG0o3WQYq1xmtv/PbT5DNEFTbqqShd4dSi4Npr/voahPnQPN1qOpM7H
         atQudN5TGOqTFyye+WRbLBYB6oJLnAHMD8dkwj1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 54/79] net: add skb_queue_empty_lockless()
Date:   Fri,  8 Nov 2019 19:50:34 +0100
Message-Id: <20191108174818.776614754@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d7d16a89350ab263484c0aa2b523dd3a234e4a80 ]

Some paths call skb_queue_empty() without holding
the queue lock. We must use a barrier in order
to not let the compiler do strange things, and avoid
KCSAN splats.

Adding a barrier in skb_queue_empty() might be overkill,
I prefer adding a new helper to clearly identify
points where the callers might be lockless. This might
help us finding real bugs.

The corresponding WRITE_ONCE() should add zero cost
for current compilers.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1380,6 +1380,19 @@ static inline int skb_queue_empty(const
 }
 
 /**
+ *	skb_queue_empty_lockless - check if a queue is empty
+ *	@list: queue head
+ *
+ *	Returns true if the queue is empty, false otherwise.
+ *	This variant can be used in lockless contexts.
+ */
+static inline bool skb_queue_empty_lockless(const struct sk_buff_head *list)
+{
+	return READ_ONCE(list->next) == (const struct sk_buff *) list;
+}
+
+
+/**
  *	skb_queue_is_last - check if skb is the last entry in the queue
  *	@list: queue head
  *	@skb: buffer
@@ -1723,9 +1736,11 @@ static inline void __skb_insert(struct s
 				struct sk_buff *prev, struct sk_buff *next,
 				struct sk_buff_head *list)
 {
-	newsk->next = next;
-	newsk->prev = prev;
-	next->prev  = prev->next = newsk;
+	/* see skb_queue_empty_lockless() for the opposite READ_ONCE() */
+	WRITE_ONCE(newsk->next, next);
+	WRITE_ONCE(newsk->prev, prev);
+	WRITE_ONCE(next->prev, newsk);
+	WRITE_ONCE(prev->next, newsk);
 	list->qlen++;
 }
 
@@ -1736,11 +1751,11 @@ static inline void __skb_queue_splice(co
 	struct sk_buff *first = list->next;
 	struct sk_buff *last = list->prev;
 
-	first->prev = prev;
-	prev->next = first;
+	WRITE_ONCE(first->prev, prev);
+	WRITE_ONCE(prev->next, first);
 
-	last->next = next;
-	next->prev = last;
+	WRITE_ONCE(last->next, next);
+	WRITE_ONCE(next->prev, last);
 }
 
 /**
@@ -1881,8 +1896,8 @@ static inline void __skb_unlink(struct s
 	next	   = skb->next;
 	prev	   = skb->prev;
 	skb->next  = skb->prev = NULL;
-	next->prev = prev;
-	prev->next = next;
+	WRITE_ONCE(next->prev, prev);
+	WRITE_ONCE(prev->next, next);
 }
 
 /**


