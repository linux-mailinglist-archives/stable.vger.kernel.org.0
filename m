Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1993F2AA8A6
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 01:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgKHA5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 19:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727871AbgKHA5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Nov 2020 19:57:07 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2AB720885;
        Sun,  8 Nov 2020 00:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797026;
        bh=HeapIco4EdLY4C1foQ2CVSOcm1YEarIgsG+WzlLX3MM=;
        h=Date:From:To:Subject:From;
        b=eDQDnwblHmuJC5dpDpEeEOdZ7zTe5AC8XRIKkTduqxFvLLkrRzpZSKMlP0Am+SZJK
         owMhUTWz9fkOLQBlLoLTJFM0yQY2zb2ODfRqldg7lO2zQpBIiZOTI6/tw9iLsxGUXv
         Z+lsAYmIuB2bCzmO2RQu67WWU76m/73zDN6YP1gE=
Date:   Sat, 07 Nov 2020 16:57:06 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, stefan@agner.ch
Subject:  +
 mm-zsmalloc-include-sparsememh-for-max_physmem_bits.patch added to -mm tree
Message-ID: <20201108005706.TCYIGo7sg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: include sparsemem.h for MAX_PHYSMEM_BITS
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-include-sparsememh-for-max_physmem_bits.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-include-sparsememh-for-max_physmem_bits.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-include-sparsememh-for-max_physmem_bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stefan Agner <stefan@agner.ch>
Subject: mm/zsmalloc: include sparsemem.h for MAX_PHYSMEM_BITS

Most architectures define MAX_PHYSMEM_BITS in asm/sparsemem.h and don't
include it in asm/pgtable.h.  Include asm/sparsemem.h directly to get the
MAX_PHYSMEM_BITS define on all architectures.

This fixes a crash when accessing zram on 32-bit ARM platform with LPAE and
more than 4GB of memory:
  Unable to handle kernel NULL pointer dereference at virtual address 00000000
  pgd = a27bd01c
  [00000000] *pgd=236a0003, *pmd=1ffa64003
  Internal error: Oops: 207 [#1] SMP ARM
  Modules linked in: mdio_bcm_unimac(+) brcmfmac cfg80211 brcmutil raspberrypi_hwmon hci_uart crc32_arm_ce bcm2711_thermal phy_generic genet
  CPU: 0 PID: 123 Comm: mkfs.ext4 Not tainted 5.9.6 #1
  Hardware name: BCM2711
  PC is at zs_map_object+0x94/0x338
  LR is at zram_bvec_rw.constprop.0+0x330/0xa64
  pc : [<c0602b38>]    lr : [<c0bda6a0>]    psr: 60000013
  sp : e376bbe0  ip : 00000000  fp : c1e2921c
  r10: 00000002  r9 : c1dda730  r8 : 00000000
  r7 : e8ff7a00  r6 : 00000000  r5 : 02f9ffa0  r4 : e3710000
  r3 : 000fdffe  r2 : c1e0ce80  r1 : ebf979a0  r0 : 00000000
  Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
  Control: 30c5383d  Table: 235c2a80  DAC: fffffffd
  Process mkfs.ext4 (pid: 123, stack limit = 0x495a22e6)
  Stack: (0xe376bbe0 to 0xe376c000)
  ...
  [<c0602b38>] (zs_map_object) from [<c0bda6a0>] (zram_bvec_rw.constprop.0+0x330/0xa64)
  [<c0bda6a0>] (zram_bvec_rw.constprop.0) from [<c0bdaf78>] (zram_submit_bio+0x1a4/0x40c)
  [<c0bdaf78>] (zram_submit_bio) from [<c085806c>] (submit_bio_noacct+0xd0/0x3c8)
  [<c085806c>] (submit_bio_noacct) from [<c08583b0>] (submit_bio+0x4c/0x190)
  [<c08583b0>] (submit_bio) from [<c06496b4>] (submit_bh_wbc+0x188/0x1b8)
  [<c06496b4>] (submit_bh_wbc) from [<c064ce98>] (__block_write_full_page+0x340/0x5e4)
  [<c064ce98>] (__block_write_full_page) from [<c064d3ec>] (block_write_full_page+0x128/0x170)
  [<c064d3ec>] (block_write_full_page) from [<c0591ae8>] (__writepage+0x14/0x68)
  [<c0591ae8>] (__writepage) from [<c0593efc>] (write_cache_pages+0x1bc/0x494)
  [<c0593efc>] (write_cache_pages) from [<c059422c>] (generic_writepages+0x58/0x8c)
  [<c059422c>] (generic_writepages) from [<c0594c24>] (do_writepages+0x48/0xec)
  [<c0594c24>] (do_writepages) from [<c0589330>] (__filemap_fdatawrite_range+0xf0/0x128)
  [<c0589330>] (__filemap_fdatawrite_range) from [<c05894bc>] (file_write_and_wait_range+0x48/0x98)
  [<c05894bc>] (file_write_and_wait_range) from [<c064f3f8>] (blkdev_fsync+0x1c/0x44)
  [<c064f3f8>] (blkdev_fsync) from [<c064408c>] (do_fsync+0x3c/0x70)
  [<c064408c>] (do_fsync) from [<c0400374>] (__sys_trace_return+0x0/0x2c)
  Exception stack(0xe376bfa8 to 0xe376bff0)
  bfa0:                   0003d2e0 b6f7b6f0 00000003 00046e40 00001000 00000000
  bfc0: 0003d2e0 b6f7b6f0 00000000 00000076 00000000 00000000 befcbb20 befcbb28
  bfe0: b6f4e060 befcbad8 b6f23e0c b6dc4a80
  Code: e5927000 e0050391 e0871005 e5918018 (e5983000)

Link: https://lkml.kernel.org/r/bdfa44bf1c570b05d6c70898e2bbb0acf234ecdf.1604762181.git.stefan@agner.ch
Fixes: 61989a80fb3a ("staging: zsmalloc: zsmalloc memory allocation library")
Signed-off-by: Stefan Agner <stefan@agner.ch>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-include-sparsememh-for-max_physmem_bits
+++ a/mm/zsmalloc.c
@@ -40,6 +40,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/pgtable.h>
+#include <asm/sparsemem.h>
 #include <asm/tlbflush.h>
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
_

Patches currently in -mm which might be from stefan@agner.ch are

mm-zsmalloc-include-sparsememh-for-max_physmem_bits.patch

