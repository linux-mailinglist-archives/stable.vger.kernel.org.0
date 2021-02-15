Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B507231BD44
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhBOPnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhBOPiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAED664EFA;
        Mon, 15 Feb 2021 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403289;
        bh=Ep7ueRS3pWvf+wcVb/DumE+C/snQ9vS6/p6iQUmTIZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgZl1J1kB9dE0a9zsOUOij+22b46HRNWd3mD0ZJJUsWZQVWaCgsdtGhyTFlf5arJC
         CuTadd+SJuh0UtPG6DjpcoEBQVlQhp9GjqUVtXPyN10MVM9OHUle8A6Lbs+u6Pz0Lw
         cenEElgRtRoG1bGsz1HxtHxGXFmAEDAEpZZS2cb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 099/104] vsock/virtio: update credit only if socket is not closed
Date:   Mon, 15 Feb 2021 16:27:52 +0100
Message-Id: <20210215152722.667509924@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit ce7536bc7398e2ae552d2fabb7e0e371a9f1fe46 upstream.

If the socket is closed or is being released, some resources used by
virtio_transport_space_update() such as 'vsk->trans' may be released.

To avoid a use after free bug we should only update the available credit
when we are sure the socket is still open and we have the lock held.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20210208144454.84438-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1130,8 +1130,6 @@ void virtio_transport_recv_pkt(struct vi
 
 	vsk = vsock_sk(sk);
 
-	space_available = virtio_transport_space_update(sk, pkt);
-
 	lock_sock(sk);
 
 	/* Check if sk has been closed before lock_sock */
@@ -1142,6 +1140,8 @@ void virtio_transport_recv_pkt(struct vi
 		goto free_pkt;
 	}
 
+	space_available = virtio_transport_space_update(sk, pkt);
+
 	/* Update CID in case it has changed after a transport reset event */
 	vsk->local_addr.svm_cid = dst.svm_cid;
 


