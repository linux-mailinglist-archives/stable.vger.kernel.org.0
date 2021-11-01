Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A8A4418FB
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhKAJx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234551AbhKAJvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0FE561501;
        Mon,  1 Nov 2021 09:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759141;
        bh=icZ0b2iOUfqXOkpvhBXHCTfRJ50BkHSnH2yFBHjf5bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B41N5RglyZKtcMMuWNxQJWJ07lEgls4Z4twi2YNlzwdRxOc2Nq6H2rf+d1W2l7C8v
         DEAb/bcl527fqXOcP9AdKhG27t5b9MDK8M9fQUi3lGNhlFWxbzV4+PseRgB8KzugI3
         cGCi86MGbtvqo8Hp6NqLelSvSborXCNkc18+u43E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 111/125] virtio-ring: fix DMA metadata flags
Date:   Mon,  1 Nov 2021 10:18:04 +0100
Message-Id: <20211101082554.107171753@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 890d33561337ffeba0d8ba42517e71288cfee2b6 ]

The flags are currently overwritten, leading to the wrong direction
being passed to the DMA unmap functions.

Fixes: 72b5e8958738aaa4 ("virtio-ring: store DMA metadata in desc_extra for split virtqueue")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Link: https://lore.kernel.org/r/20211026133100.17541-1-vincent.whitchurch@axis.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index dd95dfd85e98..3035bb6f5458 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -576,7 +576,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	/* Last one doesn't continue. */
 	desc[prev].flags &= cpu_to_virtio16(_vq->vdev, ~VRING_DESC_F_NEXT);
 	if (!indirect && vq->use_dma_api)
-		vq->split.desc_extra[prev & (vq->split.vring.num - 1)].flags =
+		vq->split.desc_extra[prev & (vq->split.vring.num - 1)].flags &=
 			~VRING_DESC_F_NEXT;
 
 	if (indirect) {
-- 
2.33.0



