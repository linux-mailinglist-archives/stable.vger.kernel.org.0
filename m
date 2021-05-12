Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD0037C622
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhELPtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235085AbhELPmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C4BB61C83;
        Wed, 12 May 2021 15:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832918;
        bh=KZsc5yZIuWsrYya7OjS5DggjPvs/sLXeDrdmYlchDik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWld0aafaePn+u+XIZsCvPj4efTYYQiOgLVbhjaEOXKfi4QJ9DbXU4I4mhr7mf6E6
         MyojpOBx+1NbdXkcvsmqeHj7sq+HQ0XHGEQXL/yFxiXvKCJf35+5r7P8UXNvAqIDB/
         FI+mpR2UzERjv5pikzuGGAPhNWuWukTbF/MAbWr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+24452624fc4c571eedd9@syzkaller.appspotmail.com
Subject: [PATCH 5.10 474/530] vsock/virtio: free queued packets when closing socket
Date:   Wed, 12 May 2021 16:49:44 +0200
Message-Id: <20210512144835.334768477@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 8432b8114957235f42e070a16118a7f750de9d39 ]

As reported by syzbot [1], there is a memory leak while closing the
socket. We partially solved this issue with commit ac03046ece2b
("vsock/virtio: free packets during the socket release"), but we
forgot to drain the RX queue when the socket is definitely closed by
the scheduled work.

To avoid future issues, let's use the new virtio_transport_remove_sock()
to drain the RX queue before removing the socket from the af_vsock lists
calling vsock_remove_sock().

[1] https://syzkaller.appspot.com/bug?extid=24452624fc4c571eedd9

Fixes: ac03046ece2b ("vsock/virtio: free packets during the socket release")
Reported-and-tested-by: syzbot+24452624fc4c571eedd9@syzkaller.appspotmail.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 28 +++++++++++++++++--------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e4370b1b7494..902cb6dd710b 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -733,6 +733,23 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 	return t->send_pkt(reply);
 }
 
+/* This function should be called with sk_lock held and SOCK_DONE set */
+static void virtio_transport_remove_sock(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt, *tmp;
+
+	/* We don't need to take rx_lock, as the socket is closing and we are
+	 * removing it.
+	 */
+	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
+		list_del(&pkt->list);
+		virtio_transport_free_pkt(pkt);
+	}
+
+	vsock_remove_sock(vsk);
+}
+
 static void virtio_transport_wait_close(struct sock *sk, long timeout)
 {
 	if (timeout) {
@@ -765,7 +782,7 @@ static void virtio_transport_do_close(struct vsock_sock *vsk,
 	    (!cancel_timeout || cancel_delayed_work(&vsk->close_work))) {
 		vsk->close_work_scheduled = false;
 
-		vsock_remove_sock(vsk);
+		virtio_transport_remove_sock(vsk);
 
 		/* Release refcnt obtained when we scheduled the timeout */
 		sock_put(sk);
@@ -828,22 +845,15 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
 
 void virtio_transport_release(struct vsock_sock *vsk)
 {
-	struct virtio_vsock_sock *vvs = vsk->trans;
-	struct virtio_vsock_pkt *pkt, *tmp;
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
 	if (sk->sk_type == SOCK_STREAM)
 		remove_sock = virtio_transport_close(vsk);
 
-	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
-		list_del(&pkt->list);
-		virtio_transport_free_pkt(pkt);
-	}
-
 	if (remove_sock) {
 		sock_set_flag(sk, SOCK_DONE);
-		vsock_remove_sock(vsk);
+		virtio_transport_remove_sock(vsk);
 	}
 }
 EXPORT_SYMBOL_GPL(virtio_transport_release);
-- 
2.30.2



