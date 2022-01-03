Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B36B48330E
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiACOdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:33:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60558 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiACObC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:31:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BEB761128;
        Mon,  3 Jan 2022 14:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F38C36AEB;
        Mon,  3 Jan 2022 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220261;
        bh=AjmbD1bZlf3o6NhTp1B8VVix/zedRV+zIB9KjzeHeHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNciToyvXNWmGH+rQb/tDwofUAuLdE+q+bBpwDNzUAB49A7sY4GkExHa1dx9bAPGF
         sxIYpN4/C+ZUgkUf3RcEgcWKipgM2D3mOeI8+8zMeGACK+8x/vKQLFWX8sws2cYttA
         UW/I08JSN7/wAXOH4DC3uQRtYZZ64TKwkWlJ1B5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15 14/73] efi: Move efifb_setup_from_dmi() prototype from arch headers
Date:   Mon,  3 Jan 2022 15:23:35 +0100
Message-Id: <20220103142057.380585410@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

commit 4bc5e64e6cf37007e436970024e5998ee0935651 upstream.

Commit 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup
for all arches") made the Generic System Framebuffers (sysfb) driver able
to be built on non-x86 architectures.

But it left the efifb_setup_from_dmi() function prototype declaration in
the architecture specific headers. This could lead to the following
compiler warning as reported by the kernel test robot:

   drivers/firmware/efi/sysfb_efi.c:70:6: warning: no previous prototype for function 'efifb_setup_from_dmi' [-Wmissing-prototypes]
   void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
        ^
   drivers/firmware/efi/sysfb_efi.c:70:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void efifb_setup_from_dmi(struct screen_info *si, const char *opt)

Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
Reported-by: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20211126001333.555514-1-javierm@redhat.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/efi.h   |    1 -
 arch/arm64/include/asm/efi.h |    1 -
 arch/riscv/include/asm/efi.h |    1 -
 arch/x86/include/asm/efi.h   |    2 --
 include/linux/efi.h          |    6 ++++++
 5 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -17,7 +17,6 @@
 
 #ifdef CONFIG_EFI
 void efi_init(void);
-extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -14,7 +14,6 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
-extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
 #else
 #define efi_init()
 #endif
--- a/arch/riscv/include/asm/efi.h
+++ b/arch/riscv/include/asm/efi.h
@@ -13,7 +13,6 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
-extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
 #else
 #define efi_init()
 #endif
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -197,8 +197,6 @@ static inline bool efi_runtime_supported
 
 extern void parse_efi_setup(u64 phys_addr, u32 data_len);
 
-extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
-
 extern void efi_thunk_runtime_setup(void);
 efi_status_t efi_set_virtual_address_map(unsigned long memory_map_size,
 					 unsigned long descriptor_size,
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1282,4 +1282,10 @@ static inline struct efi_mokvar_table_en
 }
 #endif
 
+#ifdef CONFIG_SYSFB
+extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
+#else
+static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt) { }
+#endif
+
 #endif /* _LINUX_EFI_H */


