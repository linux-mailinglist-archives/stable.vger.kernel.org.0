Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DEE411A5C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244105AbhITQtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243253AbhITQsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:48:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B586A61268;
        Mon, 20 Sep 2021 16:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156415;
        bh=GCwUDMsFmbVux04PeiOGhO2O80RocRZ7qLtJsgRhJEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUcuRplAux0Z8EC2pvHovZW/VAHq+OvIpEMnkN7s+ItCQ4H2Be0ckzkN+ntA5LKna
         Mogj530KIupKky7oD4PdqbwGRkRL2Rv0bjo12DyUcZPFDuPJtQCJoBYt0O2wvE87rw
         Bq1q8oGhykWP4beWpJ1Odh+UBIPO4o2Wt7SFwb34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 048/133] Bluetooth: fix repeated calls to sco_sock_kill
Date:   Mon, 20 Sep 2021 18:42:06 +0200
Message-Id: <20210920163914.218558386@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit e1dee2c1de2b4dd00eb44004a4bda6326ed07b59 ]

In commit 4e1a720d0312 ("Bluetooth: avoid killing an already killed
socket"), a check was added to sco_sock_kill to skip killing a socket
if the SOCK_DEAD flag was set.

This was done after a trace for a use-after-free bug showed that the
same sock pointer was being killed twice.

Unfortunately, this check prevents sco_sock_kill from running on any
socket. sco_sock_kill kills a socket only if it's zapped and orphaned,
however sock_orphan announces that the socket is dead before detaching
it. i.e., orphaned sockets have the SOCK_DEAD flag set.

To fix this, we remove the check for SOCK_DEAD, and avoid repeated
calls to sco_sock_kill by removing incorrect calls in:

1. sco_sock_timeout. The socket should not be killed on timeout as
further processing is expected to be done. For example,
sco_sock_connect sets the timer then waits for the socket to be
connected or for an error to be returned.

2. sco_conn_del. This function should clean up resources for the
connection, but the socket itself should be cleaned up in
sco_sock_release.

3. sco_sock_close. Calls to sco_sock_close in sco_sock_cleanup_listen
and sco_sock_release are followed by sco_sock_kill. Hence the
duplicated call should be removed.

Fixes: 4e1a720d0312 ("Bluetooth: avoid killing an already killed socket")
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index cad0d2750735..701d230fb9cf 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -83,7 +83,6 @@ static void sco_sock_timeout(unsigned long arg)
 	sk->sk_state_change(sk);
 	bh_unlock_sock(sk);
 
-	sco_sock_kill(sk);
 	sock_put(sk);
 }
 
@@ -175,7 +174,6 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
-		sco_sock_kill(sk);
 		sock_put(sk);
 	}
 
@@ -392,8 +390,7 @@ static void sco_sock_cleanup_listen(struct sock *parent)
  */
 static void sco_sock_kill(struct sock *sk)
 {
-	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket ||
-	    sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
 		return;
 
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
@@ -445,7 +442,6 @@ static void sco_sock_close(struct sock *sk)
 	lock_sock(sk);
 	__sco_sock_close(sk);
 	release_sock(sk);
-	sco_sock_kill(sk);
 }
 
 static void sco_sock_init(struct sock *sk, struct sock *parent)
-- 
2.30.2



