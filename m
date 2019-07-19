Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CEB6DE71
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732096AbfGSEGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730972AbfGSEGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:06:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BEA8218BC;
        Fri, 19 Jul 2019 04:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509179;
        bh=A6R18evUCaptpdOweBZB//YzgLJ/mugOzxrSr/UlB6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VF58oREiyDeR0tygmVU9U9dn+Q15jACOavh/jgwMD7+d/iWLQswQk58yUlpABqZyo
         WsDFP3S7NOHMB38Rb7qjZ3WCo8uMdAm+8gW6ZwcyktVKCyfgu0OwKwjzV5E679uRmh
         c+FQsSko4Ic/rBmc7iQmS4G7qARfCOAFHsKku6BE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Atish Patra <Atish.Patra@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.1 109/141] nvme-pci: limit max_hw_sectors based on the DMA max mapping size
Date:   Fri, 19 Jul 2019 00:02:14 -0400
Message-Id: <20190719040246.15945-109-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
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
index b97ba5ea0e61..5112983a59fb 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2538,7 +2538,8 @@ static void nvme_reset_work(struct work_struct *work)
 	 * Limit the max command size to prevent iod->sg allocations going
 	 * over a single page.
 	 */
-	dev->ctrl.max_hw_sectors = NVME_MAX_KB_SZ << 1;
+	dev->ctrl.max_hw_sectors = min_t(u32,
+		NVME_MAX_KB_SZ << 1, dma_max_mapping_size(dev->dev) >> 9);
 	dev->ctrl.max_segments = NVME_MAX_SEGS;
 	mutex_unlock(&dev->shutdown_lock);
 
-- 
2.20.1

