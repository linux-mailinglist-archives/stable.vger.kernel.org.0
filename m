Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C2B4409B
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbfFMQHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731300AbfFMIpZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:45:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DFE72147A;
        Thu, 13 Jun 2019 08:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415524;
        bh=m6ODw5BskUwFh1JO80IjSssuEvqA80Q7xvil16oRl/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpDom5CzAgOwBtcy7OrNZj/sVw0R8Wq+SVruhE3Q/nGYHcQ7ivNJ/2C2uRf5s04vV
         8i6k3SvxzTJrukyeBSmxiKCgfqZ8Bw3qRklTS50R/EqTeh93vfz+wLitfO+JzrAwk1
         8igk5009d3aEc9k8l1BoD7iqexTV2gOUUofDEnoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Wei Yang <richard.weiyang@gmail.com>, Qian Cai <cai@lca.pw>,
        Arun KS <arunks@codeaurora.org>,
        Mathieu Malaterre <malat@debian.org>,
        Andrew Banman <andrew.banman@hpe.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Borislav Petkov <bp@alien8.de>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Mike Travis <mike.travis@hpe.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oscar Salvador <osalvador@suse.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rich Felker <dalias@libc.org>, Rob Herring <robh@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 014/155] mm/memory_hotplug: release memory resource after arch_remove_memory()
Date:   Thu, 13 Jun 2019 10:32:06 +0200
Message-Id: <20190613075653.563139293@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d9eb1417c77df7ce19abd2e41619e9dceccbdf2a ]

Patch series "mm/memory_hotplug: Better error handling when removing
memory", v1.

Error handling when removing memory is somewhat messed up right now.  Some
errors result in warnings, others are completely ignored.  Memory unplug
code can essentially not deal with errors properly as of now.
remove_memory() will never fail.

We have basically two choices:
1. Allow arch_remov_memory() and friends to fail, propagating errors via
   remove_memory(). Might be problematic (e.g. DIMMs consisting of multiple
   pieces added/removed separately).
2. Don't allow the functions to fail, handling errors in a nicer way.

It seems like most errors that can theoretically happen are really corner
cases and mostly theoretical (e.g.  "section not valid").  However e.g.
aborting removal of sections while all callers simply continue in case of
errors is not nice.

If we can gurantee that removal of memory always works (and WARN/skip in
case of theoretical errors so we can figure out what is going on), we can
go ahead and implement better error handling when adding memory.

E.g. via add_memory():

arch_add_memory()
ret = do_stuff()
if (ret) {
	arch_remove_memory();
	goto error;
}

Handling here that arch_remove_memory() might fail is basically
impossible.  So I suggest, let's avoid reporting errors while removing
memory, warning on theoretical errors instead and continuing instead of
aborting.

This patch (of 4):

__add_pages() doesn't add the memory resource, so __remove_pages()
shouldn't remove it.  Let's factor it out.  Especially as it is a special
case for memory used as system memory, added via add_memory() and friends.

We now remove the resource after removing the sections instead of doing it
the other way around.  I don't think this change is problematic.

add_memory()
	register memory resource
	arch_add_memory()

remove_memory
	arch_remove_memory()
	release memory resource

While at it, explain why we ignore errors and that it only happeny if
we remove memory in a different granularity as we added it.

[david@redhat.com: fix printk warning]
  Link: http://lkml.kernel.org/r/20190417120204.6997-1-david@redhat.com
Link: http://lkml.kernel.org/r/20190409100148.24703-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Qian Cai <cai@lca.pw>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory_hotplug.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b236069ff0d8..28587f290109 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -561,20 +561,6 @@ int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
 	if (is_dev_zone(zone)) {
 		if (altmap)
 			map_offset = vmem_altmap_offset(altmap);
-	} else {
-		resource_size_t start, size;
-
-		start = phys_start_pfn << PAGE_SHIFT;
-		size = nr_pages * PAGE_SIZE;
-
-		ret = release_mem_region_adjustable(&iomem_resource, start,
-					size);
-		if (ret) {
-			resource_size_t endres = start + size - 1;
-
-			pr_warn("Unable to release resource <%pa-%pa> (%d)\n",
-					&start, &endres, ret);
-		}
 	}
 
 	clear_zone_contiguous(zone);
@@ -1843,6 +1829,26 @@ void try_offline_node(int nid)
 }
 EXPORT_SYMBOL(try_offline_node);
 
+static void __release_memory_resource(resource_size_t start,
+				      resource_size_t size)
+{
+	int ret;
+
+	/*
+	 * When removing memory in the same granularity as it was added,
+	 * this function never fails. It might only fail if resources
+	 * have to be adjusted or split. We'll ignore the error, as
+	 * removing of memory cannot fail.
+	 */
+	ret = release_mem_region_adjustable(&iomem_resource, start, size);
+	if (ret) {
+		resource_size_t endres = start + size - 1;
+
+		pr_warn("Unable to release resource <%pa-%pa> (%d)\n",
+			&start, &endres, ret);
+	}
+}
+
 /**
  * remove_memory
  * @nid: the node ID
@@ -1877,6 +1883,7 @@ void __ref __remove_memory(int nid, u64 start, u64 size)
 	memblock_remove(start, size);
 
 	arch_remove_memory(nid, start, size, NULL);
+	__release_memory_resource(start, size);
 
 	try_offline_node(nid);
 
-- 
2.20.1



