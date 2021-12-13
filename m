Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C724725BC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhLMJpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:45:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57380 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbhLMJnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:43:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B3E3B80E20;
        Mon, 13 Dec 2021 09:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EA3C341C5;
        Mon, 13 Dec 2021 09:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388627;
        bh=FY+XlnPHRlg32z0VyYXPCdb3ZLZmZGvpT8lykHEp5bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCwOJqfc6sCREE+xfBEBMSwj6jZHc5vWNMqIVLafm1WRZd9xqGj9j5l1pBeGx6dXT
         uhU/opLablRom8TFNetptjsbF9gHoOR108v8wIv5TpLIoK6hjeSSbR1nr22pe3TQ8N
         qLHEbpz//rpDEI0uaSvjlpHsWH0x9/KrnBIbf+4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.4 41/88] x86/sme: Explicitly map new EFI memmap table as encrypted
Date:   Mon, 13 Dec 2021 10:30:11 +0100
Message-Id: <20211213092934.668536790@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
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
@@ -1990,6 +1990,7 @@ config EFI
 	depends on ACPI
 	select UCS2_STRING
 	select EFI_RUNTIME_WRAPPERS
+	select ARCH_USE_MEMREMAP_PROT
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -279,7 +279,8 @@ void __init efi_arch_mem_reserve(phys_ad
 		return;
 	}
 
-	new = early_memremap(new_phys, new_size);
+	new = early_memremap_prot(new_phys, new_size,
+				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
 	if (!new) {
 		pr_err("Failed to map new boot services memmap\n");
 		return;


