Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DC632178F
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhBVMuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231542AbhBVMqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:46:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E306764F59;
        Mon, 22 Feb 2021 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997704;
        bh=8LQ+JBRCIK+bDnh8JXQegW0jT1aiz+ZrzjE/v7us4Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5NpuJhPU4GQrdGYY5sK6dzsYgKpYAoIwvcklkSgDI5RusnkhyxYhu2/BPXDufTfV
         YmoZQ2HZhUGwEGb8Wu3bsz4CBLWmMGDWpRKuaB7ZuWqTK1+Gl6XJ+TrO37sOnYCOyH
         U2N3c8cKg10Rn8hVnI7A+PDk4fhQgkHlm+EZkXgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 33/49] vsock/virtio: update credit only if socket is not closed
Date:   Mon, 22 Feb 2021 13:36:31 +0100
Message-Id: <20210222121027.399913086@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
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
@@ -959,10 +959,10 @@ void virtio_transport_recv_pkt(struct vi
 
 	vsk = vsock_sk(sk);
 
-	space_available = virtio_transport_space_update(sk, pkt);
-
 	lock_sock(sk);
 
+	space_available = virtio_transport_space_update(sk, pkt);
+
 	/* Update CID in case it has changed after a transport reset event */
 	vsk->local_addr.svm_cid = dst.svm_cid;
 


