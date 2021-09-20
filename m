Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551FB41259A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384107AbhITSqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383269AbhITSoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4B2D61AFB;
        Mon, 20 Sep 2021 17:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159157;
        bh=kJ3W0/eZlIctqLUHyPrNqD80xBPS2iOUV4vkEAQbbKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AEmHy1ffYrXK+buOIlakscosaBKVz580LHcjP23+OgZSPvAiVMgsnVjnoQvkacAp
         xZ755Ch/ETPga4/vFsXLsCrrK7ULFvqDP+Rs9wi5OQZUbD4I4lPMvtFgxOetRIYIhF
         VxpSFK3UFZGkyPkjlltP+xw9ywzXrke55bPQliyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 060/168] vhost_net: fix OoB on sendmsg() failure.
Date:   Mon, 20 Sep 2021 18:43:18 +0200
Message-Id: <20210920163923.611496519@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 3c4cea8fa7f71f00c5279547043a84bc2a4d8b8c upstream.

If the sendmsg() call in vhost_tx_batch() fails, both the 'batched_xdp'
and 'done_idx' indexes are left unchanged. If such failure happens
when batched_xdp == VHOST_NET_BATCH, the next call to
vhost_net_build_xdp() will access and write memory outside the xdp
buffers area.

Since sendmsg() can only error with EBADFD, this change addresses the
issue explicitly freeing the XDP buffers batch on error.

Fixes: 0a0be13b8fe2 ("vhost_net: batch submitting XDP buffers to underlayer sockets")
Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -467,7 +467,7 @@ static void vhost_tx_batch(struct vhost_
 		.num = nvq->batched_xdp,
 		.ptr = nvq->xdp,
 	};
-	int err;
+	int i, err;
 
 	if (nvq->batched_xdp == 0)
 		goto signal_used;
@@ -476,6 +476,15 @@ static void vhost_tx_batch(struct vhost_
 	err = sock->ops->sendmsg(sock, msghdr, 0);
 	if (unlikely(err < 0)) {
 		vq_err(&nvq->vq, "Fail to batch sending packets\n");
+
+		/* free pages owned by XDP; since this is an unlikely error path,
+		 * keep it simple and avoid more complex bulk update for the
+		 * used pages
+		 */
+		for (i = 0; i < nvq->batched_xdp; ++i)
+			put_page(virt_to_head_page(nvq->xdp[i].data));
+		nvq->batched_xdp = 0;
+		nvq->done_idx = 0;
 		return;
 	}
 


