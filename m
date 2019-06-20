Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF164D6BF
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbfFTSLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfFTSLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:11:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2292C2070B;
        Thu, 20 Jun 2019 18:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054292;
        bh=hphFwK1hIXpMMA+3jCTMhQvVE8F9g39oGFKILzNNueY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqmgEbIKIaGlqFEzI/rPBBstb1wftB1WtZd6z4XcRih2qQo8ryg1OXxjiP/KBiyeg
         5FpUb8vYYedernfuyvCxsSOEExwmMoGSfmyamIY1RSnF3tfWtUE3BVtSwso/J0z0pG
         beuAYEVjkb+Mwu8wc9HJL7khAfwGeDliXJH2SWtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Barber <smbarber@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 13/61] vsock/virtio: set SOCK_DONE on peer shutdown
Date:   Thu, 20 Jun 2019 19:57:08 +0200
Message-Id: <20190620174339.445420153@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Barber <smbarber@chromium.org>

[ Upstream commit 42f5cda5eaf4396a939ae9bb43bb8d1d09c1b15c ]

Set the SOCK_DONE flag to match the TCP_CLOSING state when a peer has
shut down and there is nothing left to read.

This fixes the following bug:
1) Peer sends SHUTDOWN(RDWR).
2) Socket enters TCP_CLOSING but SOCK_DONE is not set.
3) read() returns -ENOTCONN until close() is called, then returns 0.

Signed-off-by: Stephen Barber <smbarber@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -871,8 +871,10 @@ virtio_transport_recv_connected(struct s
 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
 			vsk->peer_shutdown |= SEND_SHUTDOWN;
 		if (vsk->peer_shutdown == SHUTDOWN_MASK &&
-		    vsock_stream_has_data(vsk) <= 0)
+		    vsock_stream_has_data(vsk) <= 0) {
+			sock_set_flag(sk, SOCK_DONE);
 			sk->sk_state = TCP_CLOSING;
+		}
 		if (le32_to_cpu(pkt->hdr.flags))
 			sk->sk_state_change(sk);
 		break;


