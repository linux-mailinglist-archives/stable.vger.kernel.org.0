Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A854A44A0
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350876AbiAaLbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58024 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376372AbiAaLZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BC9F61296;
        Mon, 31 Jan 2022 11:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E2AC340E8;
        Mon, 31 Jan 2022 11:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628328;
        bh=lpFY0+YEcA0iQW+y35zmgQwUexFSLpG0tCkYnjPzlYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcAwdrXhWRmGcQo7a7/5r+yCCopU4FjLTkvoGY4hkp78dAkBI43s/EcLCxypmZuvI
         MRj7LKhaA6s3xmDs/ohtk4uKM2NVVlbgY8b3vuSM9GYNlFdd0OBwjipTZPWB1Wiqi4
         OLXlL3QdWf4fM8LvCcMOWc2QKWTcOmwb9UQwgTw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 196/200] tools/testing/scatterlist: add missing defines
Date:   Mon, 31 Jan 2022 11:57:39 +0100
Message-Id: <20220131105240.128881135@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 0226bd64da52aa23120d1450c37a424387827a21 ]

The cited commits replaced preemptible with pagefault_disabled and
flush_kernel_dcache_page with flush_dcache_page respectively, hence need
to update the corresponding defines in the test.

  scatterlist.c: In function ‘sg_miter_stop’:
  scatterlist.c:919:4: warning: implicit declaration of function ‘flush_dcache_page’ [-Wimplicit-function-declaration]
      flush_dcache_page(miter->page);
      ^~~~~~~~~~~~~~~~~
  In file included from linux/scatterlist.h:8:0,
                   from scatterlist.c:9:
  scatterlist.c:922:18: warning: implicit declaration of function ‘pagefault_disabled’ [-Wimplicit-function-declaration]
      WARN_ON_ONCE(!pagefault_disabled());
                    ^
  linux/mm.h:23:25: note: in definition of macro ‘WARN_ON_ONCE’
    int __ret_warn_on = !!(condition);                      \
                           ^~~~~~~~~

Link: https://lkml.kernel.org/r/20220118082105.1737320-1-maorg@nvidia.com
Fixes: 723aca208516 ("mm/scatterlist: replace the !preemptible warning in sg_miter_stop()")
Fixes: 0e84f5dbf8d6 ("scatterlist: replace flush_kernel_dcache_page with flush_dcache_page")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/scatterlist/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/scatterlist/linux/mm.h
+++ b/tools/testing/scatterlist/linux/mm.h
@@ -74,7 +74,7 @@ static inline unsigned long page_to_phys
 	      __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),   \
 	      x, y)
 
-#define preemptible() (1)
+#define pagefault_disabled() (0)
 
 static inline void *kmap(struct page *page)
 {
@@ -127,6 +127,7 @@ kmalloc_array(unsigned int n, unsigned i
 #define kmemleak_free(a)
 
 #define PageSlab(p) (0)
+#define flush_dcache_page(p)
 
 #define MAX_ERRNO	4095
 


