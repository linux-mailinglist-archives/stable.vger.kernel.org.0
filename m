Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C52E24F81E
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgHXJ0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730114AbgHXIwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:52:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 197E722B4E;
        Mon, 24 Aug 2020 08:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259172;
        bh=MGpCxETfVBdJUi9yLlAn0NS7XSW2oCvWtdSw+Yn9XmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAhx4Y4D1v45geoCHlEp/fbxGb4JsVgJaT5tJ4ZlyVutLen+vVxO3iC/rUa2RMWTg
         OfaXqmNUgd/hktK6cKEszVkG71R42udLu0Xq/UvP/lPbzKEpCJUQmWOAaqHUOdzRi5
         tGQqgpBVEhoA4CuPgP2H7Lmz3dgHeGs8e1ZeXl40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mao Wenan <wenan.mao@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/39] virtio_ring: Avoid loop when vq is broken in virtqueue_poll
Date:   Mon, 24 Aug 2020 10:31:25 +0200
Message-Id: <20200824082349.872857339@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082348.445866152@linuxfoundation.org>
References: <20200824082348.445866152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Wenan <wenan.mao@linux.alibaba.com>

[ Upstream commit 481a0d7422db26fb63e2d64f0652667a5c6d0f3e ]

The loop may exist if vq->broken is true,
virtqueue_get_buf_ctx_packed or virtqueue_get_buf_ctx_split
will return NULL, so virtnet_poll will reschedule napi to
receive packet, it will lead cpu usage(si) to 100%.

call trace as below:
virtnet_poll
	virtnet_receive
		virtqueue_get_buf_ctx
			virtqueue_get_buf_ctx_packed
			virtqueue_get_buf_ctx_split
	virtqueue_napi_complete
		virtqueue_poll           //return true
		virtqueue_napi_schedule //it will reschedule napi

to fix this, return false if vq is broken in virtqueue_poll.

Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/1596354249-96204-1-git-send-email-wenan.mao@linux.alibaba.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index e459cd7302e27..5cad9f41c238b 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -785,6 +785,9 @@ bool virtqueue_poll(struct virtqueue *_vq, unsigned last_used_idx)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	if (unlikely(vq->broken))
+		return false;
+
 	virtio_mb(vq->weak_barriers);
 	return (u16)last_used_idx != virtio16_to_cpu(_vq->vdev, vq->vring.used->idx);
 }
-- 
2.25.1



