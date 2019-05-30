Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8207F2F6FA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 07:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732736AbfE3FAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 01:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727569AbfE3DJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:29 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 309E52447C;
        Thu, 30 May 2019 03:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185768;
        bh=7RcEOH/HE3JXRnzDunkFCAZCXEfpzCP3ZZnCtC8r6qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aL6PhUti42dh5gm4Ia7Lt8NHzIrnCkAlW2xsxV3heEsfb4eBoeOz2RdYRjvPUVaiG
         xsn1+oleFtw6c73FhrVlzTqaTRCjZf6OvwRbtW5CsR7qGLF6JDFJ2BUQV8mb/xD7DQ
         dT2cBXFXDn4816IVozG7Rk43RTdJGpHLl3UNIv40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>,
        Kees Cook <keescook@chromium.org>, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Jeff Smits <jeff.smits@intel.com>
Subject: [PATCH 5.1 018/405] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
Date:   Wed, 29 May 2019 20:00:16 -0700
Message-Id: <20190530030541.480359183@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 52f476a323f9efc959be1c890d0cdcf12e1582e0 upstream.

Jeff discovered that performance improves from ~375K iops to ~519K iops
on a simple psync-write fio workload when moving the location of 'struct
page' from the default PMEM location to DRAM. This result is surprising
because the expectation is that 'struct page' for dax is only needed for
third party references to dax mappings. For example, a dax-mapped buffer
passed to another system call for direct-I/O requires 'struct page' for
sending the request down the driver stack and pinning the page. There is
no usage of 'struct page' for first party access to a file via
read(2)/write(2) and friends.

However, this "no page needed" expectation is violated by
CONFIG_HARDENED_USERCOPY and the check_copy_size() performed in
copy_from_iter_full_nocache() and copy_to_iter_mcsafe(). The
check_heap_object() helper routine assumes the buffer is backed by a
slab allocator (DRAM) page and applies some checks.  Those checks are
invalid, dax pages do not originate from the slab, and redundant,
dax_iomap_actor() has already validated that the I/O is within bounds.
Specifically that routine validates that the logical file offset is
within bounds of the file, then it does a sector-to-pfn translation
which validates that the physical mapping is within bounds of the block
device.

Bypass additional hardened usercopy overhead and call the 'no check'
versions of the copy_{to,from}_iter operations directly.

Fixes: 0aed55af8834 ("x86, uaccess: introduce copy_from_iter_flushcache...")
Cc: <stable@vger.kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Reported-and-tested-by: Jeff Smits <jeff.smits@intel.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvdimm/pmem.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -281,16 +281,22 @@ static long pmem_dax_direct_access(struc
 	return __pmem_direct_access(pmem, pgoff, nr_pages, kaddr, pfn);
 }
 
+/*
+ * Use the 'no check' versions of copy_from_iter_flushcache() and
+ * copy_to_iter_mcsafe() to bypass HARDENED_USERCOPY overhead. Bounds
+ * checking, both file offset and device offset, is handled by
+ * dax_iomap_actor()
+ */
 static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	return copy_from_iter_flushcache(addr, bytes, i);
+	return _copy_from_iter_flushcache(addr, bytes, i);
 }
 
 static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	return copy_to_iter_mcsafe(addr, bytes, i);
+	return _copy_to_iter_mcsafe(addr, bytes, i);
 }
 
 static const struct dax_operations pmem_dax_ops = {


