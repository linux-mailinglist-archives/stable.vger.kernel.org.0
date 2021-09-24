Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3519416E66
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 11:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244507AbhIXJBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 05:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:32882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244433AbhIXJBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 05:01:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BC9A60F41;
        Fri, 24 Sep 2021 09:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632474004;
        bh=61OC+s/ciBqaCKRdFntDQR5moA73kG4kCsZt2M5d3qs=;
        h=Subject:To:Cc:From:Date:From;
        b=BdvHaT4RfCf0RG6rA3wYIV1xT3GILiYVpeTJOCOUxWWyNmiuwICAL9bMGIBhzMcZU
         KGSoBCCX1CzK/DxUNlTIDOJwM678IXC8cFKB3lJm2KSwb8Eb7vkfcO/yA+UGNUsJIc
         +hv3aWD4wNptPlrXdCm57TvWbLXujvzBI+OylYUE=
Subject: FAILED: patch "[PATCH] dmaengine: acpi: Avoid comparison GSI with Linux vIRQ" failed to apply to 4.4-stable tree
To:     andriy.shevchenko@linux.intel.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 Sep 2021 11:00:02 +0200
Message-ID: <16324740029741@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 67db87dc8284070adb15b3c02c1c31d5cf51c5d6 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Fri, 30 Jul 2021 23:27:15 +0300
Subject: [PATCH] dmaengine: acpi: Avoid comparison GSI with Linux vIRQ

Currently the CRST parsing relies on the fact that on most of x86 devices
the IRQ mapping is 1:1 with Linux vIRQ. However, it may be not true for
some. Fix this by converting GSI to Linux vIRQ before checking it.

Fixes: ee8209fd026b ("dma: acpi-dma: parse CSRT to extract additional resources")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210730202715.24375-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/acpi-dma.c b/drivers/dma/acpi-dma.c
index 235f1396f968..52768dc8ce12 100644
--- a/drivers/dma/acpi-dma.c
+++ b/drivers/dma/acpi-dma.c
@@ -70,10 +70,14 @@ static int acpi_dma_parse_resource_group(const struct acpi_csrt_group *grp,
 
 	si = (const struct acpi_csrt_shared_info *)&grp[1];
 
-	/* Match device by MMIO and IRQ */
+	/* Match device by MMIO */
 	if (si->mmio_base_low != lower_32_bits(mem) ||
-	    si->mmio_base_high != upper_32_bits(mem) ||
-	    si->gsi_interrupt != irq)
+	    si->mmio_base_high != upper_32_bits(mem))
+		return 0;
+
+	/* Match device by Linux vIRQ */
+	ret = acpi_register_gsi(NULL, si->gsi_interrupt, si->interrupt_mode, si->interrupt_polarity);
+	if (ret != irq)
 		return 0;
 
 	dev_dbg(&adev->dev, "matches with %.4s%04X (rev %u)\n",

