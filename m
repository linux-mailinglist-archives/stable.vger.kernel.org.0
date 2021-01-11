Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9EB2F1330
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbhAKNFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730265AbhAKNFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:05:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D833422795;
        Mon, 11 Jan 2021 13:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370272;
        bh=rhR9TjcvCo4LY0to8vsWustufsGZtC9xR0beXfdgKVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXm9mYbhz4ToYz4r+vNBotqifquySV8Ad0G6Ofj67kYeLeZR2RM12aKZ7AwnWKOvO
         Gwy86oTVGv5wNNUk2LkRZeg2dB8u9gRsXDUnLXbyQSVXPHkO0yXS9hBDZcBefpnGPN
         NrhS/AyEnZL/qpd8C3IPxhlsQiAOXioAPa0JXMuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 14/45] vhost_net: fix ubuf refcount incorrectly when sendmsg fails
Date:   Mon, 11 Jan 2021 14:00:52 +0100
Message-Id: <20210111130034.339702593@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 01e31bea7e622f1890c274f4aaaaf8bccd296aa5 ]

Currently the vhost_zerocopy_callback() maybe be called to decrease
the refcount when sendmsg fails in tun. The error handling in vhost
handle_tx_zerocopy() will try to decrease the same refcount again.
This is wrong. To fix this issue, we only call vhost_net_ubuf_put()
when vq->heads[nvq->desc].len == VHOST_DMA_IN_PROGRESS.

Fixes: bab632d69ee4 ("vhost: vhost TX zero-copy support")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/1609207308-20544-1-git-send-email-wangyunjian@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -377,6 +377,7 @@ static void handle_tx(struct vhost_net *
 	size_t hdr_size;
 	struct socket *sock;
 	struct vhost_net_ubuf_ref *uninitialized_var(ubufs);
+	struct ubuf_info *ubuf;
 	bool zcopy, zcopy_used;
 	int sent_pkts = 0;
 
@@ -444,9 +445,7 @@ static void handle_tx(struct vhost_net *
 
 		/* use msg_control to pass vhost zerocopy ubuf info to skb */
 		if (zcopy_used) {
-			struct ubuf_info *ubuf;
 			ubuf = nvq->ubuf_info + nvq->upend_idx;
-
 			vq->heads[nvq->upend_idx].id = cpu_to_vhost32(vq, head);
 			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
 			ubuf->callback = vhost_zerocopy_callback;
@@ -465,7 +464,8 @@ static void handle_tx(struct vhost_net *
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
 			if (zcopy_used) {
-				vhost_net_ubuf_put(ubufs);
+				if (vq->heads[ubuf->desc].len == VHOST_DMA_IN_PROGRESS)
+					vhost_net_ubuf_put(ubufs);
 				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
 					% UIO_MAXIOV;
 			}


