Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FC929BDC6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812949AbgJ0Qqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794886AbgJ0POI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:14:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCE7120657;
        Tue, 27 Oct 2020 15:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811647;
        bh=sadgl+KzUIy3pjWtmX0s7IkRTm41gEm5jderOKHO7Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNvmZ9Yl9ALgdHdULrnngkAwBhCpm+oJGBIda9K027OrVWbMlszmdLX6d910bbmcd
         FxzFNU35/5rtYEz1e+r9+HJ/5aXHpwO3yqYyZu5OCXr0ob5VIdQBSk4iE6TcCdslNN
         YO+VdYTo7737qVLnCAcg+NuoU3IpFM4kLMMmIdVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Sun <sherry.sun@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 567/633] misc: vop: add round_up(x,4) for vring_size to avoid kernel panic
Date:   Tue, 27 Oct 2020 14:55:10 +0100
Message-Id: <20201027135549.402653437@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit cc1a2679865a94b83804822996eed010a50a7c1d ]

Since struct _mic_vring_info and vring are allocated together and follow
vring, if the vring_size() is not four bytes aligned, which will cause
the start address of struct _mic_vring_info is not four byte aligned.
For example, when vring entries is 128, the vring_size() will be 5126
bytes. The _mic_vring_info struct layout in ddr looks like:
0x90002400:  00000000 00390000 EE010000 0000C0FF
Here 0x39 is the avail_idx member, and 0xC0FFEE01 is the magic member.

When EP use ioread32(magic) to reads the magic in RC's share memory, it
will cause kernel panic on ARM64 platform due to the cross-byte io read.
Here read magic in user space use le32toh(vr0->info->magic) will meet
the same issue.
So add round_up(x,4) for vring_size, then the struct _mic_vring_info
will store in this way:
0x90002400:  00000000 00000000 00000039 C0FFEE01
Which will avoid kernel panic when read magic in struct _mic_vring_info.

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20200929091106.24624-4-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mic/vop/vop_main.c   | 2 +-
 drivers/misc/mic/vop/vop_vringh.c | 4 ++--
 samples/mic/mpssd/mpssd.c         | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mic/vop/vop_main.c b/drivers/misc/mic/vop/vop_main.c
index 85942f6717c57..8aadc6055df17 100644
--- a/drivers/misc/mic/vop/vop_main.c
+++ b/drivers/misc/mic/vop/vop_main.c
@@ -320,7 +320,7 @@ static struct virtqueue *vop_find_vq(struct virtio_device *dev,
 	/* First assign the vring's allocated in host memory */
 	vqconfig = _vop_vq_config(vdev->desc) + index;
 	memcpy_fromio(&config, vqconfig, sizeof(config));
-	_vr_size = vring_size(le16_to_cpu(config.num), MIC_VIRTIO_RING_ALIGN);
+	_vr_size = round_up(vring_size(le16_to_cpu(config.num), MIC_VIRTIO_RING_ALIGN), 4);
 	vr_size = PAGE_ALIGN(_vr_size + sizeof(struct _mic_vring_info));
 	va = vpdev->hw_ops->remap(vpdev, le64_to_cpu(config.address), vr_size);
 	if (!va)
diff --git a/drivers/misc/mic/vop/vop_vringh.c b/drivers/misc/mic/vop/vop_vringh.c
index d069947b09345..7014ffe88632e 100644
--- a/drivers/misc/mic/vop/vop_vringh.c
+++ b/drivers/misc/mic/vop/vop_vringh.c
@@ -296,7 +296,7 @@ static int vop_virtio_add_device(struct vop_vdev *vdev,
 
 		num = le16_to_cpu(vqconfig[i].num);
 		mutex_init(&vvr->vr_mutex);
-		vr_size = PAGE_ALIGN(vring_size(num, MIC_VIRTIO_RING_ALIGN) +
+		vr_size = PAGE_ALIGN(round_up(vring_size(num, MIC_VIRTIO_RING_ALIGN), 4) +
 			sizeof(struct _mic_vring_info));
 		vr->va = (void *)
 			__get_free_pages(GFP_KERNEL | __GFP_ZERO,
@@ -308,7 +308,7 @@ static int vop_virtio_add_device(struct vop_vdev *vdev,
 			goto err;
 		}
 		vr->len = vr_size;
-		vr->info = vr->va + vring_size(num, MIC_VIRTIO_RING_ALIGN);
+		vr->info = vr->va + round_up(vring_size(num, MIC_VIRTIO_RING_ALIGN), 4);
 		vr->info->magic = cpu_to_le32(MIC_MAGIC + vdev->virtio_id + i);
 		vr_addr = dma_map_single(&vpdev->dev, vr->va, vr_size,
 					 DMA_BIDIRECTIONAL);
diff --git a/samples/mic/mpssd/mpssd.c b/samples/mic/mpssd/mpssd.c
index a11bf6c5b53b4..cd3f16a6f5caf 100644
--- a/samples/mic/mpssd/mpssd.c
+++ b/samples/mic/mpssd/mpssd.c
@@ -403,9 +403,9 @@ mic_virtio_copy(struct mic_info *mic, int fd,
 
 static inline unsigned _vring_size(unsigned int num, unsigned long align)
 {
-	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (3 + num)
+	return _ALIGN_UP(((sizeof(struct vring_desc) * num + sizeof(__u16) * (3 + num)
 				+ align - 1) & ~(align - 1))
-		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
+		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num, 4);
 }
 
 /*
-- 
2.25.1



