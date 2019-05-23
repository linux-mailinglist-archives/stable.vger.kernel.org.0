Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5194C289BA
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389920AbfEWTTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389233AbfEWTTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:19:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA01205ED;
        Thu, 23 May 2019 19:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639188;
        bh=tQ4EPmHa88YeE+lsAVf8RF8bcxRpc2MVqWookuBRWD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3bSM28gipAc1w2aHSsmX1Ozl7JHRjPTx7+znS757DYVmAnzgm5q4uB6974uzO10S
         qGIGhoRGiVW1RircNsJqcAIdmxDjQknz2wnSj/1ecJiuGAnhkAXC7AynDGlyer+M53
         SnXXgzf5xBMZabxG/sNc6uhclUOpvo//XeFiXn1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 012/139] vsock/virtio: free packets during the socket release
Date:   Thu, 23 May 2019 21:05:00 +0200
Message-Id: <20190523181722.000324612@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit ac03046ece2b158ebd204dfc4896fd9f39f0e6c8 ]

When the socket is released, we should free all packets
queued in the per-socket list in order to avoid a memory
leak.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -786,12 +786,19 @@ static bool virtio_transport_close(struc
 
 void virtio_transport_release(struct vsock_sock *vsk)
 {
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt, *tmp;
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
 	lock_sock(sk);
 	if (sk->sk_type == SOCK_STREAM)
 		remove_sock = virtio_transport_close(vsk);
+
+	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
+		list_del(&pkt->list);
+		virtio_transport_free_pkt(pkt);
+	}
 	release_sock(sk);
 
 	if (remove_sock)


