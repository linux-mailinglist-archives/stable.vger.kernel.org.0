Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0023714CA7
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfEFOmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbfEFOma (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:42:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C4920449;
        Mon,  6 May 2019 14:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153750;
        bh=UaMv/+/IrZ2+xZVxw/x43g3nED7ocOW0JouwMEKT7+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVDTl1MM5jE5Ux7YjTyQI1m/knINokqhpvO5Oobvab8u/CFeT39Vi8DSnjXA1Yucq
         z5qL9JphbSxF8U3Q1960wUeuFaZ757Ki1fMPxR/m0u5Ucc9bHYDxPBXcLP5JA4Wzrv
         LJvbRojqq3QzjC7crGwZt9ympRWZZcnuFucmX0Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David E. Box" <david.e.box@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 82/99] platform/x86: intel_pmc_core: Handle CFL regmap properly
Date:   Mon,  6 May 2019 16:32:55 +0200
Message-Id: <20190506143101.471445067@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>

commit e50af8332785355de3cb40d9f5e8c45dbfc86f53 upstream.

Only Coffeelake should use Cannonlake regmap other than Cannonlake
platform. This allows Coffeelake special handling only when there is no
matching PCI device and default reg map selected as per CPUID is for
Sunrisepoint PCH. This change is needed to enable support for newer SoCs
such as Icelake.

Cc: "David E. Box" <david.e.box@intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: 661405bd817b ("platform/x86: intel_pmc_core: Special case for Coffeelake")
Acked-by: "David E. Box" <david.e.box@linux.intel.com>
Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/intel_pmc_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/intel_pmc_core.c
+++ b/drivers/platform/x86/intel_pmc_core.c
@@ -682,7 +682,7 @@ static int __init pmc_core_probe(void)
 	 * Sunrisepoint PCH regmap can't be used. Use Cannonlake PCH regmap
 	 * in this case.
 	 */
-	if (!pci_dev_present(pmc_pci_ids))
+	if (pmcdev->map == &spt_reg_map && !pci_dev_present(pmc_pci_ids))
 		pmcdev->map = &cnp_reg_map;
 
 	if (lpit_read_residency_count_address(&slp_s0_addr))


