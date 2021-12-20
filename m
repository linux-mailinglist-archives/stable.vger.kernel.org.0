Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C20C47AC97
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbhLTOpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:45:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37592 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbhLTOoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:44:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68B626118D;
        Mon, 20 Dec 2021 14:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4C0C36AE8;
        Mon, 20 Dec 2021 14:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011459;
        bh=b6NgPVRwfRgKLmvnSqpgc95a8jTgmREj3B5OR1Wry2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kA2apAX0GqK916el5u2lyNnpG++gCjiLAbFBmSKccYOR74TuG+Ef6RGEUbxrdHLOH
         MlrlHczd8zoaU+cAwx6x6aR1tu2ZRz52lilPppISN7wZEwt2eNAfgp4hEohk/C0TVh
         pe4eX+/apPTZxaRWLCQt7C7j162CMqIaECwJNu0Q=
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
Subject: [PATCH 5.4 05/71] virtio_ring: Fix querying of maximum DMA mapping size for virtio device
Date:   Mon, 20 Dec 2021 15:33:54 +0100
Message-Id: <20211220143025.859891849@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
@@ -263,7 +263,7 @@ size_t virtio_max_dma_size(struct virtio
 	size_t max_segment_size = SIZE_MAX;
 
 	if (vring_use_dma_api(vdev))
-		max_segment_size = dma_max_mapping_size(&vdev->dev);
+		max_segment_size = dma_max_mapping_size(vdev->dev.parent);
 
 	return max_segment_size;
 }


