Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1590D3D6253
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhGZPfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237945AbhGZPez (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCC8B6056B;
        Mon, 26 Jul 2021 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316123;
        bh=7fiAPE6ikF3fpaa06HyQurZAeK3WK4HpofjvgsCGEnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYIE3q2jlaUHjCuaSxcYpVNBlPudVSoFqlHf7iD3F8BcFDwhQc85EnqJ5/v232Div
         WVfT5Hbykc0NO0jMtA+3ogVyHSBwePOf7Ega6XZy3C0ysrMcAcrBMv52bTibJOTmzI
         gHjl3EDl/7RKevzimsGrT8XGAPUR0WgFPkORhVVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ira Weiny <ira.weiny@intel.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 198/223] mm: call flush_dcache_page() in memcpy_to_page() and memzero_page()
Date:   Mon, 26 Jul 2021 17:39:50 +0200
Message-Id: <20210726153852.672438821@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 8dad53a11f8d94dceb540a5f8f153484f42be84b upstream.

memcpy_to_page and memzero_page can write to arbitrary pages, which
could be in the page cache or in high memory, so call
flush_kernel_dcache_pages to flush the dcache.

This is a problem when using these helpers on dcache challeneged
architectures.  Right now there are just a few users, chances are no one
used the PC floppy driver, the aha1542 driver for an ISA SCSI HBA, and a
few advanced and optional btrfs and ext4 features on those platforms yet
since the conversion.

Link: https://lkml.kernel.org/r/20210713055231.137602-2-hch@lst.de
Fixes: bb90d4bc7b6a ("mm/highmem: Lift memcpy_[to|from]_page to core")
Fixes: 28961998f858 ("iov_iter: lift memzero_page() to highmem.h")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/highmem.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -329,6 +329,7 @@ static inline void memcpy_to_page(struct
 
 	VM_BUG_ON(offset + len > PAGE_SIZE);
 	memcpy(to + offset, from, len);
+	flush_dcache_page(page);
 	kunmap_local(to);
 }
 
@@ -336,6 +337,7 @@ static inline void memzero_page(struct p
 {
 	char *addr = kmap_atomic(page);
 	memset(addr + offset, 0, len);
+	flush_dcache_page(page);
 	kunmap_atomic(addr);
 }
 


