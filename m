Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1B63F5515
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhHXA7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233870AbhHXA5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5954A6154B;
        Tue, 24 Aug 2021 00:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766541;
        bh=abhwVH7jxZvJC/QUmFVQU1Z3zBylCv/M+6tQw5EQd+I=;
        h=From:To:Cc:Subject:Date:From;
        b=jCInE6RiTLJS2TuexDftke6meOtkJV9KDII7AKEaiNz+/uhMRZscASNyClyw+W5aG
         U1uLieF92EfL+Pjc09RqZSdqViy0R9lObVYKnCjJ6KsEM+7Q/nVMmMkj2P1fQRDyLh
         CMdJGmO7FCNAGjuLH15Xu3nJC2dD6EtSJC/WvC0RcW5QX3YLUsFEkBEm9RNw0p6G9e
         nz9mNc/DKKX1lwcRtaUuDWEVoHsOL4JvLQgX1UZ8cjxF9U0hvKEuukveS7DsDF8F4/
         VMoTPsbo+po3C2RNSaAvplgGxxmgQ9iQ5Vll0Tz5f3SXSAbMk6gcPuCa4P52pgasEy
         EFZa11gTm5tiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.9 1/3] virtio: Improve vq->broken access to avoid any compiler optimization
Date:   Mon, 23 Aug 2021 20:55:37 -0400
Message-Id: <20210824005539.631820-1-sashal@kernel.org>
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
index 5cad9f41c238..cf7eccfe3469 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1150,7 +1150,7 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	return vq->broken;
+	return READ_ONCE(vq->broken);
 }
 EXPORT_SYMBOL_GPL(virtqueue_is_broken);
 
@@ -1164,7 +1164,9 @@ void virtio_break_device(struct virtio_device *dev)
 
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

