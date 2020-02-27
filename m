Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D574171E22
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389063AbgB0OZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387461AbgB0OLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:11:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0174B20578;
        Thu, 27 Feb 2020 14:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812671;
        bh=mvXX6h+kds8LV+p+JhJq3T4Jlw4AlEPL8NKmekeMBgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBXIE3RjpqrFufJJmqJFLzVE+wV9bm6zo9KoZl3wL4M6ZHjYrnSCik4IKi80SjC/f
         4NVN9nx/R3iLVkuvy4jWIpHOAxKQRuzPk+UZ+ZVddokZk3+73lSK7y0v51hjq6bmOe
         S58dHRQKHSKukeODnKSifsdt8Yviy7edEVPvRMs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Weimer <fweimer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Victor Stinner <vstinner@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.4 069/135] mm: Avoid creating virtual address aliases in brk()/mmap()/mremap()
Date:   Thu, 27 Feb 2020 14:36:49 +0100
Message-Id: <20200227132239.672430340@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit dcde237319e626d1ec3c9d8b7613032f0fd4663a upstream.

Currently the arm64 kernel ignores the top address byte passed to brk(),
mmap() and mremap(). When the user is not aware of the 56-bit address
limit or relies on the kernel to return an error, untagging such
pointers has the potential to create address aliases in user-space.
Passing a tagged address to munmap(), madvise() is permitted since the
tagged pointer is expected to be inside an existing mapping.

The current behaviour breaks the existing glibc malloc() implementation
which relies on brk() with an address beyond 56-bit to be rejected by
the kernel.

Remove untagging in the above functions by partially reverting commit
ce18d171cb73 ("mm: untag user pointers in mmap/munmap/mremap/brk"). In
addition, update the arm64 tagged-address-abi.rst document accordingly.

Link: https://bugzilla.redhat.com/1797052
Fixes: ce18d171cb73 ("mm: untag user pointers in mmap/munmap/mremap/brk")
Cc: <stable@vger.kernel.org> # 5.4.x-
Cc: Florian Weimer <fweimer@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Victor Stinner <vstinner@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/arm64/tagged-address-abi.rst |   11 +++++++++--
 mm/mmap.c                                  |    4 ----
 mm/mremap.c                                |    1 -
 3 files changed, 9 insertions(+), 7 deletions(-)

--- a/Documentation/arm64/tagged-address-abi.rst
+++ b/Documentation/arm64/tagged-address-abi.rst
@@ -44,8 +44,15 @@ The AArch64 Tagged Address ABI has two s
 how the user addresses are used by the kernel:
 
 1. User addresses not accessed by the kernel but used for address space
-   management (e.g. ``mmap()``, ``mprotect()``, ``madvise()``). The use
-   of valid tagged pointers in this context is always allowed.
+   management (e.g. ``mprotect()``, ``madvise()``). The use of valid
+   tagged pointers in this context is allowed with the exception of
+   ``brk()``, ``mmap()`` and the ``new_address`` argument to
+   ``mremap()`` as these have the potential to alias with existing
+   user addresses.
+
+   NOTE: This behaviour changed in v5.6 and so some earlier kernels may
+   incorrectly accept valid tagged pointers for the ``brk()``,
+   ``mmap()`` and ``mremap()`` system calls.
 
 2. User addresses accessed by the kernel (e.g. ``write()``). This ABI
    relaxation is disabled by default and the application thread needs to
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -195,8 +195,6 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	bool downgraded = false;
 	LIST_HEAD(uf);
 
-	brk = untagged_addr(brk);
-
 	if (down_write_killable(&mm->mmap_sem))
 		return -EINTR;
 
@@ -1583,8 +1581,6 @@ unsigned long ksys_mmap_pgoff(unsigned l
 	struct file *file = NULL;
 	unsigned long retval;
 
-	addr = untagged_addr(addr);
-
 	if (!(flags & MAP_ANONYMOUS)) {
 		audit_mmap_fd(fd, flags);
 		file = fget(fd);
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -607,7 +607,6 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	LIST_HEAD(uf_unmap);
 
 	addr = untagged_addr(addr);
-	new_addr = untagged_addr(new_addr);
 
 	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
 		return ret;


