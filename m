Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2F8F7DBA
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbfKKS5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:57:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729045AbfKKS5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:57:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8C9C222C6;
        Mon, 11 Nov 2019 18:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498638;
        bh=UI+AqekYuxJUbnMoV9VAKZM7KIgsoqYZOvx6VnCCY7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmA5KasNPXFdHbR+ax9aftbkYPbu9TON7GW2UvnRNuX/8bWkE88e2R/0iScNx3aCf
         KjbWVXUBgQFRhZv0mX6AdGLi0AMbbVEUbMdNdIDdW1S18qTdoyshVmd9rPzqmaFL1S
         N467xmT9sAw+Vi9ZZcoocPBeao4Bv702FOCUhRV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kairui Song <kasong@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 177/193] x86, efi: Never relocate kernel below lowest acceptable address
Date:   Mon, 11 Nov 2019 19:29:19 +0100
Message-Id: <20191111181514.169892522@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kairui Song <kasong@redhat.com>

[ Upstream commit 220dd7699c46d5940115bd797b01b2ab047c87b8 ]

Currently, kernel fails to boot on some HyperV VMs when using EFI.
And it's a potential issue on all x86 platforms.

It's caused by broken kernel relocation on EFI systems, when below three
conditions are met:

1. Kernel image is not loaded to the default address (LOAD_PHYSICAL_ADDR)
   by the loader.
2. There isn't enough room to contain the kernel, starting from the
   default load address (eg. something else occupied part the region).
3. In the memmap provided by EFI firmware, there is a memory region
   starts below LOAD_PHYSICAL_ADDR, and suitable for containing the
   kernel.

EFI stub will perform a kernel relocation when condition 1 is met. But
due to condition 2, EFI stub can't relocate kernel to the preferred
address, so it fallback to ask EFI firmware to alloc lowest usable memory
region, got the low region mentioned in condition 3, and relocated
kernel there.

It's incorrect to relocate the kernel below LOAD_PHYSICAL_ADDR. This
is the lowest acceptable kernel relocation address.

The first thing goes wrong is in arch/x86/boot/compressed/head_64.S.
Kernel decompression will force use LOAD_PHYSICAL_ADDR as the output
address if kernel is located below it. Then the relocation before
decompression, which move kernel to the end of the decompression buffer,
will overwrite other memory region, as there is no enough memory there.

To fix it, just don't let EFI stub relocate the kernel to any address
lower than lowest acceptable address.

[ ardb: introduce efi_low_alloc_above() to reduce the scope of the change ]

Signed-off-by: Kairui Song <kasong@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: https://lkml.kernel.org/r/20191029173755.27149-6-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/eboot.c              |  4 +++-
 drivers/firmware/efi/libstub/arm32-stub.c     |  2 +-
 .../firmware/efi/libstub/efi-stub-helper.c    | 24 ++++++++-----------
 include/linux/efi.h                           | 18 ++++++++++++--
 4 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index d6662fdef3001..82bc60c8acb24 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -13,6 +13,7 @@
 #include <asm/e820/types.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
+#include <asm/boot.h>
 
 #include "../string.h"
 #include "eboot.h"
@@ -813,7 +814,8 @@ efi_main(struct efi_config *c, struct boot_params *boot_params)
 		status = efi_relocate_kernel(sys_table, &bzimage_addr,
 					     hdr->init_size, hdr->init_size,
 					     hdr->pref_address,
-					     hdr->kernel_alignment);
+					     hdr->kernel_alignment,
+					     LOAD_PHYSICAL_ADDR);
 		if (status != EFI_SUCCESS) {
 			efi_printk(sys_table, "efi_relocate_kernel() failed!\n");
 			goto fail;
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index ffa242ad0a82e..41213bf5fcf5e 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -230,7 +230,7 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 	*image_size = image->image_size;
 	status = efi_relocate_kernel(sys_table, image_addr, *image_size,
 				     *image_size,
-				     kernel_base + MAX_UNCOMP_KERNEL_SIZE, 0);
+				     kernel_base + MAX_UNCOMP_KERNEL_SIZE, 0, 0);
 	if (status != EFI_SUCCESS) {
 		pr_efi_err(sys_table, "Failed to relocate kernel.\n");
 		efi_free(sys_table, *reserve_size, *reserve_addr);
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 3caae7f2cf567..35dbc2791c973 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -260,11 +260,11 @@ fail:
 }
 
 /*
- * Allocate at the lowest possible address.
+ * Allocate at the lowest possible address that is not below 'min'.
  */
-efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
-			   unsigned long size, unsigned long align,
-			   unsigned long *addr)
+efi_status_t efi_low_alloc_above(efi_system_table_t *sys_table_arg,
+				 unsigned long size, unsigned long align,
+				 unsigned long *addr, unsigned long min)
 {
 	unsigned long map_size, desc_size, buff_size;
 	efi_memory_desc_t *map;
@@ -311,13 +311,8 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		start = desc->phys_addr;
 		end = start + desc->num_pages * EFI_PAGE_SIZE;
 
-		/*
-		 * Don't allocate at 0x0. It will confuse code that
-		 * checks pointers against NULL. Skip the first 8
-		 * bytes so we start at a nice even number.
-		 */
-		if (start == 0x0)
-			start += 8;
+		if (start < min)
+			start = min;
 
 		start = round_up(start, align);
 		if ((start + size) > end)
@@ -698,7 +693,8 @@ efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 				 unsigned long image_size,
 				 unsigned long alloc_size,
 				 unsigned long preferred_addr,
-				 unsigned long alignment)
+				 unsigned long alignment,
+				 unsigned long min_addr)
 {
 	unsigned long cur_image_addr;
 	unsigned long new_addr = 0;
@@ -731,8 +727,8 @@ efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 	 * possible.
 	 */
 	if (status != EFI_SUCCESS) {
-		status = efi_low_alloc(sys_table_arg, alloc_size, alignment,
-				       &new_addr);
+		status = efi_low_alloc_above(sys_table_arg, alloc_size,
+					     alignment, &new_addr, min_addr);
 	}
 	if (status != EFI_SUCCESS) {
 		pr_efi_err(sys_table_arg, "Failed to allocate usable memory for kernel.\n");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index f87fabea4a859..b3a93f8e6e596 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1585,9 +1585,22 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
 				struct efi_boot_memmap *map);
 
+efi_status_t efi_low_alloc_above(efi_system_table_t *sys_table_arg,
+				 unsigned long size, unsigned long align,
+				 unsigned long *addr, unsigned long min);
+
+static inline
 efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			   unsigned long size, unsigned long align,
-			   unsigned long *addr);
+			   unsigned long *addr)
+{
+	/*
+	 * Don't allocate at 0x0. It will confuse code that
+	 * checks pointers against NULL. Skip the first 8
+	 * bytes so we start at a nice even number.
+	 */
+	return efi_low_alloc_above(sys_table_arg, size, align, addr, 0x8);
+}
 
 efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			    unsigned long size, unsigned long align,
@@ -1598,7 +1611,8 @@ efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 				 unsigned long image_size,
 				 unsigned long alloc_size,
 				 unsigned long preferred_addr,
-				 unsigned long alignment);
+				 unsigned long alignment,
+				 unsigned long min_addr);
 
 efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 				  efi_loaded_image_t *image,
-- 
2.20.1



