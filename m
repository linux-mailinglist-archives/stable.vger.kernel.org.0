Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805BA247528
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392305AbgHQTTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730526AbgHQPhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:37:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F2F23121;
        Mon, 17 Aug 2020 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678627;
        bh=pa7M8dBoZwbrpDy4ZMTrCKWCazaSlXNnYetm23sZ98o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fq04HTUf2YMThPKFFpcD/Ub6ysssvSyra0F8H719KI5ypN1YDkeSRj+f78lvlrer+
         z+QO1c6WP/oEhfG1U1u1r7dAxitIPEMMy2WKC6aBXfmVJUKTaltnINb4OFmCWVA4OO
         HEpYzzB8Hi09mllB3kltChkLLe8OWDL2/RiMk3rQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Koba Ko <koba.ko@canonical.com>,
        Jun Miao <jun.miao@windriver.com>,
        Ashok Raj <ashok.raj@intel.com>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.8 400/464] iommu/vt-d: Skip TE disabling on quirky gfx dedicated iommu
Date:   Mon, 17 Aug 2020 17:15:53 +0200
Message-Id: <20200817143852.945678875@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit b1012ca8dc4f9b1a1fe8e2cb1590dd6d43ea3849 upstream.

The VT-d spec requires (10.4.4 Global Command Register, TE field) that:

Hardware implementations supporting DMA draining must drain any in-flight
DMA read/write requests queued within the Root-Complex before completing
the translation enable command and reflecting the status of the command
through the TES field in the Global Status register.

Unfortunately, some integrated graphic devices fail to do so after some
kind of power state transition. As the result, the system might stuck in
iommu_disable_translation(), waiting for the completion of TE transition.

This provides a quirk list for those devices and skips TE disabling if
the qurik hits.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=208363
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=206571
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Koba Ko <koba.ko@canonical.com>
Tested-by: Jun Miao <jun.miao@windriver.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200723013437.2268-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel/dmar.c  |    1 +
 drivers/iommu/intel/iommu.c |   27 +++++++++++++++++++++++++++
 include/linux/dmar.h        |    1 +
 include/linux/intel-iommu.h |    2 ++
 4 files changed, 31 insertions(+)

--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1102,6 +1102,7 @@ static int alloc_iommu(struct dmar_drhd_
 	}
 
 	drhd->iommu = iommu;
+	iommu->drhd = drhd;
 
 	return 0;
 
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -356,6 +356,7 @@ static int intel_iommu_strict;
 static int intel_iommu_superpage = 1;
 static int iommu_identity_mapping;
 static int intel_no_bounce;
+static int iommu_skip_te_disable;
 
 #define IDENTMAP_GFX		2
 #define IDENTMAP_AZALIA		4
@@ -1629,6 +1630,10 @@ static void iommu_disable_translation(st
 	u32 sts;
 	unsigned long flag;
 
+	if (iommu_skip_te_disable && iommu->drhd->gfx_dedicated &&
+	    (cap_read_drain(iommu->cap) || cap_write_drain(iommu->cap)))
+		return;
+
 	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	iommu->gcmd &= ~DMA_GCMD_TE;
 	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
@@ -4039,6 +4044,7 @@ static void __init init_no_remapping_dev
 
 		/* This IOMMU has *only* gfx devices. Either bypass it or
 		   set the gfx_mapped flag, as appropriate */
+		drhd->gfx_dedicated = 1;
 		if (!dmar_map_gfx) {
 			drhd->ignored = 1;
 			for_each_active_dev_scope(drhd->devices,
@@ -6182,6 +6188,27 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0062, quirk_calpella_no_shadow_gtt);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x006a, quirk_calpella_no_shadow_gtt);
 
+static void quirk_igfx_skip_te_disable(struct pci_dev *dev)
+{
+	unsigned short ver;
+
+	if (!IS_GFX_DEVICE(dev))
+		return;
+
+	ver = (dev->device >> 8) & 0xff;
+	if (ver != 0x45 && ver != 0x46 && ver != 0x4c &&
+	    ver != 0x4e && ver != 0x8a && ver != 0x98 &&
+	    ver != 0x9a)
+		return;
+
+	if (risky_device(dev))
+		return;
+
+	pci_info(dev, "Skip IOMMU disabling for graphics\n");
+	iommu_skip_te_disable = 1;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, quirk_igfx_skip_te_disable);
+
 /* On Tylersburg chipsets, some BIOSes have been known to enable the
    ISOCH DMAR unit for the Azalia sound device, but not give it any
    TLB entries, which causes it to deadlock. Check for that.  We do
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -48,6 +48,7 @@ struct dmar_drhd_unit {
 	u16	segment;		/* PCI domain		*/
 	u8	ignored:1; 		/* ignore drhd		*/
 	u8	include_all:1;
+	u8	gfx_dedicated:1;	/* graphic dedicated	*/
 	struct intel_iommu *iommu;
 };
 
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -600,6 +600,8 @@ struct intel_iommu {
 	struct iommu_device iommu;  /* IOMMU core code handle */
 	int		node;
 	u32		flags;      /* Software defined flags */
+
+	struct dmar_drhd_unit *drhd;
 };
 
 /* PCI domain-device relationship */


