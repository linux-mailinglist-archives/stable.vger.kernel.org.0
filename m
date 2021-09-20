Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11BC4123E1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379181AbhITS23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378790AbhITS00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0669C632ED;
        Mon, 20 Sep 2021 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158747;
        bh=ikfZ892KD0SNUlbUzD2rhuzPSMKNp0bILxoF/E3DFCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfTxMkZZ27qVDqXKh2IYj7Nz2fVKhucwHHzNOuwAIDgocT+og5/AA/hUuXpPtwROL
         72gC9bYz9tW0Ew50KO+pP9XWArVmcHgjnW1bU2z7q4Dwst3BvQ4Z6ARtijFHK3ghuB
         1kScPedGFbZg4TkGUh9hXSfwTYcYhwxEbaqUWjBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 038/122] vhost_net: fix OoB on sendmsg() failure.
Date:   Mon, 20 Sep 2021 18:43:30 +0200
Message-Id: <20210920163917.042155863@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
@@ -466,7 +466,7 @@ static void vhost_tx_batch(struct vhost_
 		.num = nvq->batched_xdp,
 		.ptr = nvq->xdp,
 	};
-	int err;
+	int i, err;
 
 	if (nvq->batched_xdp == 0)
 		goto signal_used;
@@ -475,6 +475,15 @@ static void vhost_tx_batch(struct vhost_
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
 


