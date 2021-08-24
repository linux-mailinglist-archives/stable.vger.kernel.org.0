Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA153F5442
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhHXAyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233604AbhHXAys (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:54:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 604AC613BD;
        Tue, 24 Aug 2021 00:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766445;
        bh=sIL8ujoxV3s+6lnSojtoKCjFr6HnHs52BWB+6AGRydU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ig1xAkl4P5A0hxNP2HhXE/Mr52Pa9SxTZTAnJTyXFx28gLGitu2jyzbh7rtgXaeqf
         gPsAN846RFJTtxA1k+z2URCq8yS92zuZzFok8GvdFrbN6lxs8esW+1Kkv/j22+/ni3
         03nqIrAz8LNGq6eS6l9w3Nr06ARtCom9lFslo9M1Z3Wt+uL3nzMj0kEQet79hlRsz2
         aUlzpZdszsZYZIgXud4Drc2tYv/lCS0vKJRhykGz8H9ZWLYQjAadrA5HsX/d4jptZ8
         Bd25qL1kWLfytzyPbrByjT7JwKC/E+MZcO0Lp8uQhWLm/aXkpE35unCCeAn7ljtRhx
         rnToXbdJ2c99A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.13 06/26] virtio: Improve vq->broken access to avoid any compiler optimization
Date:   Mon, 23 Aug 2021 20:53:36 -0400
Message-Id: <20210824005356.630888-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
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
index 71e16b53e9c1..dea3bb47ca52 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2262,7 +2262,7 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	return vq->broken;
+	return READ_ONCE(vq->broken);
 }
 EXPORT_SYMBOL_GPL(virtqueue_is_broken);
 
@@ -2276,7 +2276,9 @@ void virtio_break_device(struct virtio_device *dev)
 
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

