Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDA42D0471
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgLFLpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:45:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbgLFLpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:45:42 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, justin.he@arm.com,
        Sergio Lopez <slp@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 13/46] vsock/virtio: discard packets only when socket is really closed
Date:   Sun,  6 Dec 2020 12:17:21 +0100
Message-Id: <20201206111557.101061969@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 3fe356d58efae54dade9ec94ea7c919ed20cf4db ]

Starting from commit 8692cefc433f ("virtio_vsock: Fix race condition
in virtio_transport_recv_pkt"), we discard packets in
virtio_transport_recv_pkt() if the socket has been released.

When the socket is connected, we schedule a delayed work to wait the
RST packet from the other peer, also if SHUTDOWN_MASK is set in
sk->sk_shutdown.
This is done to complete the virtio-vsock shutdown algorithm, releasing
the port assigned to the socket definitively only when the other peer
has consumed all the packets.

If we discard the RST packet received, the socket will be closed only
when the VSOCK_CLOSE_TIMEOUT is reached.

Sergio discovered the issue while running ab(1) HTTP benchmark using
libkrun [1] and observing a latency increase with that commit.

To avoid this issue, we discard packet only if the socket is really
closed (SOCK_DONE flag is set).
We also set SOCK_DONE in virtio_transport_release() when we don't need
to wait any packets from the other peer (we didn't schedule the delayed
work). In this case we remove the socket from the vsock lists, releasing
the port assigned.

[1] https://github.com/containers/libkrun

Fixes: 8692cefc433f ("virtio_vsock: Fix race condition in virtio_transport_recv_pkt")
Cc: justin.he@arm.com
Reported-by: Sergio Lopez <slp@redhat.com>
Tested-by: Sergio Lopez <slp@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Jia He <justin.he@arm.com>
Link: https://lore.kernel.org/r/20201120104736.73749-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -841,8 +841,10 @@ void virtio_transport_release(struct vso
 		virtio_transport_free_pkt(pkt);
 	}
 
-	if (remove_sock)
+	if (remove_sock) {
+		sock_set_flag(sk, SOCK_DONE);
 		vsock_remove_sock(vsk);
+	}
 }
 EXPORT_SYMBOL_GPL(virtio_transport_release);
 
@@ -1132,8 +1134,8 @@ void virtio_transport_recv_pkt(struct vi
 
 	lock_sock(sk);
 
-	/* Check if sk has been released before lock_sock */
-	if (sk->sk_shutdown == SHUTDOWN_MASK) {
+	/* Check if sk has been closed before lock_sock */
+	if (sock_flag(sk, SOCK_DONE)) {
 		(void)virtio_transport_reset_no_sock(t, pkt);
 		release_sock(sk);
 		sock_put(sk);


