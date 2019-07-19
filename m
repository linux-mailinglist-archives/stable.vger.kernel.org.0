Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02736DF76
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbfGSEfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729420AbfGSEBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76D4621897;
        Fri, 19 Jul 2019 04:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508885;
        bh=GN/OsSNmdwC+UYwQNWTMkfKny8MRTFWFNFlzyHs3pjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMEAuy8V//91E5PQd2XeRLl4PVexfPXla+SWGqb5z7oK6TIVz3H1vpZkilABDcSNm
         J61XkELg2knGNKgO9ST3JymR0md63u64QZ3x8+GsAqs1NWF3YPr4u7aGxGD+UmjAmr
         RE/EQSxX8QtX9LLBWL2IgsRLqKp3F+xORmQA+djA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Atish Patra <Atish.Patra@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 136/171] nvme-pci: limit max_hw_sectors based on the DMA max mapping size
Date:   Thu, 18 Jul 2019 23:56:07 -0400
Message-Id: <20190719035643.14300-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7637de311bd2124b298a072852448b940d8a34b9 ]

When running a NVMe device that is attached to a addressing
challenged PCIe root port that requires bounce buffering, our
request sizes can easily overflow the swiotlb bounce buffer
size.  Limit the maximum I/O size to the limit exposed by
the DMA mapping subsystem.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Atish Patra <Atish.Patra@wdc.com>
Tested-by: Atish Patra <Atish.Patra@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5dfa067f6506..5c45f4cab060 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2515,7 +2515,8 @@ static void nvme_reset_work(struct work_struct *work)
 	 * Limit the max command size to prevent iod->sg allocations going
 	 * over a single page.
 	 */
-	dev->ctrl.max_hw_sectors = NVME_MAX_KB_SZ << 1;
+	dev->ctrl.max_hw_sectors = min_t(u32,
+		NVME_MAX_KB_SZ << 1, dma_max_mapping_size(dev->dev) >> 9);
 	dev->ctrl.max_segments = NVME_MAX_SEGS;
 
 	/*
-- 
2.20.1

