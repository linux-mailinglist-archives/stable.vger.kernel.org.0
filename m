Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93A95C59E
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 00:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfGAWXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 18:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbfGAWXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 18:23:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A97C02184B;
        Mon,  1 Jul 2019 22:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562019791;
        bh=r8fIIYoMROeNFoNdX2VTqOxpftrNFKnAkQQcBgVHNlc=;
        h=Date:From:To:Subject:From;
        b=oxNRGO685a7mXUpRI6dckCypvwKAxbl8wzK9ylyC25++ngGabncrtSTHWJNknWQ20
         YRYbZvHzMWP3M3ZnKKVH4JO8QqHDGyehjceT0LdchGvOWDGs1hKk+pi8bo/7+xiXYW
         vO8pnUb4KxNcPPdkPw/nxQWfQEnm01h/Awghh1OU=
Date:   Mon, 01 Jul 2019 15:23:10 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, aryabinin@virtuozzo.com,
        colin.king@canonical.com, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        rppt@linux.vnet.ibm.com, sfr@canb.auug.org.au,
        stable@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-idle-page-fix-oops-because-end_pfn-is-larger-than-max_pfn.patch removed
 from -mm tree
Message-ID: <20190701222310.qbh_Ezywd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_idle.c: fix oops because end_pfn is larger than max_pfn
has been removed from the -mm tree.  Its filename was
     mm-idle-page-fix-oops-because-end_pfn-is-larger-than-max_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/page_idle.c: fix oops because end_pfn is larger than max_pfn

Currently the calcuation of end_pfn can round up the pfn number to more
than the actual maximum number of pfns, causing an Oops.  Fix this by
ensuring end_pfn is never more than max_pfn.

This can be easily triggered when on systems where the end_pfn gets
rounded up to more than max_pfn using the idle-page stress-ng stress test:

sudo stress-ng --idle-page 0

[ 3812.222790] BUG: unable to handle kernel paging request at 00000000000020d8
[ 3812.224341] #PF error: [normal kernel read fault]
[ 3812.225144] PGD 0 P4D 0
[ 3812.225626] Oops: 0000 [#1] SMP PTI
[ 3812.226264] CPU: 1 PID: 11039 Comm: stress-ng-idle- Not tainted 5.0.0-5-generic #6-Ubuntu
[ 3812.227643] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 3812.229286] RIP: 0010:page_idle_get_page+0xc8/0x1a0
[ 3812.230173] Code: 0f b1 0a 75 7d 48 8b 03 48 89 c2 48 c1 e8 33 83 e0 07 48 c1 ea 36 48 8d 0c 40 4c 8d 24 88 49 c1 e4 07 4c 03 24 d5 00 89 c3 be <49> 8b 44 24 58 48 8d b8 80 a1 02 00 e8 07 d5 77 00 48 8b 53 08 48
[ 3812.234641] RSP: 0018:ffffafd7c672fde8 EFLAGS: 00010202
[ 3812.235792] RAX: 0000000000000005 RBX: ffffe36341fff700 RCX: 000000000000000f
[ 3812.237739] RDX: 0000000000000284 RSI: 0000000000000275 RDI: 0000000001fff700
[ 3812.239225] RBP: ffffafd7c672fe00 R08: ffffa0bc34056410 R09: 0000000000000276
[ 3812.241027] R10: ffffa0bc754e9b40 R11: ffffa0bc330f6400 R12: 0000000000002080
[ 3812.242555] R13: ffffe36341fff700 R14: 0000000000080000 R15: ffffa0bc330f6400
[ 3812.244073] FS: 00007f0ec1ea5740(0000) GS:ffffa0bc7db00000(0000) knlGS:0000000000000000
[ 3812.245968] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3812.247162] CR2: 00000000000020d8 CR3: 0000000077d68000 CR4: 00000000000006e0
[ 3812.249045] Call Trace:
[ 3812.249625] page_idle_bitmap_write+0x8c/0x140
[ 3812.250567] sysfs_kf_bin_write+0x5c/0x70
[ 3812.251406] kernfs_fop_write+0x12e/0x1b0
[ 3812.252282] __vfs_write+0x1b/0x40
[ 3812.253002] vfs_write+0xab/0x1b0
[ 3812.253941] ksys_write+0x55/0xc0
[ 3812.254660] __x64_sys_write+0x1a/0x20
[ 3812.255446] do_syscall_64+0x5a/0x110
[ 3812.256254] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Link: http://lkml.kernel.org/r/20190618124352.28307-1-colin.king@canonical.com
Fixes: 33c3fc71c8cf ("mm: introduce idle page tracking")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_idle.c~mm-idle-page-fix-oops-because-end_pfn-is-larger-than-max_pfn
+++ a/mm/page_idle.c
@@ -136,7 +136,7 @@ static ssize_t page_idle_bitmap_read(str
 
 	end_pfn = pfn + count * BITS_PER_BYTE;
 	if (end_pfn > max_pfn)
-		end_pfn = ALIGN(max_pfn, BITMAP_CHUNK_BITS);
+		end_pfn = max_pfn;
 
 	for (; pfn < end_pfn; pfn++) {
 		bit = pfn % BITMAP_CHUNK_BITS;
@@ -181,7 +181,7 @@ static ssize_t page_idle_bitmap_write(st
 
 	end_pfn = pfn + count * BITS_PER_BYTE;
 	if (end_pfn > max_pfn)
-		end_pfn = ALIGN(max_pfn, BITMAP_CHUNK_BITS);
+		end_pfn = max_pfn;
 
 	for (; pfn < end_pfn; pfn++) {
 		bit = pfn % BITMAP_CHUNK_BITS;
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
z3fold-add-inter-page-compaction-fix.patch
coda-clean-up-indentation-replace-spaces-with-tab.patch

