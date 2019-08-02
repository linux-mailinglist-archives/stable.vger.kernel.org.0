Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9BA37F3B7
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406611AbfHBJ7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406528AbfHBJz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:55:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC8442086A;
        Fri,  2 Aug 2019 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739725;
        bh=YYYz1aKx97Ii5R7lI2bmjC8XYExlbd+kK6xQ8flCFfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIuScfaImV8vANWwcpYIYbd0sjUzV7NyZ3KLDWPAJUp6CGzrKPYWGqhTupES1aT0B
         behDjNmey0UC+SZqAVwQOThoiUfce44VnHVdqeKY//sFsGr7Yt/lUuphDlHAVG5VBJ
         sqcNRHR27PpxCvTSC6VGY7CzYlaXHfHuRJTXcHBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Muthuswamy <sunilmut@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 01/32] hv_sock: Add support for delayed close
Date:   Fri,  2 Aug 2019 11:39:35 +0200
Message-Id: <20190802092102.084353778@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunil Muthuswamy <sunilmut@microsoft.com>

commit a9eeb998c28d5506616426bd3a216bd5735a18b8 upstream.

Currently, hvsock does not implement any delayed or background close
logic. Whenever the hvsock socket is closed, a FIN is sent to the peer, and
the last reference to the socket is dropped, which leads to a call to
.destruct where the socket can hang indefinitely waiting for the peer to
close it's side. The can cause the user application to hang in the close()
call.

This change implements proper STREAM(TCP) closing handshake mechanism by
sending the FIN to the peer and the waiting for the peer's FIN to arrive
for a given timeout. On timeout, it will try to terminate the connection
(i.e. a RST). This is in-line with other socket providers such as virtio.

This change does not address the hang in the vmbus_hvsock_device_unregister
where it waits indefinitely for the host to rescind the channel. That
should be taken up as a separate fix.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/vmw_vsock/hyperv_transport.c |  110 +++++++++++++++++++++++++++------------
 1 file changed, 78 insertions(+), 32 deletions(-)

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -35,6 +35,9 @@
 /* The MTU is 16KB per the host side's design */
 #define HVS_MTU_SIZE		(1024 * 16)
 
+/* How long to wait for graceful shutdown of a connection */
+#define HVS_CLOSE_TIMEOUT (8 * HZ)
+
 struct vmpipe_proto_header {
 	u32 pkt_type;
 	u32 data_size;
@@ -290,19 +293,32 @@ static void hvs_channel_cb(void *ctx)
 		sk->sk_write_space(sk);
 }
 
-static void hvs_close_connection(struct vmbus_channel *chan)
+static void hvs_do_close_lock_held(struct vsock_sock *vsk,
+				   bool cancel_timeout)
 {
-	struct sock *sk = get_per_channel_state(chan);
-	struct vsock_sock *vsk = vsock_sk(sk);
-
-	lock_sock(sk);
+	struct sock *sk = sk_vsock(vsk);
 
-	sk->sk_state = TCP_CLOSE;
 	sock_set_flag(sk, SOCK_DONE);
-	vsk->peer_shutdown |= SEND_SHUTDOWN | RCV_SHUTDOWN;
-
+	vsk->peer_shutdown = SHUTDOWN_MASK;
+	if (vsock_stream_has_data(vsk) <= 0)
+		sk->sk_state = TCP_CLOSING;
 	sk->sk_state_change(sk);
+	if (vsk->close_work_scheduled &&
+	    (!cancel_timeout || cancel_delayed_work(&vsk->close_work))) {
+		vsk->close_work_scheduled = false;
+		vsock_remove_sock(vsk);
+
+		/* Release the reference taken while scheduling the timeout */
+		sock_put(sk);
+	}
+}
+
+static void hvs_close_connection(struct vmbus_channel *chan)
+{
+	struct sock *sk = get_per_channel_state(chan);
 
+	lock_sock(sk);
+	hvs_do_close_lock_held(vsock_sk(sk), true);
 	release_sock(sk);
 }
 
