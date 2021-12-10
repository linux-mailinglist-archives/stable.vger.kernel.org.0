Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9277A470007
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbhLJLi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:38:29 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53776 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237724AbhLJLi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 06:38:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6B216CE2A8B
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16711C00446;
        Fri, 10 Dec 2021 11:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639136091;
        bh=POcTeIaV67HxkNFECOKwlMkjUrHlgz3wa54zZP/cQpc=;
        h=Subject:To:Cc:From:Date:From;
        b=n5jIw6kUZ+vu69SKnORs304Rex/ynZSV82kh07AZfX8X9WbK05TEqeVvR5mPnN8U3
         Hb0RkHDIxN1vEOK4YHHWQMk/R374CppDrPRCypRknuIHlvwpk6dfAmCrWQmRTFok7N
         zo4PAvH4S9m4nW2D2Cu3i9AgwkOoKEQGvpa8++d0=
Subject: FAILED: patch "[PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted" failed to apply to 5.4-stable tree
To:     thomas.lendacky@amd.com, ardb@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 12:34:38 +0100
Message-ID: <1639136078520@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ff2fc02862d52e18fd3daabcfe840ec27e920a8 Mon Sep 17 00:00:00 2001
From: Tom Lendacky <thomas.lendacky@amd.com>
Date: Wed, 20 Oct 2021 13:02:11 -0500
Subject: [PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted

Reserving memory using efi_mem_reserve() calls into the x86
efi_arch_mem_reserve() function. This function will insert a new EFI
memory descriptor into the EFI memory map representing the area of
memory to be reserved and marking it as EFI runtime memory. As part
of adding this new entry, a new EFI memory map is allocated and mapped.
The mapping is where a problem can occur. This new memory map is mapped
using early_memremap() and generally mapped encrypted, unless the new
memory for the mapping happens to come from an area of memory that is
marked as EFI_BOOT_SERVICES_DATA memory. In this case, the new memory will
be mapped unencrypted. However, during replacement of the old memory map,
efi_mem_type() is disabled, so the new memory map will now be long-term
mapped encrypted (in efi.memmap), resulting in the map containing invalid
data and causing the kernel boot to crash.

Since it is known that the area will be mapped encrypted going forward,
explicitly map the new memory map as encrypted using early_memremap_prot().

Cc: <stable@vger.kernel.org> # 4.14.x
Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
Link: https://lore.kernel.org/all/ebf1eb2940405438a09d51d121ec0d02c8755558.1634752931.git.thomas.lendacky@amd.com/
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ardb: incorporate Kconfig fix by Arnd]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 95dd1ee01546..9636a3122496 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1932,6 +1932,7 @@ config EFI
 	depends on ACPI
 	select UCS2_STRING
 	select EFI_RUNTIME_WRAPPERS
+	select ARCH_USE_MEMREMAP_PROT
 	help
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index b15ebfe40a73..b0b848d6933a 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -277,7 +277,8 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 		return;
 	}
 
-	new = early_memremap(data.phys_map, data.size);
+	new = early_memremap_prot(data.phys_map, data.size,
+				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
 	if (!new) {
 		pr_err("Failed to map new boot services memmap\n");
 		return;

