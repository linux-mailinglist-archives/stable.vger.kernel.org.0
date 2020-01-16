Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D8E13F8C7
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437785AbgAPTUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731179AbgAPQxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 748DC2176D;
        Thu, 16 Jan 2020 16:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193627;
        bh=pYUCGLdMi6gDXVvxrUjAARZ0xY91qBFUik0lqrR9TTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dH995/4+8IWYVT/rxPyF/t4Uq6El59Hwf6S1KRacmZ+7o4GnUlKSnprMUlCjb2O7M
         HX18UkBq84wm0E/NvNxp7MWDEHC/g+7yO6ie8pRLgCbBVL9GjEGa6CKMXzo3g/SgaY
         KsXfSGOQstg4TSEaGCpz1B9Ph7PjyGLNKiSCE4c0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 161/205] dma-direct: don't check swiotlb=force in dma_direct_map_resource
Date:   Thu, 16 Jan 2020 11:42:16 -0500
Message-Id: <20200116164300.6705-161-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4268ac6ae5870af10a7417b22990d615f72f77e2 ]

When mapping resources we can't just use swiotlb ram for bounce
buffering.  Switch to a direct dma_capable check instead.

Fixes: cfced786969c ("dma-mapping: remove the default map_resource implementation")
Reported-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 8402b29c280f..867fd72cb260 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -375,7 +375,7 @@ dma_addr_t dma_direct_map_resource(struct device *dev, phys_addr_t paddr,
 {
 	dma_addr_t dma_addr = paddr;
 
-	if (unlikely(!dma_direct_possible(dev, dma_addr, size))) {
+	if (unlikely(!dma_capable(dev, dma_addr, size))) {
 		report_addr(dev, dma_addr, size);
 		return DMA_MAPPING_ERROR;
 	}
-- 
2.20.1

