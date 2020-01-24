Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE331483A9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404175AbgAXLaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404162AbgAXLaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:30:07 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 818F020704;
        Fri, 24 Jan 2020 11:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865406;
        bh=1SWh4Nj72FOCykuQmgcz6K7/P9lQBWVIpNbxL330CsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JA4AJzP+gvhTMHnWnqEyvW7UTUy28jYs5OJdDH1xUZvURUCUyTK5ylQC2pBMuZx3e
         pVfO5u2W6V/ZLMqeKkwFfhMDnCrTC/4YGPTSzQB7kY7n9JtfFzjAvzkL+9TUzP3nSt
         V/j+e13GE/ZX0+LO8Ug4IWLHt8Tg0tmSpe3fIdRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 524/639] iommu/mediatek: Fix iova_to_phys PA start for 4GB mode
Date:   Fri, 24 Jan 2020 10:31:34 +0100
Message-Id: <20200124093154.435223641@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit 76ce65464fcd2c21db84391572b7938b716aceb0 ]

In M4U 4GB mode, the physical address is remapped as below:

CPU Physical address:

====================

0      1G       2G     3G       4G     5G
|---A---|---B---|---C---|---D---|---E---|
+--I/O--+------------Memory-------------+

IOMMU output physical address:
 =============================

                                4G      5G     6G      7G      8G
                                |---E---|---B---|---C---|---D---|
                                +------------Memory-------------+

The Region 'A'(I/O) can not be mapped by M4U; For Region 'B'/'C'/'D', the
bit32 of the CPU physical address always is needed to set, and for Region
'E', the CPU physical address keep as is. something looks like this:
CPU PA         ->    M4U OUTPUT PA
0x4000_0000          0x1_4000_0000 (Add bit32)
0x8000_0000          0x1_8000_0000 ...
0xc000_0000          0x1_c000_0000 ...
0x1_0000_0000        0x1_0000_0000 (No change)

Additionally, the iommu consumers always use the CPU phyiscal address.

The PA in the iova_to_phys that is got from v7s always is u32, But
from the CPU point of view, PA only need add BIT(32) when PA < 0x4000_0000.

Fixes: 30e2fccf9512 ("iommu/mediatek: Enlarge the validate PA range
for 4GB mode")
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 154cf44439cb6..8e75f34ac8868 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -115,6 +115,30 @@ struct mtk_iommu_domain {
 
 static struct iommu_ops mtk_iommu_ops;
 
+/*
+ * In M4U 4GB mode, the physical address is remapped as below:
+ *
+ * CPU Physical address:
+ * ====================
+ *
+ * 0      1G       2G     3G       4G     5G
+ * |---A---|---B---|---C---|---D---|---E---|
+ * +--I/O--+------------Memory-------------+
+ *
+ * IOMMU output physical address:
+ *  =============================
+ *
+ *                                 4G      5G     6G      7G      8G
+ *                                 |---E---|---B---|---C---|---D---|
+ *                                 +------------Memory-------------+
+ *
+ * The Region 'A'(I/O) can NOT be mapped by M4U; For Region 'B'/'C'/'D', the
+ * bit32 of the CPU physical address always is needed to set, and for Region
+ * 'E', the CPU physical address keep as is.
+ * Additionally, The iommu consumers always use the CPU phyiscal address.
+ */
+#define MTK_IOMMU_4GB_MODE_REMAP_BASE	 0x40000000
+
 static LIST_HEAD(m4ulist);	/* List all the M4U HWs */
 
 #define for_each_m4u(data)	list_for_each_entry(data, &m4ulist, list)
@@ -409,7 +433,7 @@ static phys_addr_t mtk_iommu_iova_to_phys(struct iommu_domain *domain,
 	pa = dom->iop->iova_to_phys(dom->iop, iova);
 	spin_unlock_irqrestore(&dom->pgtlock, flags);
 
-	if (data->enable_4GB)
+	if (data->enable_4GB && pa < MTK_IOMMU_4GB_MODE_REMAP_BASE)
 		pa |= BIT_ULL(32);
 
 	return pa;
-- 
2.20.1



