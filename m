Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C951411395
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 13:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhITLeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 07:34:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237039AbhITLeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 07:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632137562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cGRqZSBWeWmElZO5ctChgOjYsMPsk81AMTjXRXFXY3M=;
        b=KyKLnkjfsj9/3dGBMwJT396qUkcS8i/WnxJA7NVVPad8QO4A7brzqoPeW0p3rFrfw3FJRb
        cHspVGcnpYJe2+ThWg8a28DSq3Djdlow2UOLCgQEUklRMaGRyPUbshB5tvgWh084Kiv0BP
        LMULxljSYATowSZ+mlD4lEe2RaQPSsc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-BkH3sNKTOraod2n23DbRuQ-1; Mon, 20 Sep 2021 07:32:41 -0400
X-MC-Unique: BkH3sNKTOraod2n23DbRuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A434DF8A3;
        Mon, 20 Sep 2021 11:32:40 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2065F19724;
        Mon, 20 Sep 2021 11:32:25 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        gregkh@linuxfoundation.org, David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pankaj.gupta@ionos.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 4.19 STABLE] mm/memory_hotplug: use "unsigned long" for PFN in zone_for_pfn_range()
Date:   Mon, 20 Sep 2021 13:32:24 +0200
Message-Id: <20210920113224.7478-1-david@redhat.com>
In-Reply-To: <163179697124554@kroah.com>
References: <163179697124554@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 7cf209ba8a86410939a24cb1aeb279479a7e0ca6 upstream.

Patch series "mm/memory_hotplug: preparatory patches for new online policy and memory"

These are all cleanups and one fix previously sent as part of [1]:
[PATCH v1 00/12] mm/memory_hotplug: "auto-movable" online policy and memory
groups.

These patches make sense even without the other series, therefore I pulled
them out to make the other series easier to digest.

[1] https://lkml.kernel.org/r/20210607195430.48228-1-david@redhat.com

This patch (of 4):

Checkpatch complained on a follow-up patch that we are using "unsigned"
here, which defaults to "unsigned int" and checkpatch is correct.

As we will search for a fitting zone using the wrong pfn, we might end
up onlining memory to one of the special kernel zones, such as ZONE_DMA,
which can end badly as the onlined memory does not satisfy properties of
these zones.

Use "unsigned long" instead, just as we do in other places when handling
PFNs.  This can bite us once we have physical addresses in the range of
multiple TB.

Link: https://lkml.kernel.org/r/20210712124052.26491-2-david@redhat.com
Fixes: e5e689302633 ("mm, memory_hotplug: display allowed zones in the preferred ordering")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: virtualization@lists.linux-foundation.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pierre Morel <pmorel@linux.ibm.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/memory_hotplug.h | 4 ++--
 mm/memory_hotplug.c            | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index d17d45c41a0b..565317876822 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -344,6 +344,6 @@ extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
 extern bool allow_online_pfn_range(int nid, unsigned long pfn, unsigned long nr_pages,
 		int online_type);
-extern struct zone *zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
-		unsigned long nr_pages);
+extern struct zone *zone_for_pfn_range(int online_type, int nid,
+		unsigned long start_pfn, unsigned long nr_pages);
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e60e28131f67..20f079c81b33 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -783,8 +783,8 @@ static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn
 	return movable_node_enabled ? movable_zone : kernel_zone;
 }
 
-struct zone * zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
-		unsigned long nr_pages)
+struct zone *zone_for_pfn_range(int online_type, int nid,
+		unsigned long start_pfn, unsigned long nr_pages)
 {
 	if (online_type == MMOP_ONLINE_KERNEL)
 		return default_kernel_zone_for_pfn(nid, start_pfn, nr_pages);
-- 
2.31.1

