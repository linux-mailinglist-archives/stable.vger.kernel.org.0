Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B3F41721C
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343708AbhIXMpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343686AbhIXMpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:45:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79A0461242;
        Fri, 24 Sep 2021 12:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487457;
        bh=JytDFP4yoVK//MQDstyOVDYYYqTYz85sSGPhO4rFoCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3xl+EsWd5J00huq+ag64xCE8Ug7R2Myja3ujSzh6q0Lwxqhw0hZ2AXrOjCP6HxLN
         FuQOdToje/JOJiEfveb3YQn+c5EeprTr4YUf+ny5xaQNRdhFTQtrQ4FLOkc2T8ZTS2
         VPOvJVOPQO3NOJqW4zC0yF4aTOobv4Gz01B3WpFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 10/23] dmaengine: acpi-dma: check for 64-bit MMIO address
Date:   Fri, 24 Sep 2021 14:43:51 +0200
Message-Id: <20210924124328.156321496@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124327.816210800@linuxfoundation.org>
References: <20210924124327.816210800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f94cf9f4c54a72ccbd2078bb0cedd3691a71c431 ]

Currently the match DMA controller is done only for lower 32 bits of
address which might be not true on 64-bit platform. Check upper portion
as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/acpi-dma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/acpi-dma.c b/drivers/dma/acpi-dma.c
index 16d0daa058a5..eed6bda01790 100644
--- a/drivers/dma/acpi-dma.c
+++ b/drivers/dma/acpi-dma.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -72,7 +73,9 @@ static int acpi_dma_parse_resource_group(const struct acpi_csrt_group *grp,
 	si = (const struct acpi_csrt_shared_info *)&grp[1];
 
 	/* Match device by MMIO and IRQ */
-	if (si->mmio_base_low != mem || si->gsi_interrupt != irq)
+	if (si->mmio_base_low != lower_32_bits(mem) ||
+	    si->mmio_base_high != upper_32_bits(mem) ||
+	    si->gsi_interrupt != irq)
 		return 0;
 
 	dev_dbg(&adev->dev, "matches with %.4s%04X (rev %u)\n",
-- 
2.33.0



