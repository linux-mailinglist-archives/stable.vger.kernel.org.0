Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A31BCCA7D1
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405904AbfJCQuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404546AbfJCQuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:50:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 857BA2086A;
        Thu,  3 Oct 2019 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121413;
        bh=qlKi8sfZrReaearLm/ylwI/YAYHwYCncfnDPGIhBkTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WqAca34GdP7Pn+Bj7dJ7BILuuLXv2gnsdnRRXvia2NcZzklneECwS+ScAoknJFEVd
         9HlBHRSKMkvWjrLX4LSaC1fYvuDT/G+BIurDmR2iOqXIKZK2CiV5eiYPbEC7ez3mMJ
         Q6iIIL86CloioP7/VboQHqIhmG0qdXqUOczaHQX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francois Buergisser <fbuergisser@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.3 270/344] media: hantro: Set DMA max segment size
Date:   Thu,  3 Oct 2019 17:53:55 +0200
Message-Id: <20191003154606.905277395@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francois Buergisser <fbuergisser@chromium.org>

commit c3c3509b86810293df5c524ef61421d8affc8bf0 upstream.

The Hantro codec is typically used in platforms with an IOMMU,
so we need to set a proper DMA segment size. Devices without an
IOMMU will still fallback to default 64KiB segments.

Cc: stable@vger.kernel.org
Fixes: 775fec69008d3 ("media: add Rockchip VPU JPEG encoder driver")
Signed-off-by: Francois Buergisser <fbuergisser@chromium.org>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/hantro/hantro_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/media/hantro/hantro_drv.c
+++ b/drivers/staging/media/hantro/hantro_drv.c
@@ -724,6 +724,7 @@ static int hantro_probe(struct platform_
 		dev_err(vpu->dev, "Could not set DMA coherent mask.\n");
 		return ret;
 	}
+	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 
 	for (i = 0; i < vpu->variant->num_irqs; i++) {
 		const char *irq_name = vpu->variant->irqs[i].name;


