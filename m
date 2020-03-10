Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4018017F947
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgCJMzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729474AbgCJMzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:55:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B573524696;
        Tue, 10 Mar 2020 12:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844917;
        bh=C8JapEoOUIN4r0cBd+3vAgQBPCVeIqxcY2yj8qwgDYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClVphpS4Hu9w3jgpBIpV7CrMjBUH3Ep5N5h6n9pR4MWAw7OEOb0uPu/2lSY7MyJP3
         UV7NCAxWV/UJdMZAc+iaAmmWt+nFy+AYENdcTmjqoCbVVkMIsBRydcmHEf/khryxc+
         tPjoZTIt/oHw4RGcLFnKh236EsVj8QoGLJnnYOGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 167/168] efi/x86: Handle by-ref arguments covering multiple pages in mixed mode
Date:   Tue, 10 Mar 2020 13:40:13 +0100
Message-Id: <20200310123652.457155565@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 8319e9d5ad98ffccd19f35664382c73cea216193 upstream.

The mixed mode runtime wrappers are fragile when it comes to how the
memory referred to by its pointer arguments are laid out in memory, due
to the fact that it translates these addresses to physical addresses that
the runtime services can dereference when running in 1:1 mode. Since
vmalloc'ed pages (including the vmap'ed stack) are not contiguous in the
physical address space, this scheme only works if the referenced memory
objects do not cross page boundaries.

Currently, the mixed mode runtime service wrappers require that all by-ref
arguments that live in the vmalloc space have a size that is a power of 2,
and are aligned to that same value. While this is a sensible way to
construct an object that is guaranteed not to cross a page boundary, it is
overly strict when it comes to checking whether a given object violates
this requirement, as we can simply take the physical address of the first
and the last byte, and verify that they point into the same physical page.

When this check fails, we emit a WARN(), but then simply proceed with the
call, which could cause data corruption if the next physical page belongs
to a mapping that is entirely unrelated.

Given that with vmap'ed stacks, this condition is much more likely to
trigger, let's relax the condition a bit, but fail the runtime service
call if it does trigger.

Fixes: f6697df36bdf0bf7 ("x86/efi: Prevent mixed mode boot corruption with CONFIG_VMAP_STACK=y")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200221084849.26878-4-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi_64.c |   45 +++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -316,7 +316,7 @@ void efi_sync_low_kernel_mappings(void)
 static inline phys_addr_t
 virt_to_phys_or_null_size(void *va, unsigned long size)
 {
-	bool bad_size;
+	phys_addr_t pa;
 
 	if (!va)
 		return 0;
@@ -324,16 +324,13 @@ virt_to_phys_or_null_size(void *va, unsi
 	if (virt_addr_valid(va))
 		return virt_to_phys(va);
 
-	/*
-	 * A fully aligned variable on the stack is guaranteed not to
-	 * cross a page bounary. Try to catch strings on the stack by
-	 * checking that 'size' is a power of two.
-	 */
-	bad_size = size > PAGE_SIZE || !is_power_of_2(size);
+	pa = slow_virt_to_phys(va);
 
-	WARN_ON(!IS_ALIGNED((unsigned long)va, size) || bad_size);
+	/* check if the object crosses a page boundary */
+	if (WARN_ON((pa ^ (pa + size - 1)) & PAGE_MASK))
+		return 0;
 
-	return slow_virt_to_phys(va);
+	return pa;
 }
 
 #define virt_to_phys_or_null(addr)				\
@@ -808,8 +805,11 @@ efi_thunk_get_variable(efi_char16_t *nam
 	phys_attr = virt_to_phys_or_null(attr);
 	phys_data = virt_to_phys_or_null_size(data, *data_size);
 
-	status = efi_thunk(get_variable, phys_name, phys_vendor,
-			   phys_attr, phys_data_size, phys_data);
+	if (!phys_name || (data && !phys_data))
+		status = EFI_INVALID_PARAMETER;
+	else
+		status = efi_thunk(get_variable, phys_name, phys_vendor,
+				   phys_attr, phys_data_size, phys_data);
 
 	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 
@@ -834,9 +834,11 @@ efi_thunk_set_variable(efi_char16_t *nam
 	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_data = virt_to_phys_or_null_size(data, data_size);
 
-	/* If data_size is > sizeof(u32) we've got problems */
-	status = efi_thunk(set_variable, phys_name, phys_vendor,
-			   attr, data_size, phys_data);
+	if (!phys_name || !phys_data)
+		status = EFI_INVALID_PARAMETER;
+	else
+		status = efi_thunk(set_variable, phys_name, phys_vendor,
+				   attr, data_size, phys_data);
 
 	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 
@@ -863,9 +865,11 @@ efi_thunk_set_variable_nonblocking(efi_c
 	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_data = virt_to_phys_or_null_size(data, data_size);
 
-	/* If data_size is > sizeof(u32) we've got problems */
-	status = efi_thunk(set_variable, phys_name, phys_vendor,
-			   attr, data_size, phys_data);
+	if (!phys_name || !phys_data)
+		status = EFI_INVALID_PARAMETER;
+	else
+		status = efi_thunk(set_variable, phys_name, phys_vendor,
+				   attr, data_size, phys_data);
 
 	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 
@@ -891,8 +895,11 @@ efi_thunk_get_next_variable(unsigned lon
 	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_name = virt_to_phys_or_null_size(name, *name_size);
 
-	status = efi_thunk(get_next_variable, phys_name_size,
-			   phys_name, phys_vendor);
+	if (!phys_name)
+		status = EFI_INVALID_PARAMETER;
+	else
+		status = efi_thunk(get_next_variable, phys_name_size,
+				   phys_name, phys_vendor);
 
 	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 


