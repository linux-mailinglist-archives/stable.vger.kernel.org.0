Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA80526CF29
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 00:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgIPWzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 18:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgIPWzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 18:55:22 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 416F32080C;
        Wed, 16 Sep 2020 22:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600296921;
        bh=0BYnZh10OCsiUas1KFhe3YmwnY/TzEiBP0IAPQ3+BjI=;
        h=Date:From:To:Subject:From;
        b=cYlszEHjCADC0qE7el6ARbppOQBT6yG03F3ctzC4bqUq4F0dhaDuqmyR4vcdlNDda
         0RmfBj5+Vi7j3aw9UGX5236w1ydDlfNWaOzOOnc58LJT5FGBfiYdo2KxUMaoxC8RvJ
         H41O9Eh6q1pnZtcbIUco3OCgRabg8fAMBCFVjWOw=
Date:   Wed, 16 Sep 2020 15:55:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        toshi.kani@hpe.com, tglx@linutronix.de, stable@vger.kernel.org,
        ross.zwisler@linux.intel.com, mingo@redhat.com, mingo@elte.hu,
        mawilcox@microsoft.com, jmoyer@redhat.com, jack@suse.cz,
        hpa@zytor.com, hch@lst.de, dan.j.williams@intel.com,
        mpatocka@redhat.com
Subject:  +
 arch-x86-lib-usercopy_64c-fix-__copy_user_flushcache-cache-writeback.patch
 added to -mm tree
Message-ID: <20200916225519.w7Xau%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: arch/x86/lib/usercopy_64.c: fix  __copy_user_flushcache() cache writeback
has been added to the -mm tree.  Its filename is
     arch-x86-lib-usercopy_64c-fix-__copy_user_flushcache-cache-writeback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-x86-lib-usercopy_64c-fix-__copy_user_flushcache-cache-writeback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-lib-usercopy_64c-fix-__copy_user_flushcache-cache-writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: arch/x86/lib/usercopy_64.c: fix  __copy_user_flushcache() cache writeback

If we copy less than 8 bytes and if the destination crosses a cache line,
__copy_user_flushcache would invalidate only the first cache line.  This
patch makes it invalidate the second cache line as well.

Link: https://lkml.kernel.org/r/alpine.LRH.2.02.2009161451140.21915@file01.intranet.prod.int.rdu2.redhat.com
Fixes: 0aed55af88345b ("x86, uaccess: introduce copy_from_iter_flushcache for pmem / cache-bypass operations")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lib/usercopy_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/lib/usercopy_64.c~arch-x86-lib-usercopy_64c-fix-__copy_user_flushcache-cache-writeback
+++ a/arch/x86/lib/usercopy_64.c
@@ -120,7 +120,7 @@ long __copy_user_flushcache(void *dst, c
 	 */
 	if (size < 8) {
 		if (!IS_ALIGNED(dest, 4) || size != 4)
-			clean_cache_range(dst, 1);
+			clean_cache_range(dst, size);
 	} else {
 		if (!IS_ALIGNED(dest, 8)) {
 			dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
_

Patches currently in -mm which might be from mpatocka@redhat.com are

arch-x86-lib-usercopy_64c-fix-__copy_user_flushcache-cache-writeback.patch

