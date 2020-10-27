Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F0329B502
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793674AbgJ0PHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789273AbgJ0PBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:01:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E804020715;
        Tue, 27 Oct 2020 15:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810911;
        bh=UiLXTqD7WoMnhmIwPNnT8EloUA+a6xiI7oDA2OKNmD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzM6X6FCY/U+jzMqkfSKgm+fns3ShtzHsm4P1iH+QFVvBWXq18xI8mop5LxO49a5T
         XDs4BzRnKXwpp1TJFuYag77n2DaB/JHRneEpC5i+0CrFVKeqqwgvZmC8In0TzARjnR
         dA64kSjw5yX5dEaZqm8qoP+JKyLgbI1tg7HSN8RU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 306/633] dmaengine: ioat: Allocate correct size for descriptor chunk
Date:   Tue, 27 Oct 2020 14:50:49 +0100
Message-Id: <20201027135537.029189670@linuxfoundation.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 028926e4ac8f21af343c25794117fd13c08b1712 ]

dma_alloc_coherent() is called with a fixed SZ_2M size, but frees happen
with IOAT_CHUNK_SIZE. Recently, IOAT_CHUNK_SIZE was reduced to 512M but
the allocation did not change. To fix, change to using the
IOAT_CHUNK_SIZE define.

This was caught with the upcoming patchset for converting Intel platforms to the
dma-iommu implementation. It has a warning when the unmapped size differs from
the mapped size.

Fixes: a02254f8a676 ("dmaengine: ioat: Decreasing allocation chunk size 2M->512K")
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/intel-gfx/776771a2-247a-d1be-d882-bee02d919ae0@deltatee.com/
Link: https://lore.kernel.org/r/20200922200844.2982-1-logang@deltatee.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index fd782aee02d92..98c56606ab1a9 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -389,7 +389,7 @@ ioat_alloc_ring(struct dma_chan *c, int order, gfp_t flags)
 		struct ioat_descs *descs = &ioat_chan->descs[i];
 
 		descs->virt = dma_alloc_coherent(to_dev(ioat_chan),
-						 SZ_2M, &descs->hw, flags);
+					IOAT_CHUNK_SIZE, &descs->hw, flags);
 		if (!descs->virt) {
 			int idx;
 
-- 
2.25.1



