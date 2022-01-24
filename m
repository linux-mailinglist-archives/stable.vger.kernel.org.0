Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B58498B75
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343769AbiAXTNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347811AbiAXTLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:11:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5575C061363;
        Mon, 24 Jan 2022 11:02:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 653D460E8D;
        Mon, 24 Jan 2022 19:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED0BC340E5;
        Mon, 24 Jan 2022 19:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050972;
        bh=hVdfrHB2ZSWoX/hpKALbnPJ5Gr6TKGq80beaN5XyGN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXHn/NFAUzYo/91exB1K28JlxVviXTqMF4xmNvfxD40uJFr6M/puJpGJ1yi346df9
         8I2PfwWjtFQhtZa6K33ToivTDlSWp59K3r01UhW8bl3dn5Cen1Bw+XVtBHM/GfGMrU
         rinzvK5rL2VK/pn8FBSiQ4+IBF+ESjraQXIgdr4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 014/186] Bluetooth: schedule SCO timeouts with delayed_work
Date:   Mon, 24 Jan 2022 19:41:29 +0100
Message-Id: <20220124183937.568318274@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

commit ba316be1b6a00db7126ed9a39f9bee434a508043 upstream.

struct sock.sk_timer should be used as a sock cleanup timer. However,
SCO uses it to implement sock timeouts.

This causes issues because struct sock.sk_timer's callback is run in
an IRQ context, and the timer callback function sco_sock_timeout takes
a spin lock on the socket. However, other functions such as
sco_conn_del and sco_conn_ready take the spin lock with interrupts
enabled.

This inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock usage could
lead to deadlocks as reported by Syzbot [1]:
       CPU0
       ----
  lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
  <Interrupt>
    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

To fix this, we use delayed work to implement SCO sock timouts
instead. This allows us to avoid taking the spin lock on the socket in
an IRQ context, and corrects the misuse of struct sock.sk_timer.

As a note, cancel_delayed_work is used instead of
cancel_delayed_work_sync in sco_sock_set_timer and
sco_sock_clear_timer to avoid a deadlock. In the future, the call to
bh_lock_sock inside sco_sock_timeout should be changed to lock_sock to
synchronize with other functions using lock_sock. However, since
sco_sock_set_timer and sco_sock_clear_timer are sometimes called under
the locked socket (in sco_connect and __sco_sock_close),
cancel_delayed_work_sync might cause them to sleep until an
sco_sock_timeout that has started finishes running. But
sco_sock_timeout would also sleep until it can grab the lock_sock.

Using cancel_delayed_work is fine because sco_sock_timeout does not
change from run to run, hence there is no functional difference
between:
1. waiting for a timeout to finish running before scheduling another
timeout
2. scheduling another timeout while a timeout is running.

Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[OP: adjusted context for 4.14]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -48,6 +48,8 @@ struct sco_conn {
 	spinlock_t	lock;
 	struct sock	*sk;
 
+	struct delayed_work	timeout_work;
+
 	unsigned int    mtu;
 };
 
@@ -73,9 +75,20 @@ struct sco_pinfo {
 #define SCO_CONN_TIMEOUT	(HZ * 40)
 #define SCO_DISCONN_TIMEOUT	(HZ * 2)
 
-static void sco_sock_timeout(unsigned long arg)
+static void sco_sock_timeout(struct work_struct *work)
 {
-	struct sock *sk = (struct sock *)arg;
+	struct sco_conn *conn = container_of(work, struct sco_conn,
+					     timeout_work.work);
+	struct sock *sk;
+
+	sco_conn_lock(conn);
+	sk = conn->sk;
+	if (sk)
+		sock_hold(sk);
+	sco_conn_unlock(conn);
+
+	if (!sk)
+		return;
 
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
 
@@ -89,14 +102,21 @@ static void sco_sock_timeout(unsigned lo
 
 static void sco_sock_set_timer(struct sock *sk, long timeout)
 {
+	if (!sco_pi(sk)->conn)
+		return;
+
 	BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
-	sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
+	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
+	schedule_delayed_work(&sco_pi(sk)->conn->timeout_work, timeout);
 }
 
 static void sco_sock_clear_timer(struct sock *sk)
 {
+	if (!sco_pi(sk)->conn)
+		return;
+
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
-	sk_stop_timer(sk, &sk->sk_timer);
+	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
 }
 
 /* ---- SCO connections ---- */
@@ -176,6 +196,9 @@ static void sco_conn_del(struct hci_conn
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
 		sock_put(sk);
+
+		/* Ensure no more work items will run before freeing conn. */
+		cancel_delayed_work_sync(&conn->timeout_work);
 	}
 
 	hcon->sco_data = NULL;
@@ -190,6 +213,8 @@ static void __sco_chan_add(struct sco_co
 	sco_pi(sk)->conn = conn;
 	conn->sk = sk;
 
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
+
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
 }
@@ -466,8 +491,6 @@ static struct sock *sco_sock_alloc(struc
 
 	sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
 
-	setup_timer(&sk->sk_timer, sco_sock_timeout, (unsigned long)sk);
-
 	bt_sock_link(&sco_sk_list, sk);
 	return sk;
 }


