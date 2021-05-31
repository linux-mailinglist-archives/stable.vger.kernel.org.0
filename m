Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DAE39628C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbhEaO5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232364AbhEaOzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:55:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64C3261935;
        Mon, 31 May 2021 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469587;
        bh=I3MFQZEYwlfs0WAgyazAsru7RkY9wmdUF6WGBdOVvN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWiVZySAWZLjIVSYVXDtTkDP36zCS49dMNPQZfoZ6WPAPDoHcnxuDMNAVtQlfGWvZ
         XMa4wkTzTXpZGuOHrQPZ0sr0BpSC57K1GNUC9teYJpHE59Cab/eH6gM6V1VNXDgddY
         5Qn7IzChjdAPGfuzCQVDgYFJgIWkIzi1ZL6iGQwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 256/296] iommu/amd: Clear DMA ops when switching domain
Date:   Mon, 31 May 2021 15:15:11 +0200
Message-Id: <20210531130712.363990117@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit d6177a6556f853785867e2ec6d5b7f4906f0d809 ]

Since commit 08a27c1c3ecf ("iommu: Add support to change default domain
of an iommu group") a user can switch a device between IOMMU and direct
DMA through sysfs. This doesn't work for AMD IOMMU at the moment because
dev->dma_ops is not cleared when switching from a DMA to an identity
IOMMU domain. The DMA layer thus attempts to use the dma-iommu ops on an
identity domain, causing an oops:

  # echo 0000:00:05.0 > /sys/sys/bus/pci/drivers/e1000e/unbind
  # echo identity > /sys/bus/pci/devices/0000:00:05.0/iommu_group/type
  # echo 0000:00:05.0 > /sys/sys/bus/pci/drivers/e1000e/bind
   ...
  BUG: kernel NULL pointer dereference, address: 0000000000000028
   ...
   Call Trace:
    iommu_dma_alloc
    e1000e_setup_tx_resources
    e1000e_open

Since iommu_change_dev_def_domain() calls probe_finalize() again, clear
the dma_ops there like Vt-d does.

Fixes: 08a27c1c3ecf ("iommu: Add support to change default domain of an iommu group")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Link: https://lore.kernel.org/r/20210422094216.2282097-1-jean-philippe@linaro.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a69a8b573e40..7de7a260706b 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1747,6 +1747,8 @@ static void amd_iommu_probe_finalize(struct device *dev)
 	domain = iommu_get_domain_for_dev(dev);
 	if (domain->type == IOMMU_DOMAIN_DMA)
 		iommu_setup_dma_ops(dev, IOVA_START_PFN << PAGE_SHIFT, 0);
+	else
+		set_dma_ops(dev, NULL);
 }
 
 static void amd_iommu_release_device(struct device *dev)
-- 
2.30.2



