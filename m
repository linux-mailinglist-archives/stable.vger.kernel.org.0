Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2369C311459
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBEWEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:04:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232937AbhBEO5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C836B64FDE;
        Fri,  5 Feb 2021 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534196;
        bh=f8H6f5ryS0R55IIGx+krgZyIAR/f6vQiAqxDJbIVdYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1rHChooxDiGNlJDdowdiI7vpr5pGWvXzvrpKxt9wB95DdWaz8lWWVLDfb1MKkxzo
         QrEO7GTf1zYxBQyJKKOpIxrbboLR0VAH2kE0SHwUX86CkvBAMhIpkLorsK0pHh+yA6
         EDzHRWjE8vhRIIzjj5ZahY4B+ipgIwAU1ER/rbeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/57] habanalabs: fix dma_addr passed to dma_mmap_coherent
Date:   Fri,  5 Feb 2021 15:06:49 +0100
Message-Id: <20210205140656.968808985@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit a9d4ef643430d638de1910377f50e0d492d85a43 ]

When doing dma_alloc_coherent in the driver, we add a certain hard-coded
offset to the DMA address before returning to the callee function. This
offset is needed when our device use this DMA address to perform
outbound transactions to the host.

However, if we want to map the DMA'able memory to the user via
dma_mmap_coherent(), we need to pass the original dma address, without
this offset. Otherwise, we will get erronouos mapping.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 3 ++-
 drivers/misc/habanalabs/goya/goya.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index ed1bd41262ecd..68f661aca3ff2 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -3119,7 +3119,8 @@ static int gaudi_cb_mmap(struct hl_device *hdev, struct vm_area_struct *vma,
 	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP |
 			VM_DONTCOPY | VM_NORESERVE;
 
-	rc = dma_mmap_coherent(hdev->dev, vma, cpu_addr, dma_addr, size);
+	rc = dma_mmap_coherent(hdev->dev, vma, cpu_addr,
+				(dma_addr - HOST_PHYS_BASE), size);
 	if (rc)
 		dev_err(hdev->dev, "dma_mmap_coherent error %d", rc);
 
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 235d47b2420f5..986ed3c072088 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -2675,7 +2675,8 @@ static int goya_cb_mmap(struct hl_device *hdev, struct vm_area_struct *vma,
 	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP |
 			VM_DONTCOPY | VM_NORESERVE;
 
-	rc = dma_mmap_coherent(hdev->dev, vma, cpu_addr, dma_addr, size);
+	rc = dma_mmap_coherent(hdev->dev, vma, cpu_addr,
+				(dma_addr - HOST_PHYS_BASE), size);
 	if (rc)
 		dev_err(hdev->dev, "dma_mmap_coherent error %d", rc);
 
-- 
2.27.0



