Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD4442FD6A
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 23:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243090AbhJOVcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 17:32:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:44568 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232225AbhJOVcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 17:32:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10138"; a="208789851"
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="208789851"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 14:29:58 -0700
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="443323529"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 14:29:58 -0700
Subject: [PATCH v6 03/10] cxl/pci: Fix NULL vs ERR_PTR confusion
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 15 Oct 2021 14:29:58 -0700
Message-ID: <163433325724.834522.17809774578178224149.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163379785305.692348.7804260538462033304.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163379785305.692348.7804260538462033304.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cxl_pci_map_regblock() may return an ERR_PTR(), but cxl_pci_setup_regs()
is only prepared for NULL as the error case. Pick the minimal fix for
-stable backport purposes and just have cxl_pci_map_regblock() return
NULL for errors.

Fixes: f8a7e8c29be8 ("cxl/pci: Reserve all device regions at once")
Cc: <stable@vger.kernel.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
- clarify in the changelog why cxl_pci_map_regblock() was changed to
  return NULL rather than fix the caller to expect an ERR_PTR().
  (Jonathan)

 drivers/cxl/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index ccc7c2573ddc..9c178002d49e 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -317,7 +317,7 @@ static void __iomem *cxl_pci_map_regblock(struct cxl_mem *cxlm,
 	if (pci_resource_len(pdev, bar) < offset) {
 		dev_err(dev, "BAR%d: %pr: too small (offset: %#llx)\n", bar,
 			&pdev->resource[bar], (unsigned long long)offset);
-		return IOMEM_ERR_PTR(-ENXIO);
+		return NULL;
 	}
 
 	addr = pci_iomap(pdev, bar, 0);

