Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BB66353D6
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbiKWI76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbiKWI7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:59:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB8F1001E8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:59:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBEFACE20F4
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA77DC433C1;
        Wed, 23 Nov 2022 08:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193971;
        bh=8i57MT/Xtc1hRD3vu3TPc4r/ufo5LVy3VE3uQjoAz7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBXsuCrO0se+Lmh831XI5PPfeu7JSC1RIUrrqzIXt3yxYn5+oBFmqvC5/uihx5OCm
         m5K+8c4ylXhg1rNEAAKv0nGEPj/7WT508xcwgo9Me1FAi2gOjMpUWZgbYHWpUY7KvZ
         7V/bhnkJbPU5fmGnJIrEDZY2lIqWkIDXm5O0shG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.14 17/88] arm64: efi: Fix handling of misaligned runtime regions and drop warning
Date:   Wed, 23 Nov 2022 09:50:14 +0100
Message-Id: <20221123084549.106484813@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 9b9eaee9828fe98b030cf43ac50065a54a2f5d52 upstream.

Currently, when mapping the EFI runtime regions in the EFI page tables,
we complain about misaligned regions in a rather noisy way, using
WARN().

Not only does this produce a lot of irrelevant clutter in the log, it is
factually incorrect, as misaligned runtime regions are actually allowed
by the EFI spec as long as they don't require conflicting memory types
within the same 64k page.

So let's drop the warning, and tweak the code so that we
- take both the start and end of the region into account when checking
  for misalignment
- only revert to RWX mappings for non-code regions if misaligned code
  regions are also known to exist.

Cc: <stable@vger.kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/efi.c |   52 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 18 deletions(-)

--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -16,6 +16,14 @@
 
 #include <asm/efi.h>
 
+static bool region_is_misaligned(const efi_memory_desc_t *md)
+{
+	if (PAGE_SIZE == EFI_PAGE_SIZE)
+		return false;
+	return !PAGE_ALIGNED(md->phys_addr) ||
+	       !PAGE_ALIGNED(md->num_pages << EFI_PAGE_SHIFT);
+}
+
 /*
  * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
  * executable, everything else can be mapped with the XN bits
@@ -29,14 +37,22 @@ static __init pteval_t create_mapping_pr
 	if (type == EFI_MEMORY_MAPPED_IO)
 		return PROT_DEVICE_nGnRE;
 
-	if (WARN_ONCE(!PAGE_ALIGNED(md->phys_addr),
-		      "UEFI Runtime regions are not aligned to 64 KB -- buggy firmware?"))
+	if (region_is_misaligned(md)) {
+		static bool __initdata code_is_misaligned;
+
 		/*
-		 * If the region is not aligned to the page size of the OS, we
-		 * can not use strict permissions, since that would also affect
-		 * the mapping attributes of the adjacent regions.
+		 * Regions that are not aligned to the OS page size cannot be
+		 * mapped with strict permissions, as those might interfere
+		 * with the permissions that are needed by the adjacent
+		 * region's mapping. However, if we haven't encountered any
+		 * misaligned runtime code regions so far, we can safely use
+		 * non-executable permissions for non-code regions.
 		 */
-		return pgprot_val(PAGE_KERNEL_EXEC);
+		code_is_misaligned |= (type == EFI_RUNTIME_SERVICES_CODE);
+
+		return code_is_misaligned ? pgprot_val(PAGE_KERNEL_EXEC)
+					  : pgprot_val(PAGE_KERNEL);
+	}
 
 	/* R-- */
 	if ((attr & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==
@@ -64,19 +80,16 @@ int __init efi_create_mapping(struct mm_
 	bool page_mappings_only = (md->type == EFI_RUNTIME_SERVICES_CODE ||
 				   md->type == EFI_RUNTIME_SERVICES_DATA);
 
-	if (!PAGE_ALIGNED(md->phys_addr) ||
-	    !PAGE_ALIGNED(md->num_pages << EFI_PAGE_SHIFT)) {
-		/*
-		 * If the end address of this region is not aligned to page
-		 * size, the mapping is rounded up, and may end up sharing a
-		 * page frame with the next UEFI memory region. If we create
-		 * a block entry now, we may need to split it again when mapping
-		 * the next region, and support for that is going to be removed
-		 * from the MMU routines. So avoid block mappings altogether in
-		 * that case.
-		 */
+	/*
+	 * If this region is not aligned to the page size used by the OS, the
+	 * mapping will be rounded outwards, and may end up sharing a page
+	 * frame with an adjacent runtime memory region. Given that the page
+	 * table descriptor covering the shared page will be rewritten when the
+	 * adjacent region gets mapped, we must avoid block mappings here so we
+	 * don't have to worry about splitting them when that happens.
+	 */
+	if (region_is_misaligned(md))
 		page_mappings_only = true;
-	}
 
 	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
 			   md->num_pages << EFI_PAGE_SHIFT,
@@ -104,6 +117,9 @@ int __init efi_set_mapping_permissions(s
 	BUG_ON(md->type != EFI_RUNTIME_SERVICES_CODE &&
 	       md->type != EFI_RUNTIME_SERVICES_DATA);
 
+	if (region_is_misaligned(md))
+		return 0;
+
 	/*
 	 * Calling apply_to_page_range() is only safe on regions that are
 	 * guaranteed to be mapped down to pages. Since we are only called


