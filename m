Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6CC3D431A
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 00:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhGWWJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 18:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233043AbhGWWJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 18:09:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9975B60EB5;
        Fri, 23 Jul 2021 22:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080617;
        bh=Ie8KW1gqKVigYgdWdvXa5xrDDnPZVyW4txtPpNygGLQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nhTvl0ebtSzDg/eYZOyngyAZCdsPonVl+DoSUxm8gqp3tQWRjmVI1r/3rfzHY1lGZ
         docantuwxdFgUvdmJUa3MmEGNJ8KdVDBbq+i0Tt9fHdtzQGwwEzI+C3vV61c5bUOUu
         F0mVURPP2k1zQXZLxvnDXCLmhkT9zSucOA2L/rNA=
Date:   Fri, 23 Jul 2021 15:50:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chaitanya.kulkarni@wdc.com, hch@lst.de,
        ira.weiny@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 06/15] mm: call flush_dcache_page() in
 memcpy_to_page() and memzero_page()
Message-ID: <20210723225017.xFO0jZesP%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
