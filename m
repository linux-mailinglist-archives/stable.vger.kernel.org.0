Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22082E15C2
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgLWCxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:53:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729266AbgLWCVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7873D22AAF;
        Wed, 23 Dec 2020 02:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690059;
        bh=R0F5p3NMR/Y0iMl7B4a1GrLgzCX/q+M9bdVR81CyEPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjARXfFbbEOzctuWSZW6yh/8j9vcaVhNImAkbQYbTP2RMjHdLPSxIQX9js0SWBhvl
         9dc6+VkeuElQ9baqh8lDa3PnQR62rLFEglp0qv/pb2b7fOlufiNHfO3fHLcGX5pAzu
         u5/qEDxFkn6sG6UQ6wUZCRd03w3VSsnOf5Dduahyuk2AH/ad/aprYHjkkxsJDbtc/O
         2gNq6LkzJEktg+s78M23KB6HiQcRKEp31c5wkLnguzrn4r0k5hrLPVEbPOH7D+srKH
         9AS9r6uhvjLKCT0Ou8mzp8XWS6CNoq3Jm07nmVbg3rXIk86c5YLlP+ZNWJ+/gt4cBG
         X4cgpeyPm80Jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        kbuild test robot <lkp@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 128/130] x86,swiotlb: Adjust SWIOTLB bounce buffer size for SEV guests
Date:   Tue, 22 Dec 2020 21:18:11 -0500
Message-Id: <20201223021813.2791612-128-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit e998879d4fb7991856916972168cf27c0d86ed12 ]

For SEV, all DMA to and from guest has to use shared (un-encrypted) pages.
SEV uses SWIOTLB to make this happen without requiring changes to device
drivers.  However, depending on the workload being run, the default 64MB
of it might not be enough and it may run out of buffers to use for DMA,
resulting in I/O errors and/or performance degradation for high
I/O workloads.

Adjust the default size of SWIOTLB for SEV guests using a
percentage of the total memory available to guest for the SWIOTLB buffers.

Adds a new sev_setup_arch() function which is invoked from setup_arch()
and it calls into a new swiotlb generic code function swiotlb_adjust_size()
to do the SWIOTLB buffer adjustment.

v5 fixed build errors and warnings as
Reported-by: kbuild test robot <lkp@intel.com>

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/mem_encrypt.h |  2 ++
 arch/x86/kernel/setup.c            |  6 ++++++
 arch/x86/mm/mem_encrypt.c          | 31 ++++++++++++++++++++++++++++++
 include/linux/swiotlb.h            |  8 ++++++++
 kernel/dma/swiotlb.c               | 20 +++++++++++++++++--
 5 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 848ce43b9040d..6c36956452ca6 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -36,6 +36,7 @@ void __init sme_map_bootdata(char *real_mode_data);
 void __init sme_unmap_bootdata(char *real_mode_data);
 
 void __init sme_early_init(void);
+void __init sev_setup_arch(void);
 
 void __init sme_encrypt_kernel(struct boot_params *bp);
 void __init sme_enable(struct boot_params *bp);
@@ -65,6 +66,7 @@ static inline void __init sme_map_bootdata(char *real_mode_data) { }
 static inline void __init sme_unmap_bootdata(char *real_mode_data) { }
 
 static inline void __init sme_early_init(void) { }
+static inline void __init sev_setup_arch(void) { }
 
 static inline void __init sme_encrypt_kernel(struct boot_params *bp) { }
 static inline void __init sme_enable(struct boot_params *bp) { }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 77ea96b794bd1..9dc0c94e1544f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1120,6 +1120,12 @@ void __init setup_arch(char **cmdline_p)
 	memblock_set_current_limit(ISA_END_ADDRESS);
 	e820__memblock_setup();
 
+	/*
+	 * Needs to run after memblock setup because it needs the physical
+	 * memory size.
+	 */
+	sev_setup_arch();
+
 	reserve_bios_regions();
 
 	if (efi_enabled(EFI_MEMMAP)) {
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 9268c12458c84..5911cfa31bc6d 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -196,6 +196,37 @@ void __init sme_early_init(void)
 		swiotlb_force = SWIOTLB_FORCE;
 }
 
