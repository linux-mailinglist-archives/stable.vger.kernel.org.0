Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA01B321647
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhBVMUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:20:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhBVMRK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:17:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF98164E4B;
        Mon, 22 Feb 2021 12:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996211;
        bh=A8U3fjTZ7aTPZKWXEibHh+3klriVO/cKknkKIfI6S4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGbKNqr0LgbqRowO/j7PNMYDS2DrPW1YLda3bXSkPbf0z3Vaq9dKK8E/zh2GHTafd
         mFQsoMua8seznTuLX8DMcKXdaN5Lb4P4MpLZF+htr0uQbLMWKypO5v+e7kIIpgvKBc
         DLEveFMhKgA9Cu820P6r6ff7PAjnmhPGVMLQf1BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 30/50] net/vmw_vsock: improve locking in vsock_connect_timeout()
Date:   Mon, 22 Feb 2021 13:13:21 +0100
Message-Id: <20210222121025.619521378@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
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
@@ -1107,7 +1107,6 @@ static void vsock_connect_timeout(struct
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
-	int cancel = 0;
 
 	vsk = container_of(work, struct vsock_sock, connect_work.work);
 	sk = sk_vsock(vsk);
@@ -1118,11 +1117,9 @@ static void vsock_connect_timeout(struct
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


