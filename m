Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7091709B1
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 21:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgBZUam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 15:30:42 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:39037 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbgBZUam (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 15:30:42 -0500
Received: by mail-pf1-f202.google.com with SMTP id x189so256534pfd.6
        for <stable@vger.kernel.org>; Wed, 26 Feb 2020 12:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9oP9ZiTU1p6lF1U2mfS1bBIXLROAWtwOnKtBSbb21XQ=;
        b=c+fqP6D62YFfsQ+J6OBoM/aeGgTpFFp6n879QHcWNXJ9rZEA3joGLu5Khb/SAjaZwv
         yuSXfO/WvDezMPhKpeVoFdIUBiyrw6CTx1pApaHbssDflsPf1+RC+6DY3+GGhGx1KWJi
         68lBGhbGdFAoGu5K/nKOUhdyJFwYc1TMGRkYFAiIJdged0YFP76LlT38a9DbwBqXK/34
         uqyyBLmJYNXz6tE9+Vxhch09eMpn2UNX2P8D5sVB1B5FfKn4HMfwfAeoDg9p45rz8FfS
         oW+WQOJnUW8nbgJlwUcd7MT8SiMAl5sjpmCP8PUdcc+IJsja6qKXu13jzTYanXCb+8Fv
         f9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9oP9ZiTU1p6lF1U2mfS1bBIXLROAWtwOnKtBSbb21XQ=;
        b=MVsl3ni/U13nPBBAx0nyoMB2EZlxBNXcvxrodCKtlO1e3xZr33sClt8koIrH+wWoqr
         1TXbZbo/Tg+6sc+zZgPBggNlzrmwmW14CwfPNJ/blsIFbVyDsaf/ALtO3WbW7FkzEuNS
         70GBOhXN9A5FUh5wPVj6GMLODldmeM+bxnS6YFjTI7avqQyGUUf1R1axpA88HSbATFd7
         uN2I98qvmbmRUL4sjMVk/0IeYVq08KslK7VlpgbdcMKXUbZ6r2KMh/IxI5c70F8A1M05
         W6c8MsuDGL8/R7kg7/3TgwxhGeu9Xtpdef31FZePCcKCTv8Uui7MoBxRwHRK1/TO6/dr
         RQyQ==
X-Gm-Message-State: APjAAAU3qpTganyYBN3dKJfMXZVApLEQ+Z6Z95HOkDFTnu3dxYizlBSH
        6v6m4xnh78uXVZv0jxLWd7NMg3yEbfHo9g==
X-Google-Smtp-Source: APXvYqxc3+QtUOXjvCNDTiXAo4RmNzOVk/qFDGek88Tooc1vbUAVhLRDfbsX+YtSCJhE/899DR3rlT69jwQ5PA==
X-Received: by 2002:a63:1e44:: with SMTP id p4mr568086pgm.367.1582749040887;
 Wed, 26 Feb 2020 12:30:40 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:30:06 -0800
Message-Id: <20200226203006.51567-1-yonghyun@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v3] iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for
 huge page
From:   Yonghyun Hwang <yonghyun@google.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Deepa Dinamani <deepadinamani@google.com>,
        Moritz Fischer <mdf@kernel.org>,
        Yonghyun Hwang <yonghyun@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

intel_iommu_iova_to_phys() has a bug when it translates an IOVA for a huge
page onto its corresponding physical address. This commit fixes the bug by
accomodating the level of page entry for the IOVA and adds IOVA's lower
address to the physical address.

Cc: <stable@vger.kernel.org>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Yonghyun Hwang <yonghyun@google.com>
---

Changes from v2:
- a new condition is added to check whether the pte is present.

Changes from v1:
- level cannot be 0. So, the condition, "if (level > 1)", is removed, which results in a simple code.
- a macro, BIT_MASK, is used to have a bit mask

---
 drivers/iommu/intel-iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 932267f49f9a..0837e0063973 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5553,8 +5553,10 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	u64 phys = 0;
 
 	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
-	if (pte)
-		phys = dma_pte_addr(pte);
+	if (pte && dma_pte_present(pte))
+		phys = dma_pte_addr(pte) +
+			(iova & (BIT_MASK(level_to_offset_bits(level) +
+						VTD_PAGE_SHIFT) - 1));
 
 	return phys;
 }
-- 
2.25.0.265.gbab2e86ba0-goog

