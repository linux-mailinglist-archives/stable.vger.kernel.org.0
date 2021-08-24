Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4300E3F551A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhHXA7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234498AbhHXA5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5E206187C;
        Tue, 24 Aug 2021 00:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766546;
        bh=En1RmtZ63Bx5dbgpSDJvZol5dXvyF1o1UssfUpS+cG4=;
        h=From:To:Cc:Subject:Date:From;
        b=EYoWjBg7lIUNmqZ98Gt3503RbbO+mI/yuiIn+9z2v0VrP8mk7L638SiLzdu1YNZyU
         0K3ZDY77bxtKZ3GQTqeZoRsqwQyWpc/oOUJ6G1xYTfGzzrVLczQfMpi1G+Q9zicfAu
         pmBRHFO3dc5cbRpR32Pxwrcgao0b2F1YGfEJ1zSMszeHNMliw1DNvI4My3cULEcBC1
         2sBE0CqhMdENsU5h6o4qnlUif49r+GMUgkaFjj2zUe2FE4CK9SwrjEeUBioKAqUhoL
         38IWPAjjABYqi45eD2c4rtb1J9v8xN1a0IXzVkNXg8xH12DNgyKGDS1MfpMieVBPzz
         yss7tkLr9Cprg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.4 1/2] virtio: Improve vq->broken access to avoid any compiler optimization
Date:   Mon, 23 Aug 2021 20:55:43 -0400
Message-Id: <20210824005544.631899-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 6b3565feddb2..b15c24c4d91f 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -840,7 +840,7 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	return vq->broken;
+	return READ_ONCE(vq->broken);
 }
 EXPORT_SYMBOL_GPL(virtqueue_is_broken);
 
@@ -854,7 +854,9 @@ void virtio_break_device(struct virtio_device *dev)
 
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

