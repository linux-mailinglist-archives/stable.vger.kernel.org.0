Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD2A27CCED
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgI2LOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729449AbgI2LOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED63B20848;
        Tue, 29 Sep 2020 11:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378080;
        bh=I2Z6OIspS6YUaYt1Dzh3PCUQ6/nbwqFQYOaXwnswFpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAJWyA+lC0NtehQcjhZ9TXHv06yC6MAdK8qRAxsugKsmAI02BqVqAxARAPBL+l66r
         eHwExnCceyOjptBGykqHiT8657HEtnjshNtBVRXmrJ+uV2SIeN7cX55zjJ5wftjyQk
         PArqzmBVrPrVnvHmG0o7sRlzM0rW643wUebjQujE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.wiilliams@intel.com>,
        Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Toshi Kani <toshi.kani@hpe.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 024/166] arch/x86/lib/usercopy_64.c: fix __copy_user_flushcache() cache writeback
Date:   Tue, 29 Sep 2020 12:58:56 +0200
Message-Id: <20200929105936.402814715@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit a1cd6c2ae47ee10ff21e62475685d5b399e2ed4a upstream.

If we copy less than 8 bytes and if the destination crosses a cache
line, __copy_user_flushcache would invalidate only the first cache line.

This patch makes it invalidate the second cache line as well.

Fixes: 0aed55af88345b ("x86, uaccess: introduce copy_from_iter_flushcache for pmem / cache-bypass operations")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/alpine.LRH.2.02.2009161451140.21915@file01.intranet.prod.int.rdu2.redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/lib/usercopy_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -118,7 +118,7 @@ long __copy_user_flushcache(void *dst, c
 	 */
 	if (size < 8) {
 		if (!IS_ALIGNED(dest, 4) || size != 4)
-			clean_cache_range(dst, 1);
+			clean_cache_range(dst, size);
 	} else {
 		if (!IS_ALIGNED(dest, 8)) {
 			dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);


