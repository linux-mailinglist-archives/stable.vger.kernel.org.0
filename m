Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3EF13E05D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgAPQnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:43:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgAPQnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:43:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85C0A2073A;
        Thu, 16 Jan 2020 16:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579192989;
        bh=Fiz5fCpuoIFHozhj8KdiO82jhr2DQ5w1R7fvcwlPtaM=;
        h=From:To:Cc:Subject:Date:From;
        b=da2Oeno71ikm/WDnQXLPh+cwFbZ/HN59YyRCQs4BLrvQL0m0y326N4pmQdjlcfffb
         wCAyxcssdUbPGHFLaeSYLOSEy4aEpA1kMg0r8jGAch0O+ofigTv33R7Sb8kT6FBfTS
         M4Wdaos7H5JYWO30R4NDG/Fo9Eb+FXWohLJEOSZ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Alexander.Barabash@dell.com" <Alexander.Barabash@dell.com>,
        Alexander Barabash <alexander.barabash@dell.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 001/205] ioat: ioat_alloc_ring() failure handling.
Date:   Thu, 16 Jan 2020 11:39:36 -0500
Message-Id: <20200116164300.6705-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Alexander.Barabash@dell.com" <Alexander.Barabash@dell.com>

[ Upstream commit b0b5ce1010ffc50015eaec72b0028aaae3f526bb ]

If dma_alloc_coherent() returns NULL in ioat_alloc_ring(), ring
allocation must not proceed.

Until now, if the first call to dma_alloc_coherent() in
ioat_alloc_ring() returned NULL, the processing could proceed, failing
with NULL-pointer dereferencing further down the line.

Signed-off-by: Alexander Barabash <alexander.barabash@dell.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/75e9c0e84c3345d693c606c64f8b9ab5@x13pwhopdag1307.AMER.DELL.COM
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 1a422a8b43cf..18c011e57592 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -377,10 +377,11 @@ ioat_alloc_ring(struct dma_chan *c, int order, gfp_t flags)
 
 		descs->virt = dma_alloc_coherent(to_dev(ioat_chan),
 						 SZ_2M, &descs->hw, flags);
-		if (!descs->virt && (i > 0)) {
+		if (!descs->virt) {
 			int idx;
 
 			for (idx = 0; idx < i; idx++) {
+				descs = &ioat_chan->descs[idx];
 				dma_free_coherent(to_dev(ioat_chan), SZ_2M,
 						  descs->virt, descs->hw);
 				descs->virt = NULL;
-- 
2.20.1

