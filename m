Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D15291B94
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732483AbgJRTcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729724AbgJRT1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:27:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C580222E9;
        Sun, 18 Oct 2020 19:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049222;
        bh=ZtUNsIeYrkvusPPiLeF+ZOqAu9BbhvoQn+/+kag1Xmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S68D+ueVVr69qTJ9QtUv86x0p6EEVUdGWuYZeOVX7PN0VTn2fbaUxXrurB7SwoAFy
         /5HXpXx3+cbAE+dllaqgUOxOTq+5boPXKKu8hybo29q6GBPjEI4AjtwpME7EmR3H82
         O/2hRnZPtZCvMFAzWno1UwI3A0CJGx2j5Ad/GJp0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Sun <sherry.sun@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 21/41] misc: vop: add round_up(x,4) for vring_size to avoid kernel panic
Date:   Sun, 18 Oct 2020 15:26:15 -0400
Message-Id: <20201018192635.4056198-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192635.4056198-1-sashal@kernel.org>
References: <20201018192635.4056198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1a2b67f3183d5..f9da3150f80a2 100644
--- a/drivers/misc/mic/vop/vop_main.c
+++ b/drivers/misc/mic/vop/vop_main.c
@@ -301,7 +301,7 @@ static struct virtqueue *vop_find_vq(struct virtio_device *dev,
 	/* First assign the vring's allocated in host memory */
 	vqconfig = _vop_vq_config(vdev->desc) + index;
 	memcpy_fromio(&config, vqconfig, sizeof(config));
-	_vr_size = vring_size(le16_to_cpu(config.num), MIC_VIRTIO_RING_ALIGN);
+	_vr_size = round_up(vring_size(le16_to_cpu(config.num), MIC_VIRTIO_RING_ALIGN), 4);
 	vr_size = PAGE_ALIGN(_vr_size + sizeof(struct _mic_vring_info));
 	va = vpdev->hw_ops->ioremap(vpdev, le64_to_cpu(config.address),
 			vr_size);
diff --git a/drivers/misc/mic/vop/vop_vringh.c b/drivers/misc/mic/vop/vop_vringh.c
index 99bde52a3a256..49e7a7240469c 100644
--- a/drivers/misc/mic/vop/vop_vringh.c
+++ b/drivers/misc/mic/vop/vop_vringh.c
@@ -308,7 +308,7 @@ static int vop_virtio_add_device(struct vop_vdev *vdev,
 
 		num = le16_to_cpu(vqconfig[i].num);
 		mutex_init(&vvr->vr_mutex);
-		vr_size = PAGE_ALIGN(vring_size(num, MIC_VIRTIO_RING_ALIGN) +
+		vr_size = PAGE_ALIGN(round_up(vring_size(num, MIC_VIRTIO_RING_ALIGN), 4) +
 			sizeof(struct _mic_vring_info));
 		vr->va = (void *)
 			__get_free_pages(GFP_KERNEL | __GFP_ZERO,
@@ -320,7 +320,7 @@ static int vop_virtio_add_device(struct vop_vdev *vdev,
 			goto err;
 		}
 		vr->len = vr_size;
-		vr->info = vr->va + vring_size(num, MIC_VIRTIO_RING_ALIGN);
+		vr->info = vr->va + round_up(vring_size(num, MIC_VIRTIO_RING_ALIGN), 4);
 		vr->info->magic = cpu_to_le32(MIC_MAGIC + vdev->virtio_id + i);
 		vr_addr = dma_map_single(&vpdev->dev, vr->va, vr_size,
 					 DMA_BIDIRECTIONAL);
diff --git a/samples/mic/mpssd/mpssd.c b/samples/mic/mpssd/mpssd.c
index 49db1def1721c..84e583ab8fd0c 100644
--- a/samples/mic/mpssd/mpssd.c
+++ b/samples/mic/mpssd/mpssd.c
@@ -414,9 +414,9 @@ mic_virtio_copy(struct mic_info *mic, int fd,
 
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

