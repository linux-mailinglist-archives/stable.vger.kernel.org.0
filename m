Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A5AF7E32
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfKKSsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728503AbfKKSss (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B1B521655;
        Mon, 11 Nov 2019 18:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498127;
        bh=CwCZfoRPCth1IRqPRRz/UpOF2NJeF6VJrV2ec1jRlFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4mnMNr2jeXKuWdblLKQ7o5uizRkaxVJwowyoMg1oY0j8KYVGkrB7etdMUidek+eR
         z8L2+Vv2UzlncWJhsEJs5vQvQWB1NlcgH+H3VoVveX7licgsgg1rgHRs7nD45tkXfg
         UU+YBz7ODpqC8xwybQ2JQtgLL6nWM2998Rd2c3H8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Barber <smbarber@chromium.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 023/193] vsock/virtio: fix sock refcnt holding during the shutdown
Date:   Mon, 11 Nov 2019 19:26:45 +0100
Message-Id: <20191111181501.929904168@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit ad8a7220355d39cddce8eac1cea9677333e8b821 ]

The "42f5cda5eaf4" commit rightly set SOCK_DONE on peer shutdown,
but there is an issue if we receive the SHUTDOWN(RDWR) while the
virtio_transport_close_timeout() is scheduled.
In this case, when the timeout fires, the SOCK_DONE is already
set and the virtio_transport_close_timeout() will not call
virtio_transport_reset() and virtio_transport_do_close().
This causes that both sockets remain open and will never be released,
preventing the unloading of [virtio|vhost]_transport modules.

This patch fixes this issue, calling virtio_transport_reset() and
virtio_transport_do_close() when we receive the SHUTDOWN(RDWR)
and there is nothing left to read.

Fixes: 42f5cda5eaf4 ("vsock/virtio: set SOCK_DONE on peer shutdown")
Cc: Stephen Barber <smbarber@chromium.org>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -870,9 +870,11 @@ virtio_transport_recv_connected(struct s
 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
 			vsk->peer_shutdown |= SEND_SHUTDOWN;
 		if (vsk->peer_shutdown == SHUTDOWN_MASK &&
-		    vsock_stream_has_data(vsk) <= 0) {
-			sock_set_flag(sk, SOCK_DONE);
-			sk->sk_state = TCP_CLOSING;
+		    vsock_stream_has_data(vsk) <= 0 &&
+		    !sock_flag(sk, SOCK_DONE)) {
+			(void)virtio_transport_reset(vsk, NULL);
+
+			virtio_transport_do_close(vsk, true);
 		}
 		if (le32_to_cpu(pkt->hdr.flags))
 			sk->sk_state_change(sk);


