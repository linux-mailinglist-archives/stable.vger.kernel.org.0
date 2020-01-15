Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4881F13C7E5
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgAOPeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:34:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728901AbgAOPeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:34:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TYAnQyu/bI6K6LxS75nDjuKGtOjO85u0Sck2RqAmJ7o=;
        b=RjiANO3Efqnlsm2XIdF/BKh6KYFILAYkh8ksDEg4VV1f1j9wBXnOfNz4sCm2cgsprsYOK9
        0hyLCYqNf1yuG/ct9nYhZzTFzIkc7B91tHvgp+pLyLfV41mpeOQnFWw6biyNYHKwfSUYSk
        b9kJfk6m1iHJEhL454+EOf2oQign4uI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-nP63yr5WMrKWuteqxjFLlA-1; Wed, 15 Jan 2020 10:34:41 -0500
X-MC-Unique: nP63yr5WMrKWuteqxjFLlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73126109AAFF;
        Wed, 15 Jan 2020 15:34:39 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47BEF8886D;
        Wed, 15 Jan 2020 15:34:37 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable 20/25] mm/memory_hotplug: remove "zone" parameter from sparse_remove_one_section
Date:   Wed, 15 Jan 2020 16:33:34 +0100
Message-Id: <20200115153339.36409-21-david@redhat.com>
In-Reply-To: <20200115153339.36409-1-david@redhat.com>
References: <20200115153339.36409-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b9bf8d342d9b443c0d19aa57883d8ddb38d965de upstream.

The parameter is unused, so let's drop it.  Memory removal paths should
never care about zones.  This is the job of memory offlining and will
require more refactorings.

Link: http://lkml.kernel.org/r/20190527111152.16324-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Andrew Banman <andrew.banman@hpe.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chintan Pandya <cpandya@codeaurora.org>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jun Yao <yaojun8558363@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "mike.travis@hpe.com" <mike.travis@hpe.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/memory_hotplug.h | 2 +-
 mm/memory_hotplug.c            | 2 +-
 mm/sparse.c                    | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplu=
g.h
index 5ac58325e8fc..26bda048f8a7 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -335,7 +335,7 @@ extern int offline_pages(unsigned long start_pfn, uns=
igned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern int sparse_add_one_section(int nid, unsigned long start_pfn,
 				  struct vmem_altmap *altmap);
-extern void sparse_remove_one_section(struct zone *zone, struct mem_sect=
ion *ms,
+extern void sparse_remove_one_section(struct mem_section *ms,
 		unsigned long map_offset, struct vmem_altmap *altmap);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7a1c9fbf9f41..74cfa2fbe88e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -485,7 +485,7 @@ static void __remove_section(struct zone *zone, struc=
t mem_section *ms,
 	start_pfn =3D section_nr_to_pfn((unsigned long)scn_nr);
 	__remove_zone(zone, start_pfn);
=20
-	sparse_remove_one_section(zone, ms, map_offset, altmap);
+	sparse_remove_one_section(ms, map_offset, altmap);
 }
=20
 /**
diff --git a/mm/sparse.c b/mm/sparse.c
index 6f624ce9252e..3b24ba903d9e 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -757,8 +757,8 @@ static void free_section_usemap(struct page *memmap, =
unsigned long *usemap,
 		free_map_bootmem(memmap);
 }
=20
-void sparse_remove_one_section(struct zone *zone, struct mem_section *ms=
,
-		unsigned long map_offset, struct vmem_altmap *altmap)
+void sparse_remove_one_section(struct mem_section *ms, unsigned long map=
_offset,
+			       struct vmem_altmap *altmap)
 {
 	struct page *memmap =3D NULL;
 	unsigned long *usemap =3D NULL;
--=20
2.24.1

