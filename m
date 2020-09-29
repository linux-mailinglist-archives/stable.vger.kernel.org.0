Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D9E27CD5B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgI2LJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgI2LIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:08:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C21721D43;
        Tue, 29 Sep 2020 11:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377708;
        bh=38R1XRDeld8qdJ08DT4Ym8pB1pC/aOYXW2X/W5I6pks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6HEJPpv+FdlgsNdODcApBKct52aPktMN5RUSvduJqRovjaOTfeMOylfekxOlXHp1
         GKk4pLxyILSm2SngJS9JCtzvDvyMt55MHX2g2g7L+CK366LAXFG791nDUO/w4gj2TB
         RzXk4oou+AsvpnEnbvbo7NR6C/8xzcXGjdC5ELZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 044/121] skbuff: fix a data race in skb_queue_len()
Date:   Tue, 29 Sep 2020 12:59:48 +0200
Message-Id: <20200929105932.372911098@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 86b18aaa2b5b5bb48e609cd591b3d2d0fdbe0442 ]

sk_buff.qlen can be accessed concurrently as noticed by KCSAN,

 BUG: KCSAN: data-race in __skb_try_recv_from_queue / unix_dgram_sendmsg

 read to 0xffff8a1b1d8a81c0 of 4 bytes by task 5371 on cpu 96:
  unix_dgram_sendmsg+0x9a9/0xb70 include/linux/skbuff.h:1821
				 net/unix/af_unix.c:1761
  ____sys_sendmsg+0x33e/0x370
  ___sys_sendmsg+0xa6/0xf0
  __sys_sendmsg+0x69/0xf0
  __x64_sys_sendmsg+0x51/0x70
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 write to 0xffff8a1b1d8a81c0 of 4 bytes by task 1 on cpu 99:
  __skb_try_recv_from_queue+0x327/0x410 include/linux/skbuff.h:2029
  __skb_try_recv_datagram+0xbe/0x220
  unix_dgram_recvmsg+0xee/0x850
  ____sys_recvmsg+0x1fb/0x210
  ___sys_recvmsg+0xa2/0xf0
  __sys_recvmsg+0x66/0xf0
  __x64_sys_recvmsg+0x51/0x70
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Since only the read is operating as lockless, it could introduce a logic
bug in unix_recvq_full() due to the load tearing. Fix it by adding
a lockless variant of skb_queue_len() and unix_recvq_full() where
READ_ONCE() is on the read while WRITE_ONCE() is on the write similar to
the commit d7d16a89350a ("net: add skb_queue_empty_lockless()").

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 14 +++++++++++++-
 net/unix/af_unix.c     | 11 +++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fe4b7e4883431..67b798b7115d8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1549,6 +1549,18 @@ static inline __u32 skb_queue_len(const struct sk_buff_head *list_)
 	return list_->qlen;
 }
 
+/**
+ *	skb_queue_len_lockless	- get queue length
+ *	@list_: list to measure
+ *
+ *	Return the length of an &sk_buff queue.
+ *	This variant can be used in lockless contexts.
+ */
+static inline __u32 skb_queue_len_lockless(const struct sk_buff_head *list_)
+{
+	return READ_ONCE(list_->qlen);
+}
+
 /**
  *	__skb_queue_head_init - initialize non-spinlock portions of sk_buff_head
  *	@list: queue to initialize
@@ -1752,7 +1764,7 @@ static inline void __skb_unlink(struct sk_buff *skb, struct sk_buff_head *list)
 {
 	struct sk_buff *next, *prev;
 
-	list->qlen--;
+	WRITE_ONCE(list->qlen, list->qlen - 1);
 	next	   = skb->next;
 	prev	   = skb->prev;
 	skb->next  = skb->prev = NULL;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 32ae82a5596d9..bcd6ed6e7e25c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -191,11 +191,17 @@ static inline int unix_may_send(struct sock *sk, struct sock *osk)
 	return unix_peer(osk) == NULL || unix_our_peer(sk, osk);
 }
 
-static inline int unix_recvq_full(struct sock const *sk)
+static inline int unix_recvq_full(const struct sock *sk)
 {
 	return skb_queue_len(&sk->sk_receive_queue) > sk->sk_max_ack_backlog;
 }
 
+static inline int unix_recvq_full_lockless(const struct sock *sk)
+{
+	return skb_queue_len_lockless(&sk->sk_receive_queue) >
+		READ_ONCE(sk->sk_max_ack_backlog);
+}
+
 struct sock *unix_peer_get(struct sock *s)
 {
 	struct sock *peer;
@@ -1793,7 +1799,8 @@ restart_locked:
 	 * - unix_peer(sk) == sk by time of get but disconnected before lock
 	 */
 	if (other != sk &&
-	    unlikely(unix_peer(other) != sk && unix_recvq_full(other))) {
+	    unlikely(unix_peer(other) != sk &&
+	    unix_recvq_full_lockless(other))) {
 		if (timeo) {
 			timeo = unix_wait_for_peer(other, timeo);
 
-- 
2.25.1