@@ -445,50 +461,80 @@ static int hvs_connect(struct vsock_sock
 	return vmbus_send_tl_connect_request(&h->vm_srv_id, &h->host_srv_id);
 }
 
+static void hvs_shutdown_lock_held(struct hvsock *hvs, int mode)
+{
+	struct vmpipe_proto_header hdr;
+
+	if (hvs->fin_sent || !hvs->chan)
+		return;
+
+	/* It can't fail: see hvs_channel_writable_bytes(). */
+	(void)hvs_send_data(hvs->chan, (struct hvs_send_buf *)&hdr, 0);
+	hvs->fin_sent = true;
+}
+
 static int hvs_shutdown(struct vsock_sock *vsk, int mode)
 {
 	struct sock *sk = sk_vsock(vsk);
-	struct vmpipe_proto_header hdr;
-	struct hvs_send_buf *send_buf;
-	struct hvsock *hvs;
 
 	if (!(mode & SEND_SHUTDOWN))
 		return 0;
 
 	lock_sock(sk);
-
-	hvs = vsk->trans;
-	if (hvs->fin_sent)
-		goto out;
-
-	send_buf = (struct hvs_send_buf *)&hdr;
-
-	/* It can't fail: see hvs_channel_writable_bytes(). */
-	(void)hvs_send_data(hvs->chan, send_buf, 0);
-
-	hvs->fin_sent = true;
-out:
+	hvs_shutdown_lock_held(vsk->trans, mode);
 	release_sock(sk);
 	return 0;
 }
 
-static void hvs_release(struct vsock_sock *vsk)
+static void hvs_close_timeout(struct work_struct *work)
 {
+	struct vsock_sock *vsk =
+		container_of(work, struct vsock_sock, close_work.work);
 	struct sock *sk = sk_vsock(vsk);
-	struct hvsock *hvs = vsk->trans;
-	struct vmbus_channel *chan;
 
+	sock_hold(sk);
 	lock_sock(sk);
+	if (!sock_flag(sk, SOCK_DONE))
+		hvs_do_close_lock_held(vsk, false);
 
-	sk->sk_state = TCP_CLOSING;
-	vsock_remove_sock(vsk);
-
+	vsk->close_work_scheduled = false;
 	release_sock(sk);
+	sock_put(sk);
+}
 
-	chan = hvs->chan;
-	if (chan)
-		hvs_shutdown(vsk, RCV_SHUTDOWN | SEND_SHUTDOWN);
+/* Returns true, if it is safe to remove socket; false otherwise */
+static bool hvs_close_lock_held(struct vsock_sock *vsk)
+{
+	struct sock *sk = sk_vsock(vsk);
+
+	if (!(sk->sk_state == TCP_ESTABLISHED ||
+	      sk->sk_state == TCP_CLOSING))
+		return true;
+
+	if ((sk->sk_shutdown & SHUTDOWN_MASK) != SHUTDOWN_MASK)
+		hvs_shutdown_lock_held(vsk->trans, SHUTDOWN_MASK);
+
+	if (sock_flag(sk, SOCK_DONE))
+		return true;
+
+	/* This reference will be dropped by the delayed close routine */
+	sock_hold(sk);
+	INIT_DELAYED_WORK(&vsk->close_work, hvs_close_timeout);
+	vsk->close_work_scheduled = true;
+	schedule_delayed_work(&vsk->close_work, HVS_CLOSE_TIMEOUT);
+	return false;
+}
 
+static void hvs_release(struct vsock_sock *vsk)
+{
+	struct sock *sk = sk_vsock(vsk);
+	bool remove_sock;
+
+	lock_sock(sk);
+	remove_sock = hvs_close_lock_held(vsk);
+	release_sock(sk);
+	if (remove_sock)
+		vsock_remove_sock(vsk);
 }
 
 static void hvs_destruct(struct vsock_sock *vsk)


