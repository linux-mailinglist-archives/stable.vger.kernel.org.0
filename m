Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3946C1714
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjCTPLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbjCTPLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:11:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA4930B2F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:06:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B13F4B80EC2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11526C433EF;
        Mon, 20 Mar 2023 15:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324766;
        bh=WoHtjj8OLiwyM8WH0skVJldRCid1d/QYTnhjXPDK7Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ygb3AmxQk/UiKhDZbys71dlEAEbUPu/MolWm5behWbGWvysTAqvH6Ji71ZOcN4Be
         jxWlXpzXgSLAS8WpfGVhSSbz+q91riRu+MMGFME2/z65W2Kd1xhekC1AiSnnBtmE8P
         IM2C+AFC23DBHCAK7C4KdlQ3yS9opo6jaXffyjWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/198] drm/virtio: Pass correct device to dma_sync_sgtable_for_device()
Date:   Mon, 20 Mar 2023 15:52:20 +0100
Message-Id: <20230320145507.533360077@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>

[ Upstream commit a54bace095d00e9222161495649688bc43de4dde ]

The "vdev->dev.parent" should be used instead of "vdev->dev" as a device
for which to perform the DMA operation in both
virtio_gpu_cmd_transfer_to_host_2d(3d).

Because the virtio-gpu device "vdev->dev" doesn't really have DMA OPS
assigned to it, but parent (virtio-pci or virtio-mmio) device
"vdev->dev.parent" has. The more, the sgtable in question the code is
trying to sync here was mapped for the parent device (by using its DMA OPS)
previously at:
virtio_gpu_object_shmem_init()->drm_gem_shmem_get_pages_sgt()->
dma_map_sgtable(), so should be synced here for the same parent device.

Fixes: b5c9ed70d1a9 ("drm/virtio: Improve DMA API usage for shmem BOs")
Signed-off-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230224153450.526222-1-olekstysh@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 9ff8660b50ade..208e9434cb28d 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -597,7 +597,7 @@ void virtio_gpu_cmd_transfer_to_host_2d(struct virtio_gpu_device *vgdev,
 	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);
 
 	if (virtio_gpu_is_shmem(bo) && use_dma_api)
-		dma_sync_sgtable_for_device(&vgdev->vdev->dev,
+		dma_sync_sgtable_for_device(vgdev->vdev->dev.parent,
 					    bo->base.sgt, DMA_TO_DEVICE);
 
 	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
@@ -1019,7 +1019,7 @@ void virtio_gpu_cmd_transfer_to_host_3d(struct virtio_gpu_device *vgdev,
 	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);
 
 	if (virtio_gpu_is_shmem(bo) && use_dma_api)
-		dma_sync_sgtable_for_device(&vgdev->vdev->dev,
+		dma_sync_sgtable_for_device(vgdev->vdev->dev.parent,
 					    bo->base.sgt, DMA_TO_DEVICE);
 
 	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
-- 
2.39.2



