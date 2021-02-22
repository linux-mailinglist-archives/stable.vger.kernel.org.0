Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055EB32171F
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhBVMmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:42:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhBVMlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:41:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B3A164F18;
        Mon, 22 Feb 2021 12:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997550;
        bh=IYtOLjs4R1so+RYLicGg4TanI0IUpraLK+Ef2FaJVnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0ZgfX41wFARmjbL1HTe7MbtjwfdPq9rKg5fgaUoDE80dW3Tn0gsNzUOhXSMhQWj4
         R3eineGc73WAMbChKGT1pFBQB5LdYsxRVc0X1IkEbb/8ldTggl48FWma6OPpnO68WX
         /BxSvE2bit18U0i99HwLg6hEW9PCenl6O0lzEqOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 35/57] net/vmw_vsock: improve locking in vsock_connect_timeout()
Date:   Mon, 22 Feb 2021 13:36:01 +0100
Message-Id: <20210222121030.268965648@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
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
@@ -1114,7 +1114,6 @@ static void vsock_connect_timeout(struct
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
-	int cancel = 0;
 
 	vsk = container_of(work, struct vsock_sock, connect_work.work);
 	sk = sk_vsock(vsk);
@@ -1125,11 +1124,9 @@ static void vsock_connect_timeout(struct
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


