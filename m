Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0743D5D7D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhGZPBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235616AbhGZPBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 868C260F92;
        Mon, 26 Jul 2021 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314130;
        bh=I2P/HKSHOQzt+1zw+yMkiZZVIGw37oF+WlVyIzs8Gaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDxqjmuCK7SOv0s8A1nWZtIjYZ2rBRSCNKiaz6PxVJ1yxeEBozG5Nz5QVPn7fKAvG
         nJjwcxgHtwXkDX8XJ/iRwYrbGLROs+sjX/tjMsgI9TeeUhHICcItuzfKDDcaJIlKiv
         q6X8J5S3yK07N5eS/vGRvmcigKvM28T5vdVpuyQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nguyen Dinh Phi <phind.uet@gmail.com>,
        syzbot+10f1194569953b72f1ae@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 26/47] netrom: Decrease sock refcount when sock timers expire
Date:   Mon, 26 Jul 2021 17:38:44 +0200
Message-Id: <20210726153823.805526557@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
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
index f0ecaec1ff3d..d1a0b7056743 100644
--- a/net/netrom/nr_timer.c
+++ b/net/netrom/nr_timer.c
@@ -125,11 +125,9 @@ static void nr_heartbeat_expiry(unsigned long param)
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
 
@@ -150,6 +148,8 @@ static void nr_heartbeat_expiry(unsigned long param)
 
 	nr_start_heartbeat(sk);
 	bh_unlock_sock(sk);
+out:
+	sock_put(sk);
 }
 
 static void nr_t2timer_expiry(unsigned long param)
@@ -163,6 +163,7 @@ static void nr_t2timer_expiry(unsigned long param)
 		nr_enquiry_response(sk);
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void nr_t4timer_expiry(unsigned long param)
@@ -172,6 +173,7 @@ static void nr_t4timer_expiry(unsigned long param)
 	bh_lock_sock(sk);
 	nr_sk(sk)->condition &= ~NR_COND_PEER_RX_BUSY;
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void nr_idletimer_expiry(unsigned long param)
@@ -200,6 +202,7 @@ static void nr_idletimer_expiry(unsigned long param)
 		sock_set_flag(sk, SOCK_DEAD);
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void nr_t1timer_expiry(unsigned long param)
@@ -212,8 +215,7 @@ static void nr_t1timer_expiry(unsigned long param)
 	case NR_STATE_1:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_write_internal(sk, NR_CONNREQ);
@@ -223,8 +225,7 @@ static void nr_t1timer_expiry(unsigned long param)
 	case NR_STATE_2:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_write_internal(sk, NR_DISCREQ);
@@ -234,8 +235,7 @@ static void nr_t1timer_expiry(unsigned long param)
 	case NR_STATE_3:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_requeue_frames(sk);
@@ -244,5 +244,7 @@ static void nr_t1timer_expiry(unsigned long param)
 	}
 
 	nr_start_t1timer(sk);
+out:
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
-- 
2.30.2



