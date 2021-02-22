Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853E0321707
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhBVMlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:41:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231452AbhBVMjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:39:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95FB564E41;
        Mon, 22 Feb 2021 12:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997490;
        bh=sUEhRW8eodrWE6ARQEJb2zD7Y+mmXznoyhZiF4RlgVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYKTAfg7pZPaBome88QZG7KJvB/naP0ZBQUk27J7hVaa5RGLcv3xv5lvjhr2PcT1Q
         woy6GrXYglUmjXZhRwE15Uinhjdrf+hmY3pYXV47JJ21ydUvufexC0FNnitVJuADjU
         qMMdmNS6ORK3v1/1RhPszZ2GAHohOwBzEoqCkVTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 38/57] vsock: fix locking in vsock_shutdown()
Date:   Mon, 22 Feb 2021 13:36:04 +0100
Message-Id: <20210222121030.592550076@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit 1c5fae9c9a092574398a17facc31c533791ef232 upstream.

In vsock_shutdown() we touched some socket fields without holding the
socket lock, such as 'state' and 'sk_flags'.

Also, after the introduction of multi-transport, we are accessing
'vsk->transport' in vsock_send_shutdown() without holding the lock
and this call can be made while the connection is in progress, so
the transport can change in the meantime.

To avoid issues, we hold the socket lock when we enter in
vsock_shutdown() and release it when we leave.

Among the transports that implement the 'shutdown' callback, only
hyperv_transport acquired the lock. Since the caller now holds it,
we no longer take it.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c         |    8 +++++---
 net/vmw_vsock/hyperv_transport.c |    4 ----
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -823,10 +823,12 @@ static int vsock_shutdown(struct socket
 	 */
 
 	sk = sock->sk;
+
+	lock_sock(sk);
 	if (sock->state == SS_UNCONNECTED) {
 		err = -ENOTCONN;
 		if (sk->sk_type == SOCK_STREAM)
-			return err;
+			goto out;
 	} else {
 		sock->state = SS_DISCONNECTING;
 		err = 0;
@@ -835,10 +837,8 @@ static int vsock_shutdown(struct socket
 	/* Receive and send shutdowns are treated alike. */
 	mode = mode & (RCV_SHUTDOWN | SEND_SHUTDOWN);
 	if (mode) {
-		lock_sock(sk);
 		sk->sk_shutdown |= mode;
 		sk->sk_state_change(sk);
-		release_sock(sk);
 
 		if (sk->sk_type == SOCK_STREAM) {
 			sock_reset_flag(sk, SOCK_DONE);
@@ -846,6 +846,8 @@ static int vsock_shutdown(struct socket
 		}
 	}
 
+out:
+	release_sock(sk);
 	return err;
 }
 
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -444,14 +444,10 @@ static void hvs_shutdown_lock_held(struc
 
 static int hvs_shutdown(struct vsock_sock *vsk, int mode)
 {
-	struct sock *sk = sk_vsock(vsk);
-
 	if (!(mode & SEND_SHUTDOWN))
 		return 0;
 
-	lock_sock(sk);
 	hvs_shutdown_lock_held(vsk->trans, mode);
-	release_sock(sk);
 	return 0;
 }
 


