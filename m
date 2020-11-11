Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED892AF41C
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 15:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgKKOxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 09:53:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727236AbgKKOxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 09:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605106419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B8t8a4IKn/4UDggl6V593VlD1u/4N3i8dDQlBOovljE=;
        b=RvWF4jXbL1uuoHYNfWd0cfvoHntiLtuB9LtDNM9W/89Ahzn6RrjvR3cClXqUkLbyawk+sf
        pM2ODIFNPLNPjMXaR4Z7sb+zR866k/3mKJdp30fXQcnOJzTMRYzvHB7M5O+QxbeYiS66Z+
        rfl65iqcTrlcE/1PZlwx61MmaQUAl5A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-RyV7I3fYPbC0bpz0uPuaqA-1; Wed, 11 Nov 2020 09:53:35 -0500
X-MC-Unique: RyV7I3fYPbC0bpz0uPuaqA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AB7618CB735;
        Wed, 11 Nov 2020 14:53:33 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-151.ams2.redhat.com [10.36.114.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FAFE389;
        Wed, 11 Nov 2020 14:53:30 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        David Hildenbrand <david@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Rashmica Gupta <rashmica.g@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: [PATCH v2 1/8] powernv/memtrace: don't leak kernel memory to user space
Date:   Wed, 11 Nov 2020 15:53:15 +0100
Message-Id: <20201111145322.15793-2-david@redhat.com>
In-Reply-To: <20201111145322.15793-1-david@redhat.com>
References: <20201111145322.15793-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We currently leak kernel memory to user space, because memory offlining
doesn't do any implicit clearing of memory and we are missing explicit
clearing of memory.

Let's keep it simple and clear pages before removing the linear mapping.

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

Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Fixes: 9d5171a8f248 ("powerpc/powernv: Enable removal of memory for in memory tracing")
Cc: stable@vger.kernel.org # v4.14+
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rashmica Gupta <rashmica.g@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/platforms/powernv/memtrace.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/memtrace.c b/arch/powerpc/platforms/powernv/memtrace.c
index 6828108486f8..eea1f94482ff 100644
--- a/arch/powerpc/platforms/powernv/memtrace.c
+++ b/arch/powerpc/platforms/powernv/memtrace.c
@@ -67,6 +67,23 @@ static int change_memblock_state(struct memory_block *mem, void *arg)
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
@@ -111,6 +128,11 @@ static u64 memtrace_alloc_node(u32 nid, u64 size)
 	lock_device_hotplug();
 	for (base_pfn = end_pfn; base_pfn > start_pfn; base_pfn -= nr_pages) {
 		if (memtrace_offline_pages(nid, base_pfn, nr_pages) == true) {
+			/*
+			 * Clear the range while we still have a linear
+			 * mapping.
+			 */
+			memtrace_clear_range(base_pfn, nr_pages);
 			/*
 			 * Remove memory in memory block size chunks so that
 			 * iomem resources are always split to the same size and
-- 
2.26.2

