Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0790EEF92
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389031AbfKDWWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:22:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388506AbfKDV5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:01 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56347214E0;
        Mon,  4 Nov 2019 21:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904620;
        bh=ciDTbb48whY0btX4Jeq3lVC0e8CX6K6hmGMsNlR6hrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwVdEgK6XSFtz8phMipIyyq3gsLE62nZ1ZuAzfZqti1vAdHwa3bMFai5+b7cypBuV
         WEbzA6Ge4Xyw8AN5aJPxUw4o7oSWlpvt+VbXY4IICvV/DkVifNDcT22O00M5Xi6bTw
         sB+BBNynAWdZMTjwlMHuRshUnJ8r3gYBjjbN5rfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Rashmica Gupta <rashmica.g@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        John Allen <jallen@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Juergen Gross <jgross@suse.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Len Brown <lenb@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mathieu Malaterre <malat@debian.org>,
        Michal Hocko <mhocko@suse.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/149] powerpc/powernv: hold device_hotplug_lock when calling memtrace_offline_pages()
Date:   Mon,  4 Nov 2019 22:43:25 +0100
Message-Id: <20191104212132.831809626@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 5666848774ef43d3db5151ec518f1deb63515c20 ]

Let's perform all checking + offlining + removing under
device_hotplug_lock, so nobody can mess with these devices via sysfs
concurrently.

[david@redhat.com: take device_hotplug_lock outside of loop]
  Link: http://lkml.kernel.org/r/20180927092554.13567-6-david@redhat.com
Link: http://lkml.kernel.org/r/20180925091457.28651-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pavel Tatashin <pavel.tatashin@microsoft.com>
Reviewed-by: Rashmica Gupta <rashmica.g@gmail.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rashmica Gupta <rashmica.g@gmail.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: John Allen <jallen@linux.vnet.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/memtrace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/memtrace.c b/arch/powerpc/platforms/powernv/memtrace.c
index a29fdf8a2e56e..232bf5987f91d 100644
--- a/arch/powerpc/platforms/powernv/memtrace.c
+++ b/arch/powerpc/platforms/powernv/memtrace.c
@@ -70,6 +70,7 @@ static int change_memblock_state(struct memory_block *mem, void *arg)
 	return 0;
 }
 
+/* called with device_hotplug_lock held */
 static bool memtrace_offline_pages(u32 nid, u64 start_pfn, u64 nr_pages)
 {
 	u64 end_pfn = start_pfn + nr_pages - 1;
@@ -110,6 +111,7 @@ static u64 memtrace_alloc_node(u32 nid, u64 size)
 	/* Trace memory needs to be aligned to the size */
 	end_pfn = round_down(end_pfn - nr_pages, nr_pages);
 
+	lock_device_hotplug();
 	for (base_pfn = end_pfn; base_pfn > start_pfn; base_pfn -= nr_pages) {
 		if (memtrace_offline_pages(nid, base_pfn, nr_pages) == true) {
 			/*
@@ -118,7 +120,6 @@ static u64 memtrace_alloc_node(u32 nid, u64 size)
 			 * we never try to remove memory that spans two iomem
 			 * resources.
 			 */
-			lock_device_hotplug();
 			end_pfn = base_pfn + nr_pages;
 			for (pfn = base_pfn; pfn < end_pfn; pfn += bytes>> PAGE_SHIFT) {
 				remove_memory(nid, pfn << PAGE_SHIFT, bytes);
@@ -127,6 +128,7 @@ static u64 memtrace_alloc_node(u32 nid, u64 size)
 			return base_pfn << PAGE_SHIFT;
 		}
 	}
+	unlock_device_hotplug();
 
 	return 0;
 }
-- 
2.20.1



