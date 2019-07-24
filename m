Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244177353E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 19:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfGXRRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 13:17:21 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34484 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbfGXRRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 13:17:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id A386028B608
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Cc:     kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        fbuergisser@chromium.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 1/7] media: hantro: Set DMA max segment size
Date:   Wed, 24 Jul 2019 14:16:56 -0300
Message-Id: <20190724171702.9449-2-ezequiel@collabora.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724171702.9449-1-ezequiel@collabora.com>
References: <20190724171702.9449-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francois Buergisser <fbuergisser@chromium.org>

The Hantro codec is typically used in platforms with an IOMMU,
so we need to set a proper DMA segment size. Devices without an
IOMMU will still fallback to default 64KiB segments.

Cc: stable@vger.kernel.org
Fixes: 775fec69008d3 ("media: add Rockchip VPU JPEG encoder driver")
Signed-off-by: Francois Buergisser <fbuergisser@chromium.org>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/staging/media/hantro/hantro_drv.c | 1 +
 1 file changed, 1 insertion(+)

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
-- 
2.22.0

