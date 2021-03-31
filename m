Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE3034F7FD
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 06:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhCaEac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 00:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhCaEaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Mar 2021 00:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D71B2619CD;
        Wed, 31 Mar 2021 04:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617165005;
        bh=/AElenvj5HWiyG3SBC7lc/lWWKbW5TXNW67XdZlTDd0=;
        h=Date:From:To:Subject:From;
        b=q33Nrd005Z5MmctxQJOEL4nvWdWhmXyMfxhXTQfJ7ngwf+kt0iUTYMcA2Bdg6Tp3M
         BiFH4d9RigGRwGxtAbtWpLOrWLBftG8LGv1WWjr9G9I310ZD/waFhCDES7px1We9iM
         ndnwbXB4g7Uxk2rXS+h8ohLIWg6iyylZUmyL3Sp4=
Date:   Tue, 30 Mar 2021 21:30:04 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, green.hu@gmail.com,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        rppt@linux.ibm.com, stable@vger.kernel.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  +
 =?US-ASCII?Q?nds32-flush=5Fdcache=5Fpage-use-page=5Fmapping=5Ffile-to-av?=
 =?US-ASCII?Q?oid-races-with-swapoff.patch?= added to -mm tree
Message-ID: <20210331043004._EbFtvb3s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff
has been added to the -mm tree.  Its filename is
     nds32-flush_dcache_page-use-page_mapping_file-to-avoid-races-with-swapoff.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nds32-flush_dcache_page-use-page_mapping_file-to-avoid-races-with-swapoff.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nds32-flush_dcache_page-use-page_mapping_file-to-avoid-races-with-swapoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff

Commit cb9f753a3731 ("mm: fix races between swapoff and flush dcache")
updated flush_dcache_page implementations on several architectures to use
page_mapping_file() in order to avoid races between page_mapping() and
swapoff().

This update missed arch/nds32 and there is a possibility of a race there.

Replace page_mapping() with page_mapping_file() in nds32 implementation of
flush_dcache_page().

Link: https://lkml.kernel.org/r/20210330175126.26500-1-rppt@kernel.org
Fixes: cb9f753a3731 ("mm: fix races between swapoff and flush dcache")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/mm/cacheflush.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/nds32/mm/cacheflush.c~nds32-flush_dcache_page-use-page_mapping_file-to-avoid-races-with-swapoff
+++ a/arch/nds32/mm/cacheflush.c
@@ -238,7 +238,7 @@ void flush_dcache_page(struct page *page
 {
 	struct address_space *mapping;
 
-	mapping = page_mapping(page);
+	mapping = page_mapping_file(page);
 	if (mapping && !mapping_mapped(mapping))
 		set_bit(PG_dcache_dirty, &page->flags);
 	else {
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

nds32-flush_dcache_page-use-page_mapping_file-to-avoid-races-with-swapoff.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

