Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0221768100F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbjA3N72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbjA3N7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:59:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7236C2B60A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1D9FB81144
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A43C433EF;
        Mon, 30 Jan 2023 13:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087138;
        bh=PaBntS6sQ6YPznsHsjulhhp7hdw3LAzJqNH/OE4skB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbaZAHRnTIyosM2Yu2f5iGdVR9gEwVl1ld3USRRu7SQPvUq3xNTj4FaqicYpm7XQf
         jgZbFzHMvbmBA/popAyMcmvNU1ruNa7as95BltExVEHpawCmQMwjJmvgOQqi89D1DM
         UVLmALGCMv2NJQXSkwmpFBOL9bpljRc5g2m/vi/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/313] Bluetooth: ISO: Fix possible circular locking dependency
Date:   Mon, 30 Jan 2023 14:48:57 +0100
Message-Id: <20230130134341.395637087@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 6a5ad251b7cdb990a3705428aef408433f05614a ]

This attempts to fix the following trace:

kworker/u3:1/184 is trying to acquire lock:
ffff888001888130 (sk_lock-AF_BLUETOOTH-BTPROTO_ISO){+.+.}-{0:0}, at:
iso_connect_cfm+0x2de/0x690

but task is already holding lock:
ffff8880028d1c20 (&conn->lock){+.+.}-{2:2}, at:
iso_connect_cfm+0x265/0x690

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&conn->lock){+.+.}-{2:2}:
       lock_acquire+0x176/0x3d0
       _raw_spin_lock+0x2a/0x40
       __iso_sock_close+0x1dd/0x4f0
       iso_sock_release+0xa0/0x1b0
       sock_close+0x5e/0x120
       __fput+0x102/0x410
       task_work_run+0xf1/0x160
       exit_to_user_mode_prepare+0x170/0x180
       syscall_exit_to_user_mode+0x19/0x50
       do_syscall_64+0x4e/0x90
       entry_SYSCALL_64_after_hwframe+0x62/0xcc

-> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_ISO){+.+.}-{0:0}:
       check_prev_add+0xfc/0x1190
       __lock_acquire+0x1e27/0x2750
       lock_acquire+0x176/0x3d0
       lock_sock_nested+0x32/0x80
       iso_connect_cfm+0x2de/0x690
       hci_cc_le_setup_iso_path+0x195/0x340
       hci_cmd_complete_evt+0x1ae/0x500
       hci_event_packet+0x38e/0x7c0
       hci_rx_work+0x34c/0x980
       process_one_work+0x5a5/0x9a0
       worker_thread+0x89/0x6f0
       kthread+0x14e/0x180
       ret_from_fork+0x22/0x30

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&conn->lock);
                               lock(sk_lock-AF_BLUETOOTH-BTPROTO_ISO);
                               lock(&conn->lock);
  lock(sk_lock-AF_BLUETOOTH-BTPROTO_ISO);

 *** DEADLOCK ***

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Fixes: f764a6c2c1e4 ("Bluetooth: ISO: Add broadcast support")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 61 +++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index df57cbe27b3d..2dabef488eaa 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -288,15 +288,15 @@ static int iso_connect_bis(struct sock *sk)
 	hci_dev_unlock(hdev);
 	hci_dev_put(hdev);
 
+	err = iso_chan_add(conn, sk, NULL);
+	if (err)
+		return err;
+
 	lock_sock(sk);
 
 	/* Update source addr of the socket */
 	bacpy(&iso_pi(sk)->src, &hcon->src);
 
-	err = iso_chan_add(conn, sk, NULL);
-	if (err)
-		goto release;
-
 	if (hcon->state == BT_CONNECTED) {
 		iso_sock_clear_timer(sk);
 		sk->sk_state = BT_CONNECTED;
@@ -305,7 +305,6 @@ static int iso_connect_bis(struct sock *sk)
 		iso_sock_set_timer(sk, sk->sk_sndtimeo);
 	}
 
-release:
 	release_sock(sk);
 	return err;
 
@@ -371,15 +370,15 @@ static int iso_connect_cis(struct sock *sk)
 	hci_dev_unlock(hdev);
 	hci_dev_put(hdev);
 
+	err = iso_chan_add(conn, sk, NULL);
+	if (err)
+		return err;
+
 	lock_sock(sk);
 
 	/* Update source addr of the socket */
 	bacpy(&iso_pi(sk)->src, &hcon->src);
 
