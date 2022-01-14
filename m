Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C13C48E176
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 01:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbiANA2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 19:28:13 -0500
Received: from mga04.intel.com ([192.55.52.120]:24454 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230165AbiANA2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 19:28:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642120093; x=1673656093;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RRSc0fCF2gQ58MCLYJ6EBu3GpIJNYU365XBPjiNmmwU=;
  b=aH2hmOTwwfKK+7xqAT3xwiRYnJPanp28ULfpIXa3JM2OtWPTBLRoceFs
   EFYyGpJ5d6Mzc7XZ0yZW3h3RtCSdFsXlKFE6OcHnoHFlniUbU8dHct2z2
   AKNVo+Hoih3KkW+Ub0sQ8kG+LtLGSiHERbH/pWmvojpRYPasSHOIxKuwC
   5pXglXux9y+c80/thexk8jwphMFvCaEN3+lJMdUPP6vuJdsFm+aCubBmq
   MjLJ5y9GiPyp4NbL27W9wrML9nmVSmKkJlTPk5+cn6Qh76DtNrD5FWeSf
   BE7tby8VpvLxrfkx+FGiJg3+b4vFXwZH0pkdcj6Q6bQ9gER0YjkUxhxkj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="242964235"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="242964235"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 16:28:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="491317600"
Received: from lucas-s2600cw.jf.intel.com ([10.165.21.202])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 16:28:12 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     x86@kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: [PATCH v5 1/5] x86/quirks: Fix stolen detection with integrated + discrete GPU
Date:   Thu, 13 Jan 2022 16:28:39 -0800
Message-Id: <20220114002843.2083382-1-lucas.demarchi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

early_pci_scan_bus() does a depth-first traversal, possibly calling
the quirk functions for each device based on vendor, device and class
from early_qrk table. intel_graphics_quirks() however uses PCI_ANY_ID
and does additional filtering in the quirk.

If there is an Intel integrated + discrete GPU the quirk may be called
first for the discrete GPU based on the PCI topology. Then we will fail
to reserve the system stolen memory for the integrated GPU, because we
will already have marked the quirk as "applied".

This was reproduced in a setup with Alderlake-P (integrated) + DG2
(discrete), with the following PCI topology:

	- 00:01.0 Bridge
	  `- 03:00.0 DG2
	- 00:02.0 Integrated GPU

So, stop using the QFLAG_APPLY_ONCE flag, replacing it with a static
local variable. We can set this variable in the right place, inside
intel_graphics_quirks(), only when the quirk was actually applied, i.e.
when we find the integrated GPU based on the intel_early_ids table.

Cc: stable@vger.kernel.org
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
---

v5: apply fix before the refactor

 arch/x86/kernel/early-quirks.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 1ca3a56fdc2d..de9a76eb544e 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -589,10 +589,14 @@ intel_graphics_stolen(int num, int slot, int func,
 
 static void __init intel_graphics_quirks(int num, int slot, int func)
 {
+	static bool quirk_applied __initdata;
 	const struct intel_early_ops *early_ops;
 	u16 device;
 	int i;
 
+	if (quirk_applied)
+		return;
+
 	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
 
 	for (i = 0; i < ARRAY_SIZE(intel_early_ids); i++) {
@@ -605,6 +609,8 @@ static void __init intel_graphics_quirks(int num, int slot, int func)
 
 		intel_graphics_stolen(num, slot, func, early_ops);
 
+		quirk_applied = true;
+
 		return;
 	}
 }
@@ -705,7 +711,7 @@ static struct chipset early_qrk[] __initdata = {
 	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA, PCI_ANY_ID,
-	  QFLAG_APPLY_ONCE, intel_graphics_quirks },
+	  0, intel_graphics_quirks },
 	/*
 	 * HPET on the current version of the Baytrail platform has accuracy
 	 * problems: it will halt in deep idle state - so we disable it.
-- 
2.34.1

