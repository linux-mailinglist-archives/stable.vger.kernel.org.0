Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5631064F0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfKVFwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:52:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfKVFwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C990420717;
        Fri, 22 Nov 2019 05:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401960;
        bh=pxsg+EuEhTj7wST6JFftpxmN8j+heodQmCPUdIeiIPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xO4ImW3ZTtkbfyYi3IPaKHja5PNG/BZRZyUYl8/A4OJ1oVQTIbCS5Zy5jW4J7PkXu
         7Wqegb4fBWdcKOtZ2wbFVON+Pd9xauBoca0dP3awnlULJAPgDBZUkaffEgUzadEX7z
         CXovkoQbcCoPf8NNDpnMOZeFTWIk1XKLU+jKhePU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 182/219] mm/hotplug: invalid PFNs from pfn_to_online_page()
Date:   Fri, 22 Nov 2019 00:48:34 -0500
Message-Id: <20191122054911.1750-175-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit b13bc35193d9e7a8c050a24928ca5c9e7c9a009b ]

On an arm64 ThunderX2 server, the first kmemleak scan would crash [1]
with CONFIG_DEBUG_VM_PGFLAGS=y due to page_to_nid() found a pfn that is
not directly mapped (MEMBLOCK_NOMAP).  Hence, the page->flags is
uninitialized.

This is due to the commit 9f1eb38e0e11 ("mm, kmemleak: little
optimization while scanning") starts to use pfn_to_online_page() instead
of pfn_valid().  However, in the CONFIG_MEMORY_HOTPLUG=y case,
pfn_to_online_page() does not call memblock_is_map_memory() while
pfn_valid() does.

Historically, the commit 68709f45385a ("arm64: only consider memblocks
with NOMAP cleared for linear mapping") causes pages marked as nomap
being no long reassigned to the new zone in memmap_init_zone() by
calling __init_single_page().

Since the commit 2d070eab2e82 ("mm: consider zone which is not fully
populated to have holes") introduced pfn_to_online_page() and was
designed to return a valid pfn only, but it is clearly broken on arm64.

Therefore, let pfn_to_online_page() call pfn_valid_within(), so it can
handle nomap thanks to the commit f52bb98f5ade ("arm64: mm: always
enable CONFIG_HOLES_IN_ZONE"), while it will be optimized away on
architectures where have no HOLES_IN_ZONE.

[1]
  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000006
  Mem abort info:
    ESR = 0x96000005
    Exception class = DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
  Data abort info:
    ISV = 0, ISS = 0x00000005
    CM = 0, WnR = 0
  Internal error: Oops: 96000005 [#1] SMP
  CPU: 60 PID: 1408 Comm: kmemleak Not tainted 5.0.0-rc2+ #8
  pstate: 60400009 (nZCv daif +PAN -UAO)
  pc : page_mapping+0x24/0x144
  lr : __dump_page+0x34/0x3dc
  sp : ffff00003a5cfd10
  x29: ffff00003a5cfd10 x28: 000000000000802f
  x27: 0000000000000000 x26: 0000000000277d00
  x25: ffff000010791f56 x24: ffff7fe000000000
  x23: ffff000010772f8b x22: ffff00001125f670
  x21: ffff000011311000 x20: ffff000010772f8b
  x19: fffffffffffffffe x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000
  x15: 0000000000000000 x14: ffff802698b19600
  x13: ffff802698b1a200 x12: ffff802698b16f00
  x11: ffff802698b1a400 x10: 0000000000001400
  x9 : 0000000000000001 x8 : ffff00001121a000
  x7 : 0000000000000000 x6 : ffff0000102c53b8
  x5 : 0000000000000000 x4 : 0000000000000003
  x3 : 0000000000000100 x2 : 0000000000000000
  x1 : ffff000010772f8b x0 : ffffffffffffffff
  Process kmemleak (pid: 1408, stack limit = 0x(____ptrval____))
  Call trace:
   page_mapping+0x24/0x144
   __dump_page+0x34/0x3dc
   dump_page+0x28/0x4c
   kmemleak_scan+0x4ac/0x680
   kmemleak_scan_thread+0xb4/0xdc
   kthread+0x12c/0x13c
   ret_from_fork+0x10/0x18
  Code: d503201f f9400660 36000040 d1000413 (f9400661)
  ---[ end trace 4d4bd7f573490c8e ]---
  Kernel panic - not syncing: Fatal exception
  SMP: stopping secondary CPUs
  Kernel Offset: disabled
  CPU features: 0x002,20000c38
  Memory Limit: none
  ---[ end Kernel panic - not syncing: Fatal exception ]---

Link: http://lkml.kernel.org/r/20190122132916.28360-1-cai@lca.pw
Fixes: 9f1eb38e0e11 ("mm, kmemleak: little optimization while scanning")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memory_hotplug.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 34a28227068dc..3040bedee1991 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -21,14 +21,16 @@ struct vmem_altmap;
  * walkers which rely on the fully initialized page->flags and others
  * should use this rather than pfn_valid && pfn_to_page
  */
-#define pfn_to_online_page(pfn)				\
-({							\
-	struct page *___page = NULL;			\
-	unsigned long ___nr = pfn_to_section_nr(pfn);	\
-							\
-	if (___nr < NR_MEM_SECTIONS && online_section_nr(___nr))\
-		___page = pfn_to_page(pfn);		\
-	___page;					\
+#define pfn_to_online_page(pfn)					   \
+({								   \
+	struct page *___page = NULL;				   \
+	unsigned long ___pfn = pfn;				   \
+	unsigned long ___nr = pfn_to_section_nr(___pfn);	   \
+								   \
+	if (___nr < NR_MEM_SECTIONS && online_section_nr(___nr) && \
+	    pfn_valid_within(___pfn))				   \
+		___page = pfn_to_page(___pfn);			   \
+	___page;						   \
 })
 
 /*
-- 
2.20.1

