Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4E93F5509
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhHXA6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234909AbhHXA4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3C8B6141B;
        Tue, 24 Aug 2021 00:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766531;
        bh=zWT3e4gJTxHTTlbmAOYA9XitnOFdGdTFTMYqDai0HYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIDxx0AxOLb1+c+4oh05jjKFTA6vmkhI12UCNhyAzgihscOnwRkkyJhNTOCjb1oAx
         Hn5CqnFyrbS0G/QZvF1zODgNq8O/ilTw/Z1nyv6TajeuOHuy6Y1ZlBmrNSi5GsZOh2
         YSoSgWV7a7ZyQJZgwK/2uje0BFsO2YnS78KoxirdLdyf3pU7GseiVhtCDrDAc17JDX
         f8VUQSIOaNxE19peoMGetYRagRcHLG/2YhP1TZetNbzhCA1RpRrinkql7pzR54YWb9
         tJty+RvKPIkJ8Gy2RZiVHP6GIr/QKZIAj3xZ5srmybVQYrVw0h2XMvkkV+WJeI40Lh
         3l8yJIBSToR7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.14 2/7] virtio: Improve vq->broken access to avoid any compiler optimization
Date:   Mon, 23 Aug 2021 20:55:23 -0400
Message-Id: <20210824005528.631702-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005528.631702-1-sashal@kernel.org>
References: <20210824005528.631702-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 60f0779862e4ab943810187752c462e85f5fa371 ]

Currently vq->broken field is read by virtqueue_is_broken() in busy
loop in one context by virtnet_send_command().

vq->broken is set to true in other process context by
virtio_break_device(). Reader and writer are accessing it without any
synchronization. This may lead to a compiler optimization which may
result to optimize reading vq->broken only once.

Hence, force reading vq->broken on each invocation of
virtqueue_is_broken() and also force writing it so that such
update is visible to the readers.

It is a theoretical fix that isn't yet encountered in the field.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://lore.kernel.org/r/20210721142648.1525924-2-parav@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 51278f8bd3ab..22a4329ed200 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1198,7 +1198,7 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	return vq->broken;
+	return READ_ONCE(vq->broken);
 }
 EXPORT_SYMBOL_GPL(virtqueue_is_broken);
 
@@ -1212,7 +1212,9 @@ void virtio_break_device(struct virtio_device *dev)
 
 	list_for_each_entry(_vq, &dev->vqs, list) {
 		struct vring_virtqueue *vq = to_vvq(_vq);
-		vq->broken = true;
+
+		/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
+		WRITE_ONCE(vq->broken, true);
 	}
 }
 EXPORT_SYMBOL_GPL(virtio_break_device);
-- 
2.30.2

