Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7984B3D61A4
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhGZPc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232702AbhGZPah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E815760240;
        Mon, 26 Jul 2021 16:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315865;
        bh=2tjdCL3aJ6Hw8vCvKplDi9yUOkQlbeIY10x3DZmK5Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOix8gXUfibcq00sCd25vWLPM/C8/2VmIF8T7unGhLonxbQdROcVfasZ5SsWv3Lko
         9nglTxrNJhT6khEXHNQboC8S+cKrnU/YGD8vPp3cNznYbC2+ADIffgUvJWNzzACiYT
         CvD4AwLfpEBF2P7xO/Kcbiwi3kI0fNXP9fYZyyCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nguyen Dinh Phi <phind.uet@gmail.com>,
        syzbot+10f1194569953b72f1ae@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 097/223] netrom: Decrease sock refcount when sock timers expire
Date:   Mon, 26 Jul 2021 17:38:09 +0200
Message-Id: <20210726153849.437125690@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nguyen Dinh Phi <phind.uet@gmail.com>

[ Upstream commit 517a16b1a88bdb6b530f48d5d153478b2552d9a8 ]

Commit 63346650c1a9 ("netrom: switch to sock timer API") switched to use
sock timer API. It replaces mod_timer() by sk_reset_timer(), and
del_timer() by sk_stop_timer().

Function sk_reset_timer() will increase the refcount of sock if it is
called on an inactive timer, hence, in case the timer expires, we need to
decrease the refcount ourselves in the handler, otherwise, the sock
refcount will be unbalanced and the sock will never be freed.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+10f1194569953b72f1ae@syzkaller.appspotmail.com
Fixes: 63346650c1a9 ("netrom: switch to sock timer API")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_timer.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netrom/nr_timer.c b/net/netrom/nr_timer.c
index 9115f8a7dd45..a8da88db7893 100644
--- a/net/netrom/nr_timer.c
+++ b/net/netrom/nr_timer.c
@@ -121,11 +121,9 @@ static void nr_heartbeat_expiry(struct timer_list *t)
 		   is accepted() it isn't 'dead' so doesn't get removed. */
 		if (sock_flag(sk, SOCK_DESTROY) ||
 		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
-			sock_hold(sk);
 			bh_unlock_sock(sk);
 			nr_destroy_socket(sk);
-			sock_put(sk);
-			return;
+			goto out;
 		}
 		break;
 
@@ -146,6 +144,8 @@ static void nr_heartbeat_expiry(struct timer_list *t)
 
 	nr_start_heartbeat(sk);
 	bh_unlock_sock(sk);
+out:
+	sock_put(sk);
 }
 
 static void nr_t2timer_expiry(struct timer_list *t)
@@ -159,6 +159,7 @@ static void nr_t2timer_expiry(struct timer_list *t)
 		nr_enquiry_response(sk);
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void nr_t4timer_expiry(struct timer_list *t)
@@ -169,6 +170,7 @@ static void nr_t4timer_expiry(struct timer_list *t)
 	bh_lock_sock(sk);
 	nr_sk(sk)->condition &= ~NR_COND_PEER_RX_BUSY;
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void nr_idletimer_expiry(struct timer_list *t)
@@ -197,6 +199,7 @@ static void nr_idletimer_expiry(struct timer_list *t)
 		sock_set_flag(sk, SOCK_DEAD);
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void nr_t1timer_expiry(struct timer_list *t)
@@ -209,8 +212,7 @@ static void nr_t1timer_expiry(struct timer_list *t)
 	case NR_STATE_1:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_write_internal(sk, NR_CONNREQ);
@@ -220,8 +222,7 @@ static void nr_t1timer_expiry(struct timer_list *t)
 	case NR_STATE_2:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_write_internal(sk, NR_DISCREQ);
@@ -231,8 +232,7 @@ static void nr_t1timer_expiry(struct timer_list *t)
 	case NR_STATE_3:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_requeue_frames(sk);
@@ -241,5 +241,7 @@ static void nr_t1timer_expiry(struct timer_list *t)
 	}
 
 	nr_start_t1timer(sk);
+out:
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
-- 
2.30.2



