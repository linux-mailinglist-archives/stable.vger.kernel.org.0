Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D34498ED0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348569AbiAXTso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:48:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355426AbiAXTlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:41:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56AAEB81229;
        Mon, 24 Jan 2022 19:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FF2C340E5;
        Mon, 24 Jan 2022 19:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053278;
        bh=H0WDixWq1G9g12I0MwbrOEaV0Q3A4KaDbq65bdNHOcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxRRgGb/moBju43CN2N2iKsBtkP98OffwHvzJwvyjZQB7Uj16I81wW1A/ZkEEy5XA
         j5lGTfWk0/jeZ4qmuGFElshBAShSa9SHcaVa/OKnOk6TeuVomksyUTMzw7zzcE+2tv
         IdSpHBuA8pMIYsI9vNszJKeRZZUxOXsl20UqfBpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas De Marchi <lucas.demarchi@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 014/563] x86/gpu: Reserve stolen memory for first integrated Intel GPU
Date:   Mon, 24 Jan 2022 19:36:19 +0100
Message-Id: <20220124184024.911676383@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas De Marchi <lucas.demarchi@intel.com>

commit 9c494ca4d3a535f9ca11ad6af1813983c1c6cbdd upstream.

"Stolen memory" is memory set aside for use by an Intel integrated GPU.
The intel_graphics_quirks() early quirk reserves this memory when it is
called for a GPU that appears in the intel_early_ids[] table of integrated
GPUs.

Previously intel_graphics_quirks() was marked as QFLAG_APPLY_ONCE, so it
was called only for the first Intel GPU found.  If a discrete GPU happened
to be enumerated first, intel_graphics_quirks() was called for it but not
for any integrated GPU found later.  Therefore, stolen memory for such an
integrated GPU was never reserved.

For example, this problem occurs in this Alderlake-P (integrated) + DG2
(discrete) topology where the DG2 is found first, but stolen memory is
associated with the integrated GPU:

  - 00:01.0 Bridge
    `- 03:00.0 DG2 discrete GPU
  - 00:02.0 Integrated GPU (with stolen memory)

Remove the QFLAG_APPLY_ONCE flag and call intel_graphics_quirks() for every
Intel GPU.  Reserve stolen memory for the first GPU that appears in
intel_early_ids[].

[bhelgaas: commit log, add code comment, squash in
https://lore.kernel.org/r/20220118190558.2ququ4vdfjuahicm@ldmartin-desk2]
Link: https://lore.kernel.org/r/20220114002843.2083382-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/early-quirks.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -515,6 +515,7 @@ static const struct intel_early_ops gen1
 	.stolen_size = gen9_stolen_size,
 };
 
+/* Intel integrated GPUs for which we need to reserve "stolen memory" */
 static const struct pci_device_id intel_early_ids[] __initconst = {
 	INTEL_I830_IDS(&i830_early_ops),
 	INTEL_I845G_IDS(&i845_early_ops),
@@ -588,6 +589,13 @@ static void __init intel_graphics_quirks
 	u16 device;
 	int i;
 
+	/*
+	 * Reserve "stolen memory" for an integrated GPU.  If we've already
+	 * found one, there's nothing to do for other (discrete) GPUs.
+	 */
+	if (resource_size(&intel_graphics_stolen_res))
+		return;
+
 	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
 
 	for (i = 0; i < ARRAY_SIZE(intel_early_ids); i++) {
@@ -700,7 +708,7 @@ static struct chipset early_qrk[] __init
 	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA, PCI_ANY_ID,
-	  QFLAG_APPLY_ONCE, intel_graphics_quirks },
+	  0, intel_graphics_quirks },
 	/*
 	 * HPET on the current version of the Baytrail platform has accuracy
 	 * problems: it will halt in deep idle state - so we disable it.


