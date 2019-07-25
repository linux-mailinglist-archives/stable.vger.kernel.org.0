Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80E57541A
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 18:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbfGYQdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 12:33:07 -0400
Received: from www.linuxtv.org ([130.149.80.248]:59193 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfGYQdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 12:33:06 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1hqgfx-0001sS-6i; Thu, 25 Jul 2019 16:33:05 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Thu, 25 Jul 2019 15:58:41 +0000
Subject: [git:media_tree/master] media: hantro: Set DMA max segment size
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Francois Buergisser <fbuergisser@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1hqgfx-0001sS-6i@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: hantro: Set DMA max segment size
Author:  Francois Buergisser <fbuergisser@chromium.org>
Date:    Thu Jul 25 10:17:50 2019 -0400

The Hantro codec is typically used in platforms with an IOMMU,
so we need to set a proper DMA segment size. Devices without an
IOMMU will still fallback to default 64KiB segments.

Cc: stable@vger.kernel.org
Fixes: 775fec69008d3 ("media: add Rockchip VPU JPEG encoder driver")
Signed-off-by: Francois Buergisser <fbuergisser@chromium.org>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/staging/media/hantro/hantro_drv.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/staging/media/hantro/hantro_drv.c b/drivers/staging/media/hantro/hantro_drv.c
index b71a06e9159e..4eae1dbb1ac8 100644
--- a/drivers/staging/media/hantro/hantro_drv.c
+++ b/drivers/staging/media/hantro/hantro_drv.c
@@ -731,6 +731,7 @@ static int hantro_probe(struct platform_device *pdev)
 		dev_err(vpu->dev, "Could not set DMA coherent mask.\n");
 		return ret;
 	}
+	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 
 	for (i = 0; i < vpu->variant->num_irqs; i++) {
 		const char *irq_name = vpu->variant->irqs[i].name;
