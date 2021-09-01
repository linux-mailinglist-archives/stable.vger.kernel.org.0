Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA24D3FDABC
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343940AbhIAMer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244186AbhIAMdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:33:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD001610E5;
        Wed,  1 Sep 2021 12:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499517;
        bh=5txfqAg+66DNXSuGINbyFYrQBvbCv2bZenHXa6E9YBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPcc3Z7CDM+9mHMswgx24JHU4Q7efkJR3Kjl4SqTJoW9rUQ6jSdXQ0FSSZA3IlTUW
         m7O4b/pKFhnCiiPqYnkReCMzWsY3hgyrgMmlK3C7EvTbiwsxDVB28LYqTI9d41l6+U
         7PQWL25xPN0siC/nvLYJaLMnXmlV/AivGgGDuPS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/48] virtio: Improve vq->broken access to avoid any compiler optimization
Date:   Wed,  1 Sep 2021 14:28:19 +0200
Message-Id: <20210901122254.372094121@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f6011c9ed32f..e442d400dbb2 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2268,7 +2268,7 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	return vq->broken;
+	return READ_ONCE(vq->broken);
 }
 EXPORT_SYMBOL_GPL(virtqueue_is_broken);
 
@@ -2283,7 +2283,9 @@ void virtio_break_device(struct virtio_device *dev)
 	spin_lock(&dev->vqs_list_lock);
 	list_for_each_entry(_vq, &dev->vqs, list) {
 		struct vring_virtqueue *vq = to_vvq(_vq);
-		vq->broken = true;
+
+		/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
+		WRITE_ONCE(vq->broken, true);
 	}
 	spin_unlock(&dev->vqs_list_lock);
 }
-- 
2.30.2