+void __init sev_setup_arch(void)
+{
+	phys_addr_t total_mem = memblock_phys_mem_size();
+	unsigned long size;
+
+	if (!sev_active())
+		return;
+
+	/*
+	 * For SEV, all DMA has to occur via shared/unencrypted pages.
+	 * SEV uses SWIOTLB to make this happen without changing device
+	 * drivers. However, depending on the workload being run, the
+	 * default 64MB of SWIOTLB may not be enough and SWIOTLB may
+	 * run out of buffers for DMA, resulting in I/O errors and/or
+	 * performance degradation especially with high I/O workloads.
+	 *
+	 * Adjust the default size of SWIOTLB for SEV guests using
+	 * a percentage of guest memory for SWIOTLB buffers.
+	 * Also, as the SWIOTLB bounce buffer memory is allocated
+	 * from low memory, ensure that the adjusted size is within
+	 * the limits of low available memory.
+	 *
+	 * The percentage of guest memory used here for SWIOTLB buffers
+	 * is more of an approximation of the static adjustment which
+	 * 64MB for <1G, and ~128M to 256M for 1G-to-4G, i.e., the 6%
+	 */
+	size = total_mem * 6 / 100;
+	size = clamp_val(size, IO_TLB_DEFAULT_SIZE, SZ_1G);
+	swiotlb_adjust_size(size);
+}
+
 static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 {
 	pgprot_t old_prot, new_prot;
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 0a8fced6aaec4..522a0942114ad 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -30,6 +30,9 @@ enum swiotlb_force {
  */
 #define IO_TLB_SHIFT 11
 
+/* default to 64MB */
+#define IO_TLB_DEFAULT_SIZE (64UL<<20)
+
 extern void swiotlb_init(int verbose);
 int swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
 extern unsigned long swiotlb_nr_tbl(void);
@@ -80,6 +83,7 @@ void __init swiotlb_exit(void);
 unsigned int swiotlb_max_segment(void);
 size_t swiotlb_max_mapping_size(struct device *dev);
 bool is_swiotlb_active(void);
+void __init swiotlb_adjust_size(unsigned long new_size);
 #else
 #define swiotlb_force SWIOTLB_NO_FORCE
 static inline bool is_swiotlb_buffer(phys_addr_t paddr)
@@ -108,6 +112,10 @@ static inline bool is_swiotlb_active(void)
 {
 	return false;
 }
+
+static inline void swiotlb_adjust_size(unsigned long new_size)
+{
+}
 #endif /* CONFIG_SWIOTLB */
 
 extern void swiotlb_print_info(void);
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index f99b79d7e1235..4c35ad1577e8d 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -151,8 +151,6 @@ void swiotlb_set_max_segment(unsigned int val)
 		max_segment = rounddown(val, PAGE_SIZE);
 }
 
-/* default to 64MB */
-#define IO_TLB_DEFAULT_SIZE (64UL<<20)
 unsigned long swiotlb_size_or_default(void)
 {
 	unsigned long size;
@@ -162,6 +160,24 @@ unsigned long swiotlb_size_or_default(void)
 	return size ? size : (IO_TLB_DEFAULT_SIZE);
 }
 
+void __init swiotlb_adjust_size(unsigned long new_size)
+{
+	unsigned long size;
+
+	/*
+	 * If swiotlb parameter has not been specified, give a chance to
+	 * architectures such as those supporting memory encryption to
+	 * adjust/expand SWIOTLB size for their use.
+	 */
+	if (!io_tlb_nslabs) {
+		size = ALIGN(new_size, 1 << IO_TLB_SHIFT);
+		io_tlb_nslabs = size >> IO_TLB_SHIFT;
+		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+
+		pr_info("SWIOTLB bounce buffer size adjusted to %luMB", size >> 20);
+	}
+}
+
 void swiotlb_print_info(void)
 {
 	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
-- 
2.27.0

