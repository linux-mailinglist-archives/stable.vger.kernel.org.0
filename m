Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803E13C4BAB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbhGLG6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239811AbhGLG6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34A10611C2;
        Mon, 12 Jul 2021 06:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072905;
        bh=ObtccxhA6maFkNuGS8SVMVX4ToKpiiF2Cefv679MDRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfiwIQIWR05t2LjWpSpHxC7dwXzxi4HrEglpeFpVk/lkJyPtENKboVe6Mgka5qiEC
         1ngJ6KHbjI683qyvS72wEUBMyRijay9gjddqtieJetk135LdWxZcSVKUA5zLeFYk4r
         3dYIR76opksO8RzuiVT/Wj7NoMb96/+bFhiFeQuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        syzbot+bdf710cfc41c186fdff3@syzkaller.appspotmail.com,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.12 060/700] can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() after RCU is done
Date:   Mon, 12 Jul 2021 08:02:23 +0200
Message-Id: <20210712060933.221760319@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 22c696fed25c63c7f67508309820358b94a96b6d upstream.

Set SOCK_RCU_FREE to let RCU to call sk_destruct() on completion.
Without this patch, we will run in to j1939_can_recv() after priv was
freed by j1939_sk_release()->j1939_sk_sock_destruct()

Fixes: 25fe97cb7620 ("can: j1939: move j1939_priv_put() into sk_destruct callback")
Link: https://lore.kernel.org/r/20210617130623.12705-1-o.rempel@pengutronix.de
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Reported-by: syzbot+bdf710cfc41c186fdff3@syzkaller.appspotmail.com
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/j1939/main.c   |    4 ++++
 net/can/j1939/socket.c |    3 +++
 2 files changed, 7 insertions(+)

--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -193,6 +193,10 @@ static void j1939_can_rx_unregister(stru
 	can_rx_unregister(dev_net(ndev), ndev, J1939_CAN_ID, J1939_CAN_MASK,
 			  j1939_can_recv, priv);
 
+	/* The last reference of priv is dropped by the RCU deferred
+	 * j1939_sk_sock_destruct() of the last socket, so we can
+	 * safely drop this reference here.
+	 */
 	j1939_priv_put(priv);
 }
 
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -398,6 +398,9 @@ static int j1939_sk_init(struct sock *sk
 	atomic_set(&jsk->skb_pending, 0);
 	spin_lock_init(&jsk->sk_session_queue_lock);
 	INIT_LIST_HEAD(&jsk->sk_session_queue);
+
+	/* j1939_sk_sock_destruct() depends on SOCK_RCU_FREE flag */
+	sock_set_flag(sk, SOCK_RCU_FREE);
 	sk->sk_destruct = j1939_sk_sock_destruct;
 	sk->sk_protocol = CAN_J1939;
 


