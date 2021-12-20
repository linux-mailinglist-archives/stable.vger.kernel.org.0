Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D2647AEDF
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhLTPFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240998AbhLTPD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:03:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6892C09B10A;
        Mon, 20 Dec 2021 06:52:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 776F0B80EF3;
        Mon, 20 Dec 2021 14:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBE3C36AF9;
        Mon, 20 Dec 2021 14:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011938;
        bh=0ztMs4o++AjTk8FAVdPIXVW25187xr3qv5u9YDTqV/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtktltnMQZOeOfBb2taYqQrJZmvpWW5aKAkZPEUPhuk7jaN6IwBxhwm8neWK5xxU6
         7D6kL6qIQ4eiUkLC6U/l+LqUlZgGW7c4KhqrtZBBBdtfIvTdp67ADdpue2e0fbHeqg
         mYvcihc2AyGPG6E6KlP5WD9IkreVYSeqzjITQv3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Quentin Perret <qperret@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.15 022/177] virtio_ring: Fix querying of maximum DMA mapping size for virtio device
Date:   Mon, 20 Dec 2021 15:32:52 +0100
Message-Id: <20211220143040.823752289@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 817fc978b5a29b039db0418a91072b31c9aab152 upstream.

virtio_max_dma_size() returns the maximum DMA mapping size of the virtio
device by querying dma_max_mapping_size() for the device when the DMA
API is in use for the vring. Unfortunately, the device passed is
initialised by register_virtio_device() and does not inherit the DMA
configuration from its parent, resulting in SWIOTLB errors when bouncing
is enabled and the default 256K mapping limit (IO_TLB_SEGSIZE) is not
respected:

  | virtio-pci 0000:00:01.0: swiotlb buffer is full (sz: 294912 bytes), total 1024 (slots), used 725 (slots)

Follow the pattern used elsewhere in the virtio_ring code when calling
into the DMA layer and pass the parent device to dma_max_mapping_size()
instead.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20211201112018.25276-1-will@kernel.org
Acked-by: Jason Wang <jasowang@redhat.com>
Tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Fixes: e6d6dd6c875e ("virtio: Introduce virtio_max_dma_size()")
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -268,7 +268,7 @@ size_t virtio_max_dma_size(struct virtio
 	size_t max_segment_size = SIZE_MAX;
 
 	if (vring_use_dma_api(vdev))
-		max_segment_size = dma_max_mapping_size(&vdev->dev);
+		max_segment_size = dma_max_mapping_size(vdev->dev.parent);
 
 	return max_segment_size;
 }


