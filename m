Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABC73D7E89
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 21:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhG0TfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 15:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230454AbhG0TfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 15:35:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9142560C51;
        Tue, 27 Jul 2021 19:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627414511;
        bh=WXnDVQG3wwxZ4wIfYQH+3oY1d6B8iBEuxe6YqnNC9NM=;
        h=Date:From:To:Subject:From;
        b=1xgZSMm2B1K8Hc3ylJ/tGrKwRTE1/KmdTZv49Yr3nPeCFSfRuToKq9PJWGJrir6jN
         ap6yWZSwxlBdmmioq4P3qd1jItDqSgn1hu73nifB5dA48Tz59CqfPXcyddfPrKUK5M
         YuySgyWzRhkQtUJuWI5pspfUw80ICdq0dAymNJNI=
Date:   Tue, 27 Jul 2021 12:35:11 -0700
From:   akpm@linux-foundation.org
To:     chaitanya.kulkarni@wdc.com, hch@lst.de, ira.weiny@intel.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 mm-call-flush_dcache_page-in-memcpy_to_page-and-memzero_page.patch removed
 from -mm tree
Message-ID: <20210727193511.lcvC7oH36%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: call flush_dcache_page() in memcpy_to_page() and memzero_page()
has been removed from the -mm tree.  Its filename was
     mm-call-flush_dcache_page-in-memcpy_to_page-and-memzero_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: call flush_dcache_page() in memcpy_to_page() and memzero_page()

memcpy_to_page and memzero_page can write to arbitrary pages, which could
be in the page cache or in high memory, so call flush_kernel_dcache_pages
to flush the dcache.

This is a problem when using these helpers on dcache challeneged
architectures.  Right now there are just a few users, chances are no
one used the PC floppy dr\u0456ver, the aha1542 driver for an ISA SCSI
HBA, and a few advanced and optional btrfs and ext4 features on those
platforms yet since the conversion.

Link: https://lkml.kernel.org/r/20210713055231.137602-2-hch@lst.de
Fixes: bb90d4bc7b6a ("mm/highmem: Lift memcpy_[to|from]_page to core")
Fixes: 28961998f858 ("iov_iter: lift memzero_page() to highmem.h")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/highmem.h~mm-call-flush_dcache_page-in-memcpy_to_page-and-memzero_page
+++ a/include/linux/highmem.h
@@ -318,6 +318,7 @@ static inline void memcpy_to_page(struct
 
 	VM_BUG_ON(offset + len > PAGE_SIZE);
 	memcpy(to + offset, from, len);
+	flush_dcache_page(page);
 	kunmap_local(to);
 }
 
@@ -325,6 +326,7 @@ static inline void memzero_page(struct p
 {
 	char *addr = kmap_atomic(page);
 	memset(addr + offset, 0, len);
+	flush_dcache_page(page);
 	kunmap_atomic(addr);
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

mmc-jz4740-remove-the-flush_kernel_dcache_page-call-in-jz4740_mmc_read_data.patch
mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
ps3disk-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
mm-remove-flush_kernel_dcache_page.patch

