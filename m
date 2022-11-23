Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF25C635520
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbiKWJQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbiKWJPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:15:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BD810891E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:15:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D23A61B4C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC5AC433D6;
        Wed, 23 Nov 2022 09:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194949;
        bh=OhVqUg8/S4pczckgxiJd6ilmCDLQnXigCBfeQCpfJuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcr06vaurw+UgPQIZrz4U6+1T8M1ILtj488OvvZV33ar4LY3wGh+JYbTnEbXswS8O
         86+nwalJCj2loMnZJC3K1uROZD8yjlsqd2ESUw60r25/H5xHHGH8uw+/nRKuOA9vJA
         ybnRv91OoTNrENPsloh3AkKe/+Hcf0SMK7BwqNGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/156] platform/x86/intel: pmc: Dont unconditionally attach Intel PMC when virtualized
Date:   Wed, 23 Nov 2022 09:51:03 +0100
Message-Id: <20221123084601.815356743@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monné <roger.pau@citrix.com>

[ Upstream commit 2dbfb3f33350e1e868d3d7ed4c176d8777150878 ]

The current logic in the Intel PMC driver will forcefully attach it
when detecting any CPU on the intel_pmc_core_platform_ids array,
even if the matching ACPI device is not present.

There's no checking in pmc_core_probe() to assert that the PMC device
is present, and hence on virtualized environments the PMC device
probes successfully, even if the underlying registers are not present.
Before commit 21ae43570940 ("platform/x86: intel_pmc_core: Substitute PCI
with CPUID enumeration") the driver would check for the presence of a
specific PCI device, and that prevented the driver from attaching when
running virtualized.

Fix by only forcefully attaching the PMC device when not running
virtualized.  Note that virtualized platforms can still get the device
to load if the appropriate ACPI device is present on the tables
provided to the VM.

Make an exception for the Xen initial domain, which does have full
hardware access, and hence can attach to the PMC if present.

Fixes: 21ae43570940 ("platform/x86: intel_pmc_core: Substitute PCI with CPUID enumeration")
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Acked-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221110163145.80374-1-roger.pau@citrix.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core_pltdrv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/intel_pmc_core_pltdrv.c b/drivers/platform/x86/intel_pmc_core_pltdrv.c
index e1266f5c6359..42ed02ab8a61 100644
--- a/drivers/platform/x86/intel_pmc_core_pltdrv.c
+++ b/drivers/platform/x86/intel_pmc_core_pltdrv.c
@@ -18,6 +18,8 @@
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 
+#include <xen/xen.h>
+
 static void intel_pmc_core_release(struct device *dev)
 {
 	/* Nothing to do. */
@@ -56,6 +58,13 @@ static int __init pmc_core_platform_init(void)
 	if (acpi_dev_present("INT33A1", NULL, -1))
 		return -ENODEV;
 
+	/*
+	 * Skip forcefully attaching the device for VMs. Make an exception for
+	 * Xen dom0, which does have full hardware access.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR) && !xen_initial_domain())
+		return -ENODEV;
+
 	if (!x86_match_cpu(intel_pmc_core_platform_ids))
 		return -ENODEV;
 
-- 
2.35.1



