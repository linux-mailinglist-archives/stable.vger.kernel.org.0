Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B0017FD7A
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgCJN1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbgCJMzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:55:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 794192253D;
        Tue, 10 Mar 2020 12:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844913;
        bh=khnnaXEotQCDVtCSFvYA545nYovW0yzZNDRL37GEq3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4c7gZI7EYoTumsbsqKin6y0uDL3tnZVDnmRWdqwhVT1zYs8bihXXHFHy9dChwyQ0
         GCcidswKfTVDVa9VwN7R5wKqFrkSJPu4vfOin6haF+qXECZ3Oo1pLoBvbrG5upYi3x
         N5YYTClawZfGxHyx/E+Z1a62LTxaoP9p9fDauOyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 166/168] efi/x86: Align GUIDs to their size in the mixed mode runtime wrapper
Date:   Tue, 10 Mar 2020 13:40:12 +0100
Message-Id: <20200310123652.363028853@linuxfoundation.org>
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

commit 63056e8b5ebf41d52170e9f5ba1fc83d1855278c upstream.

Hans reports that his mixed mode systems running v5.6-rc1 kernels hit
the WARN_ON() in virt_to_phys_or_null_size(), caused by the fact that
efi_guid_t objects on the vmap'ed stack happen to be misaligned with
respect to their sizes. As a quick (i.e., backportable) fix, copy GUID
pointer arguments to the local stack into a buffer that is naturally
aligned to its size, so that it is guaranteed to cover only one
physical page.

Note that on x86, we cannot rely on the stack pointer being aligned
the way the compiler expects, so we need to allocate an 8-byte aligned
buffer of sufficient size, and copy the GUID into that buffer at an
offset that is aligned to 16 bytes.

Fixes: f6697df36bdf0bf7 ("x86/efi: Prevent mixed mode boot corruption with CONFIG_VMAP_STACK=y")
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Cc: linux-efi@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200221084849.26878-2-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi_64.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -791,6 +791,8 @@ static efi_status_t
 efi_thunk_get_variable(efi_char16_t *name, efi_guid_t *vendor,
 		       u32 *attr, unsigned long *data_size, void *data)
 {
+	u8 buf[24] __aligned(8);
+	efi_guid_t *vnd = PTR_ALIGN((efi_guid_t *)buf, sizeof(*vnd));
 	efi_status_t status;
 	u32 phys_name, phys_vendor, phys_attr;
 	u32 phys_data_size, phys_data;
@@ -798,8 +800,10 @@ efi_thunk_get_variable(efi_char16_t *nam
 
 	spin_lock_irqsave(&efi_runtime_lock, flags);
 
+	*vnd = *vendor;
+
 	phys_data_size = virt_to_phys_or_null(data_size);
-	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_name = virt_to_phys_or_null_size(name, efi_name_size(name));
 	phys_attr = virt_to_phys_or_null(attr);
 	phys_data = virt_to_phys_or_null_size(data, *data_size);
@@ -816,14 +820,18 @@ static efi_status_t
 efi_thunk_set_variable(efi_char16_t *name, efi_guid_t *vendor,
 		       u32 attr, unsigned long data_size, void *data)
 {
+	u8 buf[24] __aligned(8);
+	efi_guid_t *vnd = PTR_ALIGN((efi_guid_t *)buf, sizeof(*vnd));
 	u32 phys_name, phys_vendor, phys_data;
 	efi_status_t status;
 	unsigned long flags;
 
 	spin_lock_irqsave(&efi_runtime_lock, flags);
 
+	*vnd = *vendor;
+
 	phys_name = virt_to_phys_or_null_size(name, efi_name_size(name));
-	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_data = virt_to_phys_or_null_size(data, data_size);
 
 	/* If data_size is > sizeof(u32) we've got problems */
@@ -840,6 +848,8 @@ efi_thunk_set_variable_nonblocking(efi_c
 				   u32 attr, unsigned long data_size,
 				   void *data)
 {
+	u8 buf[24] __aligned(8);
+	efi_guid_t *vnd = PTR_ALIGN((efi_guid_t *)buf, sizeof(*vnd));
 	u32 phys_name, phys_vendor, phys_data;
 	efi_status_t status;
 	unsigned long flags;
@@ -847,8 +857,10 @@ efi_thunk_set_variable_nonblocking(efi_c
 	if (!spin_trylock_irqsave(&efi_runtime_lock, flags))
 		return EFI_NOT_READY;
 
+	*vnd = *vendor;
+
 	phys_name = virt_to_phys_or_null_size(name, efi_name_size(name));
-	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_data = virt_to_phys_or_null_size(data, data_size);
 
 	/* If data_size is > sizeof(u32) we've got problems */
@@ -865,14 +877,18 @@ efi_thunk_get_next_variable(unsigned lon
 			    efi_char16_t *name,
 			    efi_guid_t *vendor)
 {
+	u8 buf[24] __aligned(8);
+	efi_guid_t *vnd = PTR_ALIGN((efi_guid_t *)buf, sizeof(*vnd));
 	efi_status_t status;
 	u32 phys_name_size, phys_name, phys_vendor;
 	unsigned long flags;
 
 	spin_lock_irqsave(&efi_runtime_lock, flags);
 
+	*vnd = *vendor;
+
 	phys_name_size = virt_to_phys_or_null(name_size);
-	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_name = virt_to_phys_or_null_size(name, *name_size);
 
 	status = efi_thunk(get_next_variable, phys_name_size,
@@ -880,6 +896,7 @@ efi_thunk_get_next_variable(unsigned lon
 
 	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 
+	*vendor = *vnd;
 	return status;
 }
 


