Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00812CE5E6
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 03:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgLDCof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 21:44:35 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:41575 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726112AbgLDCof (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 21:44:35 -0500
X-UUID: 47ccc151455948f492b256b182df520b-20201204
X-UUID: 47ccc151455948f492b256b182df520b-20201204
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1007854576; Fri, 04 Dec 2020 10:43:50 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 4 Dec 2020 10:43:48 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Dec 2020 10:43:50 +0800
From:   Miles Chen <miles.chen@mediatek.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>, Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Song Bao Hua <song.bao.hua@hisilicon.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3] proc: use untagged_addr() for pagemap_read addresses
Date:   Fri, 4 Dec 2020 10:43:47 +0800
Message-ID: <20201204024347.8295-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we try to visit the pagemap of a tagged userspace pointer, we find
that the start_vaddr is not correct because of the tag.
To fix it, we should untag the userspace pointers in pagemap_read().

I tested with 5.10-rc4 and the issue remains.

Explanation from Catalin in [1]:

:Arguably, that's a user-space bug since tagged file offsets were never
:supported. In this case it's not even a tag at bit 56 as per the arm64
:tagged address ABI but rather down to bit 47. You could say that the
:problem is caused by the C library (malloc()) or whoever created the
:tagged vaddr and passed it to this function. It's not a kernel
:regression as we've never supported it.
:
:Now, pagemap is a special case where the offset is usually not generated
:as a classic file offset but rather derived by shifting a user virtual
:address. I guess we can make a concession for pagemap (only) and allow
:such offset with the tag at bit (56 - PAGE_SHIFT + 3).

My test code is based on [2]:

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

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Song Bao Hua (Barry Song) <song.bao.hua@hisilicon.com>
Cc: stable@vger.kernel.org # v5.4-
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

---

Change since v1:

1. Follow Eirc's and Catalin's suggestion to avoid overflow
2. Cc to stable v5.4-
3. add explaination from Catalin to the commit message

Change since v2:
1. replace less-than with less-than or equal
2. Fix bad spelling in commit message
3. Fix will's email address
---
 fs/proc/task_mmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 217aa2705d5d..ee5a235b3056 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1599,11 +1599,15 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 
 	src = *ppos;
 	svpfn = src / PM_ENTRY_BYTES;
-	start_vaddr = svpfn << PAGE_SHIFT;
 	end_vaddr = mm->task_size;
 
 	/* watch out for wraparound */
-	if (svpfn > mm->task_size >> PAGE_SHIFT)
+	start_vaddr = end_vaddr;
+	if (svpfn <= (ULONG_MAX >> PAGE_SHIFT))
+		start_vaddr = untagged_addr(svpfn << PAGE_SHIFT);
+
+	/* Ensure the address is inside the task */
+	if (start_vaddr > mm->task_size)
 		start_vaddr = end_vaddr;
 
 	/*
-- 
2.18.0

