Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146ED66ACAE
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 17:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjANQqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 11:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjANQqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 11:46:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F0A65BB
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:46:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA5E6B80917
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 16:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F65C433EF;
        Sat, 14 Jan 2023 16:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673714758;
        bh=WUGrWj0HWovC3nr/EXEQyeQekMgN6R5fEFInYFKJjjE=;
        h=Subject:To:Cc:From:Date:From;
        b=BbExwkyF+GjCVo8eIniVzUuA9GQ6wkZPLCI/oJdkwfMn5IbVZ9WV94fhYeuBm8MFn
         VAEQzqGV0UOIULcXgAQ0WNuSWaA1pbSDrItktS+IumioUvEVt7I1eX/RN88Js7dptt
         PlilbXc8so/GF+LemGfDhH1dS65dvbPAmx697s58=
Subject: FAILED: patch "[PATCH] mm: Always release pages to the buddy allocator in" failed to apply to 5.15-stable tree
To:     dev@aaront.org, rppt@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 17:45:53 +0100
Message-ID: <1673714753254212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

115d9d77bb0f ("mm: Always release pages to the buddy allocator in memblock_free_late().")
16802e55dea9 ("memblock tests: Add skeleton of the memblock simulator")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 115d9d77bb0f9152c60b6e8646369fa7f6167593 Mon Sep 17 00:00:00 2001
From: Aaron Thompson <dev@aaront.org>
Date: Fri, 6 Jan 2023 22:22:44 +0000
Subject: [PATCH] mm: Always release pages to the buddy allocator in
 memblock_free_late().

If CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, memblock_free_pages()
only releases pages to the buddy allocator if they are not in the
deferred range. This is correct for free pages (as defined by
for_each_free_mem_pfn_range_in_zone()) because free pages in the
deferred range will be initialized and released as part of the deferred
init process. memblock_free_pages() is called by memblock_free_late(),
which is used to free reserved ranges after memblock_free_all() has
run. All pages in reserved ranges have been initialized at that point,
and accordingly, those pages are not touched by the deferred init
process. This means that currently, if the pages that
memblock_free_late() intends to release are in the deferred range, they
will never be released to the buddy allocator. They will forever be
reserved.

In addition, memblock_free_pages() calls kmsan_memblock_free_pages(),
which is also correct for free pages but is not correct for reserved
pages. KMSAN metadata for reserved pages is initialized by
kmsan_init_shadow(), which runs shortly before memblock_free_all().

For both of these reasons, memblock_free_pages() should only be called
for free pages, and memblock_free_late() should call __free_pages_core()
directly instead.

One case where this issue can occur in the wild is EFI boot on
x86_64. The x86 EFI code reserves all EFI boot services memory ranges
via memblock_reserve() and frees them later via memblock_free_late()
(efi_reserve_boot_services() and efi_free_boot_services(),
respectively). If any of those ranges happens to fall within the
deferred init range, the pages will not be released and that memory will
be unavailable.

For example, on an Amazon EC2 t3.micro VM (1 GB) booting via EFI:

v6.2-rc2:
  # grep -E 'Node|spanned|present|managed' /proc/zoneinfo
  Node 0, zone      DMA
          spanned  4095
          present  3999
          managed  3840
  Node 0, zone    DMA32
          spanned  246652
          present  245868
          managed  178867

v6.2-rc2 + patch:
  # grep -E 'Node|spanned|present|managed' /proc/zoneinfo
  Node 0, zone      DMA
          spanned  4095
          present  3999
          managed  3840
  Node 0, zone    DMA32
          spanned  246652
          present  245868
          managed  222816   # +43,949 pages

Fixes: 3a80a7fa7989 ("mm: meminit: initialise a subset of struct pages if CONFIG_DEFERRED_STRUCT_PAGE_INIT is set")
Signed-off-by: Aaron Thompson <dev@aaront.org>
Link: https://lore.kernel.org/r/01010185892de53e-e379acfb-7044-4b24-b30a-e2657c1ba989-000000@us-west-2.amazonses.com
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>

diff --git a/mm/memblock.c b/mm/memblock.c
index d036c7861310..685e30e6d27c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1640,7 +1640,13 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 	end = PFN_DOWN(base + size);
 
 	for (; cursor < end; cursor++) {
-		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
+		/*
+		 * Reserved pages are always initialized by the end of
+		 * memblock_free_all() (by memmap_init() and, if deferred
+		 * initialization is enabled, memmap_init_reserved_pages()), so
+		 * these pages can be released directly to the buddy allocator.
+		 */
+		__free_pages_core(pfn_to_page(cursor), 0);
 		totalram_pages_inc();
 	}
 }
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index fdb7f5db7308..85973e55489e 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -15,6 +15,10 @@ bool mirrored_kernelcore = false;
 
 struct page {};
 
+void __free_pages_core(struct page *page, unsigned int order)
+{
+}
+
 void memblock_free_pages(struct page *page, unsigned long pfn,
 			 unsigned int order)
 {

