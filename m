Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB70472572
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbhLMJnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55294 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbhLMJlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:41:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E640B80E25;
        Mon, 13 Dec 2021 09:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A1AC341C5;
        Mon, 13 Dec 2021 09:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388483;
        bh=ddXm/PPl1VT4KCEIwqKuglOPNV3ShjJRMojXdYUtQCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2w6ctlqrJQfbE9prl56FWekCA7tKIt5AtFl/0Btn6OzK2hIB3stAGXxXzHM5skOo
         JecVeTBhrucEefCgpww0SQ0xxpqkzGXsgTMOCSU46HJzbkDN3T/95AhIlJgn/LaVwA
         oRZa3PRXBNrI3akdnxt1+BUBsd/KDjnV7afzRNyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.19 32/74] x86/sme: Explicitly map new EFI memmap table as encrypted
Date:   Mon, 13 Dec 2021 10:30:03 +0100
Message-Id: <20211213092931.891204334@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
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
@@ -1953,6 +1953,7 @@ config EFI
 	depends on ACPI
 	select UCS2_STRING
 	select EFI_RUNTIME_WRAPPERS
+	select ARCH_USE_MEMREMAP_PROT
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -278,7 +278,8 @@ void __init efi_arch_mem_reserve(phys_ad
 		return;
 	}
 
-	new = early_memremap(new_phys, new_size);
+	new = early_memremap_prot(new_phys, new_size,
+				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
 	if (!new) {
 		pr_err("Failed to map new boot services memmap\n");
 		return;


