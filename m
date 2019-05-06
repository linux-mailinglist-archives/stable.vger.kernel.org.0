Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C25314EC5
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfEFOi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726679AbfEFOi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:38:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24C0421479;
        Mon,  6 May 2019 14:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153537;
        bh=c/XoGLNUgHSYgn/xU/oltXrqsx3cVeB7liKulxGLQy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4nsZ6lgaKdjuBM+wSLReSN2Moq74huEotWjn1yXD9jG/euHmhJFNIr/OcXKNoXr/
         1LHW2u40KjoPhJjg83PDJRyUjxc9hzRmKn9FqbcfWd2XPzPegoVf/iFx2VjcqBVR44
         5Ak9akEhMlEwUu3G1EMGldoG08WcBgtmEb6dISFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David E. Box" <david.e.box@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.0 105/122] platform/x86: intel_pmc_core: Handle CFL regmap properly
Date:   Mon,  6 May 2019 16:32:43 +0200
Message-Id: <20190506143104.089681384@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
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
@@ -802,7 +802,7 @@ static int __init pmc_core_probe(void)
 	 * Sunrisepoint PCH regmap can't be used. Use Cannonlake PCH regmap
 	 * in this case.
 	 */
-	if (!pci_dev_present(pmc_pci_ids))
+	if (pmcdev->map == &spt_reg_map && !pci_dev_present(pmc_pci_ids))
 		pmcdev->map = &cnp_reg_map;
 
 	if (lpit_read_residency_count_address(&slp_s0_addr))


