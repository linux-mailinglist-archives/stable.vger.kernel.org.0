Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDF545123A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346158AbhKOTbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:31:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244392AbhKOTOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:14:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3B896340F;
        Mon, 15 Nov 2021 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000440;
        bh=bvl7/2cFgDMnUQLxmYAhY/q5K98jcp/7S1Giu9g6djs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SweXJLz4aoY89G9aDH2yS8G3/IvJulerL8TG7Iw+Y9N0K0I7jYo1VpZnIUi6nWUn9
         OCKYumyzzlCQnw4Fo6cWNsViYSuyVWxkA84DNfV+Tmbm2DSknUrLtDCxyWXyG9VeGQ
         RRRArRdZveCA69s+UcV4GCmIA3ZVFBALsbRGR5WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 660/849] virtio_ring: check desc == NULL when using indirect with packed
Date:   Mon, 15 Nov 2021 18:02:23 +0100
Message-Id: <20211115165442.591358969@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit fc6d70f40b3d0b3219e2026d05be0409695f620d ]

When using indirect with packed, we don't check for allocation failures.
This patch checks that and fall back on direct.

Fixes: 1ce9e6055fa0 ("virtio_ring: introduce packed ring support")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://lore.kernel.org/r/20211020112323.67466-3-xuanzhuo@linux.alibaba.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 3035bb6f54585..d1f47327f6cfe 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1065,6 +1065,8 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 
 	head = vq->packed.next_avail_idx;
 	desc = alloc_indirect_packed(total_sg, gfp);
+	if (!desc)
+		return -ENOMEM;
 
 	if (unlikely(vq->vq.num_free < 1)) {
 		pr_debug("Can't add buf len 1 - avail = 0\n");
@@ -1176,6 +1178,7 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 	unsigned int i, n, c, descs_used, err_idx;
 	__le16 head_flags, flags;
 	u16 head, id, prev, curr, avail_used_flags;
+	int err;
 
 	START_USE(vq);
 
@@ -1191,9 +1194,14 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 
 	BUG_ON(total_sg == 0);
 
-	if (virtqueue_use_indirect(_vq, total_sg))
-		return virtqueue_add_indirect_packed(vq, sgs, total_sg,
-				out_sgs, in_sgs, data, gfp);
+	if (virtqueue_use_indirect(_vq, total_sg)) {
+		err = virtqueue_add_indirect_packed(vq, sgs, total_sg, out_sgs,
+						    in_sgs, data, gfp);
+		if (err != -ENOMEM)
+			return err;
+
+		/* fall back on direct */
+	}
 
 	head = vq->packed.next_avail_idx;
 	avail_used_flags = vq->packed.avail_used_flags;
-- 
2.33.0



