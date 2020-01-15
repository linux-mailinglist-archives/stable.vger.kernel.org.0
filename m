Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5035813C7DA
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgAOPeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:34:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37413 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728912AbgAOPeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:34:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JDa/6MD2QZaRtp/DNJJPsnCvCCrAi5HUTK78bJMcAgs=;
        b=YWm9fHGHL4T9r8jVUPvM6IQYWLoiVzFn57+9DInmLIPbSjU+Lc2akdlBmOBFnpcgxlGaac
        /dsb4UfB+scM1fpaXXPOEz7AeuTDlSv7Jx70rbounVU1OTla45mPtwbq28D9M2B7iWXrDi
        vB2WkC9Vgxa+tmrWdLvDLO/bg9BJtwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-5j_0HzXPORifJSvzdSUNOg-1; Wed, 15 Jan 2020 10:34:13 -0500
X-MC-Unique: 5j_0HzXPORifJSvzdSUNOg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B51A8C4329;
        Wed, 15 Jan 2020 15:34:11 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A82B86CB2;
        Wed, 15 Jan 2020 15:34:09 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable 10/25] mm/memory_hotplug: make __remove_section() never fail
Date:   Wed, 15 Jan 2020 16:33:24 +0100
Message-Id: <20200115153339.36409-11-david@redhat.com>
In-Reply-To: <20200115153339.36409-1-david@redhat.com>
References: <20200115153339.36409-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9d1d887d785b4fe0590bd3c5e71acaa3908044e2 upstream.

Let's just warn in case a section is not valid instead of failing to
remove somewhere in the middle of the process, returning an error that
will be mostly ignored by callers.

Link: http://lkml.kernel.org/r/20190409100148.24703-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Andrew Banman <andrew.banman@hpe.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memory_hotplug.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 42c5bc371ffe..a9fcae50a33a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -478,15 +478,15 @@ static void __remove_zone(struct zone *zone, unsign=
ed long start_pfn)
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 }
=20
-static int __remove_section(struct zone *zone, struct mem_section *ms,
-		unsigned long map_offset, struct vmem_altmap *altmap)
+static void __remove_section(struct zone *zone, struct mem_section *ms,
+			     unsigned long map_offset,
+			     struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn;
 	int scn_nr;
-	int ret =3D -EINVAL;
=20
-	if (!valid_section(ms))
-		return ret;
+	if (WARN_ON_ONCE(!valid_section(ms)))
+		return;
=20
 	unregister_memory_section(ms);
=20
@@ -495,7 +495,6 @@ static int __remove_section(struct zone *zone, struct=
 mem_section *ms,
 	__remove_zone(zone, start_pfn);
=20
 	sparse_remove_one_section(zone, ms, map_offset, altmap);
-	return 0;
 }
=20
 /**
@@ -515,7 +514,7 @@ int __remove_pages(struct zone *zone, unsigned long p=
hys_start_pfn,
 {
 	unsigned long i;
 	unsigned long map_offset =3D 0;
-	int sections_to_remove, ret =3D 0;
+	int sections_to_remove;
=20
 	/* In the ZONE_DEVICE case device driver owns the memory region */
 	if (is_dev_zone(zone)) {
@@ -536,16 +535,13 @@ int __remove_pages(struct zone *zone, unsigned long=
 phys_start_pfn,
 		unsigned long pfn =3D phys_start_pfn + i*PAGES_PER_SECTION;
=20
 		cond_resched();
-		ret =3D __remove_section(zone, __pfn_to_section(pfn), map_offset,
-				altmap);
+		__remove_section(zone, __pfn_to_section(pfn), map_offset,
+				 altmap);
 		map_offset =3D 0;
-		if (ret)
-			break;
 	}
=20
 	set_zone_contiguous(zone);
-
-	return ret;
+	return 0;
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
=20
--=20
2.24.1

