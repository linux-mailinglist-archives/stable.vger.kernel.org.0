Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E30234CA4D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhC2Igc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234323AbhC2IfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8041D619B4;
        Mon, 29 Mar 2021 08:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006903;
        bh=aNVPLI7ebc87h2oaL+qeNkrPh52+V6rtZmz1fQJ63SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeEszOoAikuQCZzwuUZpI4nqOVoMd3HcvdTUQXeVjMpeC59lHj1DPgWpE5+vbr6Xi
         /ppHMeO8kYkZlaasqZkdHkZ20+mTin3J/6HMO4VwM0bVEw0KYf1MkV8LWvvmmm8/sJ
         FoTeaLc0o6T2cpP7jMMneuszaSTeaaImAxAP1oMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        Oleg Senin <olegsenin@yandex-team.ru>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 145/254] tcp: relookup sock for RST+ACK packets handled by obsolete req sock
Date:   Mon, 29 Mar 2021 09:57:41 +0200
Message-Id: <20210329075637.975017246@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Ovechkin <ovov@yandex-team.ru>

[ Upstream commit 7233da86697efef41288f8b713c10c2499cffe85 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h | 2 +-
 net/ipv4/inet_connection_sock.c    | 7 +++++--
 net/ipv4/tcp_minisocks.c           | 7 +++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 111d7771b208..aa92af3dd444 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -284,7 +284,7 @@ static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
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



