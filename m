Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D642E3A4F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389284AbgL1NfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389232AbgL1Neo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:34:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC75C22583;
        Mon, 28 Dec 2020 13:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162443;
        bh=ckG7p101FaZzQCJzSoB5eM0PLkPmKyC6aILJ71zdxhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2xBrid4lNImowbTlt/YsZ0o2LBgudnN2SVZdklJqcZBWIGXTWjtiaPDZEQgkodl4
         usd00f2kgaVy4N+VaSwoysMaHNUX393zWVjlP0LUpPToCW5x6P3ZUydQzgtX30L4ey
         DetTAWDsxN3pXhJ9DmdAr5tgYV9iOER8ZjIqnglM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 4.19 305/346] powerpc/powernv/memtrace: Dont leak kernel memory to user space
Date:   Mon, 28 Dec 2020 13:50:24 +0100
Message-Id: <20201228124934.532018025@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit c74cf7a3d59a21b290fe0468f5b470d0b8ee37df upstream.

We currently leak kernel memory to user space, because memory
offlining doesn't do any implicit clearing of memory and we are
missing explicit clearing of memory.

Let's keep it simple and clear pages before removing the linear
mapping.

Reproduced in QEMU/TCG with 10 GiB of main memory:
  [root@localhost ~]# dd obs=9G if=/dev/urandom of=/dev/null
  [... wait until "free -m" used counter no longer changes and cancel]
  19665802+0 records in
  1+0 records out
  9663676416 bytes (9.7 GB, 9.0 GiB) copied, 135.548 s, 71.3 MB/s
  [root@localhost ~]# cat /sys/devices/system/memory/block_size_bytes
  40000000
  [root@localhost ~]# echo 0x40000000 > /sys/kernel/debug/powerpc/memtrace/enable
  [  402.978663][ T1086] page:000000001bc4bc74 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x24900
  [  402.980063][ T1086] flags: 0x7ffff000001000(reserved)
  [  402.980415][ T1086] raw: 007ffff000001000 c00c000000924008 c00c000000924008 0000000000000000
  [  402.980627][ T1086] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
  [  402.980845][ T1086] page dumped because: unmovable page
  [  402.989608][ T1086] Offlined Pages 16384
  [  403.324155][ T1086] memtrace: Allocated trace memory on node 0 at 0x0000000200000000

Before this patch:
  [root@localhost ~]# hexdump -C /sys/kernel/debug/powerpc/memtrace/00000000/trace  | head
  00000000  c8 25 72 51 4d 26 36 c5  5c c2 56 15 d5 1a cd 10  |.%rQM&6.\.V.....|
  00000010  19 b9 50 b2 cb e3 60 b8  ec 0a f3 ec 4b 3c 39 f0  |..P...`.....K<9.|$
  00000020  4e 5a 4c cf bd 26 19 ff  37 79 13 67 24 b7 b8 57  |NZL..&..7y.g$..W|$
  00000030  98 3e f5 be 6f 14 6a bd  a4 52 bc 6e e9 e0 c1 5d  |.>..o.j..R.n...]|$
  00000040  76 b3 ae b5 88 d7 da e3  64 23 85 2c 10 88 07 b6  |v.......d#.,....|$
  00000050  9a d8 91 de f7 50 27 69  2e 64 9c 6f d3 19 45 79  |.....P'i.d.o..Ey|$
  00000060  6a 6f 8a 61 71 19 1f c7  f1 df 28 26 ca 0f 84 55  |jo.aq.....(&...U|$
  00000070  01 3f be e4 e2 e1 da ff  7b 8c 8e 32 37 b4 24 53  |.?......{..27.$S|$
  00000080  1b 70 30 45 56 e6 8c c4  0e b5 4c fb 9f dd 88 06  |.p0EV.....L.....|$
  00000090  ef c4 18 79 f1 60 b1 5c  79 59 4d f4 36 d7 4a 5c  |...y.`.\yYM.6.J\|$

After this patch:
  [root@localhost ~]# hexdump -C /sys/kernel/debug/powerpc/memtrace/00000000/trace  | head
  00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
  *
  40000000

Fixes: 9d5171a8f248 ("powerpc/powernv: Enable removal of memory for in memory tracing")
Cc: stable@vger.kernel.org # v4.14+
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201111145322.15793-2-david@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/memtrace.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/arch/powerpc/platforms/powernv/memtrace.c
+++ b/arch/powerpc/platforms/powernv/memtrace.c
@@ -70,6 +70,23 @@ static int change_memblock_state(struct
 	return 0;
 }
 
+static void memtrace_clear_range(unsigned long start_pfn,
+				 unsigned long nr_pages)
+{
+	unsigned long pfn;
+
+	/*
+	 * As pages are offline, we cannot trust the memmap anymore. As HIGHMEM
+	 * does not apply, avoid passing around "struct page" and use
+	 * clear_page() instead directly.
+	 */
+	for (pfn = start_pfn; pfn < start_pfn + nr_pages; pfn++) {
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+		clear_page(__va(PFN_PHYS(pfn)));
+	}
+}
+
 /* called with device_hotplug_lock held */
 static bool memtrace_offline_pages(u32 nid, u64 start_pfn, u64 nr_pages)
 {
@@ -115,6 +132,11 @@ static u64 memtrace_alloc_node(u32 nid,
 	for (base_pfn = end_pfn; base_pfn > start_pfn; base_pfn -= nr_pages) {
 		if (memtrace_offline_pages(nid, base_pfn, nr_pages) == true) {
 			/*
+			 * Clear the range while we still have a linear
+			 * mapping.
+			 */
+			memtrace_clear_range(base_pfn, nr_pages);
+			/*
 			 * Remove memory in memory block size chunks so that
 			 * iomem resources are always split to the same size and
 			 * we never try to remove memory that spans two iomem


