Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB30F2CF988
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 06:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgLEFWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 00:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgLEFWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Dec 2020 00:22:43 -0500
Date:   Fri, 04 Dec 2020 21:21:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607145716;
        bh=mgHX+8Us9feriapGknz720sjPjEF7uSvI4qm0A1mLgI=;
        h=From:To:Subject:From;
        b=xQhbZ3VE9tPto2gZDvzBJDvYB5SdfFa7ZitWLl6UgAeuv61altZOWhFUuQRywCBQy
         8gG/L53TidJWmziWUbLq0hpBIcQ6JCaV5va1EhT7T0i8bu2JMGZk5zBk3+tlSvqkEj
         qZINKowC1lkfRCAPNx9kGG9moSSIxjTYxofCYNXg=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, andreyknvl@google.com,
        aryabinin@virtuozzo.com, catalin.marinas@arm.com,
        dvyukov@google.com, ebiederm@xmission.com, elver@google.com,
        glider@google.com, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com,
        stable@vger.kernel.org, vincenzo.frascino@arm.com, will@kernel.org
Subject:  [to-be-updated]
 proc-use-untagged_addr-for-pagemap_read-addresses.patch removed from -mm
 tree
Message-ID: <20201205052155.chIVRd2g0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: proc: use untagged_addr() for pagemap_read addresses
has been removed from the -mm tree.  Its filename was
     proc-use-untagged_addr-for-pagemap_read-addresses.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: proc: use untagged_addr() for pagemap_read addresses

When we try to visit the pagemap of a tagged userspace pointer, we find
that the start_vaddr is not correct because of the tag.  To fix it, we
should untag the usespace pointers in pagemap_read().

I tested with 5.10-rc4 and the issue remains.

Explanation from Catalin in [1]:

: Arguably, that's a user-space bug since tagged file offsets were never
: supported.  In this case it's not even a tag at bit 56 as per the arm64
: tagged address ABI but rather down to bit 47.  You could say that the
: problem is caused by the C library (malloc()) or whoever created the
: tagged vaddr and passed it to this function.  It's not a kernel regression
: as we've never supported it.
: 
: Now, pagemap is a special case where the offset is usually not generated
: as a classic file offset but rather derived by shifting a user virtual
: address.  I guess we can make a concession for pagemap (only) and allow
: such offset with the tag at bit (56 - PAGE_SHIFT + 3).

My test code is baed on [2]:

A userspace pointer which has been tagged by 0xb4: 0xb400007662f541c8

=== userspace program ===

uint64 OsLayer::VirtualToPhysical(void *vaddr) {
	uint64 frame, paddr, pfnmask, pagemask;
	int pagesize = sysconf(_SC_PAGESIZE);
	off64_t off = ((uintptr_t)vaddr) / pagesize * 8; // off = 0xb400007662f541c8 / pagesize * 8 = 0x5a00003b317aa0
	int fd = open(kPagemapPath, O_RDONLY);
	...

	if (lseek64(fd, off, SEEK_SET) != off || read(fd, &frame, 8) != 8) {
		int err = errno;
		string errtxt = ErrorString(err);
		if (fd >= 0)
			close(fd);
		return 0;
	}
...
}

=== kernel fs/proc/task_mmu.c ===

static ssize_t pagemap_read(struct file *file, char __user *buf,
		size_t count, loff_t *ppos)
{
	...
	src = *ppos;
	svpfn = src / PM_ENTRY_BYTES; // svpfn == 0xb400007662f54
	start_vaddr = svpfn << PAGE_SHIFT; // start_vaddr == 0xb400007662f54000
	end_vaddr = mm->task_size;

	/* watch out for wraparound */
	// svpfn == 0xb400007662f54
	// (mm->task_size >> PAGE) == 0x8000000
	if (svpfn > mm->task_size >> PAGE_SHIFT) // the condition is true because of the tag 0xb4
		start_vaddr = end_vaddr;

	ret = 0;
	while (count && (start_vaddr < end_vaddr)) { // we cannot visit correct entry because start_vaddr is set to end_vaddr
		int len;
		unsigned long end;
		...
	}
	...
}

[1] https://lore.kernel.org/patchwork/patch/1343258/
[2] https://github.com/stressapptest/stressapptest/blob/master/src/os.cc#L158

Link: https://lkml.kernel.org/r/20201127050738.14440-1-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Song Bao Hua (Barry Song) <song.bao.hua@hisilicon.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~proc-use-untagged_addr-for-pagemap_read-addresses
+++ a/fs/proc/task_mmu.c
@@ -1599,11 +1599,15 @@ static ssize_t pagemap_read(struct file
 
 	src = *ppos;
 	svpfn = src / PM_ENTRY_BYTES;
-	start_vaddr = svpfn << PAGE_SHIFT;
 	end_vaddr = mm->task_size;
 
 	/* watch out for wraparound */
-	if (svpfn > mm->task_size >> PAGE_SHIFT)
+	start_vaddr = end_vaddr;
+	if (svpfn < (ULONG_MAX >> PAGE_SHIFT))
+		start_vaddr = untagged_addr(svpfn << PAGE_SHIFT);
+
+	/* Ensure the address is inside the task */
+	if (start_vaddr > mm->task_size)
 		start_vaddr = end_vaddr;
 
 	/*
_

Patches currently in -mm which might be from miles.chen@mediatek.com are