-	err = iso_chan_add(conn, sk, NULL);
-	if (err)
-		goto release;
-
 	if (hcon->state == BT_CONNECTED) {
 		iso_sock_clear_timer(sk);
 		sk->sk_state = BT_CONNECTED;
@@ -391,7 +390,6 @@ static int iso_connect_cis(struct sock *sk)
 		iso_sock_set_timer(sk, sk->sk_sndtimeo);
 	}
 
-release:
 	release_sock(sk);
 	return err;
 
@@ -1430,33 +1428,29 @@ static void iso_conn_ready(struct iso_conn *conn)
 	struct sock *parent;
 	struct sock *sk = conn->sk;
 	struct hci_ev_le_big_sync_estabilished *ev;
+	struct hci_conn *hcon;
 
 	BT_DBG("conn %p", conn);
 
 	if (sk) {
 		iso_sock_ready(conn->sk);
 	} else {
-		iso_conn_lock(conn);
-
-		if (!conn->hcon) {
-			iso_conn_unlock(conn);
+		hcon = conn->hcon;
+		if (!hcon)
 			return;
-		}
 
-		ev = hci_recv_event_data(conn->hcon->hdev,
+		ev = hci_recv_event_data(hcon->hdev,
 					 HCI_EVT_LE_BIG_SYNC_ESTABILISHED);
 		if (ev)
-			parent = iso_get_sock_listen(&conn->hcon->src,
-						     &conn->hcon->dst,
+			parent = iso_get_sock_listen(&hcon->src,
+						     &hcon->dst,
 						     iso_match_big, ev);
 		else
-			parent = iso_get_sock_listen(&conn->hcon->src,
+			parent = iso_get_sock_listen(&hcon->src,
 						     BDADDR_ANY, NULL, NULL);
 
-		if (!parent) {
-			iso_conn_unlock(conn);
+		if (!parent)
 			return;
-		}
 
 		lock_sock(parent);
 
@@ -1464,30 +1458,29 @@ static void iso_conn_ready(struct iso_conn *conn)
 				    BTPROTO_ISO, GFP_ATOMIC, 0);
 		if (!sk) {
 			release_sock(parent);
-			iso_conn_unlock(conn);
 			return;
 		}
 
 		iso_sock_init(sk, parent);
 
-		bacpy(&iso_pi(sk)->src, &conn->hcon->src);
-		iso_pi(sk)->src_type = conn->hcon->src_type;
+		bacpy(&iso_pi(sk)->src, &hcon->src);
+		iso_pi(sk)->src_type = hcon->src_type;
 
 		/* If hcon has no destination address (BDADDR_ANY) it means it
 		 * was created by HCI_EV_LE_BIG_SYNC_ESTABILISHED so we need to
 		 * initialize using the parent socket destination address.
 		 */
-		if (!bacmp(&conn->hcon->dst, BDADDR_ANY)) {
-			bacpy(&conn->hcon->dst, &iso_pi(parent)->dst);
-			conn->hcon->dst_type = iso_pi(parent)->dst_type;
-			conn->hcon->sync_handle = iso_pi(parent)->sync_handle;
+		if (!bacmp(&hcon->dst, BDADDR_ANY)) {
+			bacpy(&hcon->dst, &iso_pi(parent)->dst);
+			hcon->dst_type = iso_pi(parent)->dst_type;
+			hcon->sync_handle = iso_pi(parent)->sync_handle;
 		}
 
-		bacpy(&iso_pi(sk)->dst, &conn->hcon->dst);
-		iso_pi(sk)->dst_type = conn->hcon->dst_type;
+		bacpy(&iso_pi(sk)->dst, &hcon->dst);
+		iso_pi(sk)->dst_type = hcon->dst_type;
 
-		hci_conn_hold(conn->hcon);
-		__iso_chan_add(conn, sk, parent);
+		hci_conn_hold(hcon);
+		iso_chan_add(conn, sk, parent);
 
 		if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(parent)->flags))
 			sk->sk_state = BT_CONNECT2;
@@ -1498,8 +1491,6 @@ static void iso_conn_ready(struct iso_conn *conn)
 		parent->sk_data_ready(parent);
 
 		release_sock(parent);
-
-		iso_conn_unlock(conn);
 	}
 }
 
-- 
2.39.0



