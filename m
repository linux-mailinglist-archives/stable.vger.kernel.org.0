Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC0C3ED66C
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbhHPNVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239135AbhHPNSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:18:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86301604DC;
        Mon, 16 Aug 2021 13:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119658;
        bh=k0E4IpDlHZyHchq2thmJAO7kY8pZrnFMSqqJPmaNis8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2bciKdrVDYL02YHxNvNsfpsZT3WZN2StLMXWuVGfoMDWvMd4Rn2lQAHAHWRTgEeK
         ZjztpoaC68lqQMn1XBUAyFTK4KXNrB4VY1tBXsEkQ2/bJ8cXS4wjfXhluv0z/jTFRC
         COE4CApu7/jXDh6D+6X2oXMAti4JGhdEVajKh43Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        "Longpeng(Mike)" <longpeng2@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 112/151] vsock/virtio: avoid potential deadlock when vsock device remove
Date:   Mon, 16 Aug 2021 15:02:22 +0200
Message-Id: <20210816125447.745686793@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longpeng(Mike) <longpeng2@huawei.com>

[ Upstream commit 49b0b6ffe20c5344f4173f3436298782a08da4f2 ]

There's a potential deadlock case when remove the vsock device or
process the RESET event:

  vsock_for_each_connected_socket:
      spin_lock_bh(&vsock_table_lock) ----------- (1)
      ...
          virtio_vsock_reset_sock:
              lock_sock(sk) --------------------- (2)
      ...
      spin_unlock_bh(&vsock_table_lock)

lock_sock() may do initiative schedule when the 'sk' is owned by
other thread at the same time, we would receivce a warning message
that "scheduling while atomic".

Even worse, if the next task (selected by the scheduler) try to
release a 'sk', it need to request vsock_table_lock and the deadlock
occur, cause the system into softlockup state.
  Call trace:
   queued_spin_lock_slowpath
   vsock_remove_bound
   vsock_remove_sock
   virtio_transport_release
   __vsock_release
   vsock_release
   __sock_release
   sock_close
   __fput
   ____fput

So we should not require sk_lock in this case, just like the behavior
in vhost_vsock or vmci.

Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20210812053056.1699-1-longpeng2@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 2700a63ab095..3a056f8affd1 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -356,11 +356,14 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
 
 static void virtio_vsock_reset_sock(struct sock *sk)
 {
-	lock_sock(sk);
+	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
+	 * under vsock_table_lock so the sock cannot disappear while we're
+	 * executing.
+	 */
+
 	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = ECONNRESET;
 	sk->sk_error_report(sk);
-	release_sock(sk);
 }
 
 static void virtio_vsock_update_guest_cid(struct virtio_vsock *vsock)
-- 
2.30.2



