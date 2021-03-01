Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C28328D85
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbhCATM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:12:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241140AbhCATIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:08:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83D1C65288;
        Mon,  1 Mar 2021 17:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619864;
        bh=9Zlh6iVRD7MSNIxj5N0hUbFyCNZiJpzx0EcrhIk+OFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRALueksmH5Ur9+vdLsF+tvChm5H5QOYtgPlw/5mjPrO3Eoe5f8e5WzOPmofDBDW0
         ooc72hQ6R1eGHInRDzRnxms36hnBg7v8GiO+woziTaf46BtIsVPTPlLRqbnsmzp2U9
         bTRtxueYlJm/+j8SvXeObEZbPSoFwBtfNug7rLKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 608/663] powerpc/kexec_file: fix FDT size estimation for kdump kernel
Date:   Mon,  1 Mar 2021 17:14:16 +0100
Message-Id: <20210301161211.925155666@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Bathini <hbathini@linux.ibm.com>

commit 2377c92e37fe97bc5b365f55cf60f56dfc4849f5 upstream.

On systems with large amount of memory, loading kdump kernel through
kexec_file_load syscall may fail with the below error:

    "Failed to update fdt with linux,drconf-usable-memory property"

This happens because the size estimation for kdump kernel's FDT does
not account for the additional space needed to setup usable memory
properties. Fix it by accounting for the space needed to include
linux,usable-memory & linux,drconf-usable-memory properties while
estimating kdump kernel's FDT size.

Fixes: 6ecd0163d360 ("powerpc/kexec_file: Add appropriate regions for memory reserve map")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/161243826811.119001.14083048209224609814.stgit@hbathini
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/kexec.h  |    1 +
 arch/powerpc/kexec/elf_64.c       |    2 +-
 arch/powerpc/kexec/file_load_64.c |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -136,6 +136,7 @@ int load_crashdump_segments_ppc64(struct
 int setup_purgatory_ppc64(struct kimage *image, const void *slave_code,
 			  const void *fdt, unsigned long kernel_load_addr,
 			  unsigned long fdt_load_addr);
+unsigned int kexec_fdt_totalsize_ppc64(struct kimage *image);
 int setup_new_fdt_ppc64(const struct kimage *image, void *fdt,
 			unsigned long initrd_load_addr,
 			unsigned long initrd_len, const char *cmdline);
--- a/arch/powerpc/kexec/elf_64.c
+++ b/arch/powerpc/kexec/elf_64.c
@@ -102,7 +102,7 @@ static void *elf64_load(struct kimage *i
 		pr_debug("Loaded initrd at 0x%lx\n", initrd_load_addr);
 	}
 
-	fdt_size = fdt_totalsize(initial_boot_params) * 2;
+	fdt_size = kexec_fdt_totalsize_ppc64(image);
 	fdt = kmalloc(fdt_size, GFP_KERNEL);
 	if (!fdt) {
 		pr_err("Not enough memory for the device tree.\n");
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -21,6 +21,7 @@
 #include <linux/memblock.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <asm/setup.h>
 #include <asm/drmem.h>
 #include <asm/kexec_ranges.h>
 #include <asm/crashdump-ppc64.h>
@@ -926,6 +927,40 @@ out:
 }
 
 /**
+ * kexec_fdt_totalsize_ppc64 - Return the estimated size needed to setup FDT
+ *                             for kexec/kdump kernel.
+ * @image:                     kexec image being loaded.
+ *
+ * Returns the estimated size needed for kexec/kdump kernel FDT.
+ */
+unsigned int kexec_fdt_totalsize_ppc64(struct kimage *image)
+{
+	unsigned int fdt_size;
+	u64 usm_entries;
+
+	/*
+	 * The below estimate more than accounts for a typical kexec case where
+	 * the additional space is to accommodate things like kexec cmdline,
+	 * chosen node with properties for initrd start & end addresses and
+	 * a property to indicate kexec boot..
+	 */
+	fdt_size = fdt_totalsize(initial_boot_params) + (2 * COMMAND_LINE_SIZE);
+	if (image->type != KEXEC_TYPE_CRASH)
+		return fdt_size;
+
+	/*
+	 * For kdump kernel, also account for linux,usable-memory and
+	 * linux,drconf-usable-memory properties. Get an approximate on the
+	 * number of usable memory entries and use for FDT size estimation.
+	 */
+	usm_entries = ((memblock_end_of_DRAM() / drmem_lmb_size()) +
+		       (2 * (resource_size(&crashk_res) / drmem_lmb_size())));
+	fdt_size += (unsigned int)(usm_entries * sizeof(u64));
+
+	return fdt_size;
+}
+
+/**
  * setup_new_fdt_ppc64 - Update the flattend device-tree of the kernel
  *                       being loaded.
  * @image:               kexec image being loaded.


