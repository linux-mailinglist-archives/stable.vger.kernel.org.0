Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB53C353D9B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhDEJAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237219AbhDEJAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBB4B6124C;
        Mon,  5 Apr 2021 09:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613239;
        bh=JG3rcj9yUPFQbNTf21qj+7dxIRrq32Sbt//oZalSZsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jessx7rZZcT3j0aMfWvgc3Ic8HQmcpyAeH4dm6FT0++1TAt5/ZX0zsnYq9C//K7MI
         GJzgjoK42Gs0wsJ1+nNbEmL6FS/2Y7/ZebX6m1+Q4bS238iBHxKfOJuOC8I+ksxBYU
         bAnz0H3D6rA2XeJTFFCEW29IjxNnuc+b9xmekRzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        Oleg Senin <olegsenin@yandex-team.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/56] tcp: relookup sock for RST+ACK packets handled by obsolete req sock
Date:   Mon,  5 Apr 2021 10:53:33 +0200
Message-Id: <20210405085022.638938821@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Ovechkin <ovov@yandex-team.ru>

commit 7233da86697efef41288f8b713c10c2499cffe85 upstream.

Currently tcp_check_req can be called with obsolete req socket for which big
socket have been already created (because of CPU race or early demux
assigning req socket to multiple packets in gro batch).

Commit e0f9759f530bf789e984 ("tcp: try to keep packet if SYN_RCV race
is lost") added retry in case when tcp_check_req is called for PSH|ACK packet.
But if client sends RST+ACK immediatly after connection being
established (it is performing healthcheck, for example) retry does not
occur. In that case tcp_check_req tries to close req socket,
leaving big socket active.

Fixes: e0f9759f530b ("tcp: try to keep packet if SYN_RCV race is lost")
Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
Reported-by: Oleg Senin <olegsenin@yandex-team.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h | 2 +-
 net/ipv4/inet_connection_sock.c    | 7 +++++--
 net/ipv4/tcp_minisocks.c           | 7 +++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index fc9d6e37552d..da8a582ab032 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -288,7 +288,7 @@ static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 	return inet_csk_reqsk_queue_len(sk) >= sk->sk_max_ack_backlog;
 }
 
-void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
+bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
 void inet_csk_reqsk_queue_drop_and_put(struct sock *sk, struct request_sock *req);
 
 void inet_csk_destroy_sock(struct sock *sk);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 534e2598981d..439a55d1aa99 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -698,12 +698,15 @@ static bool reqsk_queue_unlink(struct request_sock_queue *queue,
 	return found;
 }
 
-void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
+bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
 {
-	if (reqsk_queue_unlink(&inet_csk(sk)->icsk_accept_queue, req)) {
+	bool unlinked = reqsk_queue_unlink(&inet_csk(sk)->icsk_accept_queue, req);
+
+	if (unlinked) {
 		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
 		reqsk_put(req);
 	}
+	return unlinked;
 }
 EXPORT_SYMBOL(inet_csk_reqsk_queue_drop);
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 9436fb9b6a3d..a20b393b4501 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -815,8 +815,11 @@ embryonic_reset:
 		tcp_reset(sk);
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



