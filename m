Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B1428B6AC
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgJLNgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730925AbgJLNf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB1220678;
        Mon, 12 Oct 2020 13:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509757;
        bh=SzRte4HeNsd62UsF67ZtdD2Dak4L0o5TwSobw42um00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljgzF8hf0odDf/5CMBKIznCm1tgbg3SSDbon/UjNptZJWX5RwhdBZqVmmSmxwYjlZ
         jKdj4YR+pNybCvTblvFC+K+KpXv7NSZUzIjW05IVk/z/abxMwkAoBm5cOI/Dy/scSx
         BLc9OU8aU6IjBz33e68aYtzHkoUuZwTs4VfiijLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/70] net: virtio_vsock: Enhance connection semantics
Date:   Mon, 12 Oct 2020 15:26:20 +0200
Message-Id: <20201012132630.420915523@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastien Boeuf <sebastien.boeuf@intel.com>

[ Upstream commit df12eb6d6cd920ab2f0e0a43cd6e1c23a05cea91 ]

Whenever the vsock backend on the host sends a packet through the RX
queue, it expects an answer on the TX queue. Unfortunately, there is one
case where the host side will hang waiting for the answer and might
effectively never recover if no timeout mechanism was implemented.

This issue happens when the guest side starts binding to the socket,
which insert a new bound socket into the list of already bound sockets.
At this time, we expect the guest to also start listening, which will
trigger the sk_state to move from TCP_CLOSE to TCP_LISTEN. The problem
occurs if the host side queued a RX packet and triggered an interrupt
right between the end of the binding process and the beginning of the
listening process. In this specific case, the function processing the
packet virtio_transport_recv_pkt() will find a bound socket, which means
it will hit the switch statement checking for the sk_state, but the
state won't be changed into TCP_LISTEN yet, which leads the code to pick
the default statement. This default statement will only free the buffer,
while it should also respond to the host side, by sending a packet on
its TX queue.

In order to simply fix this unfortunate chain of events, it is important
that in case the default statement is entered, and because at this stage
we know the host side is waiting for an answer, we must send back a
packet containing the operation VIRTIO_VSOCK_OP_RST.

One could say that a proper timeout mechanism on the host side will be
enough to avoid the backend to hang. But the point of this patch is to
ensure the normal use case will be provided with proper responsiveness
when it comes to establishing the connection.

Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index dc4fb4aa76550..8e4c13cc61ba8 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1056,6 +1056,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		virtio_transport_free_pkt(pkt);
 		break;
 	default:
+		(void)virtio_transport_reset_no_sock(t, pkt);
 		virtio_transport_free_pkt(pkt);
 		break;
 	}
-- 
2.25.1



