Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C194724D8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbhLMJjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbhLMJhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:37:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E08C08E6E1;
        Mon, 13 Dec 2021 01:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD9DCB80E1A;
        Mon, 13 Dec 2021 09:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2EFC00446;
        Mon, 13 Dec 2021 09:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388202;
        bh=Bm5z76mNBslksp4fAACD1H87pWu4bKZSW6uZ3F/hUok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ioan09f9WJ0hecNnOe1BI+KbhH8oHke4Fp+fUpFLCHu70TqEqpeGkLYIE9LAA8mfz
         nPZ4fBQ7StGzXLOjzzNoPsGrywITWaAOYV33i2aVOPCAdNTJgDAKe6S3eJITSuaBla
         Udehk0m8mgV9DfpVsGsV1VdPxA2UedVSyLCxIKTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.14 21/53] x86/sme: Explicitly map new EFI memmap table as encrypted
Date:   Mon, 13 Dec 2021 10:30:00 +0100
Message-Id: <20211213092929.068298312@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
References: <20211213092928.349556070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 1ff2fc02862d52e18fd3daabcfe840ec27e920a8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig               |    1 +
 arch/x86/platform/efi/quirks.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1903,6 +1903,7 @@ config EFI
 	depends on ACPI
 	select UCS2_STRING
 	select EFI_RUNTIME_WRAPPERS
+	select ARCH_USE_MEMREMAP_PROT
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -276,7 +276,8 @@ void __init efi_arch_mem_reserve(phys_ad
 		return;
 	}
 
-	new = early_memremap(new_phys, new_size);
+	new = early_memremap_prot(new_phys, new_size,
+				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
 	if (!new) {
 		pr_err("Failed to map new boot services memmap\n");
 		return;


