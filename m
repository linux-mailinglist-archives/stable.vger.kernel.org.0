Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A32A27969D
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 06:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgIZET0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 00:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgIZET0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 00:19:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF92D207C4;
        Sat, 26 Sep 2020 04:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601093965;
        bh=4XYbOkZD/X+maFrZDRd5RAzqJJ9LoJUpJToY3T3h3R0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ARY3by6ITqp2ZnsjOsPvXl+rGGDcHv8XbLOpId2hoXAJYDuU33VhrEDACHeGCnZjR
         9n91SUl1xCKp3tjXuT8Qf0r7v9lmsrcvsunSEVd4++RIROvmA21hg5jWaBnCAd9vFX
         cwn6ysHBq1VfNYgqtGTRudh+891wxKG0QhjTznM0=
Date:   Fri, 25 Sep 2020 21:19:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.wiilliams@intel.com, hch@lst.de,
        hpa@zytor.com, jack@suse.cz, jmoyer@redhat.com, linux-mm@kvack.org,
        mawilcox@microsoft.com, mingo@elte.hu, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpatocka@redhat.com,
        ross.zwisler@linux.intel.com, stable@vger.kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        toshi.kani@hpe.com, viro@zeniv.linux.org.uk
Subject:  [patch 7/9] arch/x86/lib/usercopy_64.c: fix 
 __copy_user_flushcache() cache writeback
Message-ID: <20200926041924.JrUcL1D_9%akpm@linux-foundation.org>
In-Reply-To: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: arch/x86/lib/usercopy_64.c: fix  __copy_user_flushcache() cache writeback

If we copy less than 8 bytes and if the destination crosses a cache line,
__copy_user_flushcache would invalidate only the first cache line.  This
patch makes it invalidate the second cache line as well.

Link: https://lkml.kernel.org/r/alpine.LRH.2.02.2009161451140.21915@file01.intranet.prod.int.rdu2.redhat.com
Fixes: 0aed55af88345b ("x86, uaccess: introduce copy_from_iter_flushcache for pmem / cache-bypass operations")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Dan Williams <dan.j.wiilliams@intel.com>
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
