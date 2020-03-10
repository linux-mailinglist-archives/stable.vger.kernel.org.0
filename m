Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3EE317F5E0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCJLNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:13:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34899 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbgCJLNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 07:13:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 87C6C21EAD;
        Tue, 10 Mar 2020 07:13:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 07:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TTds81
        A1Hc0ifkfymhZ+LgN9OIKu5lG5POCcej80P8U=; b=paAnph/IDyEWm0mupVU5Zb
        kKe1YA1ghoRK44WtGMfUUEkqV8Q3G++AahNVVJUQsrJMInNKmkWRHl6juJeC33lw
        WrqKsQJMd5wZPK7la/+KTvNsoO2Is5BhygTmXrJmWRyzvxjAiaYGeRfYvbBd0b0I
        eLVBXC3mUWSgRjYh30PGTen5lucLYx/hirAK6a7iD9tq8JknFYi5VB+n/tRfcfyz
        hypM4lkRKzasHHwpMkbSJq1uUkGLDVZ++Zfobc5lJxJrnr9UGrRdntl94v6OsATk
        tHMwnvA+PQ2CnVK1K/38KZfMgBCU2B6zWF/M+diIXMHrEVNGIZUWZQyACl71KOFQ
        ==
X-ME-Sender: <xms:bXZnXsUp1DspNxmbIuoAEV5elxx3B6mA42VQIpAiCPgpx7J6B16Rig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:bXZnXk28nQ9lH4VVjg_Cfx_yRKHhbREz4rhg57WfmNVLWbpLpNeLAA>
    <xmx:bXZnXrZH_XufXhVP_qiV3CGDSjuGEzZQ0XjsQLTj0vL7Vhu2QlZkTg>
    <xmx:bXZnXvoVDFjs4giUGwLcFYCoO7elzluEupxsd4ZhI0yzty1iZ0ULmw>
    <xmx:bXZnXjF6JjpRHbgw_r1X8rClyxjgXN93Ei7vlj_3Q5NDLADm2HxjJQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AA0D30611FB;
        Tue, 10 Mar 2020 07:13:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] efi/x86: Handle by-ref arguments covering multiple pages in" failed to apply to 4.14-stable tree
To:     ardb@kernel.org, mingo@kernel.org, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 12:13:39 +0100
Message-ID: <158383881912217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8319e9d5ad98ffccd19f35664382c73cea216193 Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 21 Feb 2020 09:48:48 +0100
Subject: [PATCH] efi/x86: Handle by-ref arguments covering multiple pages in
 mixed mode

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

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ae398587f264..d19a2edd63cb 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -180,7 +180,7 @@ void efi_sync_low_kernel_mappings(void)
 static inline phys_addr_t
 virt_to_phys_or_null_size(void *va, unsigned long size)
 {
-	bool bad_size;
+	phys_addr_t pa;
 
 	if (!va)
 		return 0;
@@ -188,16 +188,13 @@ virt_to_phys_or_null_size(void *va, unsigned long size)
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
@@ -615,8 +612,11 @@ efi_thunk_get_variable(efi_char16_t *name, efi_guid_t *vendor,
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
 
@@ -641,9 +641,11 @@ efi_thunk_set_variable(efi_char16_t *name, efi_guid_t *vendor,
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
 
@@ -670,9 +672,11 @@ efi_thunk_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
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
 
@@ -698,8 +702,11 @@ efi_thunk_get_next_variable(unsigned long *name_size,
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
 

