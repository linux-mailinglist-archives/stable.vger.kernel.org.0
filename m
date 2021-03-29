Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2097634D574
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 18:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhC2QvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 12:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhC2Quu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 12:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E4616191F;
        Mon, 29 Mar 2021 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617036649;
        bh=6zKuFg4ohHprzMyUg+UhpNjyLyNFfJcvIiLcm5TspRQ=;
        h=From:To:Cc:Subject:Date:From;
        b=lp2xM0V/OIYmVSzM1rkxtsa2lCQyGVZ6t5H60RX1zsUdlNi1LtvoUKYKdrFCXHnT2
         T4pMUjxUZwyHri4q2n9RPgStfqgTCY1gs8d1rchHZ0QSkzQoK1ZDp2WymWbUQJQHoV
         8VSaLAfBSx41tLUTP9yFb0se0wCF5xQ0MICTTFEkgmyOVAQo10pnG0HR8oqH96EWxY
         qNu5IIdzIyChQ3+89pMepc3LDYgNUuExFxvmAZ2wX337aKc8cnItgnJU7AChvVo2O3
         x+3JrihN4CkwVLLovQssZl0hVtdqLZB9cxY8DTi5bKL+19A6oFjjlzPt1lns4un+wK
         sdo6Yfvv3jGkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, ovov@yandex-team.ru
Cc:     Oleg Senin <olegsenin@yandex-team.ru>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "tcp: relookup sock for RST+ACK packets handled by obsolete req sock" failed to apply to 4.19-stable tree
Date:   Mon, 29 Mar 2021 12:50:48 -0400
Message-Id: <20210329165048.2358733-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 7233da86697efef41288f8b713c10c2499cffe85 Mon Sep 17 00:00:00 2001
From: Alexander Ovechkin <ovov@yandex-team.ru>
Date: Mon, 15 Mar 2021 14:05:45 +0300
Subject: [PATCH] tcp: relookup sock for RST+ACK packets handled by obsolete
 req sock

Currently tcp_check_req can be called with obsolete req socket for which big
socket have been already created (because of CPU race or early demux
assigning req socket to multiple packets in gro batch).

Commit e0f9759f530bf789e984 ("tcp: try to keep packet if SYN_RCV race
is lost") added retry in case when tcp_check_req is called for PSH|ACK packet.
But if client sends RST+ACK immediatly after connection being
established (it is performing healthcheck, for example) retry does not
occur. In that case tcp_check_req tries to close req socket,
leaving big socket active.

Fixes: e0f9759f530 ("tcp: try to keep packet if SYN_RCV race is lost")
Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
Reported-by: Oleg Senin <olegsenin@yandex-team.ru>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/inet_connection_sock.h | 2 +-
 net/ipv4/inet_connection_sock.c    | 7 +++++--
 net/ipv4/tcp_minisocks.c           | 7 +++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 10a625760de9..3c8c59471bc1 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -282,7 +282,7 @@ static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 	return inet_csk_reqsk_queue_len(sk) >= sk->sk_max_ack_backlog;
 }
 
-void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
+bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
 void inet_csk_reqsk_queue_drop_and_put(struct sock *sk, struct request_sock *req);
 
 static inline void inet_csk_prepare_for_destroy_sock(struct sock *sk)
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 6bd7ca09af03..fd472eae4f5c 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -705,12 +705,15 @@ static bool reqsk_queue_unlink(struct request_sock *req)
 	return found;
 }
 
-void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
+bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
 {
-	if (reqsk_queue_unlink(req)) {
+	bool unlinked = reqsk_queue_unlink(req);
+
+	if (unlinked) {
 		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
 		reqsk_put(req);
 	}
+	return unlinked;
 }
 EXPORT_SYMBOL(inet_csk_reqsk_queue_drop);
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0055ae0a3bf8..7513ba45553d 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -804,8 +804,11 @@ embryonic_reset:
 		tcp_reset(sk, skb);
 	}
 	if (!fastopen) {
-		inet_csk_reqsk_queue_drop(sk, req);
-		__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
+		bool unlinked = inet_csk_reqsk_queue_drop(sk, req);
+
+		if (unlinked)
+			__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
+		*req_stolen = !unlinked;
 	}
 	return NULL;
 }
-- 
2.30.1




