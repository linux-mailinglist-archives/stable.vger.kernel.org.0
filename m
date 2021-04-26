Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969CF36AE30
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhDZHly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232778AbhDZHjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 712BA613D4;
        Mon, 26 Apr 2021 07:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422706;
        bh=5xBHKQcJFKrSKE5szdi9hF3l/sv4dK+0vpoR/rm0Lnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMIhc1p2dySEywLXgnTSqg8mfaduVfjIA+i4NEp3wi9rErIqHC2N65ByZ1NRXEgfK
         dOd7m2b1Ut5SidTAWxRDVsBiLN0SjF+8v4mjf62t+HQmT3+RoChiMbM8mmicHapyDn
         NBXwJ9Y652tRKW/9twyr5qwY69HvW3reWZ/4bRGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Wahl <steve.wahl@hpe.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/20] perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3
Date:   Mon, 26 Apr 2021 09:29:57 +0200
Message-Id: <20210426072816.889186531@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
References: <20210426072816.686976183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 9d480158ee86ad606d3a8baaf81e6b71acbfd7d5 ]

There may be a kernel panic on the Haswell server and the Broadwell
server, if the snbep_pci2phy_map_init() return error.

The uncore_extra_pci_dev[HSWEP_PCI_PCU_3] is used in the cpu_init() to
detect the existence of the SBOX, which is a MSR type of PMON unit.
The uncore_extra_pci_dev is allocated in the uncore_pci_init(). If the
snbep_pci2phy_map_init() returns error, perf doesn't initialize the
PCI type of the PMON units, so the uncore_extra_pci_dev will not be
allocated. But perf may continue initializing the MSR type of PMON
units. A null dereference kernel panic will be triggered.

The sockets in a Haswell server or a Broadwell server are identical.
Only need to detect the existence of the SBOX once.
Current perf probes all available PCU devices and stores them into the
uncore_extra_pci_dev. It's unnecessary.
Use the pci_get_device() to replace the uncore_extra_pci_dev. Only
detect the existence of the SBOX on the first available PCU device once.

Factor out hswep_has_limit_sbox(), since the Haswell server and the
Broadwell server uses the same way to detect the existence of the SBOX.

Add some macros to replace the magic number.

Fixes: 5306c31c5733 ("perf/x86/uncore/hsw-ep: Handle systems with only two SBOXes")
Reported-by: Steve Wahl <steve.wahl@hpe.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Steve Wahl <steve.wahl@hpe.com>
Link: https://lkml.kernel.org/r/1618521764-100923-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 61 ++++++++++++----------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index ad20220af303..40751af62dd3 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -1093,7 +1093,6 @@ enum {
 	SNBEP_PCI_QPI_PORT0_FILTER,
 	SNBEP_PCI_QPI_PORT1_FILTER,
 	BDX_PCI_QPI_PORT2_FILTER,
-	HSWEP_PCI_PCU_3,
 };
 
 static int snbep_qpi_hw_config(struct intel_uncore_box *box, struct perf_event *event)
@@ -2750,22 +2749,33 @@ static struct intel_uncore_type *hswep_msr_uncores[] = {
 	NULL,
 };
 
-void hswep_uncore_cpu_init(void)
+#define HSWEP_PCU_DID			0x2fc0
+#define HSWEP_PCU_CAPID4_OFFET		0x94
+#define hswep_get_chop(_cap)		(((_cap) >> 6) & 0x3)
+
+static bool hswep_has_limit_sbox(unsigned int device)
 {
-	int pkg = boot_cpu_data.logical_proc_id;
+	struct pci_dev *dev = pci_get_device(PCI_VENDOR_ID_INTEL, device, NULL);
+	u32 capid4;
+
+	if (!dev)
+		return false;
+
+	pci_read_config_dword(dev, HSWEP_PCU_CAPID4_OFFET, &capid4);
+	if (!hswep_get_chop(capid4))
+		return true;
 
+	return false;
+}
+
+void hswep_uncore_cpu_init(void)
+{
 	if (hswep_uncore_cbox.num_boxes > boot_cpu_data.x86_max_cores)
 		hswep_uncore_cbox.num_boxes = boot_cpu_data.x86_max_cores;
 
 	/* Detect 6-8 core systems with only two SBOXes */
-	if (uncore_extra_pci_dev[pkg].dev[HSWEP_PCI_PCU_3]) {
-		u32 capid4;
-
-		pci_read_config_dword(uncore_extra_pci_dev[pkg].dev[HSWEP_PCI_PCU_3],
-				      0x94, &capid4);
-		if (((capid4 >> 6) & 0x3) == 0)
-			hswep_uncore_sbox.num_boxes = 2;
-	}
+	if (hswep_has_limit_sbox(HSWEP_PCU_DID))
+		hswep_uncore_sbox.num_boxes = 2;
 
 	uncore_msr_uncores = hswep_msr_uncores;
 }
@@ -3028,11 +3038,6 @@ static const struct pci_device_id hswep_uncore_pci_ids[] = {
 		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
 						   SNBEP_PCI_QPI_PORT1_FILTER),
 	},
-	{ /* PCU.3 (for Capability registers) */
-		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fc0),
-		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
-						   HSWEP_PCI_PCU_3),
-	},
 	{ /* end: all zeroes */ }
 };
 
@@ -3124,27 +3129,18 @@ static struct event_constraint bdx_uncore_pcu_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
+#define BDX_PCU_DID			0x6fc0
+
 void bdx_uncore_cpu_init(void)
 {
-	int pkg = topology_phys_to_logical_pkg(boot_cpu_data.phys_proc_id);
-
 	if (bdx_uncore_cbox.num_boxes > boot_cpu_data.x86_max_cores)
 		bdx_uncore_cbox.num_boxes = boot_cpu_data.x86_max_cores;
 	uncore_msr_uncores = bdx_msr_uncores;
 
-	/* BDX-DE doesn't have SBOX */
-	if (boot_cpu_data.x86_model == 86) {
-		uncore_msr_uncores[BDX_MSR_UNCORE_SBOX] = NULL;
 	/* Detect systems with no SBOXes */
-	} else if (uncore_extra_pci_dev[pkg].dev[HSWEP_PCI_PCU_3]) {
-		struct pci_dev *pdev;
-		u32 capid4;
-
-		pdev = uncore_extra_pci_dev[pkg].dev[HSWEP_PCI_PCU_3];
-		pci_read_config_dword(pdev, 0x94, &capid4);
-		if (((capid4 >> 6) & 0x3) == 0)
-			bdx_msr_uncores[BDX_MSR_UNCORE_SBOX] = NULL;
-	}
+	if ((boot_cpu_data.x86_model == 86) || hswep_has_limit_sbox(BDX_PCU_DID))
+		uncore_msr_uncores[BDX_MSR_UNCORE_SBOX] = NULL;
+
 	hswep_uncore_pcu.constraints = bdx_uncore_pcu_constraints;
 }
 
@@ -3365,11 +3361,6 @@ static const struct pci_device_id bdx_uncore_pci_ids[] = {
 		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
 						   BDX_PCI_QPI_PORT2_FILTER),
 	},
-	{ /* PCU.3 (for Capability registers) */
-		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x6fc0),
-		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
-						   HSWEP_PCI_PCU_3),
-	},
 	{ /* end: all zeroes */ }
 };
 
-- 
2.30.2



