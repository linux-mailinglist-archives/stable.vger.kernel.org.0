Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8EA24ABAD
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgHTAMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbgHTABp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:01:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AA29208E4;
        Thu, 20 Aug 2020 00:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881705;
        bh=iXmAtY7BG2mwDIC/wHHpkcNbC6q/kDidRTK1GVKOgL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zWo7fq0cLrHlElAtTb9Mim3elpKxPdzj7sstxaldL62Tf98esOKMPiX/hsY25XPU
         tg3voCtEG+HzE35Ia07OebvxiX5lg3ufkuOF56W+pYzX65II3KNbVcwAefR8mEmvHf
         a7ezah4k4u3aRLYoKEGTnBihjHeBkujXaEamoVbI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mao Wenan <wenan.mao@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.8 21/27] virtio_ring: Avoid loop when vq is broken in virtqueue_poll
Date:   Wed, 19 Aug 2020 20:01:10 -0400
Message-Id: <20200820000116.214821-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000116.214821-1-sashal@kernel.org>
References: <20200820000116.214821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 58b96baa8d488..4f7c73e6052f6 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1960,6 +1960,9 @@ bool virtqueue_poll(struct virtqueue *_vq, unsigned last_used_idx)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	if (unlikely(vq->broken))
+		return false;
+
 	virtio_mb(vq->weak_barriers);
 	return vq->packed_ring ? virtqueue_poll_packed(_vq, last_used_idx) :
 				 virtqueue_poll_split(_vq, last_used_idx);
-- 
2.25.1

