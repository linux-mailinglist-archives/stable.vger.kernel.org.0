Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B61DCAB2F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfJCRTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389850AbfJCQUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:20:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E5F22054F;
        Thu,  3 Oct 2019 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119613;
        bh=J4T6+B81gkpI9TCDtnorHdYhOeqwjXSYR9zZtDyn2aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2C4FMmwsMxPdf5liN/TObcI9X9x3BglL2n0aBWGpG1GGcLyaLTzO+otiskbLKwcN
         hc2MPjzI/p7NoT81FLtlFAozZyeAigxFyI2LUzyxWtXIJnuJrn4A8buMdQH1jQo74R
         6rVcyt94pggWvV/XRX8P8OLlpHs4K/YIUTFORIQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "M. Vefa Bicakci" <m.v.b@runbox.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/211] platform/x86: intel_pmc_core: Do not ioremap RAM
Date:   Thu,  3 Oct 2019 17:53:16 +0200
Message-Id: <20191003154516.641195729@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M. Vefa Bicakci <m.v.b@runbox.com>

[ Upstream commit 7d505758b1e556cdf65a5e451744fe0ae8063d17 ]

On a Xen-based PVH virtual machine with more than 4 GiB of RAM,
intel_pmc_core fails initialization with the following warning message
from the kernel, indicating that the driver is attempting to ioremap
RAM:

  ioremap on RAM at 0x00000000fe000000 - 0x00000000fe001fff
  WARNING: CPU: 1 PID: 434 at arch/x86/mm/ioremap.c:186 __ioremap_caller.constprop.0+0x2aa/0x2c0
...
  Call Trace:
   ? pmc_core_probe+0x87/0x2d0 [intel_pmc_core]
   pmc_core_probe+0x87/0x2d0 [intel_pmc_core]

This issue appears to manifest itself because of the following fallback
mechanism in the driver:

	if (lpit_read_residency_count_address(&slp_s0_addr))
		pmcdev->base_addr = PMC_BASE_ADDR_DEFAULT;

The validity of address PMC_BASE_ADDR_DEFAULT (i.e., 0xFE000000) is not
verified by the driver, which is what this patch introduces. With this
patch, if address PMC_BASE_ADDR_DEFAULT is in RAM, then the driver will
not attempt to ioremap the aforementioned address.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_pmc_core.c b/drivers/platform/x86/intel_pmc_core.c
index 088d1c2047e6b..36bd2545afb62 100644
--- a/drivers/platform/x86/intel_pmc_core.c
+++ b/drivers/platform/x86/intel_pmc_core.c
@@ -685,10 +685,14 @@ static int __init pmc_core_probe(void)
 	if (pmcdev->map == &spt_reg_map && !pci_dev_present(pmc_pci_ids))
 		pmcdev->map = &cnp_reg_map;
 
-	if (lpit_read_residency_count_address(&slp_s0_addr))
+	if (lpit_read_residency_count_address(&slp_s0_addr)) {
 		pmcdev->base_addr = PMC_BASE_ADDR_DEFAULT;
-	else
+
+		if (page_is_ram(PHYS_PFN(pmcdev->base_addr)))
+			return -ENODEV;
+	} else {
 		pmcdev->base_addr = slp_s0_addr - pmcdev->map->slp_s0_offset;
+	}
 
 	pmcdev->regbase = ioremap(pmcdev->base_addr,
 				  pmcdev->map->regmap_length);
-- 
2.20.1



