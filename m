Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9202391018
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 12:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfHQKh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 06:37:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51600 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfHQKhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 06:37:20 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hyw5E-0008PK-Gd; Sat, 17 Aug 2019 11:37:16 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1hyw5E-0005ok-BK; Sat, 17 Aug 2019 11:37:16 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "" <stable@vger.kernel.org>, "Eric Dumazet" <edumazet@google.com>,
        "Denis Andzakovic" <denis.andzakovic@pulsesecurity.co.nz>
Date:   Sat, 17 Aug 2019 11:35:11 +0100
Message-ID: <lsq.1566038111.718816006@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 1/4] tcp: Clear sk_send_head after purging the write
 queue
In-Reply-To: <lsq.1566038111.397675943@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.73-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Denis Andzakovic discovered a potential use-after-free in older kernel
versions, using syzkaller.  tcp_write_queue_purge() frees all skbs in
the TCP write queue and can leave sk->sk_send_head pointing to freed
memory.  tcp_disconnect() clears that pointer after calling
tcp_write_queue_purge(), but tcp_connect() does not.  It is
(surprisingly) possible to add to the write queue between
disconnection and reconnection, so this needs to be done in both
places.

This bug was introduced by backports of commit 7f582b248d0a ("tcp:
purge write queue in tcp_connect_init()") and does not exist upstream
because of earlier changes in commit 75c119afe14f ("tcp: implement
rb-tree based retransmit queue").  The latter is a major change that's
not suitable for stable.

Reported-by: Denis Andzakovic <denis.andzakovic@pulsesecurity.co.nz>
Bisected-by: Salvatore Bonaccorso <carnil@debian.org>
Fixes: 7f582b248d0a ("tcp: purge write queue in tcp_connect_init()")
Cc: <stable@vger.kernel.org> # before 4.15
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/tcp.h | 3 +++
 1 file changed, 3 insertions(+)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1352,6 +1352,8 @@ struct tcp_fastopen_context {
 	struct rcu_head		rcu;
 };
 
+static inline void tcp_init_send_head(struct sock *sk);
+
 /* write queue abstraction */
 static inline void tcp_write_queue_purge(struct sock *sk)
 {
@@ -1359,6 +1361,7 @@ static inline void tcp_write_queue_purge
 
 	while ((skb = __skb_dequeue(&sk->sk_write_queue)) != NULL)
 		sk_wmem_free_skb(sk, skb);
+	tcp_init_send_head(sk);
 	sk_mem_reclaim(sk);
 	tcp_clear_all_retrans_hints(tcp_sk(sk));
 }

