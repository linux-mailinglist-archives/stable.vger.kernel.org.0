Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476A3F566F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390644AbfKHTIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:08:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733278AbfKHTIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:08:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B6562087E;
        Fri,  8 Nov 2019 19:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240128;
        bh=YvjnO8mm8LxPOaeaGVZWVW45loXXHdJad6136bEEwvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HButf7zpbKiN6TGiNCXOy0Wk2FMV0pKa93g9a887NKJpku0acLS+BAEmwzo9Ckjvu
         HjLYaYFjGJNOa7UEqm4wbHk3TW++MMlCU6F586yJ2O4vBjIpKd6nPC1a9N7PxR1hCf
         O/zZyNv4jBYE7rL00BdgwsSq1BICM1vjFp5Ymdpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 098/140] net: add skb_queue_empty_lockless()
Date:   Fri,  8 Nov 2019 19:50:26 +0100
Message-Id: <20191108174911.184234366@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
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
@@ -1501,6 +1501,19 @@ static inline int skb_queue_empty(const
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
@@ -1853,9 +1866,11 @@ static inline void __skb_insert(struct s
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
 
@@ -1866,11 +1881,11 @@ static inline void __skb_queue_splice(co
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
@@ -2011,8 +2026,8 @@ static inline void __skb_unlink(struct s
 	next	   = skb->next;
 	prev	   = skb->prev;
 	skb->next  = skb->prev = NULL;
-	next->prev = prev;
-	prev->next = next;
+	WRITE_ONCE(next->prev, prev);
+	WRITE_ONCE(prev->next, next);
 }
 
 /**


