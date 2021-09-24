Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD824172F0
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344231AbhIXMw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344476AbhIXMvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:51:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35AA161279;
        Fri, 24 Sep 2021 12:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487739;
        bh=qJCZf8z0SKfO4BYhVd4fDfO5qs/mt0fSlBiITh6dTkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJpEC+kPBQ1f4UzgtMU8aGVm/TU3DP3wRfOdj4rV7/LIR/aluIeP1astEYwEU06uR
         WHuD2+Bqsqd2ivV1cMS2EXSpxJiQShokdDZ3tFL/Q5AHszPdbz68Kjq3kdcezKU7gd
         sDJRKFMR7k/s8gNLMGdPcvg4thEKYigiZu2agSdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 09/34] dmaengine: acpi: Avoid comparison GSI with Linux vIRQ
Date:   Fri, 24 Sep 2021 14:44:03 +0200
Message-Id: <20210924124330.270739357@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 67db87dc8284070adb15b3c02c1c31d5cf51c5d6 upstream.

Currently the CRST parsing relies on the fact that on most of x86 devices
the IRQ mapping is 1:1 with Linux vIRQ. However, it may be not true for
some. Fix this by converting GSI to Linux vIRQ before checking it.

Fixes: ee8209fd026b ("dma: acpi-dma: parse CSRT to extract additional resources")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210730202715.24375-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/acpi-dma.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/dma/acpi-dma.c
+++ b/drivers/dma/acpi-dma.c
@@ -72,10 +72,14 @@ static int acpi_dma_parse_resource_group
 
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


