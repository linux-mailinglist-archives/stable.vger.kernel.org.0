Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE7B32175B
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhBVMqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:46:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhBVMnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5EC864F42;
        Mon, 22 Feb 2021 12:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997626;
        bh=89JRW0Kq/X1EEd8vtSTOAkXkcapPWftBLe6KfGsUw/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0O87ccn39GKYXSjdR0g9Vva1k1NDII9GW9+vXHXJKPGqBD+4wHLO53/TbsEm5p0g
         USEEkKbVxDsVXBt7NAypZXT6yqaUB+F9Jw+7+/R+C33XFcRDxfKiaY9I8mrCJ5+u1l
         TvKlAyp4bqgJePn/h0U3VjDGwj5UXzooiJ2WUABk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 20/35] vsock: fix locking in vsock_shutdown()
Date:   Mon, 22 Feb 2021 13:36:16 +0100
Message-Id: <20210222121021.007857503@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
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
 net/vmw_vsock/af_vsock.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -818,10 +818,12 @@ static int vsock_shutdown(struct socket
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
@@ -830,10 +832,8 @@ static int vsock_shutdown(struct socket
 	/* Receive and send shutdowns are treated alike. */
 	mode = mode & (RCV_SHUTDOWN | SEND_SHUTDOWN);
 	if (mode) {
-		lock_sock(sk);
 		sk->sk_shutdown |= mode;
 		sk->sk_state_change(sk);
-		release_sock(sk);
 
 		if (sk->sk_type == SOCK_STREAM) {
 			sock_reset_flag(sk, SOCK_DONE);
@@ -841,6 +841,8 @@ static int vsock_shutdown(struct socket
 		}
 	}
 
+out:
+	release_sock(sk);
 	return err;
 }
 


