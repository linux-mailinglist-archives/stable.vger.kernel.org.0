Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8127134C06
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgAHTtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:49:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43578 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730434AbgAHTqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:03 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006oh-6u; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dmm-5X; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Android Kernel Team" <kernel-team@android.com>,
        "Laura Abbott" <lauraa@codeaurora.org>,
        "Osvaldo Banuelos" <osvaldob@codeaurora.org>,
        "John Stultz" <john.stultz@linaro.org>,
        "Syed Rameez Mustafa" <rameezmustafa@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Subbaraman Narayanamurthy" <subbaram@codeaurora.org>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Matt Wagantall" <mattw@codeaurora.org>
Date:   Wed, 08 Jan 2020 19:43:27 +0000
Message-ID: <lsq.1578512578.165540140@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 29/63] staging: ashmem: Avoid deadlock with mmap/shrink
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Laura Abbott <lauraa@codeaurora.org>

commit 18e77054de741ef3ed2a2489bc9bf82a318b2d5e upstream.

Both ashmem_mmap and ashmem_shrink take the ashmem_lock. It may
be possible for ashmem_mmap to invoke ashmem_shrink:

-000|mutex_lock(lock = 0x0)
-001|ashmem_shrink(?, sc = 0x0) <--- try to take ashmem_mutex again
-002|shrink_slab(shrink = 0xDA5F1CC0, nr_pages_scanned = 0, lru_pages
-002|=
-002|124)
-003|try_to_free_pages(zonelist = 0x0, ?, ?, ?)
-004|__alloc_pages_nodemask(gfp_mask = 21200, order = 1, zonelist =
-004|0xC11D0940,
-005|new_slab(s = 0xE4841E80, ?, node = -1)
-006|__slab_alloc.isra.43.constprop.50(s = 0xE4841E80, gfpflags =
-006|2148925462, ad
-007|kmem_cache_alloc(s = 0xE4841E80, gfpflags = 208)
-008|shmem_alloc_inode(?)
-009|alloc_inode(sb = 0xE480E800)
-010|new_inode_pseudo(?)
-011|new_inode(?)
-012|shmem_get_inode(sb = 0xE480E800, dir = 0x0, ?, dev = 0, flags =
-012|187)
-013|shmem_file_setup(?, ?, flags = 187)
-014|ashmem_mmap(?, vma = 0xC5D64210) <---- Acquire ashmem_mutex
-015|mmap_region(file = 0xDF8E2C00, addr = 1772974080, len = 233472,
-015|flags = 57,
-016|sys_mmap_pgoff(addr = 0, len = 230400, prot = 3, flags = 1, fd =
-016|157, pgoff
-017|ret_fast_syscall(asm)
-->|exception
-018|NUR:0x40097508(asm)
---|end of frame

Avoid this deadlock by using mutex_trylock in ashmem_shrink; if the mutex
is already held, do not attempt to shrink.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Reported-by: Matt Wagantall <mattw@codeaurora.org>
Reported-by: Syed Rameez Mustafa <rameezmustafa@codeaurora.org>
Reported-by: Osvaldo Banuelos <osvaldob@codeaurora.org>
Reported-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
[jstultz: Minor commit message tweaks]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/android/ashmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -434,7 +434,9 @@ ashmem_shrink_scan(struct shrinker *shri
 	if (!(sc->gfp_mask & __GFP_FS))
 		return SHRINK_STOP;
 
-	mutex_lock(&ashmem_mutex);
+	if (!mutex_trylock(&ashmem_mutex))
+		return -1;
+
 	list_for_each_entry_safe(range, next, &ashmem_lru_list, lru) {
 		loff_t start = range->pgstart * PAGE_SIZE;
 		loff_t end = (range->pgend + 1) * PAGE_SIZE;

