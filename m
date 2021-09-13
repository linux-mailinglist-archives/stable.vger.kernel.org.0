Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B4840920A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344766AbhIMOH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344610AbhIMOFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:05:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D565861269;
        Mon, 13 Sep 2021 13:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540388;
        bh=ovj2dHtuEL0E6nt/2T8arqcn3LibHZn3l4vSyNwBUP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8Gy7fGdr+OVeTR9Fd+7Z5hK8NeeG4RjG3TjCK+MSdsAzzVsAGUGNtv2zdLTL+CUb
         jJV7VBCYYappJu+NoamADr9Af79ge3u28OuHJCU8PM7wyuSvLp4ZcLOAbUdNpeIzk6
         p9DUc8StEj2w8H/EbUSxAhyd5fom7yxAnUChsjVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 173/300] Bluetooth: fix repeated calls to sco_sock_kill
Date:   Mon, 13 Sep 2021 15:13:54 +0200
Message-Id: <20210913131115.244683276@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
index a7b4555f312f..9769a7ceb689 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -85,7 +85,6 @@ static void sco_sock_timeout(struct timer_list *t)
 	sk->sk_state_change(sk);
 	bh_unlock_sock(sk);
 
-	sco_sock_kill(sk);
 	sock_put(sk);
 }
 
@@ -177,7 +176,6 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
-		sco_sock_kill(sk);
 		sock_put(sk);
 	}
 
@@ -394,8 +392,7 @@ static void sco_sock_cleanup_listen(struct sock *parent)
  */
 static void sco_sock_kill(struct sock *sk)
 {
-	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket ||
-	    sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
 		return;
 
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
@@ -447,7 +444,6 @@ static void sco_sock_close(struct sock *sk)
 	lock_sock(sk);
 	__sco_sock_close(sk);
 	release_sock(sk);
-	sco_sock_kill(sk);
 }
 
 static void sco_skb_put_cmsg(struct sk_buff *skb, struct msghdr *msg,
-- 
2.30.2



