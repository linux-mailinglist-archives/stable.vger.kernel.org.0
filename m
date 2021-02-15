Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5219C31BD3F
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhBOPnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:43:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231233AbhBOPiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 245D064EF6;
        Mon, 15 Feb 2021 15:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403278;
        bh=0AlPLogGtK1SwXe8ZdnVnb8dMs7TMLLOsQwwLeE2qT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7cHcA1IcnY0LhdIOPqgmDD408IT1E89M1rs2lcl/yNFt7h6GMMr3zl0PSIJ+/uN8
         GsEXB11owIoU/VVArcY9HMKTPHqUU4OEIm5aWtZQ+1WsLUixwmxOBqe1nPNbnrkvBo
         f+DSXvYOmpNeNANrFNR6L8Rne75R856QaFeCNTeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 095/104] net/vmw_vsock: improve locking in vsock_connect_timeout()
Date:   Mon, 15 Feb 2021 16:27:48 +0100
Message-Id: <20210215152722.535194363@linuxfoundation.org>
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

From: Norbert Slusarek <nslusarek@gmx.net>

commit 3d0bc44d39bca615b72637e340317b7899b7f911 upstream.

A possible locking issue in vsock_connect_timeout() was recognized by
Eric Dumazet which might cause a null pointer dereference in
vsock_transport_cancel_pkt(). This patch assures that
vsock_transport_cancel_pkt() will be called within the lock, so a race
condition won't occur which could result in vsk->transport to be set to NULL.

Fixes: 380feae0def7 ("vsock: cancel packets when failing to connect")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/trinity-f8e0937a-cf0e-4d80-a76e-d9a958ba3ef1-1612535522360@3c-app-gmx-bap12
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1226,7 +1226,6 @@ static void vsock_connect_timeout(struct
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
-	int cancel = 0;
 
 	vsk = container_of(work, struct vsock_sock, connect_work.work);
 	sk = sk_vsock(vsk);
@@ -1237,11 +1236,9 @@ static void vsock_connect_timeout(struct
 		sk->sk_state = TCP_CLOSE;
 		sk->sk_err = ETIMEDOUT;
 		sk->sk_error_report(sk);
-		cancel = 1;
+		vsock_transport_cancel_pkt(vsk);
 	}
 	release_sock(sk);
-	if (cancel)
-		vsock_transport_cancel_pkt(vsk);
 
 	sock_put(sk);
 }


