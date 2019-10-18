Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 695ECDD446
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbfJRWFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbfJRWFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF7ED222CD;
        Fri, 18 Oct 2019 22:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436313;
        bh=ILWaVFAbM7pu+olaK2zDZOwCaPUffqfJMirgEEEL1/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oB5MfjC62W9mxaGtw53uViYxZvdXEfGUFrDIaSQoV1CfrgWsTtj9c7hQ5ael0I2rx
         Mz3DsUGszZ0DlMJQSueFcb4wDix6Dt65rMFgIFs+eiIkuhyEAwXgzqAFD5vdVQnT+s
         8fdro9eDFD1WnqAbknsTDcotzjOc9ju1QsuOGj8M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 82/89] s390/cio: fix virtio-ccw DMA without PV
Date:   Fri, 18 Oct 2019 18:03:17 -0400
Message-Id: <20191018220324.8165-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit 05668e1d74b84c53fbe0f28565e4c9502a6b8a67 ]

Commit 37db8985b211 ("s390/cio: add basic protected virtualization
support") breaks virtio-ccw devices with VIRTIO_F_IOMMU_PLATFORM for non
Protected Virtualization (PV) guests. The problem is that the dma_mask
of the ccw device, which is used by virtio core, gets changed from 64 to
31 bit, because some of the DMA allocations do require 31 bit
addressable memory. For PV the only drawback is that some of the virtio
structures must end up in ZONE_DMA because we have the bounce the
buffers mapped via DMA API anyway.

But for non PV guests we have a problem: because of the 31 bit mask
guests bigger than 2G are likely to try bouncing buffers. The swiotlb
however is only initialized for PV guests, because we don't want to
bounce anything for non PV guests. The first such map kills the guest.

Since the DMA API won't allow us to specify for each allocation whether
we need memory from ZONE_DMA (31 bit addressable) or any DMA capable
memory will do, let us use coherent_dma_mask (which is used for
allocations) to force allocating form ZONE_DMA while changing dma_mask
to DMA_BIT_MASK(64) so that at least the streaming API will regard
the whole memory DMA capable.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Fixes: 37db8985b211 ("s390/cio: add basic protected virtualization support")
Link: https://lore.kernel.org/lkml/20190930153803.7958-1-pasic@linux.ibm.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/cio.h    | 1 +
 drivers/s390/cio/css.c    | 7 ++++++-
 drivers/s390/cio/device.c | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
index ba7d2480613b9..dcdaba689b20c 100644
--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -113,6 +113,7 @@ struct subchannel {
 	enum sch_todo todo;
 	struct work_struct todo_work;
 	struct schib_config config;
+	u64 dma_mask;
 	char *driver_override; /* Driver name to force a match */
 } __attribute__ ((aligned(8)));
 
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 1fbfb0a93f5f1..831850435c23b 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -232,7 +232,12 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 	 * belong to a subchannel need to fit 31 bit width (e.g. ccw).
 	 */
 	sch->dev.coherent_dma_mask = DMA_BIT_MASK(31);
-	sch->dev.dma_mask = &sch->dev.coherent_dma_mask;
+	/*
+	 * But we don't have such restrictions imposed on the stuff that
+	 * is handled by the streaming API.
+	 */
+	sch->dma_mask = DMA_BIT_MASK(64);
+	sch->dev.dma_mask = &sch->dma_mask;
 	return sch;
 
 err:
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index c421899be20f2..027ef1dde5a7a 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -710,7 +710,7 @@ static struct ccw_device * io_subchannel_allocate_dev(struct subchannel *sch)
 	if (!cdev->private)
 		goto err_priv;
 	cdev->dev.coherent_dma_mask = sch->dev.coherent_dma_mask;
-	cdev->dev.dma_mask = &cdev->dev.coherent_dma_mask;
+	cdev->dev.dma_mask = sch->dev.dma_mask;
 	dma_pool = cio_gp_dma_create(&cdev->dev, 1);
 	if (!dma_pool)
 		goto err_dma_pool;
-- 
2.20.1

